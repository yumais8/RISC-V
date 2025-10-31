module control
(
    // Input
    input logic [31:0] instruction,

    // output
    output logic [1:0] rs1_sel,
    output logic [1:0] rs2_sel,
    output logic [4:0] rd,
    output logic rd_sel,
    output logic wb_sel,
    output logic [6:0] opcodes,
    output logic [2:0] funct3,
    output logic [6:0] funct7,
    output logic write_mem,
    output logic reg_write_curr,
    output logic reg_data_sel   
);
//////////////////////////////
// Need a re-design of the write back stage
//////////////////////////////

logic[4:0] destination_reg;

assign opcodes = instruction[6:0];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];
assign destination_reg = instruction[11:7];

always_comb begin
    case (opcodes)
        7'b0110011: // R-Type 
            begin 
                rs1_sel = 2'b0;
                rs2_sel = 2'b0;
                rd_sel = 1'b1;
                rd = destination_reg;
                wb_sel = 1'b1;
                write_mem = 1'b0;
                reg_write_curr = 1'b0;
            end
        7'b0010011: // I - Type
            begin
                rs1_sel = 2'b0;
                rs2_sel = 2'b01;
                rd_sel = 1'b1;
                rd = destination_reg;
                wb_sel = 1'b1;
                write_mem = 1'b0;
                reg_write_curr = 1'b0;
            end
        7'b0000011: // Load
            begin
                rs1_sel = 2'b0;
                rs2_sel = 2'b01;
                rd_sel = 1'b1;
                rd = destination_reg;
                wb_sel = 1'b1;
                write_mem = 1'b0;
                reg_write_curr = 1'b0;
            end
        7'b0100011: // S - Type
            begin
                rs1_sel = 2'b0;
                rs2_sel = 2'b01;
                rd_sel = 1'b0;
                rd = 5'bx;
                wb_sel = 1'b0;
                write_mem = 1'b1;
                reg_write_curr = 1'b0;
            end 
        7'b1100011: // B - Type
            begin
                rs1_sel = 2'b01;
                rs2_sel = 2'b01;
                rd_sel = 1'b0;
                rd = 5'bx;
                wb_sel = 1'b0;
                write_mem = 1'b0;
                reg_write_curr = 1'b0;
            end 
        7'b1101111: // Jal
            begin
                rs1_sel = 2'b01;
                rs2_sel = 2'b01;
                rd_sel = 1'b0;
                rd = destination_reg;
                write_mem = 1'b0;
                reg_write_curr = 1'b1;
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
