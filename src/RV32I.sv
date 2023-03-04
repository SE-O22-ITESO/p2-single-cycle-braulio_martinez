`include "RV32I_defines.sv"
import fe_pkg::*;

module RV32I (
    input wire clk,
    input wire rst,
    input wire [7:0] gpio_port_in,

    output wire [7:0] gpio_port_out,
    output reg clk_1_hz
);

RV32I_OPERAND_t bus_addr, rom_addr, ram_addr;
RV32I_OPERAND_t ram_rddata, rom_rddata, gpio_rddata;
RV32I_OPERAND_t bus_rddata, bus_wrdata;
wire bus_wren, ram_wren, gpio_wren;

parameter TOTAL_INSTRUCTIONS = 18;
reg [`RV32I_INSTRUCTION_WIDTH-1:0] rom [TOTAL_INSTRUCTIONS];
initial
    $readmemb("program.txt", rom);
assign rom_rddata = rom[rom_addr];

// 1-Hz clk generator
wire clk_1_hz_en;
counter # (
    .MAX_COUNT(25_000_000)
) half_second_generator (
    .clk    (clk),
    .rst    (rst),
    .enable (~rst),

    .max_cnt_hit    (clk_1_hz_en)
);

`FF_D_RST_EN(clk, rst, clk_1_hz_en, ~clk_1_hz, clk_1_hz)

gpio    gpio (
    .clk        (clk_1_hz),
    .rst        (rst),
    .gpio_port_in   (gpio_port_in),
    .gpio_wrdata    (bus_wrdata),
    .gpio_wren      (gpio_wren),

    .gpio_rddata    (gpio_rddata),
    .gpio_port_out  (gpio_port_out)
);

memory_controller memory_controller (
    .clk        (clk_1_hz),
    .rst        (rst),
    .bus_addr   (bus_addr),
    .bus_wrdata (bus_wrdata),
    .bus_wren   (bus_wren),
    .bus_rddata (bus_rddata),

    .rom_addr   (rom_addr),
    .rom_rddata (rom_rddata),
    .ram_addr   (ram_addr),
    .ram_rddata (ram_rddata),
    .ram_wren   (ram_wren),

    .gpio_rddata (gpio_rddata),
    .gpio_wren  (gpio_wren)
);


parameter TOTAL_RAM_ENTRIES = 32;
register_file #  (
    .NUM_OF_SETS    (TOTAL_RAM_ENTRIES),
    .DATA_BUS_WIDTH (`RV32I_INSTRUCTION_WIDTH)
) ram (
    .clk        (clk_1_hz),
    .rst        (rst),
    .wr_enable  (ram_wren),
    .wr_addr    (bus_addr),
    .wr_data    (bus_wrdata),
    .rd_addr    (ram_addr),
    .rd_data    (ram_rddata)
);

RV32I_core core(
    .clk                (clk_1_hz),
    .rst                (rst),
    .bus_rddata         (bus_rddata),

    .bus_addr           (bus_addr),
    .bus_wren           (bus_wren),
    .bus_wrdata         (bus_wrdata)
);
    
endmodule : RV32I