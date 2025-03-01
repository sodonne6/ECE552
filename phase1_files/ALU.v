module ALU (
    	input  [15:0] ALU_In1, ALU_In2,  //Inputs
    	input  [3:0]  Opcode,            //4 bit opcode
    	input  [3:0]  Shamt,             //4 bit for shift as max shift should be 15 bits
    	output reg [15:0] ALU_Out,       //otuput
    	output reg Z, N, V              //flags for zero, neg, overflow
);
	//ALL SUBMODULE HAVE BEEN MADE NOW NEED TO CONNECT
    	//wire results
    	wire [15:0] xor_result, shft_result, paddsb_result, red_result,add_result;
    	
	//TODO: ADD/SUB - ALREADY MADE RIPPLE ADDER CAN BE USED AGAIN FOR THIS ONE
	//TODO: Implement saturation - not difficult, if theres overflow saturate to most pos or most neg
	//Saturation implemented - must be tested but seems fairly intuitive - DONE?
	add_sub_16 add_unit (
		.A(ALU_In1),
		.B(ALU_In2),
		.sub(Opcode[0]),
		.Sum(add_result),
		.Ovfl(V)

	);
	
    	//TODO: XOR - DONE?
	assign xor_result = (ALU_In1 ^ ALU_In2);

   

    	//TODO: PADDSB - saturation added - DONE?
    	PADDSB_16 PADDSB(
		.A(ALU_In1),
		.B(ALU_In2),
		.Sum(paddsb_result),
		.Error()
	);

    
	//change this to only one shift call and differentiate all the shifts using opcode (sll,sra,ror)
	//this involves combining the ror and sll module
    	//logical left shift logic - taken from hw3 - DONE
    	Shifter sll_unit (
        	.Shift_In(ALU_In1),
        	.Shift_Val(Shamt),
        	.Mode(Opcode[2:0]), //logic to dinstinguish is inside the shifter module
        	.Shift_Out(shft_result)
    	);
	

	RED RED(
		.a(ALU_In1),
		.b(ALU_In2),
		.sum(red_result)
	);

    	always @(*) begin
        	case (Opcode)
            //TODO: CONNECT WIRES HOLDING VALUES TO OPCODE
			4'b0000, 4'b0001: begin  //add or sub - based on bit 0 of opcode - if Opcode[0] == 0 -> add 
                		ALU_Out = add_result; //output solution
                		//implement V flag
			end
			4'b0010: begin
				ALU_Out = xor_result;
			end
			4'b0011: begin
				ALU_Out = red_result;
			end
			4'b0100: begin
				ALU_Out = shft_result;
			end
			4'b0101: begin
				ALU_Out = shft_result;
			end
			4'b0110: begin
				ALU_Out = shft_result;
			end
			4'b0111: begin
				ALU_Out = paddsb_result;
			end
        	endcase

        	//if ALU_Out is 0 set Z to 1
        	Z = (ALU_Out == 16'b0) ? 1 : 0;
        	N = ALU_Out[15]; //MSB represents negative or positive (2's complement)
    	end

endmodule
