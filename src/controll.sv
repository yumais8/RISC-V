module controll
(
    input logic [31:0] instruction,

);

assign operation = instruction[6:0];
assign funct3 = instruction[14:12];

always_comb begin
    case (operation)
        7'b0110011: // R-Type 
            begin 
                case (funct3)
                endcase
            end
        7'b0010011: // I - Type
            begin
                case (funct3)
                endcase
            end
        7'b0000011: // I - Type more
            begin
            end
        7'b0100011: // S - Type
            begin
            end 
        7'b1100011: // B - Type
            begin
            end 
        7'b1101111: // Jal
            begin
            end 
        7'b1100111: // jalr
            begin
            end 
        7'b0110111: // lui
            begin
            end
        7'b0010111: // auipc
            begin
            end
        default: 
            begin
            end
    endcase
end

endmodule
