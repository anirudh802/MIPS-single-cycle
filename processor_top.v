`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 04:09:20 PM
// Design Name: 
// Module Name: processor_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module processor_top(clk,rst,instr,instr_addr, data, data_addr, ins_we,data_we,processor_out,done);

input clk,rst;
input [31:0] instr,data;
input [9:0] instr_addr,data_addr;
input ins_we,data_we;
output [31:0] processor_out;
output done;

wire [31:0] PC_out,ins_out,data_write;
reg [31:0] PC_in;
reg [9:0] data_write_addr; reg [9:0] data_read_addr;
wire mem_we;
wire [3:0] ALU_Con;
wire [1:0] ALUSrc;
wire branch,MemtoReg,MemWrite,done,RegWrite;
wire [1:0] RegDsT;
wire [4:0] Read1, Read2;
reg [4:0] WriteReg;
wire [31:0] WriteData, Data1,Data2;
wire [31:0] inp1;
reg [31:0] inp2;
wire [31:0] shamt;
wire [31:0] ALU_out,hi,low;
wire eq_true;
wire [31:0] immidiate;
wire [31:0] WB_data;
wire [31:0] branch_addr;
wire [31:0] temp_addr;
reg [31:0] jump_addr; 
wire jump;


assign temp_addr=PC_out+1;

PC program_counter(clk,rst,done,PC_in,PC_out);




memory ins_mem (
  .a(instr_addr),        // input wire [9 : 0] a
  .d(instr),        // input wire [31 : 0] d
  .dpra(PC_out[9:0]),  // input wire [9 : 0] dpra
  .clk(clk),    // input wire clk
  .we(ins_we),      // input wire we
  .dpo(ins_out)    // output wire [31 : 0] dpo
);


control con(ins_out[31:26],ins_out[5:0],ALU_Con,RegDsT,branch,MemtoReg,MemWrite,ALUSrc,RegWrite,jump,done);

assign Read1=ins_out[25:21];
assign Read2=ins_out[20:16];

always@(*)
begin
if(RegDsT==2'd2)
WriteReg<=5'd31;
else if(RegDsT==2'd1)
WriteReg<=ins_out[15:11];
else
WriteReg<=ins_out[20:16];
end 


assign WriteData=(RegDsT==2'd2)?(PC_out+1):WB_data;

Register_File regs(Read1, Read2, WriteReg, WriteData, RegWrite, Data1, Data2,rst, clk);

assign inp1=Data1;
assign immidiate={{16{ins_out[15]}},ins_out[15:0]};
assign shamt={27'h0,ins_out[10:6]};
always@(*)
begin
if(ALUSrc==2'h2)
inp2<=shamt;
else if (ALUSrc==2'h1)
inp2<=Data2;
else
inp2<=immidiate;
end

ALU alu(inp1,inp2,ALU_Con,ALU_out,eq_true,hi,low);


always@(*)
begin
if(done)
data_read_addr<=data_addr;
else 
data_read_addr<=ALU_out[9:0];
end

always@(*)
begin
if(rst)
data_write_addr<=data_addr;
else 
data_write_addr<=ALU_out[9:0];
end

assign data_write=(rst==1)?data:Data2;
assign mem_we=(rst==1)?data_we:MemWrite;

memory data_mem (
  .a(data_write_addr),        // input wire [9 : 0] a
  .d(data_write),        // input wire [31 : 0] d
  .dpra(data_read_addr),  // input wire [9 : 0] dpra
  .clk(clk),    // input wire clk
  .we(mem_we),      // input wire we
  .dpo(processor_out)    // output wire [31 : 0] dpo
);

assign WB_data=(MemtoReg)?processor_out:ALU_out;


assign branch_addr=PC_out+1+ins_out[15:0];

always@(*)
begin
if(ins_out[31:26]==0 && ins_out[5:0]==6'h8)
jump_addr<=ALU_out;
else
jump_addr<={temp_addr[31:26],ins_out[25:0]};
end

always@(*)
begin
if(branch==1 && eq_true==1)
PC_in<=branch_addr;
else if(jump==1)
PC_in<=jump_addr;
else
PC_in<=PC_out+1;
end




endmodule
