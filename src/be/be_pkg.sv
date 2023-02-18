// be_pkg.sv
// Back-End (BE) miscelaneous definitions for RISC-V implementation

`include "RV32I_defines.sv"

package be_pkg;

    typedef enum {
        // Arithmetic
        ADD_alu, SUB_alu,

        NULL_alu
    } RV32I_ALU_OP_t;

endpackage