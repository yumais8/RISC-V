`timescale 1ns/1ps

module tb_sext;
    // DUT interface
    logic [31:0] instruction;
    logic [31:0] immediate_o;

    // Instantiate unit under test
    sext uut(.instruction(instruction), .immediate_o(immediate_o));

    logic [20:0] imm;

    initial begin
        $display("time   instruction        immediate_o");

        // R-type (no immediate)
        instruction = 32'b0000000_00000_00000_000_00000_0110011; #1;
        $display("%0t: R-type   %h -> %h", $time, instruction, immediate_o);
        assert (immediate_o == 32'b0)
            else $error("R-type should produce zero immediate, got %h", immediate_o);

        // I-type ADDI: +0x7FF (positive)
        instruction = {12'h7ff, 5'd0, 3'b000, 5'd0, 7'b0010011}; #1;
        $display("%0t: I-addi +  %h -> %h", $time, instruction, immediate_o);
        assert (immediate_o == 32'h000007ff)
            else $error("I-addi +0x7ff should be 0x000007ff, got %h", immediate_o);

        // I-type ADDI: -1 (sign-extended)
        instruction = {12'hfff, 5'd0, 3'b000, 5'd0, 7'b0010011}; #1;
        $display("%0t: I-addi -1 %h -> %h", $time, instruction, immediate_o);
        assert (immediate_o == 32'hffffffff)
            else $error("I-addi -1 should be 0xffffffff, got %h", immediate_o);

        // I-type SHIFTS: SRLI (funct3=001) shamt=3 -> should be zero-extended
        instruction = {7'b0000000, 5'd3, 5'd0, 3'b001, 5'd0, 7'b0010011}; #1;
        $display("%0t: I-shift   %h -> %h", $time, instruction, immediate_o);
        assert (immediate_o == 32'h00000003)
            else $error("I-shift SRLI shamt=3 should be zero-extended to 0x00000003, got %h", immediate_o);

        // Load (I-type): imm = -4
        instruction = {12'hffc, 5'd0, 3'b010, 5'd0, 7'b0000011}; #1;
        $display("%0t: Load      %h -> %h", $time, instruction, immediate_o);
        assert (immediate_o == 32'hfffffffc)
            else $error("Load imm=-4 should be 0xfffffffc, got %h", immediate_o);

        // Store (S-type): build imm with high bits all ones and low bits 11000
        instruction = {7'b1111111, 5'd0, 5'd0, 3'b010, 5'b11000, 7'b0100011}; #1;
        $display("%0t: Store     %h -> %h", $time, instruction, immediate_o);
        assert (immediate_o == 32'hfffffff8)
            else $error("Store S-type should be 0xfffffff8, got %h", immediate_o);

        // Branch (B-type): example with sign-bit 0
        instruction = {7'b0000000, 5'd0, 5'd0, 3'b000, 5'd0, 7'b1100011}; #1;
        $display("%0t: Branch    %h -> %h", $time, instruction, immediate_o);
        assert (immediate_o == 32'h00000000)
            else $error("Branch B-type zero immediate should be 0x00000000, got %h", immediate_o);

        // JAL (J-type): small positive immediate example
        imm = { 20'h14, 1'b0 };
        instruction = { imm[20], imm[10:1], imm[11], imm[19:12], 5'h1, 7'b1101111}; #1;
        $display("%0t: JAL       %h -> %h", $time, instruction, immediate_o);
        assert (immediate_o == 32'($signed(imm)))   // This syntax is always sign extending, regardless of the $ sign.
            else $error("JAL J-type should be %h, got %h", 32'($signed(imm)), immediate_o);

        // LUI (U-type)
        imm = 21'hAB;
        instruction = { imm[20:1], 5'd0, 7'b0110111}; #1;
        $display("%0t: LUI       %h -> %h", $time, instruction, immediate_o);
        assert (immediate_o == 32'(imm[20:1]))
            else $error("LUI U-type should be %h, got %h", 32'(imm[20:1]), immediate_o);

        $finish;
    end
endmodule
