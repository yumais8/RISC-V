# Data memory layout (binary, $readmemb, word-addressed via address[9:2]):
#   mem[0] @ addr 0x00 = 0xDEADBEEF
#              bytes: [7:0]=0xEF(neg), [15:8]=0xBE(neg), [23:16]=0xAD(neg), [31:24]=0xDE(neg)
#              halves: [15:0]=0xBEEF(neg), [31:16]=0xDEAD(neg)
#   mem[1] @ addr 0x04 = 0x7F008001
#              bytes: [7:0]=0x01(pos), [15:8]=0x80(neg), [23:16]=0x00(pos), [31:24]=0x7F(pos)
#              halves: [15:0]=0x8001(neg), [31:16]=0x7F00(pos)

# ── Setup base addresses ────────────────────────────────────────────────────
addi x1, x0, 0          # x1 = 0x00  (base for mem[0])
addi x2, x0, 4          # x2 = 0x04  (base for mem[1])
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# ── LW: load full word ───────────────────────────────────────────────────────
# lw x10, 0(x1)  → x10 = 0xDEADBEEF
# lw  x10, 0(x1)
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# lw x11, 0(x2)  → x11 = 0x7F008001
# lw  x11, 0(x2)
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# ── LB: load byte, sign-extend ───────────────────────────────────────────────
# lb x12, 0(x1)  → byte[7:0]=0xEF → sign-extended → x12 = 0xFFFFFFEF
# lb  x12, 0(x1)
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# lb x13, 0(x2)  → byte[7:0]=0x01 → sign-extended → x13 = 0x00000001
# lb  x13, 0(x2)
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# ── LH: load halfword, sign-extend ───────────────────────────────────────────
# lh x14, 0(x1)  → half[15:0]=0xBEEF → sign-extended → x14 = 0xFFFFBEEF
# lh  x14, 0(x1)
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# lh x15, 0(x2)  → half[15:0]=0x8001 → sign-extended → x15 = 0xFFFF8001
# lh  x15, 0(x2)
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# ── LBU: load byte, zero-extend ──────────────────────────────────────────────
# lbu x15, 0(x1)  → byte[7:0]=0xEF → zero-extended → x15 = 0x000000EF
# lbu x15, 0(x1)
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# lbu x17, 0(x2)  → byte[7:0]=0x01 → zero-extended → x15 = 0x00000001
# lbu x15, 0(x2)
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# ── LHU: load halfword, zero-extend ──────────────────────────────────────────
# lhu x15, 0(x1)  → half[15:0]=0xBEEF → zero-extended → x15 = 0x0000BEEF
# lhu x15, 0(x1)
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# lhu x19, 0(x2)  → half[15:0]=0x8001 → zero-extended → x15 = 0x00008001
lhu x15, 0(x2)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
