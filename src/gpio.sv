`include "RV32I_defines.sv"
import fe_pkg::*;
import mem_pkg::*;

module gpio (
    input wire clk, rst,
    input wire [7:0] gpio_port_in,
    input RV32I_OPERAND_t gpio_wrdata,
    input wire gpio_wren,

    output reg [7:0] gpio_port_out,
    output RV32I_OPERAND_t gpio_rddata
);

`FF_D_RST(clk, rst, {{24{1'b0}}, gpio_port_in}, gpio_rddata)
`FF_D_RST_EN(clk, rst, gpio_wren, gpio_wrdata[7:0], gpio_port_out)


endmodule