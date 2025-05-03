//Peter Davis 4.28.2025
//Charlie Jungwirth 5/3/2025
module DCache(
    input clk,
    input rst_n,
    input [15:0] cpu_address,
    input [15:0] cpu_data_in,
    input cpu_write_en, 
    input cpu_read_en,

    output [15:0] cpu_data_out,
    output cpu_data_valid;//does the data outputting to cpu work

    //will update w/ signals from cache controller
            // Cache data array interface
    input [15:0] cache_addr,
    input cache_wr_en,
    input [15:0] cache_data_in,
    output [15:0] cache_data_out,
    

    input memory_data_valid,
    input [15:0] memory data,

    // Cache meta-data array interface
    input [7:0] meta_idx,
    input meta_wr_en,
    input meta_wr_way,
    input [7:0] meta_tag_in,
    input meta_valid_in,
    output [7:0] meta_tag_out0,
    output meta_valid_out0,
    output [7:0] meta_tag_out1,
    output meta_valid_out1,
    input meta_lru_in,
    output meta_lru_out

);

    // MetaDataArray signals
    wire [7:0] meta_data_in;
    wire meta_write_enable;
    wire [127:0] meta_block_enable;
    wire [7:0] meta_data_out;


    // DataArray signals
    wire [15:0] data_array_in;
    wire data_write_enable;
    wire [127:0] data_block_enable;
    wire [7:0] word_enable;
    wire [15:0] data_array_out;

    // Address decoding
    wire [5:0] index;          // 6-bit index (64 sets)
    wire [2:0] block_offset;   // Which word inside 16B block (8 words)
    wire [3:0] offset;         //Which byte inside 16B block (16 bytes)
    wire [5:0] tag;            // 5-bit tag

    wire cpu_data_valid_d;

    PARAMETER IDLE = 2'b00;//waiting
    PARAMETER WRITEDATA = 2'b01;//writing to data
    PARAMETER WAY0 = 2'b10;//just checked from way0
    PARAMETER WAY1 = 2'b11;//checking way 1
    wire[1:0] n_state,state;
    wire victim_way, n_victim_way;
    wire found, n_found;//is there a match, if not we need to go to overwrite

    wire miss_detected,fsm_busy;
    wire fsm_data_we;//when to write to cache_memory according to FSM
    wire[]
    
    assign index = cpu_address[9:4];
    assign block_offset = cpu_address[3:1];
    assign offset = cpu_address[3:0];
    assign tag = cpu_address[15:10];

cache_fill_FSM FSM(
    .clk(clk),
    .rst_n(~rst),
    .miss_detected(miss_detected),
    .memory_data_valid(memory_data_valid),
    .miss_address(miss_address),
    .fsm_busy(fsm_busy),
    .memory_read_en(), //one read signal for the memory
    .write_data_array(),
    .write_tag_array(),
    .memory_address()
    );

    // Way selection (for now assume way 0, placeholder)
    wire way_select,nxt_way_select;
    dff foundff(.d(n_found),.q(found),.rst(rst),.wen(1'b1),.clk(clk));
    dff victimff(.d(n_victim_way),.q(victim_way),.rst(rst),.wen(1'b1),.clk(clk));
    assign n_found = (n_state==WAY0)? match:
                (n_state == WAY1) ? match&found:
                found;
    assign n_victim_way = (n_state== WAY_0)? (meta_lru_out?victim_way:1'b0)://if checking way 0
    (state== WAY0)?(meta_lru_out?victim_way:1'b1) ://check to see if way 1 is LRU
    victim_way;



    dff stateff(.d(n_state),.q(state),.clk(clk),.rst(rst),.wen(1'b1));
    assign n_state = (STATE== WAY0)? WAY1:
                    (STATE==WAY1)? (found?IDLE:WRITEDATA):
                    (STATE== IDLE)? (cpu_read_en? WAY0:IDLE):
                    IDLE;//TODO: add write state

    assign way_select = (state==WAY0) ? 1'b1:1'b0;//if just finished with way 1 go to way 0,
    //otherwise continue at way 1

    // Block Enable generation (2 ways × 64 sets = 128 entries)
    wire [127:0] block_enable;
    assign block_enable =   {index,way_select}; 
    //(way_select) ? (128'b1 << (index + 64)) : (128'b1 << index);
    //uses 'illegal' operators. Will fix later

    assign meta_block_enable = block_enable;
    assign data_block_enable = block_enable;

    // Word Enable generation (8 possible 2-byte words inside block)
    assign word_enable = {7'h00,(cpu_write_en|cpu_read_en)} << block_offset;
    //also illegal

    // MetaData input format (Tag[4:0], Valid[0], LRU[0]) packed into 8 bits
    wire valid_bit = 1'b1; // Always setting valid = 1 when filling for now
    wire lru_bit = way_select; // LRU: 0/1 depending on which way replaced
    
    assign meta_data_overwrite = {tag,valid_bit, 1'b1};//meta data in case we overwrite
    assign meta_data_lruchange= {tag_out,valid_out, 0'b0};//if not correct just mark for replacement

    assign meta_data_in = match? meta_data_overwrite: meta_data_lruchange;//set lru bit to 0 if no match

    assign {tag_out,valid_out,meta_lru_out} = meta_data_out;


    assign match = valid_out &(tag_out == tag);//Found correct tag
    assign cpu_data_out = data_array_out;

    dff validff(.d(cpu_data_valid_d),.q(cpu_data_valid),.rst(rst),.clk(clk),.wen(1'b1));
    assign cpu_data_valid_d = match & (~data_write_enable)&(cpu_read_en);//correct data is about to be read




    MetaDataArray meta_data_array (
        .clk(~clk),//use the opposite edge, so data and meta data are staggered
        .rst(~rst_n),
        .DataIn(meta_data_in),
        .Write(meta_write_enable),
        .BlockEnable(meta_block_enable),
        .DataOut(meta_data_out)
    );

    DataArray data_array (
        .clk(clk),
        .rst(~rst_n),
        .DataIn(data_array_in),
        .Write(data_write_enable),
        .BlockEnable(data_block_enable),
        .WordEnable(word_enable),
        .DataOut(data_array_out)
    );

    assign cpu_data_out = data_array_out;

    // Default control behavior for now
    assign data_array_in = cpu_data_in; // Write data from CPU to cache/memory
    assign data_write_enable = ((STATE==WRITEDATA)&fsm_data_we); 
    assign meta_write_enable = 1'b0; // TODO: interface w/ cache controlelr

endmodule
