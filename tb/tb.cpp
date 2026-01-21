#include "verilated_vcd_c.h"
#include "Vtb.h"

int main(int argc, char** argv) {
    VerilatedContext* contextp = new VerilatedContext;
    Verilated::traceEverOn(true);
    contextp->commandArgs(argc, argv);
    Vtb* top = new Vtb{contextp};

    while (contextp->time() < 1000000 && !contextp->gotFinish()) {
        contextp->timeInc(1);
        top->eval();
    }

    delete top;
    delete contextp;
    return 0;
}