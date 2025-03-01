module RED (
  input [15:0] a,  //16 bit input
  input [15:0] b,  //16 bit input
  output [15:0] sum //output bit val
);

    	wire [4:0] sum0, sum1, sum2, sum3; //5 bit wires to handle overflow
    	wire [6:0] sum01, sum23, total_sum; //intermediate wires for addition

    	//aaaa+eeee
    	add_sub_4 ADD_BYTE_0 (
        	.A(a[15:12]), .B(b[15:12]), .sub(1'b0),
        	.Sum(sum0[3:0]), .Ovfl(sum0[4])
    	);
	//bbbb+ffff
    	add_sub_4 ADD_BYTE_1 (
        	.A(a[11:8]), .B(b[11:8]), .sub(1'b0),
        	.Sum(sum1[3:0]), .Ovfl(sum1[4])
    	);
	//cccc+gggg
    	add_sub_4 ADD_BYTE_2 (
        	.A(a[7:4]), .B(b[7:4]), .sub(1'b0),
        	.Sum(sum2[3:0]), .Ovfl(sum2[4])
    	);
	//dddd+hhhh
    	add_sub_4 ADD_BYTE_3 (
        	.A(a[3:0]), .B(b[3:0]), .sub(1'b0),
        	.Sum(sum3[3:0]), .Ovfl(sum3[4])
    	);

    	//sum0 + sum1
	//use 16 bit adder with 0 extension
    	add_sub_16 ADD_01 (
        	.A({11'b0, sum0}), 
        	.B({11'b0, sum1}), 
        	.sub(1'b0),
        	.Sum(sum01),
        	.Ovfl()
    	);	

    	//sum2 + sum3
	    //use 16 bit adder with 0 extension
    	add_sub_16 ADD_23 (
        	.A({11'b0, sum2}), 
        	.B({11'b0, sum3}), 
        	.sub(1'b0),
        	.Sum(sum23),
        	.Ovfl()
    	);

    	//final instantiation of 16 bit adder 
	    //extend by 0's
    	add_sub_16 ADD_FINAL (
        	.A({9'b0, sum01}), 
        	.B({9'b0, sum23}), 
        	.sub(1'b0),
        	.Sum(total_sum),
        	.Ovfl()
    	);

    	//sign extend the final value
    	assign sum = {{9{total_sum[6]}}, total_sum};  

endmodule
 
