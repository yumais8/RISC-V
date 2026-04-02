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

logic [7:0] word_addr;
logic [1:0] byte_offset;
assign word_addr   = address[9:2];
assign byte_offset = address[1:0];

logic [31:0] memory [255:0];

initial begin
    memory = '{default: '0};
end

always_comb begin
    case (funct3)
        3'h0: begin // LB - sign extend byte
            case (byte_offset)
                2'd0: mem_out = {{24{memory[word_addr][7]}},  memory[word_addr][7:0]};
                2'd1: mem_out = {{24{memory[word_addr][15]}}, memory[word_addr][15:8]};
                2'd2: mem_out = {{24{memory[word_addr][23]}}, memory[word_addr][23:16]};
                2'd3: mem_out = {{24{memory[word_addr][31]}}, memory[word_addr][31:24]};
            endcase
        end
        3'h1: begin // LH - sign extend halfword
            case (byte_offset[1])
                1'b0: mem_out = {{16{memory[word_addr][15]}}, memory[word_addr][15:0]};
                1'b1: mem_out = {{16{memory[word_addr][31]}}, memory[word_addr][31:16]};
            endcase
        end
        3'h2: mem_out = memory[word_addr]; // LW
        3'h4: begin // LBU - zero extend byte
            case (byte_offset)
                2'd0: mem_out = {24'b0, memory[word_addr][7:0]};
                2'd1: mem_out = {24'b0, memory[word_addr][15:8]};
                2'd2: mem_out = {24'b0, memory[word_addr][23:16]};
                2'd3: mem_out = {24'b0, memory[word_addr][31:24]};
            endcase
        end
        3'h5: begin // LHU - zero extend halfword
            case (byte_offset[1])
                1'b0: mem_out = {16'b0, memory[word_addr][15:0]};
                1'b1: mem_out = {16'b0, memory[word_addr][31:16]};
            endcase
        end
        default: mem_out = 32'bx;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        foreach (memory[i]) memory[i] <= '0;
    end else if (write_mem) begin
        case (funct3)
            3'h0: begin // SB
                case (byte_offset)
                    2'd0: memory[word_addr][7:0]   <= write_data[7:0];
                    2'd1: memory[word_addr][15:8]  <= write_data[7:0];
                    2'd2: memory[word_addr][23:16] <= write_data[7:0];
                    2'd3: memory[word_addr][31:24] <= write_data[7:0];
                endcase
            end
            3'h1: begin // SH
                case (byte_offset[1])
                    1'b0: memory[word_addr][15:0]  <= write_data[15:0];
                    1'b1: memory[word_addr][31:16] <= write_data[15:0];
                endcase
            end
            3'h2: memory[word_addr] <= write_data; // SW
        endcase
    end
end
endmodule
