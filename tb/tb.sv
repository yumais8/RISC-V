`timescale 1ns/1ps

module tb;
    // DUT interface
    logic clk;
    logic reset;
    logic [31:0] pc_id;
    logic [31:0] instruction_id;

    // Instantiate unit under test
    datapath #(
        .INSTRUCTION_FILE("src/instruction/instruction_mem.txt"),  // User will provide instruction file
        .MEMORY_FILE("")
    ) dut (
        .clk(clk),
        .reset(reset),
        .pc_id(pc_id),
        .instruction_id(instruction_id)
    );

    // Clock generation (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        $display("Starting datapath testbench");
        $display("Time\tPC_ID\tInstruction_ID");

        // Initialize - hold reset
        reset = 1;
        #20;  // Hold reset for 20ns

        // Release reset
        reset = 0;
        $display("Reset released at time %0t", $time);

        // Monitor for several clock cycles
        repeat (20) begin
            @(posedge clk);
            #1; // Small delay for signal propagation
            $display("%0t:\t%b\t%b", $time, pc_id, instruction_id);
        end

        $display("Testbench completed");
        $finish;
    end

endmodule