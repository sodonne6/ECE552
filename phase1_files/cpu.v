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
	wire z,n,v;//ALU flags
	wire [15:0] pcp4, pcInput, branchALUresult;//pc +4, pc Input for pc flip flop, result after branch
	wire ovflpc,ovflpc2;
	
	assign {Opcode,rd,rs,rt }= instruction;//seperate the parts of the instruction
	
	dff pcReg[15:0](.q(pc), .d(pcInput), .wen(1'b1), .clk(clk), .rst());
	add_sub_16 pcp4adder(
		.A(pc), .B(16'h0002),
		.sub(1'b0), // 1 for subtraction, 0 for addition
		.Sum(pcp4),
		.Ovfl(ovflpc)//don't care);
		);
	add_sub_16 branchAdder(
		.A(pcp4), .B({immediate[14:1],1'b0}),
		.sub(1'b0), // 1 for subtraction, 0 for addition
		.Sum(branchALUresult),
		.Ovfl(ovflpc2)//don't care);
		);
	
	assign pcInput = (Branch&z)? branchALUresult:pcp4;
	
	
	
	RegWriteData = MemtoReg? MReadData:ALU_Out;//are we loading from memory?
	assign WriteReg = RegDst? rt:rs;//for the instruction what is the destination register
	RegisterFile rf(
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
    	 .Z(z), .N(n), .V(v));
	module control_unit (
    .instr(instruction),        
    .z_flag(z),              
    .v_flag(v),              // overflow 
    .n_flag(n),              
    
    .srcReg1(),      
    .srcReg2(),      
	.dstReg(),       
	.regWrite(RegWrite),           
    
	.aluOp(ALUOp),        
	.aluSrc(ALUSrc),             // 1 ===> Immediate value; 0 ===> Register 
    
    .memRead(MemRead),            
    .memWrite(MemWrite),           
    
    .branch(Branch),          
    .branchReg(),        
    .jumpAndLink(),        
	.halt(),               
 
	.immediate(SEImm),
    
    .llb(),                // Load Lower Byte
	.lhb()
);
	assign dataMemEn = MemWrite|MemRead;
	memory1c dataMem(.data_out(MReadData), .data_in(MWriteData), .addr(ALU_Out), .enable(dataMemEn), .wr(MemWrite), .clk(clk), .rst());


endmodule
