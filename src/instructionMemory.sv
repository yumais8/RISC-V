module instructionMemory(
    input logic [31:0] address,
    output logic [31:0] instruction
);
logic [7:0] instr_addr;
assign instr_addr = address[7:0];

logic [31:0] instruction_mem [255:0];

// potentialy, install all instructions here
// initial begin
//
// end

always begin
    instruction = instruction_mem[instr_addr];
end

endmodule
