import os
import re
from riscv_assembler.convert import AssemblyConverter

cnv = AssemblyConverter(output_mode='f')

# ---------------------------------------------------------------------------
# Library audit: test each instruction type for correct 32-bit encoding.
#
# Findings (from inspecting riscv_assembler/instr_arr.py + live verification):
#   R-type  (add/sub/…)      : CORRECT  — use library output as-is
#   R-type  (slt/sltu)       : MISSING — not in library instruction table
#                               → patched by encode_r_type()
#   I-type  (addi/lw/…)      : CORRECT  — use library output as-is
#   I-load  (lb/lh/lbu/lhu)  : MISSING — not in library instruction table
#                               → patched by encode_i_load()
#   S-type  (sw/sb/sh/sd)    : BUG — lower imm field encodes imm[3:0]|imm[10]
#                               instead of imm[4:0]; upper field is also shifted
#                               → patched by encode_s_type()
#   B-type  (beq/bne/…)      : BUG — JUMP() negates skip_labels for backward
#                               branches, cancelling index-line_num difference
#                               → patched by encode_b_type()
#   J-type  (jal rd, label)  : BUG — parser length-check fails for
#                               "jal rd, label" form, treats rd as the label
#                               → patched by encode_j_type()
#   U-type  (lui/auipc)      : BUG — parser swaps rd and imm order; also
#                               formats as 13 bits instead of 20 bits
#                               → patched by encode_u_type()
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

# ---------------------------------------------------------------------------
# R-type encoder (slt, sltu — and any other R-type ops the library misses)
# RISC-V spec: funct7 | rs2 | rs1 | funct3 | rd | opcode(0110011)
# Library limitation: slt/sltu are absent from its instruction table.
# ---------------------------------------------------------------------------
R_TYPE_INFO = {
    'add':  ('0000000', '000'),
    'sub':  ('0100000', '000'),
    'xor':  ('0000000', '100'),
    'or':   ('0000000', '110'),
    'and':  ('0000000', '111'),
    'sll':  ('0000000', '001'),
    'srl':  ('0000000', '101'),
    'sra':  ('0100000', '101'),
    'slt':  ('0000000', '010'),
    'sltu': ('0000000', '011'),
}
R_TYPE_UNSUPPORTED = {'slt', 'sltu'}

def encode_r_type(asm_line):
    """Correctly encode an R-type instruction into a 32-bit binary string."""
    tokens = re.split(r'[\s,]+', asm_line.strip().lower())
    op  = tokens[0]
    rd  = REG_MAP[tokens[1]]
    rs1 = REG_MAP[tokens[2]]
    rs2 = REG_MAP[tokens[3]]
    funct7, funct3 = R_TYPE_INFO[op]

    return (funct7
            + format(rs2, '05b')
            + format(rs1, '05b')
            + funct3
            + format(rd, '05b')
            + '0110011')

# ---------------------------------------------------------------------------
# I-type ALU encoder (xori, ori, andi, slli, srli, srai, slti, sltiu)
# RISC-V spec:
#   Non-shift: imm[11:0]           | rs1 | funct3 | rd | opcode(0010011)
#   Shift:     funct7 | shamt[4:0] | rs1 | funct3 | rd | opcode(0010011)
# Library limitation: only recognises addi; the rest are absent from its
# instruction table and cause a crash.
# ---------------------------------------------------------------------------
I_ALU_FUNCT3 = {
    'addi': '000', 'xori': '100', 'ori': '110', 'andi': '111',
    'slli': '001', 'srli': '101', 'srai': '101',
    'slti': '010', 'sltiu': '011',
}
I_ALU_SHIFT_FUNCT7 = {'slli': '0000000', 'srli': '0000000', 'srai': '0100000'}
I_ALU_UNSUPPORTED = {'xori', 'ori', 'andi', 'slli', 'srli', 'srai', 'slti', 'sltiu'}

def encode_i_alu(asm_line):
    """Correctly encode an I-type ALU instruction into a 32-bit binary string."""
    tokens = re.split(r'[\s,]+', asm_line.strip().lower())
    op  = tokens[0]
    rd  = REG_MAP[tokens[1]]
    rs1 = REG_MAP[tokens[2]]
    imm = int(tokens[3])

    funct3 = I_ALU_FUNCT3[op]

    if op in I_ALU_SHIFT_FUNCT7:
        shamt = imm & 0x1F
        return (I_ALU_SHIFT_FUNCT7[op]
                + format(shamt, '05b')
                + format(rs1, '05b')
                + funct3
                + format(rd, '05b')
                + '0010011')
    else:
        return (format(imm & 0xFFF, '012b')
                + format(rs1, '05b')
                + funct3
                + format(rd, '05b')
                + '0010011')

# ---------------------------------------------------------------------------
# I-type load encoder (lb, lh, lw, lbu, lhu)
# RISC-V spec: imm[11:0] | rs1 | funct3 | rd | opcode(0000011)
# Library limitation: only recognises lw; lb/lh/lbu/lhu are absent from its
# instruction table and cause a crash.
# ---------------------------------------------------------------------------
I_LOAD_FUNCT3 = {'lb': '000', 'lh': '001', 'lw': '010', 'lbu': '100', 'lhu': '101'}

def encode_i_load(asm_line):
    """Correctly encode an I-type load instruction into a 32-bit binary string."""
    tokens = re.split(r'[\s,]+', asm_line.strip().lower())
    op  = tokens[0]
    rd  = REG_MAP[tokens[1]]
    m   = re.match(r'(-?\d+)\((\w+)\)', tokens[2])
    imm = int(m.group(1))
    rs1 = REG_MAP[m.group(2)]

    imm_bin = format(imm & 0xFFF, '012b')

    return (imm_bin
            + format(rs1, '05b')
            + I_LOAD_FUNCT3[op]
            + format(rd, '05b')
            + '0000011')

# ---------------------------------------------------------------------------
# S-type encoder (sw, sb, sh, sd)
# RISC-V spec: bits[31:25]=imm[11:5], bits[11:7]=imm[4:0]
# Library bug: encodes imm[11]|imm[9:4] in upper field and imm[3:0]|imm[10]
#              in lower field (imm[4] and imm[10] are swapped).
# ---------------------------------------------------------------------------
S_TYPE_FUNCT3 = {'sb': '000', 'sh': '001', 'sw': '010', 'sd': '011'}

def encode_s_type(asm_line):
    """Correctly encode an S-type store instruction into a 32-bit binary string."""
    tokens = re.split(r'[\s,]+', asm_line.strip().lower())
    op  = tokens[0]
    rs2 = REG_MAP[tokens[1]]
    m   = re.match(r'(-?\d+)\((\w+)\)', tokens[2])
    imm = int(m.group(1))
    rs1 = REG_MAP[m.group(2)]

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

# ---------------------------------------------------------------------------
# J-type encoder (jal)
# RISC-V spec: bits[31:12] = imm[20|10:1|11|19:12]
# Library bug: _UJ_parse checks len(tokens)==3 but tokens always have
#              line_num and code appended (len==5 for "jal rd, label"),
#              so the else-branch runs and treats 'rd' as the jump label.
# ---------------------------------------------------------------------------
J_TYPE_OPCODE = {'jal': '1101111'}

def encode_j_type(asm_line, current_pc, labels):
    """Correctly encode a JAL instruction into a 32-bit binary string."""
    tokens = re.split(r'[\s,]+', asm_line.strip().lower())
    op     = tokens[0]
    rd     = REG_MAP[tokens[1]]
    target = tokens[2]

    imm = int(target) if target.lstrip('-').isdigit() else labels[target] - current_pc

    imm21    = imm & 0x1FFFFF
    b        = format(imm21, '021b')  # b[0]=bit20 … b[20]=bit0
    # RISC-V J-type: imm[20|10:1|11|19:12]
    imm20      = b[0]       # bit 20
    imm_10_1   = b[10:20]   # bits 10..1
    imm11      = b[9]       # bit 11
    imm_19_12  = b[1:9]     # bits 19..12

    return (imm20 + imm_10_1 + imm11 + imm_19_12
            + format(rd, '05b')
            + J_TYPE_OPCODE[op])

# ---------------------------------------------------------------------------
# U-type encoder (lui, auipc)
# RISC-V spec: bits[31:12] = imm[31:12] (20-bit upper immediate)
# Library bug: _U_parse assigns tokens[1] (the rd register) to imm and
#              tries reg_map[tokens[2]] (the numeric imm) as rd → crash.
#              Also formats the immediate as only 13 bits (not 20).
# ---------------------------------------------------------------------------
U_TYPE_OPCODE = {'lui': '0110111', 'auipc': '0010111'}

def encode_u_type(asm_line):
    """Correctly encode a U-type instruction into a 32-bit binary string."""
    tokens = re.split(r'[\s,]+', asm_line.strip().lower())
    op  = tokens[0]
    rd  = REG_MAP[tokens[1]]
    imm = int(tokens[2]) & 0xFFFFF   # 20-bit upper immediate

    return format(imm, '020b') + format(rd, '05b') + U_TYPE_OPCODE[op]

# ---------------------------------------------------------------------------
# B-type encoder (beq, bne, blt, bge, bltu, bgeu)
# Library bug: JUMP() computes offset as (index - line_num - skip_labels)*4
#              where skip_labels is negated for backward branches, causing the
#              label count to cancel the index difference (yields 0 instead of
#              the correct negative offset).
# RISC-V spec: bits[31:25] = imm[12|10:5], bits[11:7] = imm[4:1|11]
# ---------------------------------------------------------------------------
B_TYPE_FUNCT3 = {'beq':'000','bne':'001','blt':'100','bge':'101','bltu':'110','bgeu':'111'}
B_TYPE_OPCODE = '1100011'

def encode_b_type(asm_line, current_pc, labels):
    """Correctly encode a B-type branch instruction into a 32-bit binary string."""
    tokens = re.split(r'[\s,]+', asm_line.strip().lower())
    op     = tokens[0]
    rs1    = REG_MAP[tokens[1]]
    rs2    = REG_MAP[tokens[2]]
    target = tokens[3]

    imm = int(target) if target.lstrip('-').isdigit() else labels[target] - current_pc

    imm13  = imm & 0x1FFF
    b      = format(imm13, '013b')  # b[0]=bit12, b[1]=bit11, b[2..7]=bit10..5, b[8..11]=bit4..1
    # RISC-V B-type: imm[12|10:5] | rs2 | rs1 | funct3 | imm[4:1|11] | opcode
    upper  = b[0] + b[2:8]    # imm[12] | imm[10:5]
    lower  = b[8:12] + b[1]   # imm[4:1] | imm[11]

    return (upper
            + format(rs2, '05b')
            + format(rs1, '05b')
            + B_TYPE_FUNCT3[op]
            + lower
            + B_TYPE_OPCODE)

# ---------------------------------------------------------------------------
# Label resolver: first-pass scan to map label names → PC byte address.
# Needed by encode_j_type and encode_b_type to compute offsets from labels.
# ---------------------------------------------------------------------------
def resolve_labels(asm_lines):
    """Return a dict mapping label names (lowercase) to their PC byte offset."""
    labels, pc = {}, 0
    for line in asm_lines:
        s = line.strip()
        if not s or s.startswith('#'):
            continue
        if s.endswith(':'):
            labels[s[:-1].lower()] = pc
        else:
            pc += 4
    return labels

# ---------------------------------------------------------------------------
# Assemble the program
# ---------------------------------------------------------------------------
B_TYPE_OPS = set(B_TYPE_FUNCT3)
J_TYPE_OPS = set(J_TYPE_OPCODE)
U_TYPE_OPS = set(U_TYPE_OPCODE)
I_LOAD_UNSUPPORTED = I_LOAD_FUNCT3.keys() - {'lw'}

# The library has bugs in J-type, U-type, and B-type encoders.  Substitute
# those lines with a NOP (addi x0,x0,0) so the library processes the file
# without crashing — instruction count is preserved so the file length matches.
_NOP = 'addi x0, x0, 0'

with open('tb/test_itype.s', 'r') as f:
    assembly_lines = f.readlines()

def _make_library_safe(lines):
    safe = []
    for line in lines:
        s = line.strip()
        if not s or s.startswith('#') or s.endswith(':'):
            safe.append(line)
            continue
        op = s.lower().split()[0]
        safe.append((_NOP + '\n') if op in J_TYPE_OPS | U_TYPE_OPS | B_TYPE_OPS | I_LOAD_UNSUPPORTED | R_TYPE_UNSUPPORTED | I_ALU_UNSUPPORTED else line)
    return safe

safe_code = ''.join(_make_library_safe(assembly_lines))

os.makedirs('src/instruction', exist_ok=True)
cnv(safe_code, 'src/instruction/instruction_mem.txt')

# Filter assembly source to actual instruction lines (skip blanks, comments,
# and label-only lines).
asm_instructions = [
    l.strip() for l in assembly_lines
    if l.strip() and not l.strip().startswith('#') and not l.strip().endswith(':')
]

# Read the 32-bit binary lines produced by riscv_assembler
with open('src/instruction/instruction_mem.txt', 'r') as f:
    binary_lines = [l.strip() for l in f if l.strip()]

# Pre-compute label positions for J-type offset resolution
labels = resolve_labels(assembly_lines)

# Patch instructions whose library encoding is incorrect.
# R-type, I-type (addi/lw): library output is correct — kept as-is.
# I-load (lb/lh/lbu/lhu), S-type, B-type, J-type, U-type: re-encoded with our own encoders.
fixed_lines = []
pc = 0
for bin_line, asm_line in zip(binary_lines, asm_instructions):
    op = asm_line.lower().split()[0]
    if op in R_TYPE_UNSUPPORTED:
        fixed_lines.append(encode_r_type(asm_line))
    elif op in I_ALU_UNSUPPORTED:
        fixed_lines.append(encode_i_alu(asm_line))
    elif op in I_LOAD_UNSUPPORTED:
        fixed_lines.append(encode_i_load(asm_line))
    elif op in S_TYPE_FUNCT3:
        fixed_lines.append(encode_s_type(asm_line))
    elif op in B_TYPE_OPS:
        fixed_lines.append(encode_b_type(asm_line, pc, labels))
    elif op in J_TYPE_OPS:
        fixed_lines.append(encode_j_type(asm_line, pc, labels))
    elif op in U_TYPE_OPS:
        fixed_lines.append(encode_u_type(asm_line))
    else:
        fixed_lines.append(bin_line)
    pc += 4

# Write byte-split output (four 8-bit lines per instruction)
with open('src/instruction/instruction_mem.txt', 'w') as f:
    for line in fixed_lines:
        for i in range(0, 32, 8):
            f.write(line[i:i+8] + '\n')


# Note:
# When loading a full 32-bit value into a register, the canonical way is:
#   lui  rd, upper20   ← loads imm[31:12] into rd, zeroes bits[11:0]
#   addi rd, rd, imm12 ← adds the sign-extended lower 12 bits
