#include "verilated_vcd_c.h"
#include "Vtb_top.h"
// Simulation unit is in the time precision of the Verilog file.
int main(int argc, char** argv) {
    long sim_time = 45000;

    VerilatedContext* contextp = new VerilatedContext;
    Verilated::traceEverOn(true);
    contextp->commandArgs(argc, argv);
    Vtb_top* top = new Vtb_top{contextp};


    while (contextp->time() < sim_time && !contextp->gotFinish()) {
        contextp->timeInc(1);    // Time increment unit equals to the time precision in the Verilog file.
        top->eval();
        // tfp->dump(contextp->time());
    }
    // tfp->close();
    delete top;
    delete contextp;
    return 0;
}