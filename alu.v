module ALU (
    input [31:0] A, B,
    input [5:0] alu_control, // ALU operation selector
    output reg [31:0] result,
    output reg zero, // For equality check
    output reg [31:0] hi,
    output reg [31:0] low
);

    always @(*) begin
        result = 32'b0;
        hi = 32'b0;
        low = 32'b0;

        case (alu_control)
            6'd0: result = $signed(A) + $signed(B);      // ADDI - signed addition
            6'd1: result = A + B;                         // ADDIU
            6'd2: result = $signed(A) - $signed(B);       // SUB
            6'd3: result = A - B;                         // SUBU
            6'd4: begin {hi, low} = {hi, low} + (A * B); end // MADD
            6'd5: begin {hi, low} = {hi, low} + (A * B); end // MADDU
            6'd6: begin {hi, low} = A * B; end            // MUL
            6'd7: result = A & B;                           //and
            6'd8: result = A | B;                           //or
            6'd9: result = A ^ B;                           //xor
            6'd10: result = ~(A | B);                     // NOR
            6'd11: result = (A < B) ? 32'd1 : 32'd0;      // SLT
            6'd12: result = A << B[4:0];                  // SLL
            6'd13: result = A >> B[4:0];                  // SRL
            6'd14: result = $signed(A) >>> B[4:0];        // SRA
            6'd15: result = $signed(A) <<< B[4:0];        // SLA (not standard MIPS)
            6'd16: result = (A == B) ? 1 : 0;             // BEQ
            6'd17: result = (A != B) ? 1 : 0;             // BNE
            6'd18: result = (A > B) ? 1 : 0;              // BGT
            6'd19: result = (A >= B) ? 1 : 0;             // BGTE
            6'd20: result = (A <= B) ? 1 : 0;             // BLE
            6'd21: result = (A < B) ? 1 : 0;              // BLTU
            6'd22: result = (A > B) ? 1 : 0;              // BGTU
            6'd23: result = {B[15:0], 16'b0};             // LUI
            6'd24: result = A;                       // JR

            6'd34: begin // add.s
                real_A = $bitstoreal(A);
                real_B = $bitstoreal(B);
                real_result = real_A + real_B;
                result = $realtobits(real_result);
            end
            6'd25: begin // sub.s
                real_A = $bitstoreal(A);
                real_B = $bitstoreal(B);
                real_result = real_A - real_B;
                result = $realtobits(real_result);
            end
            6'd26: begin cc_flag = ($bitstoreal(A) == $bitstoreal(B)); end //c.eq.s
            6'd27: begin cc_flag = ($bitstoreal(A) <= $bitstoreal(B)); end //c.le.s
            6'd28: begin cc_flag = ($bitstoreal(A) < $bitstoreal(B)); end //c.lt.s
            6'd29: begin cc_flag = ($bitstoreal(A) >= $bitstoreal(B)); end //c.ge.s
            6'd30: begin cc_flag = ($bitstoreal(A) > $bitstoreal(B)); end //c.gt.s
            6'd31: begin result = (cc_flag) ? B : A; end //mov.s cc
            6'd32: result = B; // mfcl
            6'd33: result = B; // mtc1
            default: result = 32'b0;
        endcase

        zero = (result != 32'b0);
    end

endmodule
