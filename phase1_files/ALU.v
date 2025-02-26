module ALU (
    	input  [15:0] ALU_In1, ALU_In2,  //Inputs
    	input  [3:0]  Opcode,            //4 bit opcode
    	input  [3:0]  Shamt,             //4 bit for shift as max shift should be 15 bits
    	output reg [15:0] ALU_Out,       //otuput
    	output reg Z, N, V              //flags for zero, neg, overflow
);

    	//wire results
    	wire [15:0] xor_result, sll_result, sra_result, ror_result, paddsb_result, red_result;
    	

    	//TODO: CLA implementation (New Modules needed?)

   
    	assign xor_result = ALU_In1 ^ ALU_In2;

    	//TODO: PADDSB (Parallel Add Saturation Byte-wise)
    

    

    	//logical left shift logic - taken from hw3
    	Shifter sll_unit (
        	.Shift_In(ALU_In1),
        	.Shift_Val(Shamt),
        	.Mode(1'b0), // Left shift
        	.Shift_Out(sll_result)
    	);
	//arithmetic right shift logic - taken from hw3
    	Shifter sra_unit (
        	.Shift_In(ALU_In1),
        	.Shift_Val(Shamt),
        	.Mode(1'b1), 
        	.Shift_Out(sra_result)
    	);

    	//TODO: ROTATE RIGHT

    	always @(*) begin
        	case (Opcode)
            //TODO: CONNECT WIRES HOLDING VALUES TO OPCODE
        	endcase

        	//if ALU_Out is 0 set Z to 1
        	Z = (ALU_Out == 16'b0) ? 1 : 0;
        	N = ALU_Out[15]; //MSB represents negative or positive (2's complement)
    	end

endmodule
