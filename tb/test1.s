# Test S-type instructions: sb, sh, sw
# Stores to mem[2]–mem[4] (addr 0x08–0x10), which start as zero in data.txt

# ── Setup base address and values to store ─────────────────────────────────
addi x1, x0, 0          # x1 = 0x00 (base address)
addi x10, x0, -1        # x10 = -1 (0xFFFFFFFF)
addi x11, x0, 90        # x11 = 90 (0x5A)
addi x12, x0, 939       # x12 = 939 (0x3AB)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# ── SW: store word ──────────────────────────────────────────────────────────
# sw x10, 8(x1)  → stores 0xFFFFFFFF to addr 0x08 (mem[2])
sw x10, 8(x1)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# ── SH: store halfword ─────────────────────────────────────────────────────
# sh x11, 12(x1)  → stores 0x005A to lower half of addr 0x0C (mem[3])
sh x11, 12(x1)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# sh x10, 14(x1)  → stores 0xFFFF to upper half of addr 0x0C (mem[3])
sh x10, 14(x1)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# ── SB: store byte ─────────────────────────────────────────────────────────
# sb x12, 16(x1)  → stores 0xAB to byte 0 of addr 0x10 (mem[4])
sb x12, 16(x1)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# sb x11, 17(x1)  → stores 0x5A to byte 1 of addr 0x10 (mem[4])
sb x11, 17(x1)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
