`include "RV32I_defines.sv"

package mem_pkg;

    parameter GPIO_IN_ADDR = 32'h1001_0200;
    parameter GPIO_OUT_ADDR = 32'h1001_0204;

    parameter UART_TX_ADDR = 32'h1001_0300;
    parameter UART_RX_ADDR = 32'h1001_0304;
    parameter UART_BUSY_ADDR = 32'h1001_0308;
    parameter UART_RX_DONE_ADDR = 32'h1001_030c;

    typedef enum {
        RAM, ROM, GPIO_IN, GPIO_OUT,
        UART_RX, UART_TX, UART_TX_DONE, UART_RX_DONE, UART_BUSY
    } MEM_SOURCE_t;

endpackage