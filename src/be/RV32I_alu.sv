// RV32I_alu
// Takes parametrized inputs
// A/B muxing must be done in previous stages

module RV32I_alu (
    input [`RV32I_INSTRUCTION_WIDTH-1:0] a,
    input [`RV32I_INSTRUCTION_WIDTH-1:0] b,

    output [`RV32I_INSTRUCTION_WIDTH-1:0] out
);
    
endmodule : RV32I_alu