module red(
    	input [15:0] A, B,
    	output [15:0] Sum
);
    	wire [4:0] sum_ae, sum_bf, sum_cg, sum_dh;
    	wire [4:0] sum_ae_bf, sum_cg_dh;
	wire [2:0] sum_ae_bf_out, sum_cg_dh_out;
    	wire [5:0] final_sum;
	wire [3:0}
	
    	//level 1 - add each 4 bits and log the carry out bits as the MSB's
    	add_sub_4 adder1(.A(A[15:12]), .B(B[15:12]), .Cin(1'b0), .Sum(sum_ae[3:0]), .Cout(sum_ae[4]), .PG(), .GG(), .Ovfl());
    	add_sub_4 adder2(.A(A[11:8]),  .B(B[11:8]),  .Cin(1'b0), .Sum(sum_bf[3:0]), .Cout(sum_bf[4]), .PG(), .GG(), .Ovfl());
    	add_sub_4 adder3(.A(A[7:4]),   .B(B[7:4]),   .Cin(1'b0), .Sum(sum_cg[3:0]), .Cout(sum_cg[4]), .PG(), .GG(), .Ovfl());
    	add_sub_4 adder4(.A(A[3:0]),   .B(B[3:0]),   .Cin(1'b0), .Sum(sum_dh[3:0]), .Cout(sum_dh[4]), .PG(), .GG(), .Ovfl());
	
    	//level 2 - add 4 bit parts first
    	add_sub_4 adder5(.A(sum_ae[3:0]), .B(sum_bf[3:0]), .Cin(1'b0), .Sum(sum_ae_bf[3:0]), .Cout(sum_ae_bf[4]), .PG(), .GG(), .Ovfl());
    	add_sub_4 adder6(.A(sum_cg[3:0]), .B(sum_dh[3:0]), .Cin(1'b0), .Sum(sum_cg_dh[3:0]), .Cout(sum_cg_dh[4]), .PG(), .GG(), .Ovfl());
	//then add carry out bits - append 0's to inputs to make 4 bit
	//the output will be 2 bits at most
	//no cout needed
	add_sub_4 adder7(.A({3'b0,sum_ae[4]}), .B({3'b0,sum_bf[4]}), .Cin(1'b0), .Sum(sum_ae_bf_out), .Cout(), .PG(), .GG(), .Ovfl());	
    	add_sub_4 adder8(.A({3'b0,sum_cg[4]}), .B({3'b0,sum_cg[4]}), .Cin(1'b0), .Sum(sum_cg_dh_out), .Cout(), .PG(), .GG(), .Ovfl());

	

    	
    	

endmodule
