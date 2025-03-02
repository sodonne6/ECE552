module RED (
  input [15:0] a,  //16 bit input
  input [15:0] b,  //16 bit input
  output [15:0] sum //output bit val
);

    wire [4:0] sum0, sum1, sum2, sum3; //5-bit wires to handle overflow
    wire [6:0] sum01, sum23, total_sum; // Intermediate wires for addition

    // Compute sums for 4-bit chunks using carry-lookahead adders
    add_sub_4 ADD_BYTE_0 (
        .A(a[15:12]), .B(b[15:12]), .Cin(1'b0),
        .Sum(sum0[3:0]), .Cout(sum0[4]), .PG(), .GG()
    );
    add_sub_4 ADD_BYTE_1 (
        .A(a[11:8]), .B(b[11:8]), .Cin(1'b0),
        .Sum(sum1[3:0]), .Cout(sum1[4]), .PG(), .GG()
    );
    add_sub_4 ADD_BYTE_2 (
        .A(a[7:4]), .B(b[7:4]), .Cin(1'b0),
        .Sum(sum2[3:0]), .Cout(sum2[4]), .PG(), .GG()
    );
    add_sub_4 ADD_BYTE_3 (
        .A(a[3:0]), .B(b[3:0]), .Cin(1'b0),
        .Sum(sum3[3:0]), .Cout(sum3[4]), .PG(), .GG()
    );

    // Sum of sum0 and sum1 using CLA logic
    add_sub_16 ADD_01 (
        .A({11'b0, sum0}), 
        .B({11'b0, sum1}), 
        .sub(1'b0),
        .Sum(sum01),
        .Ovfl()
    );

    // Sum of sum2 and sum3 using CLA logic
    add_sub_16 ADD_23 (
        .A({11'b0, sum2}), 
        .B({11'b0, sum3}), 
        .sub(1'b0),
        .Sum(sum23),
        .Ovfl()
    );

    // Final sum using CLA logic
    add_sub_16 ADD_FINAL (
        .A({9'b0, sum01}), 
        .B({9'b0, sum23}), 
        .sub(1'b0),
        .Sum(total_sum),
        .Ovfl()
    );

    // Sign extend the final value
    assign sum = {{9{total_sum[6]}}, total_sum};  

endmodule
