module IDEX
(
    input logic clk,
    input logic reset,
    input logic stall,

    input logic [31:0] pc_id,
    input logic [6:0] funct7_id,
    input logic [2:0] funct3_id,
    input logic write_mem_id,
    input logic [6:0] opcodes_id,
    input logic [4:0] rd_id,
    input logic [1:0] wb_sel_id,
    input logic rs1_sel_id,
    input logic rs2_sel_id,
    input logic reg_write_id,
    input logic [31:0] rs1_out_id,
    input logic [31:0] rs2_out_id,
    input logic [31:0] sext_out_id,
    input logic [4:0] rs1_id,
    input logic [4:0] rs2_id,

    output logic [31:0] pc_ex,
    output logic [6:0] funct7_ex,
    output logic [2:0] funct3_ex,
    output logic write_mem_ex,
    output logic [6:0] opcodes_ex,
    output logic [4:0] rd_ex,
    output logic [1:0] wb_sel_ex,
    output logic rs1_sel_ex,
    output logic rs2_sel_ex,
    output logic reg_write_ex,
    output logic [31:0] rs1_out_ex,
    output logic [31:0] rs2_out_ex,
    output logic [31:0] sext_out_ex,
    output logic [4:0] rs1_ex,
    output logic [4:0] rs2_ex
);

initial begin
    pc_ex = '0;
    funct7_ex = '0;
    funct3_ex = '0;
    write_mem_ex = '0;
    opcodes_ex = '0;
    rd_ex = '0;
    wb_sel_ex = '0;
    rs1_sel_ex = '0;
    rs2_sel_ex = '0;
    reg_write_ex = '0;
    rs1_out_ex = '0;
    rs2_out_ex = '0;
    sext_out_ex = '0;
    rs1_ex = '0;
    rs2_ex = '0;
end

always_ff @(posedge clk) begin
    if (reset) begin
        pc_ex <= '0;
        funct7_ex <= '0;
        funct3_ex <= '0;
        write_mem_ex <= '0;
        opcodes_ex <= '0;
        rd_ex <= '0;
        wb_sel_ex <= '0;
        rs1_sel_ex <= '0;
        rs2_sel_ex <= '0;
        reg_write_ex <= '0;
        rs1_out_ex <= '0;
        rs2_out_ex <= '0;
        sext_out_ex <= '0;
        rs1_ex <= '0;
        rs2_ex <= '0;
    end else if(stall) begin
        pc_ex <= pc_ex;
        funct7_ex <= funct7_ex;
        funct3_ex <= funct3_ex;
        write_mem_ex <= write_mem_ex;
        opcodes_ex <= opcodes_ex;
        rd_ex <= rd_ex;
        wb_sel_ex <= wb_sel_ex;
        rs1_sel_ex <= rs1_sel_ex;
        rs2_sel_ex <= rs2_sel_ex;
        reg_write_ex <= reg_write_ex;
        rs1_out_ex <= rs1_out_ex;
        rs2_out_ex <= rs2_out_ex;
        sext_out_ex <= sext_out_ex;
        rs1_ex <= rs1_ex;
        rs2_ex <= rs2_ex;
    end else begin
        pc_ex <= pc_id;
        funct7_ex <= funct7_id;
        funct3_ex <= funct3_id;
        write_mem_ex <= write_mem_id;
        opcodes_ex <= opcodes_id;
        rd_ex <= rd_id;
        wb_sel_ex <= wb_sel_id;
        rs1_sel_ex <= rs1_sel_id;
        rs2_sel_ex <= rs2_sel_id;
        reg_write_ex <= reg_write_id;
        rs1_out_ex <= rs1_out_id;
        rs2_out_ex <= rs2_out_id;
        sext_out_ex <= sext_out_id;
        rs1_ex <= rs1_id;
        rs2_ex <= rs2_id;
    end
end

endmodule
