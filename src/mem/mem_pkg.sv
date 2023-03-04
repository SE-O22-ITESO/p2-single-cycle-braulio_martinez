`include "RV32I_defines.sv"

package mem_pkg;

    parameter GPIO_IN_ADDR = 32'h10010028;
    parameter GPIO_OUT_ADDR = 32'h10010024;

    typedef enum {
        RAM, ROM, GPIO_IN, GPIO_OUT
    } MEM_SOURCE_t;

endpackage