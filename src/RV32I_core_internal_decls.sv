RV32I_OPERAND_t                 rs1, rs2, imm, alu_a, alu_b, alu_out;
RV32I_OPERAND_t                 program_counter_new;

RV32I_OPERAND_t                 program_counter_plus_4;

RV32I_OPERAND_t                 rf_write_data;
RV32I_OPCODE_t                  opcode;
RV32I_REGISTER_t                rs1_addr;
RV32I_REGISTER_t                rs2_addr;
RV32I_REGISTER_t                rd_addr;
RV32I_ALU_OP_t                  alu_op;
RV32I_INSTRUCTION_MNEMONIC_t    mnemonic;

wire                            rf_wren, bus_addr_select_alu_out;
logic                           cond_jump;
