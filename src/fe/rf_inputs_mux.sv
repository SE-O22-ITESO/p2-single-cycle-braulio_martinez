`include "RV32I_defines.sv"
import fe_pkg::*;

module rf_inputs_mux (
    input RV32I_OPERAND_t alu_out, program_counter_plus_4, program_counter_plus_imm,
    input RV32I_OPCODE_t opcode,
    input RV32I_INSTRUCTION_MNEMONIC_t mnemonic,
    input RV32I_OPERAND_t bus_rddata,

    output RV32I_OPERAND_t rf_write_data
);
    
// RD Write data
always_comb
    case (opcode)
        R_TYPE, I_TYPE, U_LUI_TYPE, U_AUI_TYPE: 
            rf_write_data   <= alu_out;

        I_LOAD_TYPE:
            case (mnemonic)
                LB  : rf_write_data <= { {24{bus_rddata[7]}}, bus_rddata[7:0]};
                LH  : rf_write_data <= { {16{bus_rddata[15]}}, bus_rddata[15:0]};
                LW  : rf_write_data <= bus_rddata;
                LBU : rf_write_data <= { {24{1'b0}}, bus_rddata[7:0]};
                LHU : rf_write_data <= { {16{1'b0}}, bus_rddata[15:0]};
                default : rf_write_data <= '0;
            endcase

        I_JALR_TYPE, J_TYPE:
            rf_write_data   <= program_counter_plus_4;

        default:
            rf_write_data   <= '0;
    endcase

endmodule