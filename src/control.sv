module control
(
    input logic [31:0] instruction,

    output logic [6:0] opcodes,
    output logic [2:0] funct3,
    output logic [6:0] funct7,
    
    output logic [1:0] rs1_sel,
    output logic [1:0] rs2_sel,
    output logic write_mem,
    output logic [1:0]wb_sel,
    output logic reg_write,
    output logic [4:0] rd
);

logic[4:0] destination_reg;

assign opcodes = instruction[6:0];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];
assign destination_reg = instruction[11:7];

always_comb begin
    case (opcodes)
        7'b0110011: // R-Type 
            begin 
                rs1_sel = 2'b01;
                rs2_sel = 2'b00;
                write_mem = 1'b0;
                wb_sel = 2'b11;
                reg_write = 1'b1;
                rd = destination_reg;
            end
        7'b0010011: // I - Type
            begin
                rs1_sel = 2'b01;
                rs2_sel = 2'b01;    // immediate
                write_mem = 1'b0;
                wb_sel = 2'b01;
                reg_write = 1'b1;
                rd = destination_reg;
            end
        7'b0000011: // Load
            begin
                rs1_sel = 2'b01;
                rs2_sel = 2'b01;
                write_mem = 1'b0;
                wb_sel = 2'b01; // memory 
                reg_write = 1'b1;
                rd = destination_reg;
            end
        7'b0100011: // S - Type
            begin
                rs1_sel = 2'b01;
                rs2_sel = 2'b01;
                write_mem = 1'b1;
                wb_sel = 2'b00; // no write bakc
                reg_write = 1'b0;
                rd = instruction[24:20]; // rs2
            end 
        7'b1100011: // B - Type
            begin
                rs1_sel = 2'b00; // pc
                rs2_sel = 2'b01; // immediate
                write_mem = 1'b0;
                wb_sel = 2'b00;
                reg_write = 1'b0;
                rd = 5'bx;
            end 
        7'b1101111: // Jal
            begin
                rs1_sel = 2'b00; // pc
                rs2_sel = 2'b01; // imm
                write_mem = 1'b0;
                wb_sel = 2'b00; // pcplus4
                reg_write = 1'b1;
                rd = destination_reg;
            end 
        7'b1100111: // jalr
            begin
                rs1_sel = 2'b01; // rs1
                rs2_sel = 2'b01; // imm
                write_mem = 1'b0;
                wb_sel = 2'b00; // pcplus4
                reg_write = 1'b1;
                rd = destination_reg;
            end 
        7'b0110111: // lui
            begin
                rs1_sel = 2'b00;  // no rs1 select
                rs2_sel = 2'b00;  // no rs2 select
                write_mem = 1'b0;
                wb_sel = 2'b10; // sext(imm)
                reg_write = 1'b1;
                rd = destination_reg;
            end
        7'b0010111: // auipc
            begin
                rs1_sel = 2'b00; // pc
                rs2_sel = 2'b01; // imm
                write_mem = 1'b0;
                wb_sel = 2'b11; //alu_out
                reg_write = 1'b1;
                rd = destination_reg;
            end
        default: 
            begin
                rs1_sel = 2'bxx;
                rs2_sel = 2'bxx;
                write_mem = 1'b0;
                wb_sel = 2'bxx;
                reg_write = 1'b0;
                rd = 5'bx;
            end
    endcase
end

endmodule
