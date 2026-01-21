module orchestrationMemory #(
    parameter string FILE = ""
)
(
    input logic [31:0] address,
    output logic [31:0] instruction
);
logic [9:0] instr_addr;
assign instr_addr = address[9:0];

logic [7:0] instruction_mem [1023:0];

initial begin
    $display("Loading instruction memory");
    if (FILE != "") $readmemb(FILE, instruction_mem);
end

always begin
    // Combine 4 consecutive bytes (32 bits) to form one instruction
    // Address points to byte offset, so divide by 4 to get word offset
    logic [9:0] word_addr = instr_addr >> 2;  // divide by 4

    // For now, assume instructions are word-aligned (address % 4 == 0)
    // Each instruction spans 4 consecutive memory locations
    instruction = {instruction_mem[word_addr*4],
                   instruction_mem[word_addr*4 + 1],
                   instruction_mem[word_addr*4 + 2],
                   instruction_mem[word_addr*4 + 3]};
    // $display("instruction here is %b", instruction);
end

endmodule
