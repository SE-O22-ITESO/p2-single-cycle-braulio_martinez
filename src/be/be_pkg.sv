// be_pkg.sv
// Back-End (BE) miscelaneous definitions for RISC-V implementation

`include "RV32I_defines.sv"

package be_pkg;

    typedef enum {
        // Arithmetic
        ADD_alu, SUB_alu,

        // Logic
        XOR_alu, OR_alu,
        AND_alu,

        // Shifts
        SLL_alu, SRL_alu, SRA_alu,

        // Compares
        SLT_alu, SLTU_alu,

        NULL_alu
    } RV32I_ALU_OP_t;

endpackage