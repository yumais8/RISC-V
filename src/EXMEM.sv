module EXMEM (
    input logic clk,
    input logic reset,
    input logic [31:0] pcplus4_ex,
    input logic [2:0] funct3_ex,
    input logic write_mem_ex,
    input logic [6:0] opcodes_ex,
    input logic [4:0] rd_ex,
    input logic [1:0] wb_sel_ex,
    input logic reg_write_ex,
    input logic [31:0] alu_out_ex,
    input logic [31:0] sext_out_ex,
    input logic [31:0] rs2_out_ex,
    input logoc pc_select_ex,

    output logic [31:0] pcplus4_mem,
    output logic [2:0] funct3_mem,
    output logic write_mem_mem,
    output logic [6:0] opcodes_mem,
    output logic [4:0] rd_mem,
    output logic [1:0] wb_sel_mem,
    output logic reg_write_mem,
    output logic [31:0] alu_out_mem,
    output logic [31:0] sext_out_mem,
    output logic [31:0] rs2_out_mem,
    output logic pc_select_mem
);

initial begin
    pcplus4_mem = '0;
    funct3_mem = '0;
    write_mem_mem = '0;
    opcodes_mem = '0;
    rd_mem = '0;
    wb_sel_mem = '0;
    reg_write_mem = '0;
    alu_out_mem = '0;
    sext_out_mem = '0;
    rs2_out_mem = '0;
    pc_select_mem = '0;
end

always_ff @(posedge clk) begin
    if (reset) begin
        pcplus4_mem <= '0;
        funct3_mem <= '0;
        write_mem_mem <= '0;
        opcodes_mem <= '0;
        rd_mem <= '0;
        wb_sel_mem <= '0;
        reg_write_mem <= '0;
        alu_out_mem <= '0;
        sext_out_mem <= '0;
        rs2_out_mem <= '0;
        pc_select_mem <= '0;
    end else begin
        pcplus4_mem <= pcplus4_ex;
        funct3_mem <= funct3_ex;
        write_mem_mem <= write_mem_ex;
        opcodes_mem <= opcodes_ex;
        rd_mem <= rd_ex;
        wb_sel_mem <= wb_sel_ex;
        reg_write_mem <= reg_write_ex;
        alu_out_mem <= alu_out_ex;
        sext_out_mem <= sext_out_ex;
        rs2_out_mem <= rs2_out_ex;
        pc_select_mem <= pc_select_ex;
    end
end
endmodule