module pc(
    input logic clk,
    input logic reset,
    input logic [31:0] pc,
    
    output logic [31:0] pc_next
);

always_ff @(posedge clk) begin
    if (reset) begin
        pc_next <= 32'h00;
    end else begin
        pc_next <= pc;
    end
end

endmodule