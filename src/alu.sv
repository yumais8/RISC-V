module alu(
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    input logic [6:0] opcodes,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic [31:0] rs_out
);

localparam SHAMT5 = {5{1'b1}};
localparam SHAMT12 = {12{1'b1}};

always_comb begin
    case (opcodes)
        7'b0110011:     // R-Type
            case(funct3):
                3'h0: 
                    case (funct7):
                        7'h00: rs_out = rs1 + rs2; // add
                        7'h20: rs_out = rs1 - rs2; // sub
                    endcase
                3'h4: rs_out = rs1 ^ rs2; // xor
                3'h6: rs_out = rs1 | rs2; // or
                3'h7: rs_out = rs1 & rs2; // and
                3'h1: rs_out = rs1 << rs2; // logical shift left
                3'h5: 
                    case (funct7):
                        7'h00: rs_out = rs1 >>> rs2; // logical shift right
                        7'h20: rs_out = $signed(rs1) >> rs2;   // arithmetic shift right
                    endcase
                3'h2: rs_out = ($signed(rs1) < $signed(rs2)) ? 1:0; // interpreted as 2's complement before comparing
                3'h3: rs_out = ($unsigned(rs1) < $unsigned(rs2)) ? 1:0; // unsigned comparison
            endcase
        7'b0010011: // I - Type
            case (funct3):
                3'h0: rs_out = rs1 + (SHAMT12 & rs2);   // logic [31:0] rs2 = {{20{imm[11]}}, imm};  // manual sign extension
                3'h4: rs_out = rs1 ^ (SHAMT12 & rs2);
                3'h6: rs_out = rs1 | (SHAMT12 & rs2);
                3'h7: rs_out = rs1 & (SHAMT12 & rs2);
                3'h1: rs_out = rs1 << (SHAMT5 & rs2);   // logical shift left
                3'h5:
                    case (funct7)
                        7'h00: rs_out = rs1 >> (SHAMT5 & rs2);  // logical shift right
                        7'h20: rs_out = $signed(rs1) >> (SHAMT5 & rs2); // arithmetic shift right
                    endcase
                3'h2: rs_out = (rs1 < $signed(SHAMT12 & rs2)) 1 : 0;
                3'h3: rs_out = (rs1 < $unsigned(SHAMT12 & rs2)) 1 : 0;
            endcase
        7'b0000011: rs_out = rs1 + rs2; // Load: adding rs1 with whatever extended imm, and send address to memory to load
        7'b0100011: rs_out = rs1 + rs2; // Store: adding rs1 with whatever extended imm, and send address to memory to store
        7'b1100011: rs_out = rs1 + rs2; // PC + imm (last bit is always 0)
        7'b1101111: rs_out = rs1 + rs2; // JAL
        7'b1100111: rs_out = (rs1 + rs2) & ~1; // JALr
        7'b0110111: rs_out = ($signed(rs2) << 12); // LUI
        7'b0010111: rs_out = rs1 + ($signed(rs2) << 12); // auipc
        default: rs_out = {16{1'b1, 1'b0}}; // Debugging purpose
    endcase
end


endmodule