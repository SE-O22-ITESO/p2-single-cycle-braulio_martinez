`include "RV32I_defines.v"

import fe_pkg::*;

module RV32I_tb ();
    
    parameter TOTAL_INSTRUCTIONS = 18;
    reg [`RV32I_INSTRUCTION_WIDTH-1:0] program_mem [TOTAL_INSTRUCTIONS];

    reg [`RV32I_INSTRUCTION_WIDTH-1:0] raw_bits = '0;

    RV32I dut (
        .clk(clk),
        .rst(rst),
        .raw_bits(raw_bits)
    );

    initial begin
        $readmemb("program.txt", program_mem);

        for (int i = 0; i < TOTAL_INSTRUCTIONS; i++) begin
            raw_bits = program_mem[i];
            #1;
            $display("OPCODE: %s, INSTR: %s RS1: %x, RS2: %x, RD: %x, IMM: %x , $signed(IMM): %d",
                dut.core.decoder.opcode.name(), dut.core.decoder.mnemonic.name(),
                dut.core.decoder.rs1, dut.core.decoder.rs2, dut.core.decoder.rd, dut.core.decoder.imm, $signed(dut.core.decoder.imm)
            );
        end
        $stop();
    end

endmodule : RV32I_tb