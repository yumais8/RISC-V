module MEMWB(
    input logic clk,
    input logic reset,
    input logic [31:0] pcplus4,
    input logic [4:0] rd,
    input logic [1:0] wb_sel,
    input logic reg_write,
    input logic [31:0] mem_out,
    input logic [31:0] alu_out,
    input logic [31:0] sext_out,

    output logic [31:0] pcplus4_next,
    output logic [4:0] rd_next,
    output logic [1:0] wb_sel_next,
    output logic reg_write_next,
    output logic [31:0] mem_out_next,
    output logic [31:0] alu_out_next,
    output logic [31:0] sext_out_next
);
initial begin
    pcplus4_next = '{default: '0};
    rd_next = '{default: '0};
    wb_sel_next = '{default: '0};
    reg_write_next = 1'b0;
    mem_out_next = '{default: '0};
    alu_out_next = '{default: '0};
    sext_out_next = '{default: '0};
end

always_ff @(posedge clk) begin
    if (reset) begin
        pcplus4_next <= '{default: '0};
        rd_next <= '{default: '0};
        wb_sel_next <= '{default: '0};
        reg_write_next <= 1'b0;
        mem_out_next <= '{default: '0};
        alu_out_next <= '{default: '0};
        sext_out_next <= '{default: '0};
    end else begin
        pcplus4_next <= pcplus4;
        rd_next <= rd;
        wb_sel_next <= wb_sel;
        reg_write_next <= reg_write;
        mem_out_next <= mem_out;
        alu_out_next <= alu_out;
        sext_out_next <= sext_out;
    end
end
endmodule