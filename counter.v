module counter(
    input wire clk,
    output reg [31:0] count
);

    initial begin
        count = 32'b0;
    end
    
    always @(posedge clk) begin
        count <= count + 1'b1;
    end

endmodule