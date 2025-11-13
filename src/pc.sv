module pc(
    input logic clk,
    input logic reset,
    input logic [31:0] pc,
    
    output logic [31:0] next_pc
);


always_ff (@posedge clk) begin
    if (reset) begin
        next_pc = '{default, 32'b0};
    end else begin
        next_pc = pc + 32'h4;
    end
end

endmodule