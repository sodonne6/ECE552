module MEMWB(
    clk,rst,en,
    MD_Out,//output of memory reading
	ALU_Out,//output of alu

    WALU_Out,
	WD_Out,
    MemToRegd, RegWrited, RegAddrd,MemToRegq, RegWriteq, RegAddrq//WB signals
);
    input clk,rst,en;

    input MemToRegd, RegWrited;
    input[3:0] RegAddrd;
    input[15:0]MD_Out,ALU_Out;
    output[15:0]WALU_Out,WD_Out;
    output MemToRegq, RegWriteq;
    output[3:0] RegAddrq;


    dff dff1[15:0](.d(ALU_Out),.q(WALU_Out),.wen(en),.clk(clk),.rst(rst));
    dff dff2[15:0](.d(MD_Out),.q(WD_Out),.wen(en),.clk(clk),.rst(rst));
    //control signals to be sent to the respective frames 
    WB iWB(.MemToRegd(MemToRegd), .RegWrited(RegWrited), .RegAddrd(RegAddrd),.MemToRegq(MemToRegq), .RegWriteq(RegWriteq), .RegAddrq(RegAddrq),.clk(clk),.rst(rst),.en(en));
endmodule