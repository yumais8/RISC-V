module datapath #(
    INSTRUCTION_FILE = "",
    MEMORY_FILE = ""
)
(
    input  logic clk,
    input  logic reset,

    // WB stage outputs (writeback to register file)
    output logic [4:0]  rd_wb,
    output logic [31:0] rd_data_wb,
    output logic        reg_write_wb
);

logic [31:0] pc_mux_out;
logic [31:0] pc;
logic [31:0] pcplus4;
logic [31:0] instruction;
logic pc_select;

pc programCounter(
    .clk(clk),
    .reset(reset),
    .pc(pc_mux_out),
    .pc_next(pc)
);

pcAdder pc_adder(
    .pc(pc),
    .next_pc(pcplus4)
);

orchestrationMemory #(
    .FILE(INSTRUCTION_FILE)
) pcInstructionMem (
    .address(pc),
    .instruction(instruction)
);

mux2 pc_mux(
    .data1(pcplus4),
    .data2(rs_alu_out),
    .select(pc_select),
    .out_data(pc_mux_out)
);

// IF/ID stage
logic [31:0] pc_id;
logic [31:0] instruction_id;

IFID ifid_stage(
    .reset(reset),
    .clk(clk),
    .pc_if(pc),
    .instruction_if(instruction),
    .pc_id(pc_id),
    .instruction_id(instruction_id)
);

// Decode stage
logic [6:0] opcodes;
logic [2:0] funct3;
logic [6:0] funct7;
logic rs1_sel;
logic rs2_sel;
logic write_mem;
logic [1:0] wb_sel;
logic reg_write;
logic [4:0] rd;

logic [4:0] rs1;
logic [4:0] rs2;

assign rs1 = instruction_id[19:15];
assign rs2 = instruction_id[24:20];
logic [31:0] rs1_out;
logic [31:0] rs2_out;
logic [31:0] immediate_out;


control controller(
    .instruction(instruction_id),
    .opcodes(opcodes),
    .funct3(funct3),
    .funct7(funct7),
    .rs1_sel(rs1_sel),
    .rs2_sel(rs2_sel),
    .write_mem(write_mem),
    .wb_sel(wb_sel),
    .reg_write(reg_write),
    .rd(rd)
);

regFile registerFile(
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd_wb),
    .data_write(rd_data_wb),
    .reg_write(reg_write_wb),
    .clk(clk),
    .reset(reset),
    .rs1_out(rs1_out),
    .rs2_out(rs2_out)
);

sext sign_extension(
    .instruction(instruction_id),
    .immediate_o(immediate_out)
);

// ID/EX pipeline registers
logic [31:0] pc_ex;
logic [6:0]  funct7_ex;
logic [2:0]  funct3_ex;
logic        write_mem_ex;
logic [6:0]  opcodes_ex;
logic [4:0]  rd_ex;
logic [1:0]  wb_sel_ex;
logic        rs1_sel_ex;
logic        rs2_sel_ex;
logic        reg_write_ex;
logic [31:0] rs1_out_ex;
logic [31:0] rs2_out_ex;
logic [31:0] sext_out_ex;

IDEX idex_stage(
    .clk(clk),
    .reset(reset),
    .pc_id(pc_id),
    .funct7_id(funct7),
    .funct3_id(funct3),
    .write_mem_id(write_mem),
    .opcodes_id(opcodes),
    .rd_id(rd),
    .wb_sel_id(wb_sel),
    .rs1_sel_id(rs1_sel),
    .rs2_sel_id(rs2_sel),
    .reg_write_id(reg_write),
    .rs1_out_id(rs1_out),
    .rs2_out_id(rs2_out),
    .sext_out_id(immediate_out),
    .pc_ex(pc_ex),
    .funct7_ex(funct7_ex),
    .funct3_ex(funct3_ex),
    .write_mem_ex(write_mem_ex),
    .opcodes_ex(opcodes_ex),
    .rd_ex(rd_ex),
    .wb_sel_ex(wb_sel_ex),
    .rs1_sel_ex(rs1_sel_ex),
    .rs2_sel_ex(rs2_sel_ex),
    .reg_write_ex(reg_write_ex),
    .rs1_out_ex(rs1_out_ex),
    .rs2_out_ex(rs2_out_ex),
    .sext_out_ex(sext_out_ex)
);

// Execute stage
logic [31:0] rs1_alu_in;
logic [31:0] rs2_alu_in;
logic [31:0] rs_alu_out;
logic        comp_out;
logic [31:0] pc_plus4_ex;

mux4 rs1_mux(
    .option0(pc_ex),
    .option1(rs1_out_ex),
    .option2(/* alu forwarding */ 32'b1),
    .option3(/* memory output */ 32'd2),
    .select({1'b0 /* from forwarding unit */, rs1_sel_ex}),
    .mux_out(rs1_alu_in)
);

mux4 rs2_mux(
    .option0(rs2_out_ex),
    .option1(sext_out_ex),
    .option2(/* alu forwarding */ 32'b1),
    .option3(/* memory output */ 32'd2),
    .select({1'b0 /* from forwarding unit */, rs2_sel_ex}),
    .mux_out(rs2_alu_in)
);

alu alu(
    .rs1(rs1_alu_in),
    .rs2(rs2_alu_in),
    .opcodes(opcodes_ex),
    .funct3(funct3_ex),
    .funct7(funct7_ex),
    .rs_out(rs_alu_out)
);

branchComp comparator(
    .rs1(rs1_out_ex),
    .rs2(rs2_out_ex),
    .funct3(funct3_ex),
    .comp_out(comp_out)
);

pcAdder pc_adder_ex(
    .pc(pc_ex),
    .next_pc(pc_plus4_ex)
);

// pc select signal
localparam [6:0] jal_opcodes = 7'b1101111;
localparam [6:0] jalr_opcodes = 7'b1100111;
localparam [6:0] branch_opcodes = 7'b1100011;
logic jumpImmediate = (opcodes_ex == jal_opcodes) || (opcodes_ex == jalr_opcodes);
logic branchOpcodes = opcodes_ex == branch_opcodes;

assign pc_select = jumpImmediate | (branchOpcodes & comp_out);

// EX/MEM pipeline registers
logic [31:0] alu_out_mem;
logic [6:0]  opcodes_mem;
logic [4:0]  rd_mem;
logic [1:0]  wb_sel_mem;
logic        reg_write_mem;
logic        write_mem_mem;
logic [2:0]  funct3_mem;
logic [31:0] sext_out_mem;
logic [31:0] pcplus4_mem;

EXMEM exmem_stage(
    .clk(clk),
    .reset(reset),
    .pcplus4_ex(pc_plus4_ex),
    .funct3_ex(funct3_ex),
    .write_mem_ex(write_mem_ex),
    .opcodes_ex(opcodes_ex),
    .rd_ex(rd_ex),
    .wb_sel_ex(wb_sel_ex),
    .reg_write_ex(reg_write_ex),
    .alu_out_ex(rs_alu_out),
    .sext_out_ex(sext_out_ex),
    .pcplus4_mem(pcplus4_mem),
    .funct3_mem(funct3_mem),
    .write_mem_mem(write_mem_mem),
    .opcodes_mem(opcodes_mem),
    .rd_mem(rd_mem),
    .wb_sel_mem(wb_sel_mem),
    .reg_write_mem(reg_write_mem),
    .alu_out_mem(alu_out_mem),
    .sext_out_mem(sext_out_mem)
);

// MEM stage
logic [31:0] mem_data_out;

memory #(
    .MEMORY_FILE(MEMORY_FILE)
) data_memory (
    .address(alu_out_mem),
    .write_data(alu_out_mem),
    .write_mem(write_mem_mem),
    .funct3(funct3_mem),
    .clk(clk),
    .reset(reset),
    .mem_out(mem_data_out),
    .memory0(),
    .memory1(),
    .memory2(),
    .memory3(),
    .memory4(),
    .memory5(),
    .memory6(),
    .memory7(),
    .memory8(),
    .memory9()
);

logic [31:0] pcplus4_wb;
logic [1:0] wb_select_wb;
logic [31:0] mem_data_wb;
logic [31:0] alu_data_wb;
logic [31:0] sext_out_wb;


// MEM WB stage
MEMWB memwb_stage(
    .clk(clk),
    .reset(reset),
    .pcplus4_mem(pcplus4_mem),
    .rd_mem(rd_mem),
    .wb_sel_mem(wb_sel_mem),
    .reg_write_mem(reg_write_mem),
    .mem_out_mem(mem_data_out),
    .alu_out_mem(alu_out_mem),
    .sext_out_mem(sext_out_mem),
    .pcplus4_wb(pcplus4_wb),
    .rd_wb(rd_wb),
    .wb_sel_wb(wb_select_wb),
    .reg_write_wb(reg_write_wb),
    .mem_out_wb(mem_data_wb),
    .alu_out_wb(alu_data_wb),
    .sext_out_wb(sext_out_wb)
);

// WB stage: select writeback data
mux4 wb_mux(
    .option0(pcplus4_wb),
    .option1(mem_data_wb),
    .option2(sext_out_wb),
    .option3(alu_data_wb),
    .select(wb_select_wb),
    .mux_out(rd_data_wb)
);

endmodule
