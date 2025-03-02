module cpu(input clk, input rst_n, output hlt,output [15:0]pc);
	
	wire RegDst,Branch,MemRead,MemtoReg,ALUOp, MemWrite,ALUSrc,RegWrite;//control signals
	wire [15:0] RReadData1,RReadData2,MReadData,MWriteData,ALUin2;// register outputs, data mem outputs, and intermediate signal for ALU input
	wire[15:0] ALU_Out;//output of central ALU
	wire[15:0] instruction;//Current instruction
	wire [15:0] SEImm;//sign extended immediate
	wire dataMemEn;//enable data Mem?
	wire [15:0] RegWriteData;
	wire [3:0] Opcode, rd,rs,rt;//where rt could be immediate
	wire[3:0] WriteReg;//what register to write to

	assign {Opcode,rd,rs,rt }= instruction;//seperate the parts of the instruction
	
	dff pcReg(.q(), .d(), .wen(), .clk(), .rst());
	
	
	RegWriteData = MemtoReg? MReadData:ALU_Out;//are we loading from memory?
	assign WriteReg = RegDst? rt:rs;//for the instruction what is the destination register
	module RegisterFile(
    .clk(clk),
    .rst(),
    .SrcReg1(rd),
    .SrcReg2(rs),
    .DstReg(WriteReg),
    .WriteReg(RegWrite),
    .DstData(RegWriteData),
    .SrcData1(RReadData1),
    .SrcData2(RReadData2)
);
	
	assign ALUin2 = ALUSrc? :RReadData2
	ALU iALU(
    	.ALU_In1(ReadData1), .ALU_In2(ALUin2),  
    	.Opcode(),            
    	.Shamt(),             
    	.ALU_Out(ALU_Out),     
    	 .Z(), .N(), .V());

	assign dataMemEn = MemWrite|MemRead;
	memory1c dataMem(.data_out(MReadData), .data_in(MWriteData), .addr(ALU_Out), .enable(dataMemEn), .wr(MemWrite), .clk(clk), .rst());


endmodule
