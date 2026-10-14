# Recursive Fibonacci in RISC-V (RV32I)
# No pseudoinstructions: call -> jal, ret -> jalr
# Computes fib(20) = 6765

    .text
    .global _start

_start:
    addi    a0, x0, 5      # a0 = 20
    jal     ra, fib           # ra = return addr, jump to fib
    # a0 now holds 6765
halt:
    jal     x0, halt        # stop here forever

# --------------------------------------------------
# fib(n)  ->  fib(n-1) + fib(n-2)
# Base cases: fib(0)=0, fib(1)=1
# Argument:   a0 = n
# Returns:    a0 = fib(n)
# --------------------------------------------------
fib:
    # Prologue
    addi    sp, sp, -16
    sw      ra, 12(sp)
    sw      s0, 8(sp)

    # if n <= 1, return n   (ble a0,t0 → bge t0,a0 — ble is a pseudoinstruction)
    addi    t0, x0, 1
    bge     t0, a0, .base

    # fib(n-1)
    addi    s0, a0, 0         # s0 = n
    addi    a0, a0, -1
    jal     ra, fib           # a0 = fib(n-1)
    addi    t1, a0, 0         # t1 = fib(n-1)

    # fib(n-2)
    addi    a0, s0, -2
    jal     ra, fib           # a0 = fib(n-2)

    # sum and fall through to epilogue
    add     a0, a0, t1

    jal     x0, .epilogue  # unconditional jump (no link)

.base:
    # a0 = n already, fall through

.epilogue:
    lw      s0, 8(sp)
    lw      ra, 12(sp)
    addi    sp, sp, 16
    jalr    x0, ra, 0      # return (was: ret)