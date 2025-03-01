module add_sub_16(
    input [15:0] A, B,
    input sub, // 1 for subtraction, 0 for addition
    output [15:0] Sum,
    output Ovfl
);
    wire [15:0] B_xor; 
    wire Cin;
    wire [3:0] C, PG, GG;

    assign B_xor = B ^ {16{Sub}}; //negate if subtraction
    assign Cin = Sub; // add 1 if negated

    CLA_4bit cla0(A[3:0], B_xor[3:0], Cin, Sum[3:0], C[0], PG[0], GG[0]);
    CLA_4bit cla1(A[7:4], B_xor[7:4], C[0], Sum[7:4], C[1], PG[1], GG[1]);
    CLA_4bit cla2(A[11:8], B_xor[11:8], C[1], Sum[11:8], C[2], PG[2], GG[2]);
    CLA_4bit cla3(A[15:12], B_xor[15:12], C[2], Sum[15:12], C[3], PG[3], GG[3]);

    assign Ovfl = GG[3] | (PG[3] & C[3]);
endmodule
