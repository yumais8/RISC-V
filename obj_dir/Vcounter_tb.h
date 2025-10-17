// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VCOUNTER_TB_H_
#define _VCOUNTER_TB_H_  // guard

#include "verilated.h"

//==========

class Vcounter_tb__Syms;

//----------

VL_MODULE(Vcounter_tb) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_OUT8(clk,0,0);
    VL_OUT(count,31,0);
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    CData/*0:0*/ __VinpClk__TOP__clk;
    CData/*0:0*/ __Vclklast__TOP____VinpClk__TOP__clk;
    CData/*0:0*/ __Vchglast__TOP__clk;
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    Vcounter_tb__Syms* __VlSymsp;  // Symbol table
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vcounter_tb);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    Vcounter_tb(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~Vcounter_tb();
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval() { eval_step(); }
    /// Evaluate when calling multiple units/models per time step.
    void eval_step();
    /// Evaluate at end of a timestep for tracing, when using eval_step().
    /// Application must call after all eval() and before time changes.
    void eval_end_step() {}
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(Vcounter_tb__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(Vcounter_tb__Syms* symsp, bool first);
  private:
    static QData _change_request(Vcounter_tb__Syms* __restrict vlSymsp);
    static QData _change_request_1(Vcounter_tb__Syms* __restrict vlSymsp);
  public:
    static void _combo__TOP__2(Vcounter_tb__Syms* __restrict vlSymsp);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(Vcounter_tb__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif  // VL_DEBUG
  public:
    static void _eval_initial(Vcounter_tb__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(Vcounter_tb__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _initial__TOP__1(Vcounter_tb__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _sequent__TOP__3(Vcounter_tb__Syms* __restrict vlSymsp);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
