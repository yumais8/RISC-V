`timescale 1ns/1ps

module tb_sext;
    // DUT interface
    logic [31:0] instruction;
    logic [31:0] immediate_o;

    // Instantiate unit under test
    sext uut(.instruction(instruction), .immediate_o(immediate_o));

    initial begin
        $display("time   instruction        immediate_o");

        // R-type (no immediate)
        instruction = 32'b0000000_00000_00000_000_00000_0110011; #1;
        $display("%0t: R-type   %h -> %h", $time, instruction, immediate_o);

        // I-type ADDI: +0x7FF (positive)
        instruction = {12'h7ff, 5'd0, 3'b000, 5'd0, 7'b0010011}; #1;
        $display("%0t: I-addi +  %h -> %h", $time, instruction, immediate_o);

        // I-type ADDI: -1 (sign-extended)
        instruction = {12'hfff, 5'd0, 3'b000, 5'd0, 7'b0010011}; #1;
        $display("%0t: I-addi -1 %h -> %h", $time, instruction, immediate_o);

        // I-type SHIFTS: SRLI (funct3=001) shamt=3 -> should be zero-extended
        instruction = {7'b0000000, 5'd3, 5'd0, 3'b001, 5'd0, 7'b0010011}; #1;
        $display("%0t: I-shift   %h -> %h", $time, instruction, immediate_o);

        // Load (I-type): imm = -4
        instruction = {12'hffc, 5'd0, 3'b010, 5'd0, 7'b0000011}; #1;
        $display("%0t: Load      %h -> %h", $time, instruction, immediate_o);

        // Store (S-type): build imm with high bits all ones and low bits 11000
        instruction = {7'b1111111, 5'd0, 5'd0, 3'b010, 5'b11000, 7'b0100011}; #1;
        $display("%0t: Store     %h -> %h", $time, instruction, immediate_o);

        // Branch (B-type): example with sign-bit 0
        instruction = {1'b0, 7'b0000000, 5'd0, 5'd0, 3'b000, 5'd0, 7'b1100011}; #1;
        $display("%0t: Branch    %h -> %h", $time, instruction, immediate_o);

        // JAL (J-type): small positive immediate example
        instruction = {1'b0, 8'h0, 1'b0, 10'h3, 1'b0, 7'b1101111}; #1;
        $display("%0t: JAL       %h -> %h", $time, instruction, immediate_o);

        // LUI (U-type)
        instruction = {20'hABCDE, 5'd0, 7'b0110111}; #1;
        $display("%0t: LUI       %h -> %h", $time, instruction, immediate_o);

        $finish;
    end
endmodule
