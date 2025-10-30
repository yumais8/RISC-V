module branchComp(
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    input logic [2:0] funct3,
    output logic comp_out
);

localparam true = 1'b1;
localparam false = 1'b0;
// When opcodes == beq, bne, blt, bge, bltu, bgeu
always_comb begin
    case (funct3)
        3'h0: comp_out = rs1 == rs2 ? true : false;
        3'h1: comp_out = rs1 != rs2 ? true : false;
        3'h4: comp_out = rs1 < rs2 ? true : false;
        3'h5: comp_out = rs1 >= rs2 ? true : false;
        3'h6: comp_out = $unsigned(rs1) < $unsigned(rs2) ? true : false;
        3'h7: comp_out = $unsigned(rs1) >= $unsigned(rs2) ? true: false;
        default: comp_out = false;
    endcase
end

endmodule