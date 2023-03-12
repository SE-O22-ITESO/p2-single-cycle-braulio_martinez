`include "RV32I_defines.sv"

package mem_pkg;

    parameter GPIO_IN_ADDR = 32'h1001_0028;
    parameter GPIO_OUT_ADDR = 32'h1001_0024;

    parameter UART_TX_ADDR = 32'h1001_0100;
    parameter UART_RX_ADDR = 32'h1001_0101;
    parameter UART_TX_DONE = 32'h1001_0102;
    parameter UART_RX_DONE = 32'h1001_0103;

    typedef enum {
        RAM, ROM, GPIO_IN, GPIO_OUT,
        UART_RX_ADDR, UART_TX_ADDR, UART_TX_DONE, UART_RX_DONE
    } MEM_SOURCE_t;

endpackage