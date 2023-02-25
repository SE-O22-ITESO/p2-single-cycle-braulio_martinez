`include "RV32I_defines.sv"
import fe_pkg::*;
import be_pkg::*;

module control_unit (
    input wire clk,
    input wire rst,

    input RV32I_OPERAND_t rs1, rs2, rd,
    input RV32I_IMM_t  imm,
    input RV32I_OPCODE_t opcode,
    input RV32I_INSTRUCTION_MNEMONIC_t mnemonic,
    input RV32I_OPERAND_t alu_out, program_counter_s1,
    input RV32I_OPERAND_t alu_out_exec_s3,

    output logic rf_wren,
    output RV32I_OPERAND_t alu_a, alu_b, program_counter_new, program_counter_plus_4_s1,
    output RV32I_OPERAND_t rf_write_data,
    output RV32I_CONTROL_UNIT_FSM_t control_unit_state, control_unit_state_next
);

// FSM
`FF_D_RST_EN_DATA_TYPE(clk, rst, ~rst, control_unit_state_next, control_unit_state, RV32I_CONTROL_UNIT_FSM_t)
// Save PC+1
`FF_D_RST_EN(clk, rst, (control_unit_state == FETCH_S1), alu_out, program_counter_plus_4_s1)
// Save COND operation result (rs1 - rs2)

// Program counter selection logic
always_comb
    case (opcode)
        // OPCodes that DO change the PC
        B_TYPE, J_TYPE, I_JALR_TYPE, I_ENV_TYPE:
            program_counter_new <= alu_out_exec_s3;
        
        default:
            program_counter_new <= program_counter_plus_4_s1;
    endcase


// ALU operands for EXEC stage only
// ALU is used during FETCH to increase PC
RV32I_OPERAND_t alu_exec_a, alu_exec_b;

assign alu_a    =   control_unit_state == EXECUTE_S3 ?
                    alu_exec_a  : 
                    control_unit_state == FETCH_S1 ?
                    program_counter_s1 : '0;
assign alu_b    =   control_unit_state == EXECUTE_S3 ?
                    alu_exec_b  : 
                    control_unit_state == FETCH_S1 ?
                    `RV32I_PC_STEP  : '0;


// FSM logic
always_comb
    if (rst)
        control_unit_state_next <= FETCH_S1;
    else begin
        case (control_unit_state)
            FETCH_S1:       control_unit_state_next <= DECODE_S2;
            DECODE_S2:      control_unit_state_next <= EXECUTE_S3;
            EXECUTE_S3:     control_unit_state_next <= WRITEBACK_S4;
            WRITEBACK_S4:   control_unit_state_next <= FETCH_S1;

            default: control_unit_state_next <= FETCH_S1;
        endcase
    end

// Mux A/B inputs to ALU depending on OPCODE
always_comb
    case (opcode)

        R_TYPE: begin
            alu_exec_a <= rs1;
            alu_exec_b <= rs2;
        end

        I_TYPE, I_LOAD_TYPE, I_JALR_TYPE, S_TYPE: begin
            alu_exec_a <= rs1;
            alu_exec_b <= imm;
        end

        J_TYPE, B_TYPE: begin
            alu_exec_a <= program_counter_s1;
            alu_exec_b <= imm;
        end

        U_LUI_TYPE: begin
            alu_exec_a <= imm;
            alu_exec_b <= 'd12;
        end

        U_AUI_TYPE: begin
            alu_exec_a <= imm;
            alu_exec_b <= program_counter_s1;
        end

        default: begin
            alu_exec_a <= '0;
            alu_exec_b <= '0;
        end
    endcase

// RD Write enable and data
always_comb
    case (control_unit_state)

        WRITEBACK_S4:
            case (opcode)
                R_TYPE, I_TYPE, I_LOAD_TYPE, U_AUI_TYPE, U_LUI_TYPE: begin
                    rf_wren         <= '1;
                    rf_write_data   <= alu_out_exec_s3;
                end

                I_JALR_TYPE, J_TYPE: begin
                    rf_wren         <= '1;
                    rf_write_data   <= program_counter_plus_4_s1;
                end

                default: begin
                    rf_wren         <= '0;
                    rf_write_data   <= '0;
                end
            endcase

        default: begin
            rf_wren         <= '0;
            rf_write_data   <= '0;
        end

    endcase

endmodule : control_unit