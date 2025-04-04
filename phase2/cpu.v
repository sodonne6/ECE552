module cpu(input clk, input rst_n, output hlt,output [15:0]pc);
	
	wire Branch,MemRead,MemtoReg, MemWrite,ALUSrc,RegWrite;//control signals for there final phase
	wire DMemRead,DMemtoReg, DMemWrite,DALUSrc,DRegWrite;//control signals for D phase
	wire XMemRead,XMemtoReg, XMemWrite,XRegWrite;//control signals for ex phase
	wire WMemtoReg,WRegWrite;//control signals for M phase to forward
	wire [3:0] DALUOp,ALUOp;
	wire [15:0] RReadData1,RReadData2,DRReadData1,DRReadData2,XRReadData1,XRReadData2,MReadData,WMReadData,ALUin2,ALUin1,MALUIn2;// register outputs, data mem outputs, and intermediate signal for ALU input
	wire [15:0] WRReadData1,WRReadData2,MReadData1,MReadData2;
	wire[15:0] ALU_Out,MALU_Out,WALU_Out;//output of central ALU
	wire[15:0] instruction;//Current instruction
	wire [15:0] DSEImm,XSEImm;//sign extended immediate
	wire dataMemEn;//enable data Mem?
	wire [15:0] RegWriteData;
	wire [3:0] Opcode, rd,rs,rt;//where rt could be immediate
	wire[3:0] WriteReg,DWriteReg, XWriteReg, MWriteReg;//what register to write to
	wire z,n,v,z_q,n_q,v_q;//ALU flags
	wire [15:0] pcp4, pcInput, branchALUresult;//pc +4, pc Input for pc flip flop, result after branch
	wire ovflpc,ovflpc2;
	wire llb, lhb;
	wire [3:0] cusrcReg1,cusrcReg2,cudstReg;//control unit signals for register file inputs
	wire jumpAndLink, BranchReg;
	wire rst,cycle,cycle2;//assert reset when resetting, cycle is true when rst_n is low for at least one cycle
	wire [15:0] highByteLoad,lowByteLoad;//intermediate signals for hbl, lbu
	wire[15:0] Dpc;//pc in dc phase (+4)
	wire c_n,c_v,c_z;//change n,v,z?
	wire Dllb, Dlhb,Xllb,Xlhb,Mllb,Mlhb;
	assign {Opcode,rd,rs,rt }= instruction;//seperate the parts of the instruction
	
	IFID iIFID(
    	.clk(clk),
    	.rst(rst),
    	.nxt_instr(),  
    	.nxt_PC(),    
    	.en(1'b1),         //assert to let pipeline know to keep going -> when low the pipeline stalls 
    	.instr_ID(),   
    	.PC_ID()       
	);
	IDEX iIDEX(
    	.clk(clk),.rst(rst),.en(1'b1),         	//when low the pipeline stalls 
    	//inputs from the ID stage
		.read_data_1_ID(DRReadData1),     //read data 1
    	.read_data_2_ID(DRReadData2),     //read data 2
    	.imm_ID(DSEImm),     	//sign extended immediate
    	.PC_ID(),      	//PC value from ID
    	//outputs to the EX stage
    	.read_data_1_EX(XRReadData1), 	//read data 1 value going to ex
    	.read_data_2_EX(XRReadData2),	//read data 2 going to ex
    	.imm_EX(XSEImm),		//immidiate going to ex 
    	.PC_EX(),		//pc value going to ex
		.ALUopd(DALUOp),.ALUopq(ALUOp),.ALUsrcd(DALUSrc),.ALUsrcq(ALUsrc),//EX signals 
		.MemWrited(DMemWrite),.MemWriteq(XMemWrite),// M signals
		.MemToRegd(DMemToReg), .RegWrited(DRegWrite), .RegAddrd(DWriteReg),.MemToRegq(XMemToRegd), .RegWriteq(XRegWrite), .RegAddrq(XWriteReg),//WB signals
		.llbd(Dllb),.llbq(Xllb),.lhbd(Dlhb),.lhbq(Xlhb)//more WB signals
		);
	EXMEM iEXMEM(
        .clk(clk),.rst(rst),.en(1'b1), 
		.ALU_Out(ALU_Out),//output of EX ALU
		.ALU_In2(ALUin2),

		.read_data_1_EX(XRReadData1),     //read data 1
    	.read_data_2_EX(XRReadData2),     //read data 2
		.read_data_1_M(WRReadData1), 	//read data 1 value going to ex
    	.read_data_2_M(WRReadData2),	//read data 2 going to ex





		.MALU_Out(MALU_Out),
		.MALU_In2(MALUIn2),

        .MemWrited(XMemWrite),.MemWriteq(MemWrite),// M signals
		.MemToRegd(XMemToRegd), .RegWrited(XRegWrite), .RegAddrd(XWriteReg),.MemToRegq(MMemToRegd), .RegWriteq(MRegWrite), .RegAddrq(MWriteReg),//WB signals
		.llbd(Xllb),.llbq(Mllb),.lhbd(Xlhb),.lhbq(Mlhb)//more WB signals
        );
	MEMWB	iMEMWB(
    .clk(clk),.rst(rst),.en(1'b1),
	.MD_Out(MReadData),//output of memory reading
	.ALU_Out(MALU_Out),//output of alu


	.read_data_1_M(DRReadData1),     //read data 1
    .read_data_2_M(DRReadData2),     //read data 2
	.read_data_1_WB(XRReadData1), 	//read data 1 value going to ex
    .read_data_2_WB(XRReadData2),	//read data 2 going to ex

	.WALU_Out(WALU_Out),
	.WD_Out(WMReadData),

	.MemToRegd(MMemToRegd), .RegWrited(MRegWrite), .RegAddrd(MWriteReg),.MemToRegq(MemToReg), .RegWriteq(RegWrite), .RegAddrq(WriteReg),//WB signals
	.llbd(Mllb),.llbq(llb),.lhbd(Mlhb),.lhbq(lhb)//more WB signals
	);
	//TODO: look at rst_n mechanics,
	
	//assign rst = ~rst_n;
	//pc flip flop
	
	dff pcReg[15:0](.q(pc), .d(pcInput), .wen(1'b1), .clk(clk), .rst(rst));
	
	dff cycleff(.q(cycle),.d(1'b1),.clk(clk),.wen(1'b1),.rst(~rst_n));
	dff rstff(.q(cycle2),.d(cycle|rst_n),.rst(1'b0),.wen(1'b1),.clk(clk));
	assign rst = ~cycle2&(~rst_n);
	
	//keep flags in flip flop to check branch potentially
	dff nff(.q(n_q),.d(n),.wen(c_n),.clk(clk),.rst(rst));//only store when alu operation
	dff vff(.q(v_q),.d(v),.wen(c_v),.clk(clk),.rst(rst));//only store when alu operation
	dff zff(.q(z_q),.d(z),.wen(c_z),.clk(clk),.rst(rst));//only store when alu operation
	
	add_sub_16 pcp4adder(//add 2 to pc
		.A(pc), .B(16'h0002),
		.sub(1'b0), // 1 for subtraction, 0 for addition
		.Sum(pcp4),
		.Ovfl(ovflpc)//don't care);
		);
		
	add_sub_16 branchAdder(//compute pc+2 + offset
		.A(pcp4), .B({DSEImm[15:0]}),
		.sub(1'b0), // 1 for subtraction, 0 for addition
		.Sum(branchALUresult),
		.Ovfl(ovflpc2)//don't care);
		);
	
	assign pcInput = rst? 16'h0000:
					Branch ? branchALUresult:
					BranchReg? RReadData1//is it a branch?
					:pcp4;
	
	memory1c_instr instructionMem(.data_out(instruction), .data_in(16'hxxxx), .addr(pc), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(rst));
	
	assign highByteLoad ={instruction[7:0],WRReadData2[7:0]};
	assign lowByteLoad ={WRReadData2[15:8],instruction[7:0]};
	
	assign RegWriteData = lhb?highByteLoad
		:llb? lowByteLoad
		:MemtoReg? MReadData//are we loading from memory?
		:jumpAndLink? pcp4//pcs?
		:ALU_Out;//default is just the result of whatever operation
	
	
	
	//assign WriteReg = RegDst? rt:rs;//for the instruction what is the destination register
	RegisterFile rf(
    .clk(clk),
    .rst(rst),
    .SrcReg1(cusrcReg1),
    .SrcReg2(cusrcReg2),
    .DstReg(WriteReg),
    .WriteReg(RegWrite),
    .DstData(RegWriteData),
    .SrcData1(DRReadData1),
    .SrcData2(DRReadData2)
);
	
	assign ALUin2 = ALUSrc? DSEImm:RReadData2;
	assign ALUin1 = RReadData1;
	ALU iALU(
    	.ALU_In1(ALUin1), .ALU_In2(ALUin2),  
    	.Opcode(ALUOp),            
    	.Shamt(rt),//TODO add an intermediate signal for this      
    	.ALU_Out(ALU_Out),     
    	 .Z(z), .N(n), .V(v));
		 
		 //control unit
	control_unit CU(
    .instr(instruction),        
    .z_flag(z_q),              
    .v_flag(v_q),              // overflow 
    .n_flag(n_q),              
    
	.c_z(c_z),
	.c_v(c_v),
	.c_n(c_n),
	
    .srcReg1(cusrcReg1),      
    .srcReg2(cusrcReg2),      
	.dstReg(DWriteReg),       
	.regWrite(DRegWrite),           
    
	.aluOp(DALUOp),        
	.aluSrc(DALUSrc),             // 1 ===> Immediate value; 0 ===> Register 
    
    .memRead(DMemRead),            
    .memWrite(DMemWrite),           
    
    .branch(Branch),          
    .branchReg(BranchReg),        
    .jumpAndLink(jumpAndLink),        
	.halt(hlt),               
 
	.immediate(DSEImm),
    
    .llb(Dllb),                // Load Lower Byte
	.lhb(Dlhb)
);
	assign DMemtoReg = DMemRead;
	assign dataMemEn = MemWrite|MemToReg;
	
	memory1c dataMem(.data_out(MReadData), .data_in(MALUIn2), .addr(MALU_Out), .enable(dataMemEn), .wr(MemWrite), .clk(clk), .rst(rst));

endmodule
