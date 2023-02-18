`define RV32I_OPCODE_WIDTH        7
`define RV32I_INSTRUCTION_WIDTH   32
`define RV32I_FUNCT_7_WIDTH       7
`define RV32I_FUNCT_3_WIDTH       3
`define RV32I_RS1_ADDR_WIDTH      5
`define RV32I_RS2_ADDR_WIDTH      5
`define RV32I_RD_ADDR_WIDTH       5
`define RV32I_IMM_WIDTH           32
`define RV32I_NUM_OF_REGS         32

`define FF_D_RST_EN(clk, rst, en, d, q)\
    always @(posedge clk, posedge rst) begin \
        if (rst) \
            q <= 'd0;\
        else if (en)\
            q <= d;\
		end

typedef logic [`RV32I_INSTRUCTION_WIDTH-1:0] RV32I_OPERAND_t;