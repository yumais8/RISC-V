// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcounter_tb.h for the primary calling header

#include "Vcounter_tb.h"
#include "Vcounter_tb__Syms.h"

//==========

VL_CTOR_IMP(Vcounter_tb) {
    Vcounter_tb__Syms* __restrict vlSymsp = __VlSymsp = new Vcounter_tb__Syms(this, name());
    Vcounter_tb* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vcounter_tb::__Vconfigure(Vcounter_tb__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-9);
    Verilated::timeprecision(-9);
}

Vcounter_tb::~Vcounter_tb() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = NULL);
}

void Vcounter_tb::_initial__TOP__1(Vcounter_tb__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcounter_tb::_initial__TOP__1\n"); );
    Vcounter_tb* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    VL_FINISH_MT("counter_tb.v", 16, "");
    vlTOPp->clk = 0U;
    vlTOPp->count = 0U;
}

void Vcounter_tb::_eval_initial(Vcounter_tb__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcounter_tb::_eval_initial\n"); );
    Vcounter_tb* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_initial__TOP__1(vlSymsp);
    vlTOPp->__Vclklast__TOP____VinpClk__TOP__clk = vlTOPp->__VinpClk__TOP__clk;
}

void Vcounter_tb::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcounter_tb::final\n"); );
    // Variables
    Vcounter_tb__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vcounter_tb* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vcounter_tb::_eval_settle(Vcounter_tb__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcounter_tb::_eval_settle\n"); );
    Vcounter_tb* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__2(vlSymsp);
}

void Vcounter_tb::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcounter_tb::_ctor_var_reset\n"); );
    // Body
    clk = VL_RAND_RESET_I(1);
    count = VL_RAND_RESET_I(32);
    __VinpClk__TOP__clk = VL_RAND_RESET_I(1);
    __Vchglast__TOP__clk = VL_RAND_RESET_I(1);
}
