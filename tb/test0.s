# Setup: x1=5, x2=5, x3=10, x4=-1 (0xFFFFFFFF)
addi x1, x0, 5
addi x2, x0, 5
addi x3, x0, 10
addi x4, x0, -1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# beq: x1==x2 → taken
# beq x1, x2, pass_beq
# addi x9, x9, 1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# pass_beq:

# bne: x1!=x3 → taken
# bne x1, x3, pass_bne
# addi x9, x9, 1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# pass_bne:

blt x4, x1, pass_blt
addi x9, x9, 1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
pass_blt:

# bge: x1 >= x2 (signed) → taken
# bge x1, x2, pass_bge
# addi x9, x9, 1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# pass_bge:

# bltu: x1 < x3 (unsigned) → taken
# bltu x1, x3, pass_bltu
# addi x9, x9, 1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
# pass_bltu:

# bgeu: x4 >= x3 (unsigned, 0xFFFFFFFF >= 10) → taken
# bgeu x4, x3, pass_bgeu
# addi x9, x9, 1
# addi x0, x0, 0
# addi x0, x0, 0
# pass_bgeu:
