`include "RV32I_defines.v"
import fe_pkg::*;

module RV32I (
    input wire clk,
    input wire rst,
    input wire [`RV32I_INSTRUCTION_WIDTH-1:0] raw_bits,

    output RV32I_OPCODE_t opcode,
    output RV32I_RS1_t rs1
);

RV32I_decoder decoder(
    .raw_bits(raw_bits),
    .rs1(rs1)
);
    
endmodule : RV32I