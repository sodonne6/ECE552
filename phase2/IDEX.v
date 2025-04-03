module IDEX(
    	input clk,
    	input rst,
    	input en,         	//when low the pipeline stalls 
    	//inputs from the ID stage
    	input [15:0] read_data_1_ID,     //read data 1
    	input [15:0] read_data_2_ID,     //read data 2
    	input [15:0] imm_ID,     	//sign extended immediate
    	input [15:0] PC_ID,      	//PC value from ID
    	//outputs to the EX stage
    	output [15:0] read_data_1_EX, 	//read data 1 value going to ex
    	output [15:0] read_data_2_EX,	//read data 2 going to ex
    	output [15:0] imm_EX,		//immidiate going to ex 
    	output [15:0] PC_EX		//pc value going to ex
);

    

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
