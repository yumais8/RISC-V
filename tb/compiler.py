from riscv_assembler.convert import AssemblyConverter

cnv = AssemblyConverter(output_mode = 'f')

# Read the assembly file content
with open('tb/test0.s', 'r') as f:
    assembly_code = f.read()

cnv(assembly_code, 'src/instruction/test0.txt')
