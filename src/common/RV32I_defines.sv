`define RV32I_OPCODE_WIDTH        7
`define RV32I_INSTRUCTION_WIDTH   32
`define RV32I_FUNCT_7_WIDTH       7
`define RV32I_FUNCT_3_WIDTH       3
`define RV32I_RS1_ADDR_WIDTH      5
`define RV32I_RS2_ADDR_WIDTH      5
`define RV32I_RD_ADDR_WIDTH       5
`define RV32I_IMM_WIDTH           32
`define RV32I_NUM_OF_REGS         32
`define RV32I_PC_STEP             32'd4

`define FF_D_RST_EN(clk, rst, en, d, q)\
    always @(posedge clk, posedge rst) begin \
        if (rst) \
            q <= '0;\
        else if (en)\
            q <= d;\
		end

`define FF_D_RST(clk, rst, d, q)\
    always @(posedge clk, posedge rst) begin \
            q <= d;\
		end

`define FF_D_RST_EN_RESET_VALUE(clk, rst, en, d, q, reset_value)\
    always @(posedge clk, posedge rst) begin \
        if (rst) \
            q <= reset_value;\
        else if (en)\
            q <= d;\
		end

`define FF_D_RST_EN_DATA_TYPE(clk, rst, en, d, q, data_type)\
    always @(posedge clk, posedge rst) begin \
        if (rst) \
            q <= data_type'(0);\
        else if (en)\
            q <= d;\
		end

`define FF_D_RST_DATA_TYPE(clk, rst, d, q, data_type)\
    always @(posedge clk, posedge rst) begin \
        if (rst) \
            q <= data_type'(0);\
        else\
            q <= d;\
		end

`define MUX_2_TO_1(a, b, sel_a, out)\
    always_comb begin \
        if (sel_a) \
            out <= a;\
        else \
            out <= b;\
		end


typedef logic [`RV32I_INSTRUCTION_WIDTH-1:0] RV32I_OPERAND_t;