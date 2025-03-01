module add_sub_16(
    input signed [15:0] A, B,
    input sub, // 1 for subtraction, 0 for addition
    output signed [15:0] Sum,
    output Ovfl
);
    wire [15:0] B_xor; 
    wire [15:0] s;
    wire Cin;
    wire [3:0] C, PG, GG;

    assign B_xor = B ^ {16{sub}}; // negate if subtraction
    assign Cin = sub; // add 1 if negated

    add_sub_4 a1(A[3:0], B_xor[3:0], Cin, s[3:0], C[0], PG[0], GG[0]);
    add_sub_4 a2(A[7:4], B_xor[7:4], C[0], s[7:4], C[1], PG[1], GG[1]);
    add_sub_4 a3(A[11:8], B_xor[11:8], C[1], s[11:8], C[2], PG[2], GG[2]);
    add_sub_4 a4(A[15:12], B_xor[15:12], C[2], s[15:12], C[3], PG[3], GG[3]);

    assign Ovfl = (~A[15] & ~B_xor[15] & s[15]) | (A[15] & B_xor[15] & ~s[15]);
    assign Sum = Ovfl ? (A[15] ? 16'h8000 : 16'h7FFF) : s; // saturation
endmodule
