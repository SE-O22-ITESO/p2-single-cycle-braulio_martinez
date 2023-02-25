
`include "RV32I_defines.sv"
module shifter (
    input RV32I_OPERAND_t operand, num_of_shifts,

    output RV32I_OPERAND_t sll, srl, sra
);
    
    assign sll = operand << num_of_shifts;
    assign srl = operand >> num_of_shifts;
    assign sra = operand >>> num_of_shifts;

endmodule