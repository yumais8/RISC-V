`timescale 1ns/1ps

module tb_control;
    logic [31:0] instruction;
    logic [6:0] opcodes;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [1:0] rs1_sel;
    logic [1:0] rs2_sel;
    logic write_mem;
    logic [1:0] web_sel;
    logic reg_write;
    logic [4:0] rd;

    control uui(.*);

    logic [6:0] opcodes_e;
    logic [4:0] rs1_e;
    logic [4:0] rs2_e;
    logic [4:0] rd_e;

    initial begin
        $display("Now testing the control unit functionalities");

        // R-Type instruction 
        $display("Testing the R instruction");
        opcodes_e = 7'b0110011;
        rs1_e = 5'h1;
        rs2_e = 5'h2;
        rd_e = 5'h3;
        instruction = { 7'h0, rs2_e, rs1_e, 3'h0 /* add */, rd_e, 7'b0110011}; #1;
        assert (opcodes = opcodes_e)
            else $display("The expected opcodes should be %h --> %h", opcdes_e, opcodes);
        
        // I-Type
    end

endmodule
