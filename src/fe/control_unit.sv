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
    input RV32I_OPERAND_t alu_out, program_counter,

    output RV32I_ALU_OP_t alu_op,
    output RV32I_OPERAND_t alu_a, alu_b,
    output RV32I_CONTROL_UNIT_FSM_t control_unit_state, control_unit_state_next
);

// FSM
`FF_D_RST_EN_DATA_TYPE(clk, rst, ~rst, control_unit_state_next, control_unit_state, RV32I_CONTROL_UNIT_FSM_t)



// data for EXEC stage only
RV32I_ALU_OP_t  alu_op_exec;
RV32I_OPERAND_t alu_exec_a, alu_exec_b;

// Select final alu_op depending on current stage:
assign alu_op   =   control_unit_state == EXECUTE_S3 ?
                    alu_op_exec : ADD_alu;
assign alu_a    =   control_unit_state == EXECUTE_S3 ?
                    alu_exec_a  : program_counter;
assign alu_b    =   control_unit_state == EXECUTE_S3 ?
                    alu_exec_b  : '1;

always_comb begin
    if (rst)
        control_unit_state_next <= FETCH_S1;
    else begin
        case (control_unit_state)
            FETCH_S1:       control_unit_state_next <= DECODE_S2;
            DECODE_S2:      control_unit_state_next <= EXECUTE_S3;
            EXECUTE_S3:     control_unit_state_next <= WRITEBACK_S4;
            WRITEBACK_S4:   control_unit_state_next <= INCREASE_PC_S5;
            INCREASE_PC_S5: control_unit_state_next <= FETCH_S1;

            default: control_unit_state_next <= FETCH_S1;
        endcase
    end
end

// Set alu_op_exec based on mnemonic
always_comb
    case (mnemonic)
        ADD, ADDI:
            alu_op_exec <= ADD_alu;

        default:
            alu_op_exec <= NULL_alu;
    endcase

// Mux A/B inputs to ALU depending on OPCODE
always_comb
    case (opcode)

        R_TYPE: begin
            alu_exec_a <= rs1;
            alu_exec_b <= rs2;
        end

        I_TYPE: begin
            alu_exec_a <= rs1;
            alu_exec_b <= imm;
        end

        default: begin
            alu_exec_a <= '0;
            alu_exec_b <= '0;
        end
    endcase
    
endmodule : control_unit