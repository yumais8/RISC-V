module regFile(
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic [31:0] data_write,
    input logic reg_write,
    input logic clk,
    input logic reset,

    output logic [31:0] rs1_out,
    output logic [31:0] rs2_out
);

logic [31:0] registers [31:0];      // The second [31:0] means register[0], resgiter[1], register[2], ... register[31]. 

initial begin
    registers = '{default: '0};
end

always_comb begin
    // Register 0 (x0) always returns 0 in RISC-V
    rs1_out = (rs1 == 5'b0) ? 32'b0 : registers[rs1];
    rs2_out = (rs2 == 5'b0) ? 32'b0 : registers[rs2];
end

always_ff @(posedge clk) begin
    if (reset) begin
        registers <= '{default: 32'b0};
    end else if (reg_write && (rd != 5'b0)) begin
        registers[rd] <= data_write;
    end
end

endmodule