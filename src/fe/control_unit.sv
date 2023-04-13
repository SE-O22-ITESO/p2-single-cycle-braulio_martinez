`include "RV32I_defines.sv"
import fe_pkg::*;
import be_pkg::*;

module control_unit (
    input wire clk,
    input wire rst,

    input RV32I_OPCODE_t opcode,
    input RV32I_INSTRUCTION_MNEMONIC_t mnemonic,

    output wire bus_wren, bus_rden,
    output logic rf_wren
);

// Combo assignments
assign bus_wren                         =   (opcode == S_TYPE);
assign bus_rden                         =   (opcode == I_LOAD_TYPE);

// RF Write enable
always_comb
    case (opcode)
        R_TYPE, I_TYPE, I_LOAD_TYPE, U_LUI_TYPE, I_JALR_TYPE, U_AUI_TYPE, J_TYPE:
            rf_wren         = ~rst;

        default:
            rf_wren         = '0;
    endcase

endmodule : control_unit