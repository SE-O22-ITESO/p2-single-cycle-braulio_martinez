RV32I_OPERAND_t                 rs1, rs2, rd, imm, alu_a, alu_b, alu_out;
RV32I_OPERAND_t                 rs1_s2, rs2_s2, imm_s2;
RV32I_OPERAND_t                 raw_bits_s1, alu_out_s3;
RV32I_OPERAND_t                 program_counter_s1, program_counter_new, program_counter_plus_4_s1, program_counter_plus_imm_s2;
RV32I_OPERAND_t                 rf_write_data;
RV32I_OPERAND_t                 bus_rddata_s4;
RV32I_OPCODE_t                  opcode, opcode_s2;
RV32I_RS1_t                     rs1_addr, rs1_addr_s2;
RV32I_RS2_t                     rs2_addr, rs2_addr_s2;
RV32I_RD_t                      rd_addr, rd_addr_s2;
RV32I_ALU_OP_t                  alu_op, alu_op_s2;
RV32I_CONTROL_UNIT_FSM_t        control_unit_state;
RV32I_INSTRUCTION_MNEMONIC_t    mnemonic, mnemonic_s2;

wire                            rf_wren, opcode_changes_program_counter, bus_addr_select_alu_out;
wire                            program_counter_wren;
logic                           cond_jump;
