# Test U-type instruction: AUIPC
# auipc rd, imm → rd = PC + (imm << 12)

# ── AUIPC test 1 ──────────────────────────────────────────────────────────
# auipc x5, 0  → x5 = PC + 0 = 0x00000000 (PC = 0x00)
# auipc x5, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

# ── AUIPC test 2 ──────────────────────────────────────────────────────────
# auipc x6, 1  → x6 = PC + (1 << 12) = 0x14 + 0x1000 = 0x00001014
# PC = 5 instructions × 4 bytes = 0x14
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
auipc x6, 1234
