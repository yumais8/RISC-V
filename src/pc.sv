module pc(
    input logic clk,
    input logic reset,
    input logic [31:0] pc,
    input logic stall,
    
    output logic [31:0] pc_next
);

always_ff @(posedge clk) begin
    if (reset) begin
        pc_next <= 32'h00;
    end else if(stall) begin
        pc_next <= pc_next;
    end else begin
        pc_next <= pc;
    end
end

endmodule