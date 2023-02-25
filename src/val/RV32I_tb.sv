`include "RV32I_defines.sv"

import fe_pkg::*;

module RV32I_tb ();
    
    parameter TOTAL_INSTRUCTIONS = 18;
    reg [`RV32I_INSTRUCTION_WIDTH-1:0] program_mem [TOTAL_INSTRUCTIONS];

    reg [`RV32I_INSTRUCTION_WIDTH-1:0] instruction = '0;

    bit clk = '0;
    bit rst = '1;
    int i = 0;

    wire [`RV32I_INSTRUCTION_WIDTH-1:0] program_counter_s1;

    initial forever #1 clk = ~clk;

    RV32I_core dut (
        .clk(clk),
        .rst(rst),
        .raw_bits(program_mem[(dut.program_counter_s1 - 32'h4000000) >> 2]),
        .program_counter_s1(program_counter_s1)
    );

    initial begin
        $readmemb("program.txt", program_mem);

        #4 rst = '0;

        while (dut.program_counter_s1 < TOTAL_INSTRUCTIONS) begin
            @(posedge clk);
            $display("OPCODE: %s, INSTR: %s RS1: %x, RS2: %x, RD: %x, IMM: %x , $signed(IMM): %d",
                dut.decoder.opcode.name(), dut.decoder.mnemonic.name(),
                dut.decoder.rs1_addr, dut.decoder.rs2_addr, dut.decoder.rd_addr, dut.decoder.imm, $signed(dut.decoder.imm)
            );
        end
        $stop();

    end

endmodule : RV32I_tb