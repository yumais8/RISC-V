module EXMEM (
    input logic clk,
    input logic reset,
    input logic [31:0] pcplus4,
    input logic [2:0] funct3,
    input logic write_mem,
    input logic [6:0] opcodes,
    input logic [4:0] rd,
    input logic [1:0] wb_sel,
    input logic reg_write,
    input logic [31:0] alu_out,
    input logic cmp_out,
    input logic [31:0] sext_out,

    output logic [31:0] pcplus4_next,
    output logic [2:0] funct3_next,
    output logic write_mem_next,
    output logic [6:0] opcodes_next,
    output logic [4:0] rd_next,
    output logic [1:0] wb_sel_next,
    output logic reg_write_next,
    output logic [31:0] alu_out_next,
    output logic cmp_out_next,
    output logic [31:0] sext_out_next
);

initial begin
    pcplus4_next = '0;
    funct3_next = '0;
    write_mem_next = '0;
    opcodes_next = '0;
    rd_next = '0;
    wb_sel_next = '0;
    reg_write_next = '0;
    alu_out_next = '0;
    cmp_out_next = '0;
    sext_out_next = '0;
end

always_ff @(posedge clk) begin
    if (reset) begin
        pcplus4_next <= '0;
        funct3_next <= '0;
        write_mem_next <= '0;
        opcodes_next <= '0;
        rd_next <= '0;
        wb_sel_next <= '0;
        reg_write_next <= '0;
        alu_out_next <= '0;
        cmp_out_next <= '0;
        sext_out_next <= '0;
    end else begin
        pcplus4_next <= pcplus4;
        funct3_next <= funct3;
        write_mem_next <= write_mem;
        opcodes_next <= opcodes;
        rd_next <= rd;
        wb_sel_next <= wb_sel;
        reg_write_next <= reg_write;
        alu_out_next <= alu_out;
        cmp_out_next <= cmp_out;
        sext_out_next <= sext_out;
    end
end
endmodule