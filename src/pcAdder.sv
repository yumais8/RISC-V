module pcAdder(
    input logic[31:0] pc,
    output logic[31:0] next_pc
);

always_comb begin
    next_pc = pc + 4;
end

endmodule