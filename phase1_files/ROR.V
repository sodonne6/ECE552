module ROR (
    input [15:0] Rot_In,  //input to be rotated
    input [3:0] Rot_amt,  //rotation amount
    output [15:0] Rot_Out //output
);

    wire [15:0] r1, r2, r3, r4;

    //check each bit of rot_amt and rotate accordingly, if bit is 0 then move on with past rotated value
    assign r1 = Rot_amt[0] ? {Rot_In[0], Rot_In[15:1]} : Rot_In;
    assign r2 = Rot_amt[1] ? {r1[1:0], r1[15:2]} : r1;
    assign r3 = Rot_amt[2] ? {r2[3:0], r2[15:4]} : r2;
    assign r4 = Rot_amt[3] ? {r3[7:0], r3[15:8]} : r3;

    assign Rot_Out = r4;

endmodule
