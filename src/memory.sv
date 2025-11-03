module memory(
    input logic [31:0] address,
    input logic [31:0] write_data,
    input logic write_mem,
    input logic [2:0] funct3,
    input logic clk,
    input logic reset,

    output logic [31:0] mem_out
);
//////////////////////////////////////////////////////////////
// Since it's not possible to simulate that much memory, we need to limit the memory size before we have disc implemented
//////////////////////////////////////////////////////////////

logic [7:0] mem_addr;
assign mem_addr = address[7:0];

logic [31:0] memory [255:0];

initial begin
    memory = '{default: '0};
end

always_comb begin
    case (funct3)
        3'h0: mem_out = $signed(memory[mem_addr][7:0]);
        3'h1: mem_out = $signed(memory[mem_addr][15:0]);
        3'h2: mem_out = $signed(memory[mem_addr]);
        3'h4: mem_out = $unsigned(memory[mem_addr][7:0]);
        3'h5: mem_out = $unsigned(memory[mem_addr][15:0]);
        default: mem_out = 32'bx;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        foreach (memory[i]) memory[i] <= '0;
    end else if (write_mem) begin
        case (funct3)
            3'h0: memory[mem_addr][7:0] <= write_data[7:0];
            3'h1: memory[mem_addr][15:0] <= write_data[15:0];
            3'h2: memory[mem_addr] <= write_data;
        endcase
    end
end
endmodule
