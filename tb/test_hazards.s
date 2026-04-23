# Test data/memory hazards to exercise the forwarding unit:
#   (1) EX → EX forwarding (back-to-back RAW on ALU results)
#   (2) MEM → EX forwarding (RAW with one instruction between producer and consumer)
#   (3) Chained RAW (consumer depends on value written in the immediately prior instr)
#   (4) Load-use hazard (lw followed by immediate consumer → must stall 1 cycle, then forward)
#   (5) Load with 1-instr gap (forward only, no stall)
#   (6) Store-data forwarding (sw rs2 comes from the instruction right before it)
#   (7) Store-after-load (sw immediately after lw uses loaded value as store data)
#
# Data memory layout (from tb/test0.s):
#   mem[0] @ 0x00 = 0xDEADBEEF
#   mem[1] @ 0x04 = 0x7F008001
#
# Expected final register state (all values in hex, 32-bit):
#   x1  = 0x00000000    x2  = 0x00000004
#   x5  = 0x0000000A    x6  = 0x0000000F
#   x7  = 0x00000014    x8  = 0x00000015
#   x9  = 0x00000002    x10 = 0x00000005
#   x11 = 0xDEADBEEF    x12 = 0xDEADBEEF
#   x13 = 0x7F008001    x14 = 0x7F008001
#   x15 = 0x00000055    x16 = 0x00000055
#   x17 = 0x7F008001    x18 = 0x7F008001
#   mem[2] @ 0x08 = 0x00000055
#   mem[3] @ 0x0C = 0x7F008001

# ── Setup ────────────────────────────────────────────────────────────────
addi x1, x0, 0         # x1 = 0x00000000   (base for mem[0])
addi x2, x0, 4         # x2 = 0x00000004   (base for mem[1])
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# ── (1) EX → EX forwarding: producer in EX/MEM feeds consumer in EX ──────
addi x5, x0, 10        # x5 = 0x0000000A
addi x6, x5, 5         # RAW on x5 (back-to-back)          → x6 = 0x0000000F

# ── (2) MEM → EX forwarding: producer now in MEM/WB, consumer in EX ──────
addi x7, x0, 20        # x7 = 0x00000014
addi x0, x0, 0         # gap
addi x8, x7, 1         # RAW on x7 with 1-instr gap        → x8 = 0x00000015

# ── (3) Chained RAW: every instruction depends on the previous one ───────
addi x9,  x0, 1        # x9  = 0x00000001
addi x9,  x9, 1        # forward from prev, same-reg OW    → x9  = 0x00000002
addi x10, x9, 3        # forward from prev                 → x10 = 0x00000005

# ── (4) Load-use hazard: lw immediately followed by consumer (must stall) ─
lw   x11, 0(x1)        # x11 = 0xDEADBEEF  (load from mem[0])
addi x12, x11, 0       # stall 1, then forward             → x12 = 0xDEADBEEF

# ── (5) Load with 1-instr gap: MEM → EX forward, no stall needed ─────────
lw   x13, 0(x2)        # x13 = 0x7F008001  (load from mem[1])
addi x0, x0, 0         # gap
addi x14, x13, 0       # forwarded from WB                 → x14 = 0x7F008001

# ── (6) Store-data forwarding: sw rs2 produced by the prior instruction ──
addi x15, x0, 85       # x15 = 0x00000055
sw   x15, 8(x0)        # store x15 to mem[2]               → mem[2] = 0x00000055
addi x0, x0, 0
lw   x16, 8(x0)        # verifies the store landed         → x16 = 0x00000055

# ── (7) Store-after-load: sw immediately after lw using loaded value ─────
lw   x17, 4(x0)        # x17 = 0x7F008001  (load from mem[1])
sw   x17, 12(x0)       # store loaded value to mem[3]      → mem[3] = 0x7F008001
addi x0, x0, 0
lw   x18, 12(x0)       # verifies the store landed         → x18 = 0x7F008001

# ── Drain pipeline ───────────────────────────────────────────────────────
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
