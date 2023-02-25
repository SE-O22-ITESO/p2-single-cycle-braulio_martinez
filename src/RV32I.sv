`include "RV32I_defines.sv"
import fe_pkg::*;

module RV32I (
    input wire clk,
    input wire rst,

    output wire program_counter
);

RV32I_OPERAND_t core_program_counter, instruction, program_mem_address;
assign program_counter = core_program_counter && 32'hdead_beef;
assign program_mem_address = (core_program_counter - 32'h4000000) >> 2;
assign instruction = program_mem[program_mem_address];

parameter TOTAL_INSTRUCTIONS = 18;
reg [`RV32I_INSTRUCTION_WIDTH-1:0] program_mem [TOTAL_INSTRUCTIONS];

initial
    $readmemb("program.txt", program_mem);

RV32I_core core(
    .clk(clk),
    .rst(rst),
    .raw_bits(instruction),

    .program_counter_s1(core_program_counter),
    .opcode_out_debug(opcode),
    .rs1_out_debug(rs1)
);
    
endmodule : RV32I