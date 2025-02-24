//essentially an AND  gate that also outputs 1 if both 6bit numbers are 000000

module nxor6(
input wire [5:0] x, y,
output wire [5:0] nxor_6
    );
    
    nxor1 nxor_0 (.a(x[0]), .b(y[0]), .nxor_1(nxor_6[0]));
    nxor1 nxor_1 (.a(x[1]), .b(y[1]), .nxor_1(nxor_6[1]));
    nxor1 nxor_2 (.a(x[2]), .b(y[2]), .nxor_1(nxor_6[2]));
    nxor1 nxor_3 (.a(x[3]), .b(y[3]), .nxor_1(nxor_6[3]));
    nxor1 nxor_4 (.a(x[4]), .b(y[4]), .nxor_1(nxor_6[4]));
    nxor1 nxor_5 (.a(x[5]), .b(y[5]), .nxor_1(nxor_6[5]));
    
endmodule
