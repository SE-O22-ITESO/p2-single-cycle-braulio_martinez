// FETCH_S1 STAGE
/* `FF_D_RST_EN(clk, rst, (control_unit_state == FETCH_S1), bus_rddata, raw_bits_s1)
`FF_D_RST_EN(clk, rst, (control_unit_state == FETCH_S1), alu_out, program_counter_plus_4_s1) */


// DECODE_S2 STAGE
/* `FF_D_RST_DATA_TYPE(clk, rst, rd_addr, rd_addr_s2, RV32I_REGISTER_t)
`FF_D_RST_DATA_TYPE(clk, rst, opcode, opcode_s2, RV32I_OPCODE_t)
`FF_D_RST_DATA_TYPE(clk, rst, mnemonic, mnemonic_s2, RV32I_INSTRUCTION_MNEMONIC_t) */

/* `FF_D_RST_EN(clk, rst, (control_unit_state == DECODE_S2), rs1, rs1_s2)
`FF_D_RST_EN(clk, rst, (control_unit_state == DECODE_S2), rs2, rs2_s2)
`FF_D_RST_EN(clk, rst, (control_unit_state == DECODE_S2), imm, imm_s2) */

/* `FF_D_RST_EN(clk, rst, (control_unit_state == DECODE_S2), alu_out, program_counter_plus_imm_s2) */

// EXECUTE_S3 STAGE
/* `FF_D_RST_EN(clk, rst, (control_unit_state == EXECUTE_S3), alu_out, alu_out_s3) */

// MEM_S4 STAGE
/* `FF_D_RST_EN(clk, rst, (control_unit_state == MEM_S4), bus_rddata, bus_rddata_s4) */

// WRITEBACK_S5 STAGE
/* `FF_D_RST_EN_RESET_VALUE(clk, rst, program_counter_wren, program_counter_new, program_counter_s1, `RV32I_INSTRUCTION_WIDTH'h400000) */

// Raw bits Single Cycle
`FF_D_RST_DATA_TYPE(clk, rst, rom_rddata, raw_bits, RV32I_OPERAND_t)
// PC Single Cycle
`FF_D_RST_RESET_VALUE(clk, rst, program_counter_new, program_counter, `RV32I_INSTRUCTION_WIDTH'h400000)