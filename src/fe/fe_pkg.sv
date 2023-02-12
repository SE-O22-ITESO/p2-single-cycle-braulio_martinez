// fe_pkg.sv
// Front-End (FE) miscelaneous definitions for RISC-V implementation

`include "RV32I_defines.sv"

package fe_pkg

    typedef enum logic[`RV32I_OPCODE_WIDTH-1:0] {
        R_TYPE      = `RV32I_OPCODE_WIDTH'b0110011,
        I_TYPE      = `RV32I_OPCODE_WIDTH'b0010011,
        I_LOAD_TYPE = `RV32I_OPCODE_WIDTH'b0000011,
        I_JALR_TYPE = `RV32I_OPCODE_WIDTH'b1100111,
        I_ENV_TYPE  = `RV32I_OPCODE_WIDTH'b1110011,
        S_TYPE      = `RV32I_OPCODE_WIDTH'b0100011,
        B_TYPE      = `RV32I_OPCODE_WIDTH'b1100011,
        J_TYPE      = `RV32I_OPCODE_WIDTH'b1101111,
        U_LUI_TYPE  = `RV32I_OPCODE_WIDTH'b0110111,
        U_AUI_TYPE  = `RV32I_OPCODE_WIDTH'b0010111
    } RV32I_OPCODE_t;

    typedef enum {
        //R-TYPE
        ADD, SUB, XOR, OR, AND, SLL, SRL, SRA, SLT, SLTU,
        //I-TYPE
        ADDI, XORI, ORI, ANDI, SLLI, SRLI, SRAI, SLTI,
        SLTIU, LB, LH, LW, LBU, LHU, JALR, ECALL, EBREAK,
        //S-TYPE
        SB, SH, SW,
        //B-TYPE
        BEQ, BNE, BLT, BGE, BLTU, BGEU,
        //J-TYPE
        JAL,
        //U-TYPE
        LUI, AUIPC,
        
        //INVALID
        NULL
    } RV32I_INSTRUCTION_MNEMONIC_t;

    typedef reg [`RV32I_FUNCT_7_WIDTH-1:0]  RV32I_FUNCT_7_t;
    typedef reg [`RV32I_FUNCT_3_WIDTH-1:0]  RV32I_FUNCT_3_t;
    typedef reg [`RV32I_RS1_ADDR_WIDTH-1:0] RV32I_RS1_t;
    typedef reg [`RV32I_RS2_ADDR_WIDTH-1:0] RV32I_RS2_t;
    typedef reg [`RV32I_RD_ADDR_WIDTH-1:0]  RV32I_RD_t;
    typedef reg [`RV32I_IMM_WIDTH-1:0]      RV32I_IMM_t;

    typedef enum {
        ADD, SUB, XOR, OR, AND, SLL, SRL, SRA, SLT, SLTU
    } RV32I_R_TYPE_INSTRUCTION_t;

    typedef enum {
        ADDI, XORI, ORI, ANDI, SLLI, SRLI, SRAI, SLTI,
        SLTIU, LB, LH, LW, LBU, LHU, JALR, ECALL, EBREAK
    } RV32I_I_TYPE_INSTRUCTION_t;

    typedef enum {
        SB, SH, SW
    } RV32I_S_TYPE_INSTRUCTION_t;

    typedef enum {
        BEQ, BNE, BLT, BGE, BLTU, BGEU
    } RV32I_B_TYPE_INSTRUCTION_t;

    typedef enum {
        JAL
    } RV32I_J_TYPE_INSTRUCTION_t;

    typedef enum {
        LUI, AUIPC
    } RV32I_U_TYPE_INSTRUCTION_t;

endpackage