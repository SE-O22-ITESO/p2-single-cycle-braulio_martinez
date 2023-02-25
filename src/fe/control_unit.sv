`include "RV32I_defines.sv"
import fe_pkg::*;
import be_pkg::*;

module control_unit (
    input wire clk,
    input wire rst,

    input RV32I_OPCODE_t opcode,
    input RV32I_INSTRUCTION_MNEMONIC_t mnemonic,

    output logic rf_wren,
    output RV32I_CONTROL_UNIT_FSM_t control_unit_state, control_unit_state_next
);

// FSM
`FF_D_RST_EN_DATA_TYPE(clk, rst, ~rst, control_unit_state_next, control_unit_state, RV32I_CONTROL_UNIT_FSM_t)


// FSM logic
always_comb
    if (rst)
        control_unit_state_next <= FETCH_S1;
    else begin
        case (control_unit_state)
            FETCH_S1:       control_unit_state_next <= DECODE_S2;
            DECODE_S2:      control_unit_state_next <= EXECUTE_S3;
            EXECUTE_S3:     control_unit_state_next <= WRITEBACK_S5;
            WRITEBACK_S5:   control_unit_state_next <= FETCH_S1;

            default: control_unit_state_next <= FETCH_S1;
        endcase
    end

// RF Write enable
always_comb
    case (control_unit_state)

        WRITEBACK_S5:
            case (opcode)
                R_TYPE, I_TYPE, I_LOAD_TYPE, U_AUI_TYPE, U_LUI_TYPE:
                    rf_wren         <= '1;

                I_JALR_TYPE, J_TYPE:
                    rf_wren         <= '1;

                default:
                    rf_wren         <= '0;
            endcase

        default:
            rf_wren         <= '0;

    endcase

endmodule : control_unit