module datapath(
    input logic clk,
    input logic reset
);

logic [31:0] pc;

pc pc(
    .clk(clk),
    .reset(reset),
    .pc(pc),
    .next_pc()
);


controll controll(

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
