`timescale 1ns / 1ps

module tb_processor_top;

    reg clk = 0;
    reg rst = 1;

    reg [31:0] instr;
    reg [31:0] data;
    reg [9:0] instr_addr = 0;
    reg [9:0] data_addr = 0;
    reg ins_we = 0;
    reg data_we = 0;

    wire [31:0] processor_out;
    wire done;

    processor_top uut (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .instr_addr(instr_addr),
        .data(data),
        .data_addr(data_addr),
        .ins_we(ins_we),
        .data_we(data_we),
        .processor_out(processor_out),
        .done(done)
    );

    // Clock generator
    always #5 clk = ~clk;

    task write_instr(input [9:0] addr, input [31:0] inst);
        begin
            @(negedge clk);
            instr_addr = addr;
            instr = inst;
            ins_we = 1;
            @(negedge clk);
            ins_we = 0;
        end
    endtask

    task write_data(input [9:0] addr, input [31:0] val);
        begin
            @(negedge clk);
            data_addr = addr;
            data = val;
            data_we = 1;
            @(negedge clk);
            data_we = 0;
        end
    endtask

    initial begin
        // Reset phase
        @(negedge clk);
        rst = 1;
        write_data(10'd0, 32'd5);  // Memory[0] = 5
        write_data(10'd1, 32'd10); // Memory[1] = 10
        @(negedge clk);
        rst = 0;

        // Load instructions
        // Example: LW $t0, 0($zero)   => opcode = 35 (0x23), base = 0, rt = 8, offset = 0
        write_instr(10'd0, 32'b100011_00000_01000_0000000000000000);  // LW $t0, 0($zero)
        // LW $t1, 4($zero)
        write_instr(10'd1, 32'b100011_00000_01001_0000000000000001);  // LW $t1, 1($zero)
        // ADD $t2, $t0, $t1
        write_instr(10'd2, 32'b000000_01000_01001_01010_00000_100000); // R-type ADD
        // SW $t2, 2($zero)
        write_instr(10'd3, 32'b101011_00000_01010_0000000000000010); // SW $t2, 2($zero)
        // HALT
        write_instr(10'd4, 32'b111111_00000_00000_00000_00000_000000); // HALT

        // Wait for program to finish
        wait(done);

        $display("Final Output = %d", processor_out);
        $finish;
    end
endmodule
