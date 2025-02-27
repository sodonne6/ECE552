module PC_control(
    	input [2:0] C,      //condition code - dictionary prvided in brief 
    	input [8:0] I,      //signed offset
    	input [2:0] F,      //flags ZVN (Z=zero),(V=overflow),(N= negative)
    	input [15:0] PC_in, // Current PC
    	output [15:0] PC_out // Updated PC
);

    	wire [15:0] offset_ext;		//extended offset
    	wire [15:0] target;		//target address 
   	wire branch;		//flag to be hig or low depending on if branch is to be taken

    	//sign extend the offset I and shift by 1 to left
	//using I[8] keeps the sign and sign extends by the MSB to keep pos or neg
    	assign offset_extended = {{7{I[8]}}, I, 1'b0}; 

    	//compute target by by nxor PC_in with 16'00....10 (same as adding 2)
	//and the or with extended offset to get branch offset involved
    	assign target = (PC_in ^ 16'b0000000000000010) | offset_extended;

    	//assign flag bits from F input split into 3 wires 
    	wire Z = F[2];
    	wire V = F[1];
    	wire N = F[0];

    	//determine if the branch should be taken
	//check each code againt C and check if the condition is also passing 
	//these checks are OR'd against eachother so if one is high we know to take the branch
    	assign branch =   ((C == 3'b000) & ~Z) |  //not equal condition C will be 1 if equal and invert Z 
                          ((C == 3'b001) & Z) |   //equal logic
                          ((C == 3'b010) & (~Z & ~N)) | //greater Than no negative flag and not 0
                          ((C == 3'b011) & N) |   //negative flag high
                          ((C == 3'b100) & (Z | ~N)) |  //greater Than or Equal (Z == 1 or N=Z=0)
                          ((C == 3'b101) & (N | Z)) |  //less Than or equal (N=1 or Z=1)
                          ((C == 3'b110) & V) |   // Overflow (V=1)
                          (C == 3'b111);  //unconditional branch

    	//if branch is high we low the target into PC_Out and if not we simply load PC+2
    	assign PC_out = branch ? target : (PC_in ^ 16'b0000000000000010); // PC + 2

endmodule
