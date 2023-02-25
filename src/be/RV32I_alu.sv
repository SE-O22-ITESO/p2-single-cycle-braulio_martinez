// RV32I_alu
// Takes parametrized inputs
// A/B muxing must be done in previous stages
`include "RV32I_defines.sv"
import fe_pkg::*;
import be_pkg::*;

module RV32I_alu (
    input RV32I_OPERAND_t a, b, rs1, rs2, imm, program_counter_plus_4_s1,
    input RV32I_INSTRUCTION_MNEMONIC_t mnemonic,

    output RV32I_OPERAND_t out
);

RV32I_OPERAND_t adder_substracter_out, a_adder, b_adder;
RV32I_OPERAND_t shifter_operand, shifter_num_of_shifts, sll, srl, sra;
logic adder_substracter_mode;
wire rs1_lt_rs2_s, rs1_gt_rs2_s, rs1_lt_rs2_u, rs1_gt_rs2_u, rs1_equal_rs2;
wire rs1_lt_imm_s, rs1_gt_imm_s, rs1_lt_imm_u, rs1_gt_imm_u, rs1_equal_imm;

adder_substracter_bmod # (
    .NUMBER_OF_BITS(`RV32I_INSTRUCTION_WIDTH)
) adder_substracter (
    .a      (a_adder),
    .b      (b_adder),
    .mode   (adder_substracter_mode),
    .result (adder_substracter_out)
);

comparators rs1_rs2_comparators (
    .a          (rs1),
    .b          (rs2),
    .a_lt_b_s   (rs1_lt_rs2_s),
    .a_gt_b_s   (rs1_gt_rs2_s),
    .a_lt_b_u   (rs1_lt_rs2_u),
    .a_gt_b_u   (rs1_gt_rs2_u),
    .equal      (rs1_equal_rs2)
);

comparators rs1_imm_comparators (
    .a          (rs1),
    .b          (imm),
    .a_lt_b_s   (rs1_lt_imm_s),
    .a_gt_b_s   (rs1_gt_imm_s),
    .a_lt_b_u   (rs1_lt_imm_u),
    .a_gt_b_u   (rs1_gt_imm_u),
    .equal      (rs1_equal_imm)
);

shifter shifter (
    .operand(shifter_operand),
    .num_of_shifts(shifter_num_of_shifts),
    .sll(sll),
    .srl(srl),
    .sra(sra)
);

// Adder inputs and muxing
assign adder_substracter_mode = (mnemonic == SUB) ? '1 : '0;
assign a_adder = a;
assign b_adder = (mnemonic == AUIPC) ? sll : b;

// Shifter inputs and muxing
assign shifter_operand = a;

always_comb
    case (mnemonic)

        SLLI, SRLI, SRAI:   shifter_num_of_shifts <= {{27{1'b0}}, b[4:0]};
        AUIPC:              shifter_num_of_shifts <= 'd12;

        default: shifter_num_of_shifts <= b;
    endcase

// Output muxing
always_comb
    case (mnemonic)

        ADD, ADDI, LB, LH, LW, LBU, LHU, SB, SH, SW, JAL, JALR, SUB, AUIPC:
            out <= adder_substracter_out;
        XOR, XORI:  out <=  a ^ b;
        OR, ORI:    out <=  a | b;
        AND, ANDI:  out <=  a & b;
        SLL, SLLI:  out <=  sll;
        SRL, SRLI:  out <=  srl;
        SRA, SRAI:  out <=  sra;
        SLT:        out <=  (rs1_lt_rs2_s && ~rs1_equal_rs2) ? 'd1 : '0;
        SLTI:       out <=  (rs1_lt_imm_s && ~rs1_equal_imm) ? 'd1 : '0;
        SLTU:       out <=  (rs1_lt_rs2_u && ~rs1_equal_rs2) ? 'd1 : '0;
        SLTIU:      out <=  (rs1_lt_imm_u && ~rs1_equal_imm) ? 'd1 : '0;

        BEQ:        out <=  rs1_equal_rs2   ?
                            adder_substracter_out : program_counter_plus_4_s1;
        BNE:        out <=  ~rs1_equal_rs2  ?
                            adder_substracter_out : program_counter_plus_4_s1;
        BLT:        out <=  ~rs1_equal_rs2 & rs1_lt_rs2_s ?
                            adder_substracter_out : program_counter_plus_4_s1;
        BGE:        out <=  rs1_equal_rs2 | rs1_gt_rs2_s ?
                            adder_substracter_out : program_counter_plus_4_s1;
        BLTU:       out <=  ~rs1_equal_rs2 & rs1_lt_rs2_u ?
                            adder_substracter_out : program_counter_plus_4_s1;
        BGEU:       out <=  ~rs1_equal_rs2 & rs1_gt_rs2_u ?
                            adder_substracter_out : program_counter_plus_4_s1;
        
        LUI:        out <=  sll;

        default:    out <= '0;

    endcase
    
endmodule : RV32I_alu