module RED (
  input [15:0] a,  
  input [15:0] b,  
  output [15:0] sum 
);
    // wires for the 4-bit values (extended to 5 bits to handle sign extension)
    wire [4:0] a0_ext, a1_ext, a2_ext, a3_ext;
    wire [4:0] b0_ext, b1_ext, b2_ext, b3_ext;

    wire [4:0] sum0, sum1, sum2, sum3;
    wire [6:0] sum01, sum23, total_sum; 
    
    // sign extend each 4-bit chunk to 5 bits
    assign a0_ext = {a[15], a[15:12]};
    assign a1_ext = {a[11], a[11:8]};
    assign a2_ext = {a[7], a[7:4]};
    assign a3_ext = {a[3], a[3:0]};
    
    assign b0_ext = {b[15], b[15:12]};
    assign b1_ext = {b[11], b[11:8]};
    assign b2_ext = {b[7], b[7:4]};
    assign b3_ext = {b[3], b[3:0]};
    
    // compute sums for each 4-bit signed chunk
    add_sub_4 ADD_BYTE_0 (
        .A(a[15:12]), .B(b[15:12]), .Cin(1'b0),
        .Sum(sum0[3:0]), .Cout(), .PG(), .GG()
    );
    // sign-extend the 4-bit result based on MSB
    assign sum0[4] = sum0[3]; 
    
    add_sub_4 ADD_BYTE_1 (
        .A(a[11:8]), .B(b[11:8]), .Cin(1'b0),
        .Sum(sum1[3:0]), .Cout(), .PG(), .GG()
    );
    assign sum1[4] = sum1[3];
    
    add_sub_4 ADD_BYTE_2 (
        .A(a[7:4]), .B(b[7:4]), .Cin(1'b0),
        .Sum(sum2[3:0]), .Cout(), .PG(), .GG()
    );
    assign sum2[4] = sum2[3]; 
    
    add_sub_4 ADD_BYTE_3 (
        .A(a[3:0]), .B(b[3:0]), .Cin(1'b0),
        .Sum(sum3[3:0]), .Cout(), .PG(), .GG()
    );
    assign sum3[4] = sum3[3]; 
    
    wire [15:0] sum0_ext, sum1_ext;
    assign sum0_ext = {{11{sum0[4]}}, sum0};
    assign sum1_ext = {{11{sum1[4]}}, sum1};
    
    add_sub_16 ADD_01 (
        .A(sum0_ext), 
        .B(sum1_ext), 
        .sub(1'b0),
        .Sum(sum01),
        .Ovfl()
    );
    
    wire [15:0] sum2_ext, sum3_ext;
    assign sum2_ext = {{11{sum2[4]}}, sum2};
    assign sum3_ext = {{11{sum3[4]}}, sum3};
    
    add_sub_16 ADD_23 (
        .A(sum2_ext), 
        .B(sum3_ext), 
        .sub(1'b0),
        .Sum(sum23),
        .Ovfl()
    );
    
    wire [15:0] sum01_ext, sum23_ext;
    assign sum01_ext = {{9{sum01[6]}}, sum01};
    assign sum23_ext = {{9{sum23[6]}}, sum23};
    
    add_sub_16 ADD_FINAL (
        .A(sum01_ext), 
        .B(sum23_ext), 
        .sub(1'b0),
        .Sum(total_sum),
        .Ovfl()
    );
    
    // sign extend
    assign sum = {{9{total_sum[6]}}, total_sum};  
endmodule
