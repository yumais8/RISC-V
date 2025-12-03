module IFID(
    input logic reset,
    input logic clk,
    input logic [31:0] pc,
    input logic [31:0] instruction,
    output logic [31:0] pc_next,
    output logic [31:0] instruction_next
);

initial begin
    pc_next = '{default: '0};
    instruction_next = '{default: '0};
end

always_ff @(posedge clk) begin
    if (reset) begin
        pc_next <= '{default: '0};
        instruction_next <= '{default: '0};
    end else begin
        pc_next <= pc;
        instruction_next <= instruction;
    end
end

endmodule