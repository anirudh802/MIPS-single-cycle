`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2025 02:19:29 PM
// Design Name: 
// Module Name: memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//     Wrapper around Xilinx distributed memory IP core (dist_mem_gen_0)
//     Supports dual-port access with write and asynchronous read
// 
// Dependencies: 
//     Requires the dist_mem_gen_0 IP core to be configured and instantiated
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module memory(
    input [9:0] a,         // write address
    input [9:0] dpra,      // read address
    input [31:0] d,        // data input
    input clk,             // clock
    input we,              // write enable
    output [31:0] dpo      // data output
);

    dist_mem_gen_0 your_instance_name (
        .a(a),        // input wire [9 : 0] a
        .d(d),        // input wire [31 : 0] d
        .dpra(dpra),  // input wire [9 : 0] dpra
        .clk(clk),    // input wire clk
        .we(we),      // input wire we
        .dpo(dpo)     // output wire [31 : 0] dpo
    );

endmodule
