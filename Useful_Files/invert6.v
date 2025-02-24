module invert6(
input wire [5:0] x,
output wire [5:0] notx,
output wire [5:0] invertx
);
wire b = 6'b000001; //add at after inverting each bit to complete process
//invert each bit using invert1
invert1 invert1_0 (.d(x[0]), .notd(notx[0]));
invert1 invert1_1 (.d(x[1]), .notd(notx[1]));
invert1 invert1_2 (.d(x[2]), .notd(notx[2]));
invert1 invert1_3 (.d(x[3]), .notd(notx[3]));
invert1 invert1_4 (.d(x[4]), .notd(notx[4]));
invert1 invert1_5 (.d(x[5]), .notd(notx[5]));

assign invertx = notx + b;


endmodule
