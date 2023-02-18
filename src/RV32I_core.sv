`include "RV32I_defines.sv"
import fe_pkg::*;

module RV32I_core (
    input wire clk,
    input wire rst,
    input RV32I_OPERAND_t instruction,

    output RV32I_OPCODE_t opcode_out_debug,
    output RV32I_OPERAND_t rs1_out_debug
);

assign opcode_out_debug = opcode;
assign rs1_out_debug = rs1;

RV32I_RS1_t rs1_addr;
RV32I_RS2_t rs2_addr;
RV32I_RD_t  rd_addr;
RV32I_IMM_t imm;
RV32I_OPCODE_t opcode;
RV32I_INSTRUCTION_MNEMONIC_t mnemonic;
RV32I_OPERAND_t  rs1, rs2, rd;

`FF_D_RST_EN(clk, rst, '1, instruction, raw_bits)

RV32I_decoder decoder (
    .raw_bits   (raw_bits),
    .rs1_addr   (rs1_addr),
    .rs2_addr   (rs2_addr),
    .rd_addr    (rd_addr),
    .imm        (imm),
    .opcode     (opcode),
    .mnemonic   (mnemonic)
);

control_unit  control_unit  (
    .clk    (clk),
    .rst    (rst),
    .rs1    (rs1),
    .rs2    (rs2),
    .rd     (rd),
    .imm    (imm),
    .opcode (opcode),
    .mnemonic (mnemonic)
);

RV32I_register_file #  (
    .NUM_OF_SETS(`RV32I_NUM_OF_REGS),
    .DATA_BUS_WIDTH(`RV32I_INSTRUCTION_WIDTH)
) register_file (
    .clk        (clk),
    .wr_enable  ('0),
    .wr_addr    (rd_addr),
    .wr_data    ('0),
    .rd_addr_1  (rs1_addr),
    .rd_addr_2  (rs2_addr),
    .rd_addr_3  (rd_addr),
    .rd_data_1  (rs1),
    .rd_data_2  (rs2),
    .rd_data_3  (rd)
);


endmodule : RV32I_core