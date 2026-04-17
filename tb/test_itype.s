# Test I-type ALU instructions (excludes loads):
#   ADDI, XORI, ORI, ANDI, SLLI, SRLI, SRAI, SLTI, SLTIU
#
# All test instructions read only x1/x2/x3 (set during setup) and write to
# unique destination registers (x5–x24), so there are no data hazards between
# them — they run back-to-back with no NOPs needed.

# ── Setup registers with test values ─────────────────────────────────────
addi x1, x0, 10        # x1 = 10  (0x0000000A)
addi x2, x0, -5        # x2 = -5  (0xFFFFFFFB)
addi x3, x0, 255       # x3 = 255 (0x000000FF)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# ── ADDI ─────────────────────────────────────────────────────────────────
addi x5, x1, 20        # x5 = 10 + 20 = 30 (0x0000001E)
addi x6, x1, -3        # x6 = 10 + (-3) = 7 (0x00000007)
addi x7, x2, 5         # x7 = -5 + 5 = 0 (0x00000000)

# ── XORI ─────────────────────────────────────────────────────────────────
xori x8, x1, 255       # x8 = 0x0A ^ 0xFF = 0xF5 (245)
xori x9, x2, 15        # x9 = 0xFFFFFFFB ^ 0x0F = 0xFFFFFFF4 (-12)

# ── ORI ──────────────────────────────────────────────────────────────────
ori x10, x1, 255       # x10 = 0x0A | 0xFF = 0xFF (255)
ori x11, x2, 4         # x11 = 0xFFFFFFFB | 0x04 = 0xFFFFFFFF (-1)

# ── ANDI ─────────────────────────────────────────────────────────────────
andi x12, x1, 255      # x12 = 0x0A & 0xFF = 0x0A (10)
andi x13, x2, 15       # x13 = 0xFFFFFFFB & 0x0F = 0x0B (11)

# ── SLLI (shift left logical immediate) ──────────────────────────────────
slli x14, x1, 4        # x14 = 10 << 4 = 160 (0x000000A0)
slli x15, x1, 1        # x15 = 10 << 1 = 20 (0x00000014)

# ── SRLI (shift right logical immediate) ─────────────────────────────────
srli x16, x1, 1        # x16 = 10 >> 1 = 5 (0x00000005)
srli x17, x2, 4        # x17 = 0xFFFFFFFB >> 4 = 0x0FFFFFFF (logical, zero-fill)

# ── SRAI (shift right arithmetic immediate) ──────────────────────────────
srai x18, x2, 4        # x18 = (-5) >>> 4 = -1 (0xFFFFFFFF, sign-extends)
srai x19, x1, 1        # x19 = 10 >>> 1 = 5 (0x00000005, same as SRLI for positives)

# ── SLTI (set less than immediate, signed) ───────────────────────────────
slti x20, x2, 0        # x20 = (-5 < 0) ? 1 : 0 = 1
slti x21, x1, 5        # x21 = (10 < 5) ? 1 : 0 = 0
slti x22, x1, 20       # x22 = (10 < 20) ? 1 : 0 = 1

# ── SLTIU (set less than immediate, unsigned) ────────────────────────────
sltiu x23, x1, 20      # x23 = (10 < 20) ? 1 : 0 = 1 (unsigned)
sltiu x24, x2, 1       # x24 = (0xFFFFFFFB < 1) ? 1 : 0 = 0 (unsigned: -5 is huge)

# ── Drain pipeline ───────────────────────────────────────────────────────
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
