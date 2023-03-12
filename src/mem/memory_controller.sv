`include "RV32I_defines.sv"
import fe_pkg::*;
import mem_pkg::*;

module memory_controller (
    input wire clk, rst,
    input RV32I_OPERAND_t bus_addr, bus_wrdata,
    input wire bus_wren,

    input RV32I_OPERAND_t rom_rddata, ram_rddata, gpio_rddata, uart_rddata,

    input wire uart_rx_flag, uart_busy,

    output RV32I_OPERAND_t rom_addr, ram_addr,
    output RV32I_OPERAND_t bus_rddata,
    output logic ram_wren, gpio_wren,
    output logic uart_tx_send, uart_rx_clear
);

MEM_SOURCE_t mem_source;

assign rom_addr     =   (bus_addr - 32'h400000) >> 2;
assign ram_addr     =   (bus_addr - 32'h10010000) >> 2;

assign mem_source   =   (bus_addr == GPIO_OUT_ADDR) ?
                        GPIO_OUT    :
                        (bus_addr == GPIO_IN_ADDR)  ?
                        GPIO_IN     :
                        (bus_addr == UART_TX_ADDR)  ?
                        UART_TX     :
                        (bus_addr == UART_RX_ADDR)  ?
                        UART_RX     :
                        (bus_addr == UART_TX_DONE_ADDR)  ?
                        UART_TX_DONE:
                        (bus_addr == UART_RX_DONE_ADDR)  ?
                        UART_RX_DONE:
                        (bus_addr == UART_BUSY_ADDR)  ?
                        UART_BUSY:
                        (bus_addr[16] && bus_addr[28]) ?
                        RAM         :
                        ROM;

assign bus_rddata   =   (mem_source == GPIO_IN)     ?
                        gpio_rddata :
                        (mem_source == RAM)         ?
                        ram_rddata  :
                        (mem_source == UART_BUSY)   ?
                        { {31{1'b0}}, uart_busy }   :
                        rom_rddata;

assign ram_wren     =   (mem_source == RAM)         ?
                        bus_wren    :
                        '0;

assign gpio_wren    =   (mem_source == GPIO_OUT)    ?
                        bus_wren    :
                        '0;

assign uart_tx_send =   (mem_source == UART_TX) && bus_wren;

endmodule