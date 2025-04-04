module EXMEM(
        clk,
    	rst,
    	en, 
		ALU_Out,
		ALU_In2,

		MALU_Out,
		MALU_In2,
        MemWrited,MemWriteq,// M signals
		MemToRegd, RegWrited, RegAddrd,MemToRegq, RegWriteq, RegAddrq//WB signals
        );
		//input and output signals for control signals

		input clk,rst,en;

		input MemWrited,MemToRegd, RegWrited;
		input[3:0] RegAddrd;
		input[15:0] ALU_Out,ALU_In2;
		output[15:0] MALU_Out;
		output[15:0] MALU_In2;
		output MemWriteq,MemToRegq, RegWriteq;
		output[3:0] RegAddrq;

		//control signals to be sent to the respective frames 
		dff dff1[15:0](.d(ALU_Out),.q(MALU_Out),.wen(en),.clk(clk),.rst(rst));
		dff dff2[15:0](.d(ALU_In2),.q(MALU_In2),.wen(en),.clk(clk),.rst(rst));
		M iM(.MemWrited(MemWrited),.MemWriteq(MemWriteq),.clk(clk),.rst(rst),.en(en));
		WB iWB(.MemToRegd(MemToRegd), .RegWrited(RegWrited), .RegAddrd(RegAddrd),.MemToRegq(MemToRegq), .RegWriteq(RegWriteq), .RegAddrq(RegAddrq),.clk(clk),.rst(rst),.en(en));


endmodule