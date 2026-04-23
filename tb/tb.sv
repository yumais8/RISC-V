`timescale 1ns/1ps

module tb;
    logic clk;
    logic reset;

    // WB stage outputs
    logic [4:0]  rd_wb;
    logic [31:0] rd_data_wb;
    logic        reg_write_wb;

    // Instantiate unit under test
    datapath #(
        .INSTRUCTION_FILE("src/instruction/instruction_mem.txt"),
        .MEMORY_FILE("src/memory/data.txt")
    ) dut (
        .clk(clk),
        .reset(reset),
        .rd_wb(rd_wb),
        .rd_data_wb(rd_data_wb),
        .reg_write_wb(reg_write_wb)
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

        repeat (70) begin
            @(posedge clk);
            #1;
            $display("t=%0t  rd_wb=%0d  rd_data_wb=%0d  reg_write_wb=%b",
                     $time, rd_wb, rd_data_wb, reg_write_wb);
        end

        $display("Testbench completed");
        $finish;
    end

endmodule
