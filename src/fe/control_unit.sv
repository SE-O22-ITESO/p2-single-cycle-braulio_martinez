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

    output RV32I_ALU_OP_t alu_op,
    output reg [`RV32I_INSTRUCTION_WIDTH-1:0] alu_a,
    output reg [`RV32I_INSTRUCTION_WIDTH-1:0] alu_b
);

// Set ALU_OP based on mnemonic
always_comb
    case (mnemonic)
        ADD, ADDI:
            alu_op <= ADD_alu;

        default:
            alu_op <= NULL_alu;
    endcase

// Mux A/B inputs to ALU depending on OPCODE
always_comb
    case (opcode)

        R_TYPE: begin
            alu_a <= rs1;
            alu_b <= rs2;
        end

        I_TYPE: begin
            alu_a <= rs1;
            alu_b <= imm;
        end

        default: begin
            alu_a <= '0;
            alu_b <= '0;
        end
    endcase
    
endmodule : control_unit