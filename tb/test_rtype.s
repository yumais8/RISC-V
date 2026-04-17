# Test R-type instructions:
#   ADD, SUB, XOR, OR, AND, SLL, SRL, SRA, SLT, SLTU

# ── Setup registers with test values ─────────────────────────────────────
addi x1, x0, 10        # x1 = 10  (0x0000000A)
addi x2, x0, 3         # x2 = 3   (0x00000003)
addi x3, x0, -5        # x3 = -5  (0xFFFFFFFB)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# ── ADD ──────────────────────────────────────────────────────────────────
# add x5, x1, x2  → x5 = 10 + 3 = 13 (0x0000000D)
# add x5, x1, x2
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# add x6, x1, x3  → x6 = 10 + (-5) = 5 (0x00000005)
# add x6, x1, x3
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# 
# ── SUB ──────────────────────────────────────────────────────────────────
# sub x7, x1, x2  → x7 = 10 - 3 = 7 (0x00000007)
# sub x7, x1, x2
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# sub x8, x2, x1  → x8 = 3 - 10 = -7 (0xFFFFFFF9)
# sub x8, x2, x1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# ── XOR ──────────────────────────────────────────────────────────────────
# xor x9, x1, x2  → x9 = 0x0A ^ 0x03 = 0x09 (9)
# xor x9, x1, x2
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# xor x10, x1, x3  → x10 = 0x0A ^ 0xFFFFFFFB = 0xFFFFFFF1 (-15)
# xor x10, x1, x3
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# ── OR ───────────────────────────────────────────────────────────────────
# or x11, x1, x2  → x11 = 0x0A | 0x03 = 0x0B (11)
# or x11, x1, x2
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# or x12, x1, x3  → x12 = 0x0A | 0xFFFFFFFB = 0xFFFFFFFB (-5)
# or x12, x1, x3
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# ── AND ──────────────────────────────────────────────────────────────────
# and x13, x1, x2  → x13 = 0x0A & 0x03 = 0x02 (2)
# and x13, x1, x2
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# and x14, x1, x3  → x14 = 0x0A & 0xFFFFFFFB = 0x0A (10)
# and x14, x1, x3
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# ── SLL (shift left logical) ────────────────────────────────────────────
# sll x15, x1, x2  → x15 = 10 << 3 = 80 (0x00000050)
# sll x15, x1, x2
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# ── SRL (shift right logical) ───────────────────────────────────────────
# srl x16, x1, x2  → x16 = 10 >> 3 = 1 (0x00000001)
# srl x16, x1, x2
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# srl x17, x3, x2  → x17 = 0xFFFFFFFB >> 3 = 0x1FFFFFFF (logical, zero-fill)
# srl x17, x3, x2
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# ── SRA (shift right arithmetic) ────────────────────────────────────────
# sra x18, x3, x2  → x18 = (-5) >>> 3 = -1 (0xFFFFFFFF, sign-extends)
# contrast with SRL above: SRL gives 0x1FFFFFFF, SRA gives 0xFFFFFFFF
sra x18, x3, x2
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# sra x19, x1, x2  → x19 = 10 >>> 3 = 1 (0x00000001, same as SRL for positives)
sra x19, x1, x2
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# ── SLT (set less than, signed) ─────────────────────────────────────────
# slt x20, x3, x1  → x20 = (-5 < 10) ? 1 : 0 = 1
slt x20, x3, x1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# slt x21, x1, x3  → x21 = (10 < -5) ? 1 : 0 = 0
slt x21, x1, x3
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# ── SLTU (set less than, unsigned) ──────────────────────────────────────
# sltu x22, x1, x3  → x22 = (10 < 0xFFFFFFFB) ? 1 : 0 = 1 (unsigned)
sltu x22, x1, x3
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# sltu x23, x3, x1  → x23 = (0xFFFFFFFB < 10) ? 1 : 0 = 0 (unsigned)
sltu x23, x3, x1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
