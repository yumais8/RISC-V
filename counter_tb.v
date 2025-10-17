`timescale 1ns / 1ns

module counter_tb(clk, count);

output reg clk;
output wire [31:0] count;

initial begin
    clk = 0;
end

always #5 clk = ~clk; // Clock period of 10 time units

always #5 begin
    $display("Time: %0t | Count: %d", $time, count);
end

initial begin
    #10000; // Run the simulation for 10000 time units
    $finish;
end

counter counter_i(
    .clk(clk),
    .count(count)
);

initial begin
    $dumpfile("counter.vcd");
    $dumpvars(0, counter_tb); // dump all signals in counter_tb
end

endmodule