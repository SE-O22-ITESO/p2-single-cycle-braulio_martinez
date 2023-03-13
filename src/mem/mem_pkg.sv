`include "RV32I_defines.sv"

package mem_pkg;

    parameter GPIO_IN_ADDR = 32'h1001_0028;
    parameter GPIO_OUT_ADDR = 32'h1001_0024;

    parameter UART_TX_ADDR = 32'h1001_0100;
    parameter UART_RX_ADDR = 32'h1001_0104;
    parameter UART_TX_DONE_ADDR = 32'h1001_0102;
    parameter UART_BUSY_ADDR = 32'h1001_0108;
    parameter UART_RX_DONE_ADDR = 32'h1001_010c;

    typedef enum {
        RAM, ROM, GPIO_IN, GPIO_OUT,
        UART_RX, UART_TX, UART_TX_DONE, UART_RX_DONE, UART_BUSY
    } MEM_SOURCE_t;

endpackage