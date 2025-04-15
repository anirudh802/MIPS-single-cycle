`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    PC (Program Counter)
// Description:    Holds the address of the current instruction.
//                 Updates on the rising edge of the clock if not done.
//                 Resets to 0 when rst is high.
//////////////////////////////////////////////////////////////////////////////////

module PC(
    input clk,
    input rst,
    input done,
    input [31:0] PC_in,
    output reg [31:0] PC_out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        PC_out <= 32'b0;      // Reset the PC to 0
    else if (!done)
        PC_out <= PC_in;      // Update PC only if not done
end

endmodule
