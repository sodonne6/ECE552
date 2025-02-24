//output to board should be max_tick_reg and lsfr_reg (the current 23 bit number)
//only 16 LED's how do you output 23 bits?
//use switches to change to show second half of number 

`timescale 1ns / 1ps
module lfsr (
    input wire clk, //clock
    input wire reset, //reset
    output wire [21:0] lfsr_reg,  //lfsr register 22 bit
    output reg [21:0] one_counter, //count how many ones generated
    output reg [21:0] zero_counter, // count how many zeroes counted
    output reg max_tick_reg 
);
 localparam seed_val = 22'b1111111111111110111000; // seed value


reg [21:0] register; //current bit configuration
reg [21:0] next_register; //next bit config
reg tap_feedback; //store generated bit

integer cycle_counter; // count the number of cycles

always @(posedge clk, posedge reset) 
    if (reset) //if reset set all to zero
        begin
            register <= seed_val;
            max_tick_reg <= 1'b0; 
            zero_counter <= 22'b00000000000000000000000; // 
            one_counter <= 22'b00000000000000000000000; 
            cycle_counter <= 0; // Reset cycle counter
        end
    else
        begin
            register <= next_register;
            cycle_counter <= cycle_counter + 1;
            if (cycle_counter == 2**22 - 1) 
                begin
                max_tick_reg <= 1'b1;
                zero_counter <= 22'b00000000000000000000000; 
                one_counter <= 22'b00000000000000000000000; 
                cycle_counter <= 0; 
                end
            else
                max_tick_reg <= 1'b0;
                begin
                    if (lfsr_reg[0] == 1'b1)
                    one_counter = one_counter + 1; //increase one counter
                else if (lfsr_reg[0] == 1'b0)
                    zero_counter = zero_counter + 1; //increase zero counter
                end
        end


always @*
begin
    tap_feedback = ~(register[21] ^~ register[16]); // XNOR tapped bits
   
    next_register = {register[20:0], tap_feedback}; // Tap feedback goes at 0 position other bits shift up
end 

// Output 
assign lfsr_reg = register; // Output the 22 bit register

endmodule
