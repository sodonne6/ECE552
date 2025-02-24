module nxor1(
    input wire a,b,
    output wire nxor_1
    );
    
    assign nxor_1 = ~(a ^ b); 
endmodule

// a     b     nxor
// 0     0      1
// 0     1      0
// 1     0      0
// 1     1      1