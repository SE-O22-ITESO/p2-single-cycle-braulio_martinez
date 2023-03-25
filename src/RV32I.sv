`include "RV32I_defines.sv"
import fe_pkg::*;

module RV32I (
    input wire clk,
    input wire rst,
    input wire [7:0] gpio_port_in,
    input wire UART_rx,

    output wire [7:0] gpio_port_out,
    output reg clk_1_hz,

    output wire UART_tx
);

RV32I_OPERAND_t bus_addr, rom_addr, ram_addr;
RV32I_OPERAND_t ram_rddata, rom_rddata, gpio_rddata, uart_rddata;
RV32I_OPERAND_t bus_rddata, bus_wrdata;
RV32I_OPERAND_t program_counter;
wire bus_wren, ram_wren, gpio_wren, uart_tx_send, uart_rx_clear, uart_busy, uart_rx_flag;
reg [7:0] uart_tx_data;
assign uart_rddata[31:8] = '0;

parameter TOTAL_INSTRUCTIONS = 64;
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
`FF_D_RST_EN(clk, rst, uart_tx_send, bus_wrdata[7:0], uart_tx_data)

gpio    gpio (
    .clk        (clk),
    .rst        (rst),
    .gpio_port_in   (gpio_port_in),
    .gpio_wrdata    (bus_wrdata),
    .gpio_wren      (gpio_wren),

    .gpio_rddata    (gpio_rddata),
    .gpio_port_out  (gpio_port_out)
);

UART_duplex uart (
    .clk        (clk),
    .n_rst      (~rst),
    .rx         (UART_rx),
    .tx         (UART_tx),

    .Tx_Data    (uart_tx_data),

    .tx_send    (uart_tx_send),
    .rx_flag_clr (uart_rx_clear),
    .uart_busy  (uart_busy),
    .Rx_Data_w  (uart_rddata[7:0]),
    .rx_flag    (uart_rx_flag)
);

memory_controller memory_controller (
    .clk        (clk),
    .rst        (rst),
    .bus_addr   (bus_addr),
    .bus_wrdata (bus_wrdata),
    .bus_wren   (bus_wren),
    .bus_rddata (bus_rddata),

    .program_counter (program_counter),

    .rom_addr   (rom_addr),
    .rom_rddata (rom_rddata),
    .ram_addr   (ram_addr),
    .ram_rddata (ram_rddata),
    .ram_wren   (ram_wren),

    .gpio_rddata (gpio_rddata),
    .gpio_wren  (gpio_wren),

    .uart_rddata (uart_rddata),
    .uart_tx_send (uart_tx_send),
    .uart_rx_clear (uart_rx_clear),
    .uart_busy (uart_busy),
    .uart_rx_flag (uart_rx_flag)
);


parameter TOTAL_RAM_ENTRIES = 64;
register_file #  (
    .NUM_OF_SETS    (TOTAL_RAM_ENTRIES),
    .DATA_BUS_WIDTH (`RV32I_INSTRUCTION_WIDTH)
) ram (
    .clk        (clk),
    .rst        (rst),
    .wr_enable  (ram_wren),
    .wr_addr    (ram_addr),
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

    .rom_rddata         (rom_rddata),
    .program_counter    (program_counter)
);
    
endmodule : RV32I