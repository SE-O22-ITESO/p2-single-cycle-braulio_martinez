// fe_pkg.sv
// Front-End (FE) miscelaneous definitions for RISC-V implementation

`include "RV32I_defines.sv"

package fe_pkg;

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

    //State Machine for control
    typedef enum {
        IDLE_S0, FETCH_S1, DECODE_S2, EXECUTE_S3, MEM_S4, WRITEBACK_S5
    } RV32I_CONTROL_UNIT_FSM_t;

    typedef enum { 
        PC_PLUS_4, PC_PLUS_IMM, ALU_OUT
    } PC_INPUT_SELECTOR_t;

endpackage