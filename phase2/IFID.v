module IFID(
    	input clk,
    	input rst,
    	input [15:0] nxt_instr,  
    	input [15:0] nxt_PC,    
    	input en,         //assert to let pipeline know to keep going -> when low the pipeline stalls 
    	output [15:0] instr_ID,   
    	output [15:0] PC_ID       
);

    
    	//unused Bitline2 is left unconnected
	//registere for connection
    	Register instr_reg (
        	.clk(clk),
        	.rst(rst),
        	.D(nxt_instr),
        	.WriteReg(en),
        	.ReadEnable1(1'b0),  // 0 enables output of stored data on Bitline1
        	.ReadEnable2(1'b0),
        	.Bitline1(instr_ID),
        	.Bitline2()          // Unused
    	);
    	//register for pc value
    	Register pc_reg (
        	.clk(clk),
        	.rst(rst),
        	.D(nxt_PC),
        	.WriteReg(en),
        	.ReadEnable1(1'b0),  //0 allows output of stored data on Bitline1
        	.ReadEnable2(1'b0),
        	.Bitline1(PC_ID),
        	.Bitline2()          //not used for project currently
    	);

endmodule
