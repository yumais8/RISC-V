`timescale 1ns/1ps

module tb_datapath;
    // DUT interface
    logic clk;
    logic reset;
    logic [31:0] pc_id;
    logic [31:0] instruction_id;

    // Instantiate unit under test
    datapath #(
        .INSTRUCTION_FILE("src/instruction/test0.txt"),
        .MEMORY_FILE("")
    ) uut (
        .clk(clk),
        .reset(reset),
        .pc_id(pc_id),
        .instruction_id(instruction_id)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period (100MHz)
    end

    // Test sequence
    initial begin
        $display("Starting datapath testbench");
        $display("Time\tPC_ID\t\tInstruction_ID");

        // Initialize
        reset = 1;
        #10; // Hold reset for 10ns

        // Release reset
        reset = 0;
        #5; // Small delay

        // Monitor for several clock cycles
        repeat (10) begin
            @(posedge clk);
            #1; // Small delay for signal propagation
            $display("%0t:\t%h\t%h", $time, pc_id, instruction_id);
        end

        $display("Testbench completed");
        $finish;
    end

endmodule