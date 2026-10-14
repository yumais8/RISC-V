`timescale 1ns/1ps

module tb;
    logic clk;
    logic reset;

    // Instantiate unit under test
    riscv_soc #(
        .INSTRUCTION_FILE("src/instruction/instruction_mem.txt"),
        .MEMORY_FILE("src/memory/data.txt")
    ) dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb);
        $display("Starting datapath testbench");

        // Initialize - hold reset
        reset = 1;
        #10;

        // Release reset
        reset = 0;
        $display("Reset released at time %0t", $time);

        repeat (3000) begin
            @(posedge clk);
            #1;
            $display("t=%0t", $time);
        end

        $display("Testbench completed");
        $finish;
    end

endmodule
