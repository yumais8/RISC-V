module datapath(
    input logic clk,
    input logic reset
);

regFile register(
    .rs1(),
    .rs2(),
    .rd(),
    .data_write(),
    .reg_write(),
    .clk(),
    .reset(),
    .rs1_out(),
    .rs2_out()
);



endmodule