`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 04:34:28 PM
// Design Name: 
// Module Name: control_unit
// Description: Simplified to match top-level instantiation
//////////////////////////////////////////////////////////////////////////////////

module control_unit (
    input [5:0] opcode,
    input [5:0] func,
    output reg [5:0] alu_control,
    output reg reg_dst,
    output reg branch,
    output reg mem_to_reg,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write,
    output reg jump,
    output reg done
);

    always @(*) begin
        // Set default values
        reg_write    = 0;
        alu_src      = 0;
        mem_write    = 0;
        mem_to_reg   = 0;
        branch       = 0;
        jump         = 0;
        alu_control  = 6'b000000;
        reg_dst      = 0;
        done         = 0;

        case (opcode)
            6'b000000: begin // R-Type
                reg_write = 1;
                reg_dst   = 1;
                case (func)
                    6'd32: alu_control = 6'd0; // ADD
                    6'd33: alu_control = 6'd1; // ADDU
                    6'd34: alu_control = 6'd2; // SUB
                    6'd35: alu_control = 6'd3; // SUBU
                    6'd28: alu_control = 6'd4; // MUL
                    6'd29: alu_control = 6'd5; // MULU
                    6'd30: alu_control = 6'd6; // DIV
                    6'd36: alu_control = 6'd7; // AND
                    6'd37: alu_control = 6'd8; // OR
                    6'd38: alu_control = 6'd9; // XOR
                    6'd39: alu_control = 6'd10;// NOR
                    6'd42: alu_control = 6'd11;// SLT
                    6'd0 : alu_control = 6'd12;// SLL
                    6'd2 : alu_control = 6'd13;// SRL
                    6'd3 : alu_control = 6'd14;// SRA
                    6'd4 : alu_control = 6'd15;// SLLV
                    6'd8 : jump = 1;           // JR
                    default: alu_control = 6'd0;
                endcase
            end

            6'd8: begin // ADDI
                reg_write   = 1;
                alu_src     = 1;
                alu_control = 6'd0;
            end
            6'd9: begin // ADDIU
                reg_write   = 1;
                alu_src     = 1;
                alu_control = 6'd1;
            end
            6'd12: begin // ANDI
                reg_write   = 1;
                alu_src     = 1;
                alu_control = 6'd7;
            end
            6'd13: begin // ORI
                reg_write   = 1;
                alu_src     = 1;
                alu_control = 6'd8;
            end
            6'd14: begin // XORI
                reg_write   = 1;
                alu_src     = 1;
                alu_control = 6'd9;
            end
            6'd15: begin // LUI
                reg_write   = 1;
                alu_src     = 1;
                alu_control = 6'd23;
            end
            6'd35: begin // LW
                reg_write   = 1;
                mem_to_reg  = 1;
                alu_src     = 1;
                alu_control = 6'd0;
            end
            6'd43: begin // SW
                mem_write   = 1;
                alu_src     = 1;
                alu_control = 6'd0;
            end
            6'd4: begin // BEQ
                branch      = 1;
                alu_control = 6'd16;
            end
            6'd5: begin // BNE
                branch      = 1;
                alu_control = 6'd17;
            end
            6'd24: begin // BGT
                branch      = 1;
                alu_control = 6'd18;
            end
            6'd25: begin // BGTE
                branch      = 1;
                alu_control = 6'd19;
            end
            6'd26: begin
                branch      = 1;
                alu_control = 6'd11;
            end
            6'd27: begin
                branch      = 1;
                alu_control = 6'd20;
            end
            6'd28: begin
                branch      = 1;
                alu_control = 6'd21;
            end
            6'd29: begin
                branch      = 1;
                alu_control = 6'd22;
            end
            6'd10: begin // SLTI
                reg_write   = 1;
                alu_src     = 1;
                alu_control = 6'd11;
            end
            6'd11: begin // SLTIU
                reg_write   = 1;
                alu_src     = 1;
                alu_control = 6'd16;
            end
            6'd2: begin // J
                jump        = 1;
            end
            6'd63: begin // Custom HALT
                done        = 1;
            end
            default: begin
                // NOP or undefined
            end
        endcase
    end

endmodule
