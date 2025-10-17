`timescale 1ns / 1ps

// The foloowing is to set time unit and precision. Similar to timescale, but it's usually used in a scoped file. Not compiler directives.
// timeunit 1ns;
// timeprecision 1ps;

module tb_top
(
    output wire[3:0] counter
);

  //clock and reset signal declaration
  // logic tb_clk, reset;
  // logic [31:0] tb_WB_Data;

  // logic [4:0] reg_num;
  // logic [31:0] reg_data;
  // logic reg_write_sig;
  // logic wr;
  // logic rd;
  // logic [8:0] addr;
  // logic [31:0] wr_data;
  // logic [31:0] rd_data;

  localparam CLKPERIOD = 10;
  localparam CLKDELAY = CLKPERIOD / 2;
  localparam NUM_CYCLES = 3;

  // riscv riscV (
  //     .clk(tb_clk),
  //     .reset(reset),
  //     .WB_Data(tb_WB_Data),
  //     .reg_num(reg_num),
  //     .reg_data(reg_data),
  //     .reg_write_sig(reg_write_sig),
  //     .wr(wr),
  //     .rd(rd),
  //     .addr(addr),
  //     .wr_data(wr_data),
  //     .rd_data(rd_data)
  // );
  logic [3:0] count;
  logic tb_clk, reset;

  counter counter_inst (
    .clk(tb_clk),
    .reset(reset),
    .count(count)
  );

  assign counter = count;

  initial begin
    // Initialize waveform dumping
    $dumpfile("tb_top.vcd");           // Specify the waveform file name
    $dumpvars(); // Dump specific signals only
    
    // Alternative: More selective dumping
    // $dumpvars(1, tb_top);              // Dump only top-level variables
    // $dumpvars(2, counter_inst);        // Dump counter instance and its immediate children
    
    tb_clk = 0;
    reset  = 1;
    #(CLKPERIOD); // This means clock delay for 10 ns
    reset = 0;

    #(CLKPERIOD * NUM_CYCLES);

    $stop;
  end

  always @(posedge tb_clk) begin

    $strobe($time, ": Counter reached %d", count);
    // $dumpvars(0, tb_top);              // Dump all variables in the testbench

  end
  // always @(posedge tb_clk) begin : REGISTER
  //   if (reg_write_sig)
  //     $display($time, ": Register [%d] written with value: [%X] | [%d]\n", reg_num, reg_data, $signed(reg_data));
  // end : REGISTER

  // always @(posedge tb_clk) begin : MEMORY
  //   if (wr && ~rd)
  //     $display($time, ": Memory [%d] written with value: [%X] | [%d]\n", addr, wr_data, $signed(wr_data));

  //   else if (rd && ~wr)
  //     $display($time, ": Memory [%d] read with value: [%X] | [%d]\n", addr, rd_data, $signed(rd_data));
  // end : MEMORY

  //clock generator
  always #(CLKDELAY) tb_clk = ~tb_clk;

endmodule
