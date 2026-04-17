module IFID(
    input logic reset,
    input logic clk,
    input logic [31:0] pc_if,
    input logic [31:0] instruction_if,
    output logic [31:0] pc_id,
    output logic [31:0] instruction_id
);

initial begin
    pc_id = '{default: '0};
    instruction_id = '{default: '0};
end

always_ff @(posedge clk) begin
    if (reset) begin
        pc_id <= '{default: '0};
        instruction_id <= '{default: '0};
    end else begin
        pc_id <= pc_if;
        instruction_id <= instruction_if;
    end
end

endmodule
