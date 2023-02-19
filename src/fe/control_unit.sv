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
    output RV32I_OPERAND_t alu_a, alu_b, program_counter_new,
    output RV32I_CONTROL_UNIT_FSM_t control_unit_state, control_unit_state_next
);

RV32I_OPERAND_t program_counter_plus_4;

// FSM
`FF_D_RST_EN_DATA_TYPE(clk, rst, ~rst, control_unit_state_next, control_unit_state, RV32I_CONTROL_UNIT_FSM_t)
// Save PC+1
`FF_D_RST_EN(clk, rst, (control_unit_state == FETCH_S1), alu_out, program_counter_plus_4)

// Program counter selection logic
always_comb
    case (opcode)
        // OPCodes that DO change the PC
        B_TYPE, J_TYPE, I_JALR_TYPE, I_ENV_TYPE:
            program_counter_new <= alu_out;
        
        default:
            program_counter_new <= program_counter_plus_4;
    endcase


// ALU for EXEC stage only
RV32I_ALU_OP_t  alu_op_exec;
RV32I_OPERAND_t alu_exec_a, alu_exec_b;

// Select final alu_op depending on current stage:
assign alu_op   =   control_unit_state == EXECUTE_S3 ?
                    alu_op_exec :
                    // Force ALU to sum PC+1 
                    control_unit_state == FETCH_S1 ?
                    ADD_alu     :
                    control_unit_state == DECODE_S2 ?
                    SUB_alu     : NULL_alu;
assign alu_a    =   control_unit_state == EXECUTE_S3 ?
                    alu_exec_a  : 
                    control_unit_state == FETCH_S1 ?
                    program_counter :
                    control_unit_state == DECODE_S2 ?
                    rs1  : '0;
assign alu_b    =   control_unit_state == EXECUTE_S3 ?
                    alu_exec_b  : 
                    control_unit_state == FETCH_S1 ?
                    `RV32I_PC_STEP :
                    control_unit_state == DECODE_S2 ?
                    rs2  : '0;

// ALU operands selection


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

// Set alu_op_exec based on mnemonic
always_comb
    case (mnemonic)
        ADD, ADDI   : alu_op_exec <= ADD_alu;
        SUB         : alu_op_exec <= SUB_alu;
        XOR, XORI   : alu_op_exec <= XOR_alu;
        OR, ORI     : alu_op_exec <= OR_alu;
        AND, ANDI   : alu_op_exec <= AND_alu;
        SLL, SLLI   : alu_op_exec <= SLL_alu;
        SRL, SRLI   : alu_op_exec <= SRL_alu;
        SLTU, SLTIU : alu_op_exec <= SLTU_alu;
        JAL         : alu_op_exec <= ADD_alu;

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

        I_TYPE, I_LOAD_TYPE, I_JALR_TYPE, S_TYPE: begin
            alu_exec_a <= rs1;
            alu_exec_b <= imm;
        end

        J_TYPE: begin
            alu_exec_a <= program_counter;
            alu_exec_b <= imm;
        end

        default: begin
            alu_exec_a <= '0;
            alu_exec_b <= '0;
        end
    endcase
    
endmodule : control_unit