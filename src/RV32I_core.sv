`include "RV32I_defines.sv"
import fe_pkg::*;
import be_pkg::*;

module RV32I_core (
    input wire clk,
    input wire rst,
    input RV32I_OPERAND_t bus_rddata,

    output RV32I_OPERAND_t bus_addr, bus_wrdata,
    output wire bus_wren, bus_rden
);

`include "RV32I_core_internal_decls.sv"
`include "RV32I_core_flops.sv"

// bus_addr selection
`MUX_2_TO_1(alu_out, program_counter, bus_addr_select_alu_out, bus_addr)
// bus_wrdata selection
always_comb
    case (mnemonic)
        SB  : bus_wrdata <= { {24{rs2[7]}}, rs2[7:0]};
        SH  : bus_wrdata <= { {16{rs2[15]}}, rs2[15:0]};
        SW  : bus_wrdata <= rs2;
        default : bus_wrdata <= '0;
    endcase

// Program counter adder
assign program_counter_plus_4 = program_counter + 'h4;

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
    .clk        (clk),
    .rst        (rst),
    .opcode     (opcode),
    .mnemonic   (mnemonic),

    .bus_addr_select_alu_out        (bus_addr_select_alu_out),
    .bus_wren   (bus_wren),
    .bus_rden   (bus_rden),
    .rf_wren    (rf_wren),
    .program_counter_wren (program_counter_wren),
    .control_unit_state (control_unit_state)
);

alu_inputs_mux alu_inputs_mux (
    .rs1        (rs1),
    .rs2        (rs2),
    .imm        (imm),
    .opcode     (opcode),
    .program_counter    (program_counter),
    .control_unit_state (control_unit_state),

    .alu_a      (alu_a),
    .alu_b      (alu_b)
);

RV32I_alu alu (
    .a          (alu_a),
    .b          (alu_b),
    .rs1        (rs1),
    .rs2        (rs2),
    .imm        (imm),
    // Force ALU to ADD during other stages for PC+1
    .mnemonic   (mnemonic),

    .cond_jump  (cond_jump),
    .out        (alu_out)
);

program_counter_inputs_mux program_counter_inputs_mux (
    .program_counter_plus_4     (program_counter_plus_4),
    .program_counter_plus_imm   (program_counter_plus_imm_s2),
    .alu_out                    (alu_out),
    .opcode                     (opcode),
    .cond_jump                  (cond_jump),

    .program_counter_new        (program_counter_new)
);

rf_inputs_mux rf_inputs_mux (
    .alu_out    (alu_out),
    .program_counter_plus_4 (program_counter_plus_4),
    .program_counter_plus_imm (program_counter_plus_imm_s2),
    .opcode     (opcode),
    .mnemonic   (mnemonic),
    .bus_rddata (bus_rddata),

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
    .rd_addr_1  (rs1_addr),
    .rd_addr_2  (rs2_addr),
    .rd_addr_3  (rd_addr),
    .rd_data_1  (rs1),
    .rd_data_2  (rs2)
);

endmodule : RV32I_core