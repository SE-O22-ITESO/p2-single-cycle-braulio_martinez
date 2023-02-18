`include "RV32I_defines.v"

import fe_pkg::*;

module RV32I_decoder (
    input clk,
    input rst,
    input wire [`RV32I_INSTRUCTION_WIDTH-1:0] raw_bits,

    output RV32I_INSTRUCTION_MNEMONIC_t  mnemonic,
    output RV32I_RS1_t          rs1,
    output RV32I_RS2_t          rs2,
    output RV32I_RD_t           rd,
    output RV32I_IMM_t          imm
);

RV32I_OPCODE_t  opcode;
RV32I_FUNCT_3_t funct3;
RV32I_FUNCT_7_t funct7;

// Assigments
assign opcode = RV32I_OPCODE_t'(raw_bits[`RV32I_OPCODE_WIDTH-1:0]);
// FIXME: Might be easier to simply pass 14:12 to save some logic
assign funct3 = (opcode == R_TYPE)      ||
                (opcode == I_TYPE)      ||
                (opcode == I_LOAD_TYPE) ||
                (opcode == I_JALR_TYPE) ||
                (opcode == I_ENV_TYPE)  ||
                (opcode == S_TYPE)      || 
                (opcode == B_TYPE)      ?
                raw_bits[14:12] : '0;

assign funct7 = (opcode == R_TYPE)      ?
                raw_bits[31:25]         :
                (opcode == I_TYPE)      ?
                raw_bits[31:25]         :
                (opcode == I_ENV_TYPE)  ?
                { {(`RV32I_FUNCT_7_WIDTH-1){1'b0}}, raw_bits[7]} : '0;

// RS1/RS2/RD/IMM require no 'processing' besides picking bits
always_comb
    case (opcode)

        R_TYPE: begin
            rs1 <= raw_bits[19:15];
            rs2 <= raw_bits[24:20];
            rd  <= raw_bits[11:7];
            imm <= '0;
        end

        I_TYPE, I_LOAD_TYPE, I_JALR_TYPE, I_ENV_TYPE: begin
            rs1 <= raw_bits[19:15];
            rs2 <= '0;
            rd  <= raw_bits[11:7];
            imm <= { {20{raw_bits[31]}}, raw_bits[31:20] };
        end

        S_TYPE: begin
            rs1 <= raw_bits[19:15];
            rs2 <= raw_bits[24:20];
            rd  <= '0;
            imm <= { {20{raw_bits[31]}}, raw_bits[31:25], raw_bits[11:7] };
        end
        
        B_TYPE: begin
            rs1 <= raw_bits[19:15];
            rs2 <= raw_bits[24:20];
            rd  <= '0;
            imm <= { {20{raw_bits[31]}}, raw_bits[31], raw_bits[7], raw_bits[30:25], raw_bits[11:8], 1'b0 }; 
        end

        U_LUI_TYPE, U_AUI_TYPE: begin
            rs1 <= '0;
            rs2 <= '0;
            rd  <= raw_bits[11:7];
            imm <= { raw_bits[31:12], {12{1'b0}} };
        end

        J_TYPE: begin
            rs1 <= '0;
            rs2 <= '0;
            rd  <= raw_bits[11:7];
            imm <= { {12{raw_bits[31]}}, raw_bits[31], raw_bits[19:12], raw_bits[20], raw_bits[30:21], 1'b0 };
        end

        default: begin
            rs1 <= '0;
            rs2 <= '0;
            rd  <= '0;
            imm <= '0;
        end

    endcase

// Mnemonic
always_comb
    case (opcode)

        R_TYPE:
            case (funct3)
                'h0: mnemonic <= (funct7[5] == '0) ?
                                 ADD :
                                 (funct7[5] == '1) ?
                                 SUB : NULL;
                'h4: mnemonic <= XOR;
                'h6: mnemonic <= OR;
                'h7: mnemonic <= AND;
                'h1: mnemonic <= SLL;
                'h5: mnemonic <= (funct7[5] == '0) ?
                                 SRL :
                                 (funct7[5] == '1) ?
                                 SRA : NULL;
                'h2: mnemonic <= SLT;
                'h3: mnemonic <= SLTU;
                default : mnemonic <= NULL;
            endcase

        I_TYPE:
            case (funct3)
                'h0: mnemonic <= ADDI;
                'h4: mnemonic <= XORI;
                'h6: mnemonic <= ORI;
                'h7: mnemonic <= ANDI;
                'h1: mnemonic <= SLLI;
                'h5: mnemonic <= (funct7[5] == '0) ?
                                 SRLI :
                                 (funct7[5] == '1) ?
                                 SRAI : NULL;
                'h2: mnemonic <= SLTI;
                'h3: mnemonic <= SLTIU;
                default : mnemonic <= NULL;
            endcase

        I_LOAD_TYPE:
            case (funct3)
                'h0: mnemonic <= LB;
                'h1: mnemonic <= LH;
                'h2: mnemonic <= LW;
                'h4: mnemonic <= LBU;
                'h5: mnemonic <= LHU;
                default : mnemonic <= NULL;
            endcase
        
        S_TYPE:
            case (funct3)
                'h0: mnemonic <= SB;
                'h1: mnemonic <= SH;
                'h2: mnemonic <= SW;
                default : mnemonic <= NULL;
            endcase

        B_TYPE:
            case (funct3)
                'h0: mnemonic <= BEQ;
                'h1: mnemonic <= BNE;
                'h4: mnemonic <= BLT;
                'h5: mnemonic <= BGE;
                'h6: mnemonic <= BLTU;
                'h7: mnemonic <= BGEU;
                default : mnemonic <= NULL;
            endcase

        J_TYPE:
            mnemonic <= JAL;

        I_JALR_TYPE:
            mnemonic <= JALR;

        U_LUI_TYPE:
            mnemonic <= LUI;

        U_AUI_TYPE:
            mnemonic <= AUIPC;

        I_ENV_TYPE:
            mnemonic <= (funct7[0] == '1) ?
                        EBREAK : ECALL;

        default:
            mnemonic = NULL;

    endcase

endmodule : RV32I_decoder