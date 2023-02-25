`include "RV32I_defines.sv"

import fe_pkg::*;

module RV32I_tb ();
    
    parameter TOTAL_INSTRUCTIONS = 18;
    reg [`RV32I_INSTRUCTION_WIDTH-1:0] rom [TOTAL_INSTRUCTIONS];

    RV32I_OPERAND_t bus_addr, rom_addr, ram_addr, ram_rddata;
    RV32I_OPERAND_t bus_rddata, bus_wrdata;
    wire bus_wren;

    bit clk = '0;
    bit rst = '1;
    int i = 0;

    parameter TOTAL_RAM_ENTRIES = 32;
    register_file #  (
        .NUM_OF_SETS    (TOTAL_RAM_ENTRIES),
        .DATA_BUS_WIDTH (`RV32I_INSTRUCTION_WIDTH)
    ) ram (
        .clk        (clk),
        .rst        (rst),
        .wr_enable  (bus_wren),
        .wr_addr    (bus_addr),
        .wr_data    (bus_wrdata),
        .rd_addr    (ram_addr),
        .rd_data    (ram_rddata)
    );

    RV32I_core dut(
        .clk                (clk),
        .rst                (rst),
        .bus_rddata         (bus_rddata),

        .bus_addr           (bus_addr),
        .bus_wren           (bus_wren),
        .bus_wrdata         (bus_wrdata)
    );

    
    assign rom_addr     = (bus_addr - 32'h4000000) >> 2;
    assign ram_addr     = (bus_addr - 32'h10010000) >> 2;
    assign bus_rddata   =  bus_addr[28]     ? 
                            RV32I_OPERAND_t'(ram_rddata)      :
                            RV32I_OPERAND_t'(rom[rom_addr]);

    initial forever #1 clk = ~clk;
    initial begin
        $readmemb("program.txt", rom);

        #4 rst = '0;

        forever begin
            @(dut.decoder.mnemonic);
            $display("OPCODE: %s, INSTR: %s RS1: %x, RS2: %x, RD: %x, IMM: %x , $signed(IMM): %d",
                dut.decoder.opcode.name(), dut.decoder.mnemonic.name(),
                dut.decoder.rs1_addr, dut.decoder.rs2_addr, dut.decoder.rd_addr, dut.decoder.imm, $signed(dut.decoder.imm)
            );
        end
        //s$stop();
    end

endmodule : RV32I_tb