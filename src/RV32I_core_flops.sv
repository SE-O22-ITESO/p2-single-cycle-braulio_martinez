// FETCH_S1 STAGE
`FF_D_RST_EN(clk, rst, (control_unit_state == FETCH_S1), bus_rddata, raw_bits_s1)
`FF_D_RST_EN(clk, rst, (control_unit_state == FETCH_S1), alu_out, program_counter_plus_4_s1)


// DECODE_S2 STAGE
`FF_D_RST(clk, rst, rd_addr, rd_addr_s2)
`FF_D_RST(clk, rst, opcode, opcode_s2)
`FF_D_RST(clk, rst, mnemonic, mnemonic_s2)

`FF_D_RST(clk, rst, rs1, rs1_s2)
`FF_D_RST(clk, rst, rs2, rs2_s2)
`FF_D_RST(clk, rst, rd, rd_s2)
`FF_D_RST(clk, rst, imm, imm_s2)

`FF_D_RST(clk, rst, alu_out, program_counter_plus_imm_s2)

// EXECUTE_S3 STAGE
`FF_D_RST_EN(clk, rst, (control_unit_state == EXECUTE_S3), alu_out, alu_out_s3)

// MEM_S4 STAGE
`FF_D_RST_EN(clk, rst, (control_unit_state == MEM_S4), bus_rddata, bus_rddata_s4)

// WRITEBACK_S5 STAGE
`FF_D_RST_EN_RESET_VALUE(clk, rst, program_counter_wren, program_counter_new, program_counter_s1, `RV32I_INSTRUCTION_WIDTH'h4000000)
