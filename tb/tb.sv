`timescale 1ns/1ps

module tb;
    // DUT interface
    logic clk;
    logic reset;

    // EX stage variables
    // logic [31:0] pc_ex;
    // logic [6:0] funct7_ex;
    // logic [2:0] funct3_ex;
    // logic write_mem_ex;
    // logic [6:0] opcodes_ex;
    // logic [4:0] rd_ex;
    // logic [1:0] wb_sel_ex;
    // logic [1:0] rs1_sel_ex;
    // logic [1:0] rs2_sel_ex;
    // logic reg_write_ex;
    // logic [31:0] rs1_out_ex;
    // logic [31:0] rs2_out_ex;
    // logic [31:0] sext_out_ex;

    // MEM stage signals
    logic [31:0] alu_out_mem;
    logic        cmp_out_mem;
    logic [6:0]  opcodes_mem;
    logic [4:0]  rd_mem;
    logic [1:0]  wb_sel_mem;
    logic        reg_write_mem;
    logic        write_mem_mem;
    logic [2:0]  funct3_mem;
    logic [31:0] sext_out_mem;
    logic [31:0] pcplus4_mem;
    logic [31:0] mem_data_out;

    // debugging DUI variables
    logic [31:0] pc;
    logic [31:0] pc_id;
    logic [31:0] instruction_id;

    // Instantiate unit under test
    datapath #(
        .INSTRUCTION_FILE("src/instruction/instruction_mem.txt"),  // User will provide instruction file
        .MEMORY_FILE("")
    ) dut (
        .clk(clk),
        .reset(reset),
        // .pc_ex(pc_ex),
        // .funct7_ex(funct7_ex),
        // .funct3_ex(funct3_ex),
        // .write_mem_ex(write_mem_ex),
        // .opcodes_ex(opcodes_ex),
        // .rd_ex(rd_ex),
        // .wb_sel_ex(wb_sel_ex),
        // .rs1_sel_ex(rs1_sel_ex),
        // .rs2_sel_ex(rs2_sel_ex),
        // .reg_write_ex(reg_write_ex),
        // .rs1_out_ex(rs1_out_ex),
        // .rs2_out_ex(rs2_out_ex),
        // .sext_out_ex(sext_out_ex),
        // MEM stage ports
        .alu_out_mem(alu_out_mem),
        .cmp_out_mem(cmp_out_mem),
        .opcodes_mem(opcodes_mem),
        .rd_mem(rd_mem),
        .wb_sel_mem(wb_sel_mem),
        .reg_write_mem(reg_write_mem),
        .write_mem_mem(write_mem_mem),
        .funct3_mem(funct3_mem),
        .sext_out_mem(sext_out_mem),
        .pcplus4_mem(pcplus4_mem),
        .mem_data_out(mem_data_out),
        // debugging variable
        .pc(pc),
        .pc_id(pc_id),
        .instruction_id(instruction_id)
    );

    // Clock generation (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        $display("Starting datapath testbench");

        // Initialize - hold reset
        reset = 1;
        #20;  // Hold reset for 20ns

        // Release reset
        reset = 0;
        $display("Reset released at time %0t", $time);

        // Monitor for several clock cycles
        repeat (5) begin
            @(posedge clk);
            #1; // Small delay for signal propagation
            $display("--------------- t=%0t ---------------", $time);
            // $display("  pc_ex:  %d", pc_ex);
            // $display("  funct7_ex:   %b", funct7_ex);
            // $display("  funct3_ex:   %b", funct3_ex);
            // $display("  write_mem_ex: %b", write_mem_ex);
            // $display("  opcodes_ex:  %d: %b", opcodes_ex, opcodes_ex);
            // $display("  rd_ex:       %b", rd_ex);
            // $display("  wb_sel_ex:   %b", wb_sel_ex);
            // $display("  rs1_sel_ex:  %b", rs1_sel_ex);
            // $display("  rs2_sel_ex:  %b", rs2_sel_ex);
            // $display("  reg_write_ex: %b", reg_write_ex);
            // $display("  rs1_out_ex:  %b", rs1_out_ex);
            // $display("  rs2_out_ex:  %b", rs2_out_ex);
            // $display("  sext_out_ex: %b", sext_out_ex);

            $display("  -- MEM stage --");
            $display("  alu_out_mem:   %d", alu_out_mem);
            $display("  opcodes_mem:   %b", opcodes_mem);
            $display("  rd_mem:        %b", rd_mem);
            $display("  reg_write_mem: %b", reg_write_mem);
            $display("  cmp_out_mem:   %b", cmp_out_mem);
            $display("  wb_sel_mem:    %b", wb_sel_mem);
            $display("  write_mem_mem: %b", write_mem_mem);
            $display("  funct3_mem:    %b", funct3_mem);
            $display("  sext_out_mem:  %d", sext_out_mem);
            $display("  pcplus4_mem:   %d", pcplus4_mem);
            $display("  mem_data_out:  %d", mem_data_out);

            $display("  -- debugging vars --");
            $display("  pc:    %d", pc);
            $display("  pc_id: %d: %b", pc_id, pc_id);
            $display("  instruction_id: %d: %b", instruction_id, instruction_id);

        end

        $display("Testbench completed");
        $finish;
    end

endmodule