`include "RV32I_defines.sv"
import fe_pkg::*;
import be_pkg::*;

module control_unit (
    input wire clk,
    input wire rst,

    input RV32I_OPCODE_t opcode,
    input RV32I_INSTRUCTION_MNEMONIC_t mnemonic,

    output wire opcode_changes_program_counter, bus_addr_select_alu_out, bus_wren, bus_rden,
    output logic rf_wren,
    output logic program_counter_wren,
    output RV32I_CONTROL_UNIT_FSM_t control_unit_state, control_unit_state_next
);

// FSM
`FF_D_RST_EN_DATA_TYPE(clk, rst, 1'b1, control_unit_state_next, control_unit_state, RV32I_CONTROL_UNIT_FSM_t)

// Combo assignments
assign opcode_changes_program_counter   =   (opcode == B_TYPE) || (opcode == J_TYPE) || (opcode == I_JALR_TYPE) || (opcode == I_ENV_TYPE);
assign bus_addr_select_alu_out          =   ((opcode == I_LOAD_TYPE) || (opcode == S_TYPE)) && (control_unit_state == MEM_S4);
assign bus_wren                         =   (opcode == S_TYPE) && (control_unit_state == MEM_S4);
assign bus_rden                         =   (opcode == I_LOAD_TYPE) && (control_unit_state == MEM_S4);

// FSM logic
always_comb
    if (rst)
        control_unit_state_next <= FETCH_S1;
    else begin
        case (control_unit_state)
            IDLE_S0:        control_unit_state_next <= FETCH_S1;
            FETCH_S1:       control_unit_state_next <= DECODE_S2;
            DECODE_S2:      control_unit_state_next <= EXECUTE_S3;

            EXECUTE_S3:     
                case (opcode)
                    I_LOAD_TYPE, S_TYPE:
                        control_unit_state_next <= MEM_S4;
                    B_TYPE, J_TYPE, U_AUI_TYPE:
                        control_unit_state_next <= FETCH_S1;
                    default:control_unit_state_next <= WRITEBACK_S5;
                endcase

            MEM_S4:         control_unit_state_next <= (opcode == S_TYPE) ? FETCH_S1 : WRITEBACK_S5;
            WRITEBACK_S5:   control_unit_state_next <= FETCH_S1;

            default: control_unit_state_next <= FETCH_S1;
        endcase
    end

// RF Write enable
always_comb
    case (control_unit_state)

        // JAL already has everything 'computed' by S3 point
        EXECUTE_S3:
            rf_wren <= ((mnemonic == JAL) || (mnemonic == JALR) || (mnemonic == AUIPC)) ? '1 : '0;

        WRITEBACK_S5:
            case (opcode)
                R_TYPE, I_TYPE, I_LOAD_TYPE, U_LUI_TYPE:
                    rf_wren         <= '1;

                default:
                    rf_wren         <= '0;
            endcase

        default:
            rf_wren         <= '0;

    endcase

// PC Write enable
always_comb
    case (control_unit_state)

        EXECUTE_S3:
            case (mnemonic)
                BEQ, BNE, BLT, BGE, BLTU, BGEU, JAL, AUIPC:
                    program_counter_wren            <= '1;
                default :
                    program_counter_wren            <= '0;
            endcase

        MEM_S4:
            program_counter_wren <= opcode == S_TYPE ? '1 : '0;

        WRITEBACK_S5:
            program_counter_wren <= '1;
        
        default :   program_counter_wren <= '0;
    endcase

endmodule : control_unit