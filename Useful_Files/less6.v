//use 8 bit greater than or equal to from LabB 
//inverting the final answer from this Lab files will constitute as a A<B circuit 
// ~(A>=B) = A<B

module less6(
input wire [7:0] x,y,
output less_6
    );
    
wire [7:0] x8,y8;

//store 6th bit in independant variables to use for 2's complement 
wire msbx, msby, out;
assign msbx = x[5];
assign msby = y[5];

//in context that this is a 6 bit circuit the 8th and 7th bit of x and y need to be set to 0 
//load 6 bit inouts into the first 6 bits of x8 and y8
assign x8 [7:6] = 0;
assign y8 [7:6] = 0;
assign x8 [5:0] = x;
assign y8 [5:0] = y;
    
greq8 A_greq_B (.a(x8), .b(y8), .greq(out));
assign less_6 = ~msbx & out | ~msbx & msby | msby & out;


endmodule
