module add_sub_16 (
    	input [15:0] A, B,   // 4-bit Inputs
    	input sub,          // 0 = Add, 1 = Subtract
    	output [15:0] Sum,   // 4-bit Sum Output
    	output Ovfl         // Overflow Flag
);
	//rs and rt have widths of 5 bits so
	
    	wire [15:0] B_xor;   // XOR version of B
    	wire [15:0] carry;   //carry signals

    	
    	assign B_xor = B ^ {4{sub}};  

    	//instantiate Full Adders 
    	fulladder_1bit FA0 (A[0], B_xor[0], sub,      Sum[0], carry[0]);
    	fulladder_1bit FA1 (A[1], B_xor[1], carry[0], Sum[1], carry[1]);
    	fulladder_1bit FA2 (A[2], B_xor[2], carry[1], Sum[2], carry[2]);
    	fulladder_1bit FA3 (A[3], B_xor[3], carry[2], Sum[3], carry[3]);

	fulladder_1bit FA4 (A[4], B_xor[4], carry[3], Sum[4], carry[4]);
	fulladder_1bit FA5 (A[5], B_xor[5], carry[4], Sum[5], carry[5]);
    	fulladder_1bit FA6 (A[6], B_xor[6], carry[5], Sum[6], carry[6]);
    	fulladder_1bit FA7 (A[7], B_xor[7], carry[6], Sum[7], carry[7]);

	fulladder_1bit FA8 (A[8], B_xor[8], carry[7], Sum[8], carry[8]);
	fulladder_1bit FA9 (A[9], B_xor[9], carry[8], Sum[9], carry[9]);
    	fulladder_1bit FA10 (A[10], B_xor[10], carry[9], Sum[10], carry[10]);
    	fulladder_1bit FA11 (A[11], B_xor[11], carry[10], Sum[11], carry[11]);

	fulladder_1bit FA12 (A[12], B_xor[12], carry[11], Sum[12], carry[12]);
	fulladder_1bit FA13 (A[13], B_xor[13], carry[12], Sum[13], carry[13]);
    	fulladder_1bit FA14 (A[14], B_xor[14], carry[13], Sum[14], carry[14]);
    	fulladder_1bit FA15 (A[15], B_xor[15], carry[14], Sum[15], carry[15]);

    	//Overflow Detection
    	assign Ovfl = (~(A[15] ^ B_xor[15])) & (A[15] ^ Sum[15]);

endmodule


