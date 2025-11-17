module orchestrationMemory #(
    parameter string FILE = ""
)
(
    input logic [31:0] address,
    output logic [31:0] instruction
);
logic [7:0] instr_addr;
assign instr_addr = address[7:0];

logic [31:0] instruction_mem [255:0];

initial begin
    $display("Loading instruction memory");
    if (FILE != "") $readmemh(FILE, instruction_mem);
end

always begin
    instruction = instruction_mem[instr_addr];
end

endmodule
