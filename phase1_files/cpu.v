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
	wire llb, lhb;
	wire [3:0] cusrcReg1,cusrcReg2,cudstReg;//control unit signals for register file inputs
	wire jumpAndLink, BranchReg;
	wire rst;
	wire [15:0] halfByteLoad;
	
	assign {Opcode,rd,rs,rt }= instruction;//seperate the parts of the instruction
	
	//TODO: look at rst_n mechanics, LLB,LHB don't do anything rn
	assign rst = ~rst_n;
	//pc flip flop
	
	dff pcReg[15:0](.q(pc), .d(pcInput), .wen(1'b1), .clk(clk), .rst(rst));
	
	add_sub_16 pcp4adder(//add 2 to pc
		.A(pc), .B(16'h0002),
		.sub(1'b0), // 1 for subtraction, 0 for addition
		.Sum(pcp4),
		.Ovfl(ovflpc)//don't care);
		);
		
	add_sub_16 branchAdder(//compute pc+2 + offset
		.A(pcp4), .B({SEImm[14:1],1'b0}),
		.sub(1'b0), // 1 for subtraction, 0 for addition
		.Sum(branchALUresult),
		.Ovfl(ovflpc2)//don't care);
		);
	
	assign pcInput = (Branch&z)? branchALUresult:pcp4;
	
	memory1c_instr instructionMem(.data_out(instruction), .data_in(16'hxxxx), .addr(pc), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(rst));
	
	assign halfByteLoad = {lhb?instruction[7:0]:RReadData1[15:8],llb?instruction[7:0]:RReadData1[7:0]};
	
	
	assign RegWriteData = (lhb|llb)?
		halfByteLoad
		:MemtoReg? MReadData:ALU_Out;//are we loading from memory?
	
	
	
	assign WriteReg = RegDst? rt:rs;//for the instruction what is the destination register
	RegisterFile rf(
    .clk(clk),
    .rst(rst),
    .SrcReg1(rd),
    .SrcReg2(rs),
    .DstReg(WriteReg),
    .WriteReg(RegWrite),
    .DstData(RegWriteData),
    .SrcData1(RReadData1),
    .SrcData2(RReadData2)
);
	
	assign ALUin2 = ALUSrc? SEImm:RReadData2;
	ALU iALU(
    	.ALU_In1(ReadData1), .ALU_In2(ALUin2),  
    	.Opcode(aluOp),            
    	.Shamt(rt),             
    	.ALU_Out(ALU_Out),     
    	 .Z(z), .N(n), .V(v));
		 
		 //control unit
	control_unit CU(
    .instr(instruction),        
    .z_flag(z),              
    .v_flag(v),              // overflow 
    .n_flag(n),              
    
    .srcReg1(cusrcReg1),      
    .srcReg2(cusrcReg2),      
	.dstReg(cudstReg),       
	.regWrite(RegWrite),           
    
	.aluOp(ALUOp),        
	.aluSrc(ALUSrc),             // 1 ===> Immediate value; 0 ===> Register 
    
    .memRead(MemRead),            
    .memWrite(MemWrite),           
    
    .branch(Branch),          
    .branchReg(BranchReg),        
    .jumpAndLink(jumpAndLink),        
	.halt(halt),               
 
	.immediate(SEImm),
    
    .llb(llb),                // Load Lower Byte
	.lhb(lhb)
);
	assign dataMemEn = MemWrite|MemRead;
	memory1c dataMem(.data_out(MReadData), .data_in(MWriteData), .addr(ALU_Out), .enable(dataMemEn), .wr(MemWrite), .clk(clk), .rst(rst));


endmodule
