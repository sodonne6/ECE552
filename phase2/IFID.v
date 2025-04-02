//FORWARDS DATA FROM IF TO ID

module IFID(
	input clk,
	input rst,
	input [15:0] nxt_instr,
	input [15:0] nxt_PC,
	input en,		//assert to let pipeline know to keep going -> when low the pipeline stalls 
	output [15:0] instr_ID,
	output [15:0] PC_ID

);

	//istantiate 16 flip flops for next_instr
	//passes current instruction to instr_ID 
  	dff dff_nxt_instr_0  (.q(instr_ID[0]),  .d(nxt_instr[0]),  .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_1  (.q(instr_ID[1]),  .d(nxt_instr[1]),  .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_2  (.q(instr_ID[2]),  .d(nxt_instr[2]),  .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_3  (.q(instr_ID[3]),  .d(nxt_instr[3]),  .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_4  (.q(instr_ID[4]),  .d(nxt_instr[4]),  .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_5  (.q(instr_ID[5]),  .d(nxt_instr[5]),  .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_6  (.q(instr_ID[6]),  .d(nxt_instr[6]),  .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_7  (.q(instr_ID[7]),  .d(nxt_instr[7]),  .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_8  (.q(instr_ID[8]),  .d(nxt_instr[8]),  .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_9  (.q(instr_ID[9]),  .d(nxt_instr[9]),  .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_10 (.q(instr_ID[10]), .d(nxt_instr[10]), .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_11 (.q(instr_ID[11]), .d(nxt_instr[11]), .wen(en), .clk(clk), .rst(rst));  	
	dff dff_nxt_instr_12 (.q(instr_ID[12]), .d(nxt_instr[12]), .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_13 (.q(instr_ID[13]), .d(nxt_instr[13]), .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_14 (.q(instr_ID[14]), .d(nxt_instr[14]), .wen(en), .clk(clk), .rst(rst));
  	dff dff_nxt_instr_15 (.q(instr_ID[15]), .d(nxt_instr[15]), .wen(en), .clk(clk), .rst(rst));

	//istantiate 16 flops for next instr
	dff dff_nxt_PC_0 (.q(PC_ID[0]),  .d(nxt_PC[0]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_1 (.q(PC_ID[1]),  .d(nxt_PC[1]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_2 (.q(PC_ID[2]),  .d(nxt_PC[2]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_3 (.q(PC_ID[3]),  .d(nxt_PC[3]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_4 (.q(PC_ID[4]),  .d(nxt_PC[4]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_5 (.q(PC_ID[5]),  .d(nxt_PC[5]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_6 (.q(PC_ID[6]),  .d(nxt_PC[6]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_7 (.q(PC_ID[7]),  .d(nxt_PC[7]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_8 (.q(PC_ID[8]),  .d(nxt_PC[8]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_9 (.q(PC_ID[9]),  .d(nxt_PC[9]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_10 (.q(PC_ID[10]),  .d(nxt_PC[10]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_11 (.q(PC_ID[11]),  .d(nxt_PC[11]),  .wen(en), .clk(clk), .rst(rst));	
	dff dff_nxt_PC_12 (.q(PC_ID[12]),  .d(nxt_PC[12]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_13 (.q(PC_ID[13]),  .d(nxt_PC[13]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_14 (.q(PC_ID[14]),  .d(nxt_PC[14]),  .wen(en), .clk(clk), .rst(rst));
	dff dff_nxt_PC_15 (.q(PC_ID[15]),  .d(nxt_PC[15]),  .wen(en), .clk(clk), .rst(rst));




endmodule