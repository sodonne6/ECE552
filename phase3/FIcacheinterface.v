//interface from thbe fetch stage of the cpu and the I cache

module FICacheInterface(addr,clk,rst,data,data_ready,ren);

    input [15:0] addr;//address to read/write to
    input clk,rst,ren; //clock, reset, read enabled
    output [15:0] data;//instruction pulled
    output data_ready;//assert high when data is valid

endmodule