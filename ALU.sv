module ALU (ALU_Out, Error, ALU_In1, ALU_In2, Opcode);
    input [3:0] ALU_In1, ALU_In2;
    input [1:0] Opcode;
    output reg [3:0] ALU_Out;
    output reg Error; //overflow flag

    //wires for submodule results -> will be passed to ALU_Out afterwards
    wire [3:0] alu_result, nand_result, xor_result;
    wire alu_error;

    //adder/subtracter logic istantiation
    addsub_4bit alu_addsub (
        .A(ALU_In1), 
        .B(ALU_In2), 
        .sub(Opcode[0]), 
        .Sum(alu_result), 
        .Ovfl(alu_error)
    );

    //nand logic istantiation
    nand_4bit alu_nand (
        .x(ALU_In1), 
        .y(ALU_In2), 
        .nand_4(nand_result)
    );
    //xor logic istantiation
    xor_4bit alu_xor (
        .x(ALU_In1), 
        .y(ALU_In2), 
        .xor_4(xor_result)
    );

    //combinational logic for ALU
    always @(*) begin
        case (Opcode)
            2'b00, 2'b01: begin  //add or sub - based on bit 0 of opcode - if Opcode[0] == 0 -> add 
                ALU_Out = alu_result; //output solution
                Error = alu_error;	//overflow detection
            end
            2'b10: begin  //Nand code 
                ALU_Out = nand_result;
                Error = 0;	//no overflow
            end
            2'b11: begin  // XOR
                ALU_Out = xor_result;
                Error = 0;	//no overflow
            end	
            default: begin
                ALU_Out = 4'b0000;
                Error = 0;	//no overflow
            end
        endcase
    end

endmodule

