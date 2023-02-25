`include "RV32I_defines.sv"
import fe_pkg::*;
import be_pkg::*;

module RV32I_core (
    input wire clk,
    input wire rst,
    input RV32I_OPERAND_t raw_bits,

    output RV32I_OPCODE_t opcode_out_debug,
    output RV32I_OPERAND_t rs1_out_debug,
    output RV32I_OPERAND_t program_counter_s1
);

RV32I_OPERAND_t     rs1, rs2, rd, imm, alu_a, alu_b, alu_out;
RV32I_OPERAND_t     raw_bits_fetched_s1, alu_out_exec_s3;
RV32I_OPERAND_t     program_counter_new, program_counter_plus_4_s1;
RV32I_OPCODE_t      opcode;
RV32I_RS1_t         rs1_addr;
RV32I_RS2_t         rs2_addr;
RV32I_RD_t          rd_addr;
RV32I_ALU_OP_t      alu_op;
RV32I_CONTROL_UNIT_FSM_t control_unit_state;
RV32I_INSTRUCTION_MNEMONIC_t mnemonic;

wire rf_wren;
RV32I_OPERAND_t     rf_write_data;

// Fetch raw_bits
`FF_D_RST_EN(clk, rst, (control_unit_state == FETCH_S1), raw_bits, raw_bits_fetched_s1)
// Flop ALU results
`FF_D_RST_EN(clk, rst, (control_unit_state == EXECUTE_S3), alu_out, alu_out_exec_s3)
// Write new program counter
`FF_D_RST_EN_RESET_VALUE(clk, rst, (control_unit_state == WRITEBACK_S4), program_counter_new, program_counter_s1, `RV32I_INSTRUCTION_WIDTH'h4000000)

assign opcode_out_debug = RV32I_OPCODE_t'(rs1 ^ 7'b1100110);
assign rs1_out_debug = rs1;

RV32I_decoder decoder (
    .raw_bits   (raw_bits_fetched_s1),
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
    .program_counter_s1 (program_counter_s1),
    .program_counter_new (program_counter_new),
    .program_counter_plus_4_s1 (program_counter_plus_4_s1),
    .alu_out_exec_s3        (alu_out_exec_s3),

    .rf_write_data (rf_write_data),
    .rf_wren    (rf_wren),
    .alu_a      (alu_a),
    .alu_b      (alu_b),
    .control_unit_state (control_unit_state)
);

RV32I_alu alu (
    .a          (alu_a),
    .b          (alu_b),
    .rs1        (rs1),
    .rs2        (rs2),
    .imm        (imm),
    .mnemonic   ((control_unit_state == EXECUTE_S3) ? mnemonic : ADD),
    .program_counter_plus_4_s1 (program_counter_plus_4_s1),
    .out        (alu_out)
);

RV32I_register_file #  (
    .NUM_OF_SETS    (`RV32I_NUM_OF_REGS),
    .DATA_BUS_WIDTH (`RV32I_INSTRUCTION_WIDTH)
) register_file (
    .clk        (clk),
    .rst        (rst),
    .wr_enable  (rf_wren),
    .wr_addr    (rd_addr),
    .wr_data    (rf_write_data),
    .rd_addr_1  (rs1_addr),
    .rd_addr_2  (rs2_addr),
    .rd_addr_3  (rd_addr),
    .rd_data_1  (rs1),
    .rd_data_2  (rs2),
    .rd_data_3  (rd)
);

endmodule : RV32I_core