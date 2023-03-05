`include "RV32I_defines.sv"

import fe_pkg::*;

module RV32I_tb ();

    bit clk = '0;
    bit rst = '1;

    wire [7:0] gpio_port_out;
    bit [7:0] gpio_port_in = 'd2;

    RV32I dut (
        .clk(clk),
        .rst(rst),
        .gpio_port_in   (gpio_port_in),

        .gpio_port_out  (gpio_port_out)
    );


    initial forever #1 clk = ~clk;
    initial begin
        #4 rst = '0;

        /* forever begin
            @(dut.decoder.mnemonic);
            $display("OPCODE: %s, INSTR: %s RS1: %x, RS2: %x, RD: %x, IMM: %x , $signed(IMM): %d",
                dut.decoder.opcode.name(), dut.decoder.mnemonic.name(),
                dut.decoder.rs1_addr, dut.decoder.rs2_addr, dut.decoder.rd_addr, dut.decoder.imm, $signed(dut.decoder.imm)
            );
        end */
    end
    always @(clk)
        force dut.clk_1_hz = clk;

endmodule : RV32I_tb