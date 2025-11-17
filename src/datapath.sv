module datapath #(
    INSTRUCTION_FILE = "",
    MEMORY_FILE = ""
)
(
    input logic clk,
    input logic reset
);

logic [31:0] pc;
logic [31:0] next_pc;
logic [31:0] instruction;

pc pc(
    .clk(clk),
    .reset(reset),
    .pc(pc),
    .next_pc(next_pc)
);

orchestrationMemory pcInstructionMem #(
    .FILE(INSTRUCTION_FILE)
) imem (
    .address(next_pc),
    .instruction(instruction)
);

control control(
    .instruction(),
    .opcodes(),
    .funct3(),
    .funct7(),
    .rs1_sel(),
    .rs2_sel(),
    .write_mem(),
    .wb_sel(),
    .reg_write(),
    .rd()
);

mux2 pc_mux(
    .data1(),
    .data2(),
    .select(),
    .out_data()
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
