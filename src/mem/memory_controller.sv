`include "RV32I_defines.sv"
import fe_pkg::*;
import mem_pkg::*;

module memory_controller (
    input wire clk, rst,
    input RV32I_OPERAND_t bus_addr, bus_wrdata,
    input wire bus_wren,

    input RV32I_OPERAND_t rom_addr, ram_addr,
    input RV32I_OPERAND_t rom_rddata, ram_rddata, gpio_rddata,

    output RV32I_OPERAND_t bus_rddata,
    output logic ram_wren, gpio_wren
);

MEM_SOURCE_t mem_source;

assign rom_addr     = (bus_addr - 32'h400000) >> 2;
assign ram_addr     = (bus_addr - 32'h10010000) >> 2;

always_comb
    priority casez (bus_addr)
        GPIO_OUT_ADDR:
            mem_source <= GPIO_OUT;
        
        GPIO_IN_ADDR:
            mem_source <= GPIO_IN;
        
        32'b???1_????_????_???1_????_????_????_????:
            mem_source <= RAM;

        32'b0000_0000_01??_????_????_????_????_????:
            mem_source <= ROM;     

        default : mem_source <= ROM;
    endcase

always_comb
    case (mem_source)
        GPIO_OUT    : begin
            bus_rddata  <= '0;
            ram_wren    <= '0;
            gpio_wren   <= bus_wren;
        end

        GPIO_IN     : begin
            bus_rddata  <= gpio_rddata;
            ram_wren    <= '0;
            gpio_wren   <= '0;
        end

        ROM         : begin
            bus_rddata  <= rom_rddata;
            ram_wren    <= '0;
            gpio_wren   <= '0;
        end

        RAM         : begin
            bus_rddata  <= ram_rddata;
            ram_wren    <= bus_wren;
            gpio_wren   <= '0;
        end

        default     : begin
            bus_rddata  <= '0;
            ram_wren    <= '0;
            gpio_wren   <= '0;
        end
    endcase

endmodule