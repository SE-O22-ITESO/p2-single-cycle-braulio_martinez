`include "RV32I_defines.sv"

module comparators (
    input RV32I_OPERAND_t a, b,

    output logic equal,
    // LT = Less-Than, GT = Greater-Than
    // S = Signed, U = Unsigned
    output logic a_lt_b_s, a_gt_b_s,
    output logic a_lt_b_u, a_gt_b_u
);
    
    assign a_lt_b_s = $signed(a) < $signed(b);
    assign a_gt_b_s = $signed(a) > $signed(b);

    assign a_lt_b_u = a < b;
    assign a_gt_b_u = a > b;

    assign equal = ~|(a ^ b);

endmodule