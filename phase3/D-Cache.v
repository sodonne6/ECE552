//Peter Davis 4.28.2025

module DCache(
    input clk,
    input rst_n,
    input [15:0] cpu_address,
    input [15:0] cpu_data_in,
    input cpu_write_en, // 1 = write, 0 = read
    output [15:0] cpu_data_out
    //will update w/ signals from cache controller
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
    wire [4:0] tag;            // 5-bit tag

    assign index = cpu_address[9:4];
    assign block_offset = cpu_address[3:1];
    assign tag = cpu_address[14:10];

    // Way selection (for now assume way 0, placeholder)
    wire way_select;
    assign way_select = 1'b0; // TODO: replace with real replacement policy or hit

    // Block Enable generation (2 ways × 64 sets = 128 entries)
    wire [127:0] block_enable;
    assign block_enable = (way_select) ? (128'b1 << (index + 64)) : (128'b1 << index);
    //uses 'illegal' operators. Will fix later

    assign meta_block_enable = block_enable;
    assign data_block_enable = block_enable;

    // Word Enable generation (8 possible 2-byte words inside block)
    assign word_enable = 8'b1 << block_offset;
    //also illegal

    // MetaData input format (Tag[4:0], Valid[0], LRU[0]) packed into 8 bits
    wire valid_bit = 1'b1; // Always setting valid = 1 when filling for now
    wire lru_bit = way_select; // LRU: 0/1 depending on which way replaced
    assign meta_data_in = {tag, valid_bit, lru_bit};

    MetaDataArray meta_data_array (
        .clk(clk),
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
    assign data_write_enable = cpu_write_en; // Write-enable during CPU write ops
    assign meta_write_enable = 1'b0; // TODO: interface w/ cache controlelr

endmodule
