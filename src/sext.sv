module sext(
    input logic[31:0] instruction,
    output logic[31:0] immediate_o
);

    // Test to see if it's better to manually inline (or is this good style?)
    logic [6:0] opcode = instruction[6:0];
    logic [2:0] funct3 = instruction[14:12]; // Used only for I-Type nested case

    always_comb begin

        // Case for instruction type
        unique case (opcode)
            7'b0110011: // R-Type - sext not used
                immediate_o = 32'b0;
            7'b0010011, 7'b1100111: begin // I-Type "S" and JALR (which has a funct3 of 0x0)
                unique case (funct3)
                    3'h1, 3'h5: // "Don't care", 0-extend
                        immediate_o = { 20{1'b0}, instruction[31:20]};
                    default: // All others sign-extend
                        immediate_o = { 20{instruction[31]}, instruction[31:20]};
                endcase
            end
            7'b0000011: // I-Type "L"
                immediate_o = {20{instruction[31]}, instruction[31:20]};
            7'b0100011: // S-type
                immediate_o = {20{instruction[31]}, {instruction[31:25],instruction[11:7]}};
            7'b1100011: // B-type
                immediate_o = {20{instruction[31]}, {instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0}};
            7'b1101111: // J-type
                immediate_o = {12{instruction[31]}, {instruction[31], instruction[19:12], instruction[20], instruction[30:21],1'b0}};
            7'b0110111, 7'b0010111: // U-type LUI and U-type AUIPC "Don't care", 0-extend
                immediate_o = {12{1'b0}, instruction[31:12]};
            default: immediate_o = 32{1'b0}; // Tell compiler that this case is truly unique
        endcase
    end
endmodule