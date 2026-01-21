module datapath #(
    INSTRUCTION_FILE = "",
    MEMORY_FILE = ""
)
(
    input logic clk,
    input logic reset,

    output logic [31:0] pc_id,
    output logic [31:0] instruction_id
);

logic [31:0] pc_mux_out;
logic [31:0] pc;
logic [31:0] pcplus4;
logic [31:0] instruction;

pc programCounter(
    .clk(clk),
    .reset(reset),
    .pc(pc_mux_out),
    .pc_next(pc)
);

pcAdder pc_adder(
    .pc(pc),
    .next_pc(pcplus4)
);

orchestrationMemory #(
    .FILE(INSTRUCTION_FILE)
) pcInstructionMem (
    .address(pc),
    .instruction(instruction)
);

mux2 pc_mux(
    .data1(pcplus4),
    .data2(32'h0),
    .select(1'b0),
    .out_data(pc_mux_out)
);

IFID ifid(
    .reset(reset),
    .clk(clk),
    .pc(pc),
    .instruction(instruction),
    .pc_next(pc_id),
    .instruction_next(instruction_id)
);

endmodule
