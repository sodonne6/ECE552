//The module that contains all of the cache modules to instansiate.
module cache_container(maddr,clk,rst,mdata_in,mwen,mren,mdata_out,mdata_ready,iaddr,iren,idata,idata_ready);


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


    wire [15:0] dcache_addr;
    wire dcache_wr_en;
    wire [15:0] dcache_data_in;
    wire [15:0] dcache_data_out;

    // Cache meta-data array interface
    wire [7:0] dmeta_idx;
    wire dmeta_wr_en;
    wire dmeta_wr_way;
    wire [7:0] dmeta_tag_in;
    wire dmeta_valid_in;
    wire [7:0] dmeta_tag_out0;
    wire dmeta_valid_out0;
    wire [7:0] dmeta_tag_out1;
    wire dmeta_valid_out1;
    wire dmeta_lru_in;
    wire dmeta_lru_out;


    wire [15:0] icache_addr;
    wire icache_wr_en;
    wire [15:0] icache_data_in;
    wire [15:0] icache_data_out;

    // Cache meta-data array interface
    wire [7:0] imeta_idx;
    wire imeta_wr_en;
    wire imeta_wr_way;
    wire [7:0] imeta_tag_in;
    wire imeta_valid_in;
    wire [7:0] imeta_tag_out0;
    wire imeta_valid_out0;
    wire [7:0] imeta_tag_out1;
    wire imeta_valid_out1;
    wire imeta_lru_in;
    wire imeta_lru_out;


    assign mdata_ready = ~mstall;
    assign idata_ready = ~istall;
    // MDCacheInterface MDCI(.addr(maddr),.clk(clk),.rst(rst),.data_in(mdata_in),.data_out(mdata_out), .data_ready(mdata_ready),.wen(mwen),.ren(mren));
    // FICacheInterface FICI(.addr(iaddr),.clk(clk),.rst(rst),.data(idata),.data_ready(.idata_ready),.ren(iren));



     DCache IC(
        .clk(clk),
        .rst_n(~rst),
        .cpu_address(iaddr),
        .cpu_data_in(idata_out),
        .cpu_write_en(1'b0), // 1 = write, 0 = read
        .cpu_data_out(16'h00),
        //will update w/ signals from cache controller
                // Cache data array interface
        .cache_addr(dcache_addr),
        .cache_wr_en(dcache_wr_en),
        .cache_data_in(dcache_data_in),
        .cache_data_out(dcache_data_out),
        
        // Cache meta-data array interface
        .meta_idx(dmeta_idx),
        .meta_wr_en(dmeta_wr_en),
        .meta_wr_way(dmeta_wr_en),
        .meta_tag_in(dmeta_tag_in),
        .meta_valid_in(dmeta_valid_in),
        .meta_tag_out0(dmeta_tag_out0),
        .meta_valid_out0(dmeta_tag_out0),
        .meta_tag_out1(dmeta_tag_out1),
        .meta_valid_out1(dmeta_valid_out1),
        .meta_lru_in(dmeta_lru_in),
        .meta_lru_out(dmeta_lru_out)

    );
    DCache DC(

        .clk(clk),
        .rst_n(~rst),
        .cpu_address(maddr),
        .cpu_data_in(mdata_out),
        .cpu_write_en(mwen), // 1 = write, 0 = read
        .cpu_data_out(mdata_in),
        //will update w/ signals from cache controller

                // Cache data array interface
        .cache_addr(dcache_addr),
        .cache_wr_en(dcache_wr_en),
        .cache_data_in(dcache_data_in),
        .cache_data_out(dcache_data_out),
        
        // Cache meta-data array interface
        .meta_idx(dmeta_idx),
        .meta_wr_en(dmeta_wr_en),
        .meta_wr_way(dmeta_wr_en),
        .meta_tag_in(dmeta_tag_in),
        .meta_valid_in(dmeta_valid_in),
        .meta_tag_out0(dmeta_tag_out0),
        .meta_valid_out0(dmeta_tag_out0),
        .meta_tag_out1(dmeta_tag_out1),
        .meta_valid_out1(dmeta_valid_out1),
        .meta_lru_in(dmeta_lru_in),
        .meta_lru_out(dmeta_lru_out)

    );

    cache_controller iControl(
        // System signals
        .clk(clk),
        .rst_n(rst_n),
        
        // Processor interface
        .addr(iaddr),
        .rd_req(iren),
        .wr_req(iwen),
        .data_in(idata_in),
        .data_out(idata_out),
        .stall(istall),
        
        // Cache data array interface
        .cache_addr(icache_addr),
        .cache_wr_en(icache_wr_en),
        .cache_data_in(icache_data_in),
        .cache_data_out(icache_data_out),
        
        // Cache meta-data array interface
        .meta_idx(imeta_idx),
        .meta_wr_en(imeta_wr_en),
        .meta_wr_way(imeta_wr_en),
        .meta_tag_in(imeta_tag_in),
        .meta_valid_in(imeta_valid_in),
        .meta_tag_out0(imeta_tag_out0),
        .meta_valid_out0(imeta_tag_out0),
        .meta_tag_out1(imeta_tag_out1),
        .meta_valid_out1(imeta_valid_out1),
        .meta_lru_in(imeta_lru_in),
        .meta_lru_out(imeta_lru_out),
        
        // Memory interface signals
        .mem_addr(imem_addr),
        .mem_rd_req(imem_wr_req),
        .mem_wr_req(imem_wr_req),
        .mem_data_out(idata_in),
        .mem_data_in(idata_out),
        .mem_data_valid(idata_valid),
        
        // Arbitration interface
        .mem_access_req(imem_access_req),
        .mem_access_grant(imem_access_grant)
);
    cache_controller dControl(
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
        .cache_addr(dcache_addr),
        .cache_wr_en(dcache_wr_en),
        .cache_data_in(dcache_data_in),
        .cache_data_out(dcache_data_out),
        
        // Cache meta-data array interface
        .meta_idx(dmeta_idx),
        .meta_wr_en(dmeta_wr_en),
        .meta_wr_way(dmeta_wr_en),
        .meta_tag_in(dmeta_tag_in),
        .meta_valid_in(dmeta_valid_in),
        .meta_tag_out0(dmeta_tag_out0),
        .meta_valid_out0(dmeta_tag_out0),
        .meta_tag_out1(dmeta_tag_out1),
        .meta_valid_out1(dmeta_valid_out1),
        .meta_lru_in(dmeta_lru_in),
        .meta_lru_out(dmeta_lru_out),
        
        // Memory interface signals
        .mem_addr(dmem_addr),
        .mem_rd_req(dmem_wr_req),
        .mem_wr_req(dmem_wr_req),
        .mem_data_out(ddata_in),
        .mem_data_in(ddata_out),
        .mem_data_valid(ddata_valid),
        
        // Arbitration interface
        .mem_access_req(dmem_access_req),
        .mem_access_grant(dmem_access_grant)
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