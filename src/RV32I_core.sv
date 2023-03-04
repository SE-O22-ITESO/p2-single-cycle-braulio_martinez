`include "RV32I_defines.sv"
import fe_pkg::*;
import be_pkg::*;

module RV32I_core (
    input wire clk,
    input wire rst,
    input RV32I_OPERAND_t bus_rddata,

    output RV32I_OPERAND_t bus_addr, bus_wrdata,
    output wire bus_wren, bus_rden,
    output RV32I_OPCODE_t opcode_out_debug,
    output RV32I_OPERAND_t rs1_out_debug
);

`include "RV32I_core_internal_decls.sv"
`include "RV32I_core_flops.sv"

//DEBUG logic so Quartus does not skip synthesis
assign opcode_out_debug = RV32I_OPCODE_t'(rs1 ^ 7'b1100110);
assign rs1_out_debug = rs1_s2;

// bus_addr selection
`MUX_2_TO_1(alu_out_s3, program_counter_s1, bus_addr_select_alu_out, bus_addr)
// bus_wrdata selection
always_comb
    case (mnemonic_s2)
        SB  : bus_wrdata <= { {24{rs2_s2[7]}}, rs2_s2[7:0]};
        SH  : bus_wrdata <= { {16{rs2_s2[15]}}, rs2_s2[15:0]};
        SW  : bus_wrdata <= rs2_s2;
        default : bus_wrdata <= '0;
    endcase

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

    .opcode_changes_program_counter (opcode_changes_program_counter),
    .bus_addr_select_alu_out        (bus_addr_select_alu_out),
    .bus_wren   (bus_wren),
    .bus_rden   (bus_rden),
    .rf_wren    (rf_wren),
    .program_counter_wren (program_counter_wren),
    .control_unit_state (control_unit_state)
);

alu_inputs_mux alu_inputs_mux (
    .rs1        (rs1_s2),
    .rs2        (rs2_s2),
    .rd         (rd_s2),
    .imm        (imm),
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

    .cond_jump  (cond_jump),
    .out        (alu_out)
);

program_counter_inputs_mux program_counter_inputs_mux (
    .program_counter_plus_4     (program_counter_plus_4_s1),
    .program_counter_plus_imm   (program_counter_plus_imm_s2),
    .alu_out                    (alu_out_s3),
    .opcode                     (opcode_s2),
    .cond_jump                  (cond_jump),

    .program_counter_new        (program_counter_new)
);

rf_inputs_mux rf_inputs_mux (
    .alu_out    (alu_out_s3),
    .program_counter_plus_4 (program_counter_plus_4_s1),
    .opcode     (opcode_s2),
    .mnemonic   (mnemonic_s2),
    .bus_rddata (bus_rddata_s4),

    .rf_write_data  (rf_write_data)
);

RV32I_register_file #  (
    .NUM_OF_SETS    (`RV32I_NUM_OF_REGS),
    .DATA_BUS_WIDTH (`RV32I_INSTRUCTION_WIDTH)
) register_file (
    .clk        (clk),
    .rst        (rst),
    .wr_enable  (rf_wren),
    .wr_addr    (rd_addr_s2),
    .wr_data    (rf_write_data),
    .rd_addr_1  (rs1_addr),
    .rd_addr_2  (rs2_addr),
    .rd_addr_3  (rd_addr),
    .rd_data_1  (rs1),
    .rd_data_2  (rs2),
    .rd_data_3  (rd)
);

endmodule : RV32I_core