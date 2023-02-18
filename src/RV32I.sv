`include "RV32I_defines.sv"
import fe_pkg::*;

module RV32I (
    input wire clk,
    input wire rst,
    input RV32I_OPERAND_t instruction,

    output RV32I_OPCODE_t opcode,
    output RV32I_OPERAND_t rs1, program_counter
);

RV32I_core core(
    .clk(clk),
    .rst(rst),
    .raw_bits(instruction),

    .program_counter(program_counter),
    .opcode_out_debug(opcode),
    .rs1_out_debug(rs1)
);
    
endmodule : RV32I