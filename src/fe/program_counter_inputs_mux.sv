`include "RV32I_defines.sv"
import fe_pkg::*;

module program_counter_inputs_mux (
    input RV32I_OPERAND_t program_counter_plus_4,
    input RV32I_OPERAND_t alu_out,
    input RV32I_OPCODE_t opcode,
    input wire cond_jump,

    output RV32I_OPERAND_t program_counter_new
);
    
always_comb
    case (opcode)
        B_TYPE:
            program_counter_new =  cond_jump ? 
                                    alu_out :
                                    program_counter_plus_4;

        J_TYPE, I_JALR_TYPE:
            program_counter_new =  alu_out;

        default:
            program_counter_new =  program_counter_plus_4;
    endcase

endmodule