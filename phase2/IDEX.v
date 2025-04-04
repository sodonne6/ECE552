module IDEX(
    	clk,
    	rst,
    	en,         	//when low the pipeline stalls 
    	//inputs from the ID stage
    	read_data_1_ID,     //read data 1
    	read_data_2_ID,     //read data 2
    	imm_ID,     	//sign extended immediate
    	PC_ID,      	//PC value from ID
    	//outputs to the EX stage
    	read_data_1_EX, 	//read data 1 value going to ex
    	read_data_2_EX,	//read data 2 going to ex
    	imm_EX,		//immidiate going to ex 
    	PC_EX,		//pc value going to ex
		ALUopd,ALUopq,ALUsrcd,ALUsrcq,//EX signals 
		MemWrited,MemWriteq,// M signals
		MemToRegd, RegWrited, RegAddrd,MemToRegq, RegWriteq, RegAddrq//WB signals

);


		input  [15:0] read_data_1_ID,read_data_2_ID,imm_ID,PC_ID;
		output [15:0] read_data_1_EX; 	//read data 1 value going to ex
    	output [15:0] read_data_2_EX;	//read data 2 going to ex
    	output [15:0] imm_EX;		//immidiate going to ex 
    	output [15:0] PC_EX;		//pc value going to ex
		//input and output signals for control signals
		input  ALUsrcd, clk,rst,en;
		input [3:0] ALUopd;
		output [3:0] ALUopq;
		output ALUsrcq;


		input MemWrited;
		output MemWriteq;

		input MemToRegd, RegWrited;
		input[3:0] RegAddrd;
		output MemToRegq, RegWriteq;
		output[3:0] RegAddrq;

		//control signals to be sent to the respective frames 
		EX iEX(.ALUopd(ALUopd),.ALUopq(ALUopq),.ALUsrcd(ALUsrcd),.ALUsrcq(ALUsrcq),.clk(clk),.rst(rst),.en(en));
		M iM(.MemWrited(MemWrited),.MemWriteq(MemWriteq),.clk(clk),.rst(rst),.en(en));
		WB iWB(.MemToRegd(MemToRegd), .RegWrited(RegWrited), .RegAddrd(RegAddrd),.MemToRegq(MemToRegq), .RegWriteq(RegWriteq), .RegAddrq(RegAddrq),.clk(clk),.rst(rst),.en(en));
    	//forward read_data_1 from ID to EX
    	Register rd1_reg (
        	.clk(clk),
        	.rst(rst),
        	.D(read_data_1_ID),
        	.WriteReg(en),
        	.ReadEnable1(1'b0),  //0 enables driving Bitline1 with the stored value
        	.ReadEnable2(1'b0),
        	.Bitline1(read_data_1_EX),
        	.Bitline2()
    	);

    	//forward read_data_2 from ID to EX
    	Register rd2_reg (
        	.clk(clk),
        	.rst(rst),
        	.D(read_data_2_ID),
        	.WriteReg(en),
        	.ReadEnable1(1'b0),
        	.ReadEnable2(1'b0),
        	.Bitline1(read_data_2_EX),
        	.Bitline2()
    	);

    	//forward the sign-extended immediate from ID to EX
    	Register imm_reg (
        	.clk(clk),
        	.rst(rst),
        	.D(imm_ID),
        	.WriteReg(en),
        	.ReadEnable1(1'b0),
        	.ReadEnable2(1'b0),
        	.Bitline1(imm_EX),
        	.Bitline2()
    	);

    	//forward the PC value from ID to EX
    	Register pc_reg (
        	.clk(clk),
        	.rst(rst),
        	.D(PC_ID),
        	.WriteReg(en),
        	.ReadEnable1(1'b0),
        	.ReadEnable2(1'b0),
        	.Bitline1(PC_EX),
        	.Bitline2()
    	);

endmodule
