`include "RV32I_defines.sv"

import fe_pkg::*;

module RV32I_tb ();
    
    parameter TOTAL_INSTRUCTIONS = 18;
    reg [`RV32I_INSTRUCTION_WIDTH-1:0] program_mem [TOTAL_INSTRUCTIONS];

    reg [`RV32I_INSTRUCTION_WIDTH-1:0] instruction = '0;

    RV32I dut (
        .clk(clk),
        .rst(rst),
        .instruction(instruction)
    );

    initial begin
        $readmemb("program.txt", program_mem);

        for (int i = 0; i < TOTAL_INSTRUCTIONS; i++) begin
            instruction = program_mem[i];
            #1;
            $display("OPCODE: %s, INSTR: %s RS1: %x, RS2: %x, RD: %x, IMM: %x , $signed(IMM): %d",
                dut.core.decoder.opcode.name(), dut.core.decoder.mnemonic.name(),
                dut.core.decoder.rs1_addr, dut.core.decoder.rs2_addr, dut.core.decoder.rd_addr, dut.core.decoder.imm, $signed(dut.core.decoder.imm)
            );
        end
        $stop();
    end

endmodule : RV32I_tb