// RV32I_alu
// Takes parametrized inputs
// A/B muxing must be done in previous stages
`include "RV32I_defines.sv"
import be_pkg::*;

module RV32I_alu (
    input RV32I_OPERAND_t a, b,
    input RV32I_ALU_OP_t alu_op,

    output RV32I_OPERAND_t out
);

wire adder_substracter_mode =   alu_op == ADD_alu ?
                                '0 : '1;

adder_substracter_bmod # (
    .NUMBER_OF_BITS(`RV32I_INSTRUCTION_WIDTH)
) adder_substracter (
    .a(a),
    .b(b),
    .mode(adder_substracter_mode),
    .result(out)
);
    
endmodule : RV32I_alu