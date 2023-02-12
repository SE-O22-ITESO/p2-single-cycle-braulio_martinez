`include "RV_defines.sv"

import fe_pkg::*;

module RV32I_decoder (
    input wire [`RV32I_INSTRUCTION_WIDTH-1:0] raw_bits,

    output RV32I_INSTRUCTION_t  mnemonic,
    output RV32I_RS1_t          rs1,
    output RV32I_RS2_t          rs2,
    output RV32I_RD_t           rd,
    output RV32I_IMM_t          imm
);

RV32I_OPCODE_t  opcode;
RV32I_FUNCT_3_t funct3;
RV32I_FUNCT_7_t funct7;

// Assigments
assign opcode = RV32I_OPCODE_t'(raw_bits[RV32I_OPCODE_WIDTH-1:0]);
// FIXME: Might be easier to simply pass 14:12 to save some logic
assign funct3 = (opcode == R_TYPE) ||
                (opcode == I_TYPE) ||
                (opcode == S_TYPE) || 
                (opcode == B_TYPE) ?
                raw_bits[14:12] : '0;

assign funct7 = (opcode == R_TYPE) ?
                raw_bits[31:25] :
                (opcode == I_TYPE) ?
                //FIXME: [5:11] or [11:5]?
                raw_bits[11:5]  : '0;

// RS1/RS2/RD/IMM require no 'processing' besides picking bits
always @(raw_bits)
    case (opcode)

        R_TYPE: begin
            rs1 => raw_bits[19:15];
            rs2 => raw_bits[24:20];
            rd  => raw_bits[11:7];
            imm => '0;
        end

        I_TYPE: begin
            rs1 => raw_bits[19:15];
            rs2 => '0;
            rd  => raw_bits[11:7];
            imm => { {20'{1'b0}}, raw_bits[31:20] };
        end

        S_TYPE: begin
            rs1 => raw_bits[19:15];
            rs2 => raw_bits[24:20];
            rd  => '0;
            imm => { {20'{1'b0}}, raw_bits[31:25], raw_bits[11:7] };
        end
        
        /*B_TYPE: begin
            rs1 => raw_bits[:];
            rs2 => raw_bits[:];
            rd  => raw_bits[:];
            imm => raw_bits[:];
        end

        U_TYPE: begin
            rs1 => raw_bits[:];
            rs2 => raw_bits[:];
            rd  => raw_bits[:];
            imm => raw_bits[:];
        end

        J_TYPE: begin
            rs1 => raw_bits[:];
            rs2 => raw_bits[:];
            rd  => raw_bits[:];
            imm => raw_bits[:];
        end*/

        default: begin
            rs1 => '0;
            rs2 => '0;
            rd  => '0
            imm => '0;
        end
        
    endcase
    
endmodule : RV32I_decoder