module IDEX
(
    input logic clk,
    input logic reset,
    input logic [31:0] pc,
    input logic [6:0] funct7,
    input logic [2:0] funct3,
    input logic write_mem,
    input logic [6:0] opcodes,
    input logic [4:0] rd,
    input logic [1:0] wb_sel,
    input logic [1:0] rs1_sel,
    input logic [1:0] rs2_sel,
    input logic reg_write,
    input logic [31:0] rs1_out,
    input logic [31:0] rs2_out,
    input logic [31:0] sext_out,

    output logic [31:0] pc_next,
    output logic [6:0] funct7_next,
    output logic [2:0] funct3_next,
    output logic write_mem_next,
    output logic [6:0] opcodes_next,
    output logoc [4:0] rd_next,
    output logic [1:0] wb_sel_next,
    output logic [1:0] rs1_sel_next,
    output logic [1:0] rs2_sel_next,
    output logic reg_write_next,
    output logic [31:0] rs1_out_next,
    output logic [31:0] rs2_out_next,
    output logic [31:0] sext_out_next
);

initial begin
    pc_next = '{default: '0};
    funct7_next = '{default: '0};
    funct3_next = '{default: '0};
    write_mem_next = '{default: '0};
    opcodes_next = '{default: '0};
    rd_next = '{default: '0};
    wb_sel_next = '{default: '0};
    rs1_sel_next = '{default: '0};
    rs2_sel_next = '{default: '0};
    reg_write_next = '{default: '0};
    rs1_out_next = '{default: '0};
    rs2_out_next = '{default: '0};
    sext_out_next = '{default: '0};
end

always_ff @(posedge clk) begin
    if (reset) begin
        pc_next <= '{default: '0};
        funct7_next <= '{default: '0};
        funct3_next <= '{default: '0};
        write_mem_next <= '{default: '0};
        opcodes_next <= '{default: '0};
        rd_next <= '{default: '0};
        wb_sel_next <= '{default: '0};
        rs1_sel_next <= '{default: '0};
        rs2_sel_next <= '{default: '0};
        reg_write_next <= '{default: '0};
        rs1_out_next <= '{default: '0};
        rs2_out_next <= '{default: '0};
        sext_out_next <= '{default: '0};
    end else begin
        pc_next <= pc;
        funct7_next <= funct7;
        funct3_next <= funct3;
        write_mem_next <= write_mem;
        opcodes_next <= opcodes;
        rd_next <= rd;
        wb_sel_next <= wb_sel;
        rs1_sel_next <= rs1_sel;
        rs2_sel_next <= rs2_sel;
        reg_write_next <= reg_write;
        rs1_out_next <= rs1_out;
        rs2_out_next <= rs2_out;
        sext_out_next <= sext_out;
    end
end

endmodule
