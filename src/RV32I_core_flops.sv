// FETCH_S1 STAGE
`FF_D_RST_EN(clk, rst, (control_unit_state == FETCH_S1), raw_bits, raw_bits_s1)
`FF_D_RST_EN(clk, rst, (control_unit_state == FETCH_S1), alu_out, program_counter_plus_4_s1)

// DECODE_S2 STAGE
`FF_D_RST_EN_DATA_TYPE(clk, rst, (control_unit_state == DECODE_S2), rs1_addr, rs1_addr_s2, RV32I_RS1_t)
`FF_D_RST_EN_DATA_TYPE(clk, rst, (control_unit_state == DECODE_S2), rs2_addr, rs2_addr_s2, RV32I_RS2_t)
`FF_D_RST_EN_DATA_TYPE(clk, rst, (control_unit_state == DECODE_S2), rd_addr, rd_addr_s2, RV32I_RD_t)
`FF_D_RST_EN_DATA_TYPE(clk, rst, (control_unit_state == DECODE_S2), opcode, opcode_s2, RV32I_OPCODE_t)
`FF_D_RST_EN_DATA_TYPE(clk, rst, (control_unit_state == DECODE_S2), mnemonic, mnemonic_s2, RV32I_INSTRUCTION_MNEMONIC_t)
`FF_D_RST_EN_DATA_TYPE(clk, rst, (control_unit_state == DECODE_S2), rs1, rs1_s2, RV32I_OPERAND_t)
`FF_D_RST_EN_DATA_TYPE(clk, rst, (control_unit_state == DECODE_S2), rs2, rs2_s2, RV32I_OPERAND_t)
`FF_D_RST_EN_DATA_TYPE(clk, rst, (control_unit_state == DECODE_S2), rd, rd_s2, RV32I_OPERAND_t)
`FF_D_RST_EN_DATA_TYPE(clk, rst, (control_unit_state == DECODE_S2), imm, imm_s2, RV32I_OPERAND_t)

// EXECUTE_S3 STAGE
`FF_D_RST_EN(clk, rst, (control_unit_state == EXECUTE_S3), alu_out, alu_out_s3)

// WRITEBACK_S5 STAGE
`FF_D_RST_EN_RESET_VALUE(clk, rst, (control_unit_state == WRITEBACK_S5), program_counter_new, program_counter_s1, `RV32I_INSTRUCTION_WIDTH'h4000000)

