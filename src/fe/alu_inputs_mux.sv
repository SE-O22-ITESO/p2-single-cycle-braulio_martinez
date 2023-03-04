`include "RV32I_defines.sv"
import fe_pkg::*;

module alu_inputs_mux (
    input RV32I_OPERAND_t rs1, rs2, rd, imm,
    input RV32I_OPCODE_t opcode,
    input RV32I_OPERAND_t program_counter,
    input RV32I_CONTROL_UNIT_FSM_t control_unit_state,
    
    output RV32I_OPERAND_t alu_a, alu_b
);

// ALU operands for EXEC stage only
RV32I_OPERAND_t alu_exec_a, alu_exec_b;

// ALU is used during FETCH to increase PC
// ALUI is also used speculatively during DECODE to get the PC += IMM value
assign alu_a    =   control_unit_state == EXECUTE_S3 ?
                    alu_exec_a : program_counter;
                    
assign alu_b    =   control_unit_state == EXECUTE_S3 ?
                    alu_exec_b  : 
                    control_unit_state == FETCH_S1 ?
                    `RV32I_PC_STEP  : imm;
    
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
            alu_exec_a <= program_counter;
            alu_exec_b <= imm;
        end

        U_LUI_TYPE: begin
            alu_exec_a <= imm;
            alu_exec_b <= 'd12;
        end

        U_AUI_TYPE: begin
            alu_exec_a <= imm;
            alu_exec_b <= program_counter;
        end

        default: begin
            alu_exec_a <= '0;
            alu_exec_b <= '0;
        end
    endcase

endmodule