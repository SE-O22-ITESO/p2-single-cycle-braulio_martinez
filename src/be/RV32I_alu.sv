// RV32I_alu
// Takes parametrized inputs
// A/B muxing must be done in previous stages
`include "RV32I_defines.sv"
import fe_pkg::*;

module RV32I_alu (
    input RV32I_OPERAND_t a, b,
    input RV32I_ALU_OP_t alu_op,

    output RV32I_OPERAND_t out
);
    
endmodule : RV32I_alu