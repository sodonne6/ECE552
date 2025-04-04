// the wb register on top of each register in between steps, i.e. in cpu there should be 3 of these
//contains control signols needed in the WB phase
//d means input, q means output signal
//feel free to add more signals 
module WB(MemToRegd, RegWrited, RegAddrd,MemToRegq, RegWriteq, RegAddrq,clk,rst,en);
input clk,rst,en;
input MemToRegd, RegWrited;
input[3:0] RegAddrd;
output MemToRegq, RegWriteq;
output[3:0] RegAddrq;

dff  RegAddrdff[3:0](.q(RegAddrq), .d(RegAddrd), .wen(en), .clk(clk), .rst(rst));
dff idff1(.q(MemToRegq), .d(MemToRegd), .wen(en), .clk(clk), .rst(rst));
dff idff21(.q(RegWriteq), .d(RegWrited), .wen(en), .clk(clk), .rst(rst));
endmodule
