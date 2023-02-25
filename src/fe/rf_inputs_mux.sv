`include "RV32I_defines.sv"
import fe_pkg::*;

module rf_inputs_mux (
    input RV32I_OPERAND_t alu_out, program_counter_plus_4,
    input RV32I_OPCODE_t opcode,

    output RV32I_OPERAND_t rf_write_data
);
    
// RD Write data
always_comb
    case (opcode)
        R_TYPE, I_TYPE, I_LOAD_TYPE, U_AUI_TYPE, U_LUI_TYPE: 
            rf_write_data   <= alu_out;

        I_JALR_TYPE, J_TYPE:
            rf_write_data   <= program_counter_plus_4;

        default:
            rf_write_data   <= '0;
    endcase

endmodule