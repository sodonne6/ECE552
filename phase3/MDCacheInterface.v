module MDCacheInterface(addr,clk,rst,data,data_ready);

    input [15:0] addr;//address to read/write to
    input clk,rst; 
    input [15:0] data_in;
    input wen, ren;//write/read enabled
    output [15:0] data_out;
    output data_ready;//assert high when data is valid

endmodule