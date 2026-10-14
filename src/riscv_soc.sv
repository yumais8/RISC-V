module riscv_soc #(
    parameter string INSTRUCTION_FILE = "",
    parameter string MEMORY_FILE = ""
)(
    input  logic clk,
    input  logic reset
);

    // Core <-> memory bus
    logic [31:0] imem_addr;
    logic [31:0] imem_rdata;
    logic [31:0] dmem_addr;
    logic [31:0] dmem_wdata;
    logic [31:0] dmem_rdata;
    logic        dmem_write;
    logic [2:0]  dmem_funct3;

    riscv core (
        .clk(clk),
        .reset(reset),
        .imem_addr(imem_addr),
        .imem_rdata(imem_rdata),
        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_write(dmem_write),
        .dmem_funct3(dmem_funct3),
        .dmem_rdata(dmem_rdata)
    );

    orchestrationMemory #(
        .FILE(INSTRUCTION_FILE)
    ) imem (
        .address(imem_addr),
        .instruction(imem_rdata)
    );

    memory #(
        .MEMORY_FILE(MEMORY_FILE)
    ) dmem (
        .address(dmem_addr),
        .write_data(dmem_wdata),
        .write_mem(dmem_write),
        .funct3(dmem_funct3),
        .clk(clk),
        .reset(reset),
        .mem_out(dmem_rdata),
        .memory0(),
        .memory1(),
        .memory2(),
        .memory3(),
        .memory4(),
        .memory5(),
        .memory6(),
        .memory7(),
        .memory8(),
        .memory9()
    );

endmodule
