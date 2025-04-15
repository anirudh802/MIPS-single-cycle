`timescale 1ns / 1ps

module Register_File (
    input [4:0] Read1,        // Register address 1
    input [4:0] Read2,        // Register address 2
    input [4:0] WriteReg,     // Register address to write
    input [31:0] WriteData,   // Data to write
    input RegWrite,           // Write enable signal
    output [31:0] Data1,      // Output data 1
    output [31:0] Data2,      // Output data 2
    input rst,                // Reset signal
    input clk                 // Clock signal
);

    // Register array: 32 registers, each 32-bit wide
    reg [31:0] registers [0:31];

    // Asynchronous read
    assign Data1 = (Read1 != 0) ? registers[Read1] : 32'b0;
    assign Data2 = (Read2 != 0) ? registers[Read2] : 32'b0;

    // Synchronous write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers to 0
            integer i;
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (RegWrite && WriteReg != 0) begin
            // Write to register if RegWrite is enabled (ignore $zero)
            registers[WriteReg] <= WriteData;
        end
    end

endmodule
