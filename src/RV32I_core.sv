`include "RV32I_defines.sv"
import fe_pkg::*;
import be_pkg::*;

module RV32I_core (
    input wire clk,
    input wire rst,
    input RV32I_OPERAND_t raw_bits,

    output RV32I_OPCODE_t opcode_out_debug,
    output RV32I_OPERAND_t rs1_out_debug,
    output RV32I_OPERAND_t program_counter
);

RV32I_OPERAND_t     rs1, rs2, rd, raw_bits_fetched, imm, alu_a, alu_b, alu_out;
RV32I_OPCODE_t      opcode;
RV32I_RS1_t         rs1_addr;
RV32I_RS2_t         rs2_addr;
RV32I_RD_t          rd_addr;
RV32I_ALU_OP_t      alu_op;
RV32I_CONTROL_UNIT_FSM_t control_unit_state;
RV32I_INSTRUCTION_MNEMONIC_t mnemonic;

// Fetch raw_bits
`FF_D_RST_EN(clk, rst, (control_unit_state == FETCH_S1), raw_bits, raw_bits_fetched)
// Program counter
`FF_D_RST_EN(clk, rst, (control_unit_state == INCREASE_PC_S5), alu_out, program_counter)

assign opcode_out_debug = RV32I_OPCODE_t'(rs1 ^ 7'b1100110);
assign rs1_out_debug = rs1;

RV32I_decoder decoder (
    .raw_bits   (raw_bits_fetched),
    .rs1_addr   (rs1_addr),
    .rs2_addr   (rs2_addr),
    .rd_addr    (rd_addr),
    .imm        (imm),
    .opcode     (opcode),
    .mnemonic   (mnemonic)
);

control_unit  control_unit  (
    .clk        (clk),
    .rst        (rst),
    .rs1        (rs1),
    .rs2        (rs2),
    .rd         (rd),
    .imm        (imm),
    .opcode     (opcode),
    .mnemonic   (mnemonic),
    .alu_out    (alu_out),
    .program_counter (program_counter),

    .alu_op     (alu_op),
    .alu_a      (alu_a),
    .alu_b      (alu_b),
    .control_unit_state (control_unit_state)
);

RV32I_alu alu (
    .a      (alu_a),
    .b      (alu_b),
    .alu_op (alu_op),
    .out    (alu_out)
);

RV32I_register_file #  (
    .NUM_OF_SETS    (`RV32I_NUM_OF_REGS),
    .DATA_BUS_WIDTH (`RV32I_INSTRUCTION_WIDTH)
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