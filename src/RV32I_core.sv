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

`include "RV32I_core_internal_decls.sv"
`include "RV32I_core_flops.sv"

//DEBUG logic so Quartus does not skip synthesis
assign opcode_out_debug = RV32I_OPCODE_t'(rs1 ^ 7'b1100110);
assign rs1_out_debug = rs1;

// Combo assignments
assign opcode_changes_program_counter = (opcode_s2 == B_TYPE) || (opcode_s2 == J_TYPE) || (opcode_s2 == I_JALR_TYPE) || (opcode_s2 == I_ENV_TYPE);

// Program counter selection logic
`MUX_2_TO_1(alu_out_s3, program_counter_plus_4_s1, opcode_changes_program_counter, program_counter_new)

RV32I_decoder decoder (
    .raw_bits   (raw_bits_s1),

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
    .opcode     (opcode_s2),
    .mnemonic   (mnemonic_s2),

    .rf_wren    (rf_wren),
    .control_unit_state (control_unit_state)
);

alu_inputs_mux alu_inputs_mux (
    .rs1        (rs1_s2),
    .rs2        (rs2_s2),
    .rd         (rd_s2),
    .imm        (imm_s2),
    .opcode     (opcode_s2),
    .program_counter    (program_counter_s1),
    .control_unit_state (control_unit_state),

    .alu_a      (alu_a),
    .alu_b      (alu_b)
);

RV32I_alu alu (
    .a          (alu_a),
    .b          (alu_b),
    .rs1        (rs1_s2),
    .rs2        (rs2_s2),
    .imm        (imm_s2),
    // Force ALU to ADD during other stages for PC+1
    .mnemonic   ((control_unit_state == EXECUTE_S3) ? mnemonic_s2 : ADD),
    .program_counter_plus_4_s1 (program_counter_plus_4_s1),
    .out        (alu_out)
);

rf_inputs_mux rf_inputs_mux (
    .alu_out    (alu_out_s3),
    .program_counter_plus_4 (program_counter_plus_4_s1),
    .opcode     (opcode_s2),

    .rf_write_data  (rf_write_data)
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
    .rd_addr_1  (rs1_addr_s2),
    .rd_addr_2  (rs2_addr_s2),
    .rd_addr_3  (rd_addr_s2),
    .rd_data_1  (rs1),
    .rd_data_2  (rs2),
    .rd_data_3  (rd)
);

endmodule : RV32I_core