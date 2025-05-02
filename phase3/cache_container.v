//The module that contains all of the cache modules to instansiate.
module cache_container();


    input [15:0] maddr;//address to read/write to
    input clk,rst; 
    input [15:0] mdata_in;
    input mwen, mren;//write/read enabled
    output [15:0] mdata_out;
    output mdata_ready;//assert high when data is valid

    input [15:0] iaddr;//address to read/write to
    input iren; //clock, reset, read enabled
    output [15:0] idata;//instruction pulled
    output idata_ready;//assert high when data is valid

    wire dmem_we,dmem_re, imem_re;//data/ I mem read/write enable
    wire imem_data_valid,dmem_data_valid;
    wire[15:0] dmem_data_in, dmem_data_out,imem_data_out,imem_addr,dmem_addr,addr;
    wire[15:0] data_in,data_out;
    wire mstall, istall;
    wire mem_access_req,mem_access_grant,inst_access_req,inst_access_grant;//who wants to access memory/who has permission
    wire data_valid,mem_wr_req,mem_rd_req;
    assign mdata_ready = ~mstall;
    assign idata_ready = ~istall;
    // MDCacheInterface MDCI(.addr(maddr),.clk(clk),.rst(rst),.data_in(mdata_in),.data_out(mdata_out), .data_ready(mdata_ready),.wen(mwen),.ren(mren));
    // FICacheInterface FICI(.addr(iaddr),.clk(clk),.rst(rst),.data(idata),.data_ready(.idata_ready),.ren(iren));

    DCache IC(
        .clk(clk),
        .rst_n(~rst),
        .cpu_address(),
        .cpu_data_in(),
        .cpu_write_en(), // 1 = write, 0 = read
        .cpu_data_out(),
        //will update w/ signals from cache controller
        .mem_we(1'b0),
        .mem_re(imem_re),
        .mem_addr(),
    );
    cache_controller mControl(
        // System signals
        .clk(clk),
        .rst_n(rst_n),
        
        // Processor interface
        .addr(maddr),
        .rd_req(mren),
        .wr_req(mwen),
        .data_in(mdata_in),
        .data_out(mdata_out),
        .stall(mstall),
        
        // Cache data array interface
        output [15:0] cache_addr,
        output cache_wr_en,
        output [15:0] cache_data_in,
        input [15:0] cache_data_out,
        
        // Cache meta-data array interface
        output [7:0] meta_idx,
        output meta_wr_en,
        output meta_wr_way,
        output [7:0] meta_tag_in,
        output meta_valid_in,
        input [7:0] meta_tag_out0,
        input meta_valid_out0,
        input [7:0] meta_tag_out1,
        input meta_valid_out1,
        output meta_lru_in,
        input meta_lru_out,
        
        // Memory interface signals
        .mem_addr(dmem_addr),
        .mem_rd_req(mem_wr_req),
        .mem_wr_req(mem_wr_req),
        .mem_data_out(data_in),
        .mem_data_in(data_out),
        .mem_data_valid(data_valid),
        
        // Arbitration interface
        .mem_access_req(mem_access_req),
        .mem_access_grant(mem_access_grant)
);

    // cache_controller ICC(clk,rst_n,miss_detected, memory_data_valid,miss_address,busy, write_data_array,write_tag_array,memory_address);
    // cache_controller MCC(clk,rst_n,miss_detected, memory_data_valid,miss_address,busy, write_data_array,write_tag_array,memory_address);


    //cache_mem_interface CMI(.dwe(mem_wr_req),.dre(mem_r),.ire(imem_re),.clk(clk),.rst(rst),.i_data_valid(imem_data_valid), .d_data_valid(dmem_data_valid),.d_data_in(dmem_data_in),
    //.d_addr(dmem_addr),.i_addr(imem_addr),.i_data_out(imem_data_out), .d_data_out(dmem_data_out));
    memory_arbitration MA(//decide whether I or D cache gets access to memory
        // System signals
        .clk(clk),
        .rst_n(~rst),
        
        // I-cache request interface
        .icache_req(inst_access_req),
        .icache_grant(inst_access_grant),
        
        // D-cache request interface
        .dcache_req(mem_access_req),
        .dcache_grant(mem_access_grant)
    );

    assign addr = mem_wr_req|mem_access_grant? dmem_addr:imem_addr;

    memory4c mem(.data_out(data_out), .data_in(data_in), .addr(addr), .enable(mem_access_grant|inst_access_grant|mem_wr_req), .wr(mem_wr_req), .clk(clk), .rst(rst), .data_valid(data_valid));
endmodule