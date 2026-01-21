from riscv_assembler.convert import AssemblyConverter

cnv = AssemblyConverter(output_mode = 'f')

# Read the assembly file content
with open('tb/test0.s', 'r') as f:
    assembly_code = f.read()

cnv(assembly_code, 'src/instruction/instruction_mem.txt')

# Convert 32-bit lines to 8-bit lines
with open('src/instruction/instruction_mem.txt', 'r') as f:
    lines = f.readlines()

with open('src/instruction/instruction_mem.txt', 'w') as f:
    for line in lines:
        line = line.strip()
        if line:  # Skip empty lines
            # Split 32-bit binary into four 8-bit chunks
            for i in range(0, 32, 8):
                byte = line[i:i+8]
                f.write(byte + '\n')


# Note:
# When loading a full 32bits value into a register, the best way is to
# Lui --> upper 20 bits
# addi --> lower 12 bit