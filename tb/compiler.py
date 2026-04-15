import os
import re
from riscv_assembler.convert import AssemblyConverter

cnv = AssemblyConverter(output_mode = 'f')

# Read the assembly file content
with open('tb/test0.s', 'r') as f:
    assembly_lines = f.readlines()

assembly_code = ''.join(assembly_lines)

os.makedirs('src/instruction', exist_ok=True)
cnv(assembly_code, 'src/instruction/instruction_mem.txt')

# ---------------------------------------------------------------------------
# The riscv_assembler library mis-encodes S-type (store) immediates.
# Specifically it encodes {imm[3:0], 1'b0} in bits[11:7] instead of imm[4:0].
# We detect S-type instructions by opcode and re-encode them from scratch.
# ---------------------------------------------------------------------------

REG_MAP = {f'x{i}': i for i in range(32)}
REG_MAP.update({
    'zero':0, 'ra':1, 'sp':2, 'gp':3, 'tp':4,
    't0':5, 't1':6, 't2':7, 's0':8, 'fp':8, 's1':9,
    'a0':10,'a1':11,'a2':12,'a3':13,'a4':14,'a5':15,
    'a6':16,'a7':17,'s2':18,'s3':19,'s4':20,'s5':21,
    's6':22,'s7':23,'s8':24,'s9':25,'s10':26,'s11':27,
    't3':28,'t4':29,'t5':30,'t6':31,
})

S_TYPE_FUNCT3 = {'sb': '000', 'sh': '001', 'sw': '010'}

def encode_s_type(asm_line):
    """Correctly encode an S-type store instruction into a 32-bit binary string."""
    tokens = re.split(r'[\s,]+', asm_line.strip().lower())
    op   = tokens[0]
    rs2  = REG_MAP[tokens[1]]
    m    = re.match(r'(-?\d+)\((\w+)\)', tokens[2])
    imm  = int(m.group(1))
    rs1  = REG_MAP[m.group(2)]

    # 12-bit two's complement immediate
    imm12    = imm & 0xFFF
    imm_bin  = format(imm12, '012b')
    imm_hi   = imm_bin[0:7]   # imm[11:5] → bits[31:25]
    imm_lo   = imm_bin[7:12]  # imm[4:0]  → bits[11:7]

    return (imm_hi
            + format(rs2, '05b')
            + format(rs1, '05b')
            + S_TYPE_FUNCT3[op]
            + imm_lo
            + '0100011')

# Filter assembly source to actual instruction lines (skip blanks and comments)
asm_instructions = [
    l.strip() for l in assembly_lines
    if l.strip() and not l.strip().startswith('#')
]

# Read the 32-bit binary lines produced by riscv_assembler
with open('src/instruction/instruction_mem.txt', 'r') as f:
    binary_lines = [l.strip() for l in f if l.strip()]

# Patch S-type instructions
fixed_lines = []
for bin_line, asm_line in zip(binary_lines, asm_instructions):
    op = asm_line.lower().split()[0]
    if op in S_TYPE_FUNCT3:
        fixed_lines.append(encode_s_type(asm_line))
    else:
        fixed_lines.append(bin_line)

# Write byte-split output (four 8-bit lines per instruction)
with open('src/instruction/instruction_mem.txt', 'w') as f:
    for line in fixed_lines:
        for i in range(0, 32, 8):
            f.write(line[i:i+8] + '\n')


# Note:
# When loading a full 32bits value into a register, the best way is to
# Lui --> upper 20 bits
# addi --> lower 12 bit
