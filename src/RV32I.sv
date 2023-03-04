`include "RV32I_defines.sv"
import fe_pkg::*;

module RV32I (
    input wire clk,
    input wire rst,

    output wire program_counter
);

RV32I_OPERAND_t bus_addr, rom_addr, ram_addr;
RV32I_OPERAND_t ram_rddata;
RV32I_OPERAND_t bus_rddata, bus_wrdata;
wire bus_wren;

// Prevent Quartus from skipping synthesis
assign program_counter = bus_addr && 32'hdead_beef;

assign rom_addr     = (bus_addr - 32'h400000) >> 2;
assign ram_addr     = (bus_addr - 32'h10010000) >> 2;
assign bus_rddata   =  bus_addr[28]     ? 
                       ram_rddata       :
                       rom[rom_addr];

parameter TOTAL_INSTRUCTIONS = 18;
reg [`RV32I_INSTRUCTION_WIDTH-1:0] rom [TOTAL_INSTRUCTIONS];
initial
    $readmemb("program.txt", rom);

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

RV32I_core core(
    .clk                (clk),
    .rst                (rst),
    .bus_rddata         (bus_rddata),

    .bus_addr           (bus_addr),
    .bus_wren           (bus_wren),
    .bus_wrdata         (bus_wrdata),
    .opcode_out_debug   (opcode),
    .rs1_out_debug      (rs1)
);
    
endmodule : RV32I