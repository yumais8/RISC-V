module MEMWB(
    input logic clk,
    input logic reset,
    input logic [31:0] pcplus4_mem,
    input logic [4:0] rd_mem,
    input logic [1:0] wb_sel_mem,
    input logic reg_write_mem,
    input logic [31:0] mem_out_mem,
    input logic [31:0] alu_out_mem,
    input logic [31:0] sext_out_mem,

    output logic [31:0] pcplus4_wb,
    output logic [4:0] rd_wb,
    output logic [1:0] wb_sel_wb,
    output logic reg_write_wb,
    output logic [31:0] mem_out_wb,
    output logic [31:0] alu_out_wb,
    output logic [31:0] sext_out_wb
);
initial begin
    pcplus4_wb = '{default: '0};
    rd_wb = '{default: '0};
    wb_sel_wb = '{default: '0};
    reg_write_wb = 1'b0;
    mem_out_wb = '{default: '0};
    alu_out_wb = '{default: '0};
    sext_out_wb = '{default: '0};
end

always_ff @(posedge clk) begin
    if (reset) begin
        pcplus4_wb <= '{default: '0};
        rd_wb <= '{default: '0};
        wb_sel_wb <= '{default: '0};
        reg_write_wb <= 1'b0;
        mem_out_wb <= '{default: '0};
        alu_out_wb <= '{default: '0};
        sext_out_wb <= '{default: '0};
    end else begin
        pcplus4_wb <= pcplus4_mem;
        rd_wb <= rd_mem;
        wb_sel_wb <= wb_sel_mem;
        reg_write_wb <= reg_write_mem;
        mem_out_wb <= mem_out_mem;
        alu_out_wb <= alu_out_mem;
        sext_out_wb <= sext_out_mem;
    end
end
endmodule
