// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef _VCOUNTER_TB__SYMS_H_
#define _VCOUNTER_TB__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODULE CLASSES
#include "Vcounter_tb.h"

// SYMS CLASS
class Vcounter_tb__Syms : public VerilatedSyms {
  public:
    
    // LOCAL STATE
    const char* __Vm_namep;
    bool __Vm_didInit;
    
    // SUBCELL STATE
    Vcounter_tb*                   TOPp;
    
    // CREATORS
    Vcounter_tb__Syms(Vcounter_tb* topp, const char* namep);
    ~Vcounter_tb__Syms() {}
    
    // METHODS
    inline const char* name() { return __Vm_namep; }
    
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
