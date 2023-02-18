module RV32I_decoder_ref(
    input [31:0] instr,
    output [6:0] opcode,
    output [4:0] funct3,
    output [6:0] funct7,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output reg [11:0] imm,
    output reg is_imm,
    output reg is_branch,
    output reg is_load,
    output reg is_store,
    output reg is_jump
);

assign opcode = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];
assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign rd = instr[11:7];

always @(*) begin
    case (opcode)
        7'b0110111: begin
            is_jump = 1;
            is_imm = 1;
            imm = {{20{instr[31]}}, instr[31:12]};
        end
        7'b0010111: begin
            is_jump = 1;
            is_imm = 1;
            imm = {{20{instr[31]}}, instr[31:12]};
        end
        7'b1101111: begin
            is_jump = 1;
            is_imm = 1;
            imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 0};
        end
        7'b1100011: begin
            is_branch = 1;
            is_imm = 1;
            imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 0};
        end
        7'b0000011: begin
            is_load = 1;
            is_imm = 1;
            imm = {{20{instr[31]}}, instr[31:20]};
        end
        7'b0100011: begin
            is_store = 1;
            is_imm = 1;
            imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        end
        default: begin
            is_jump = 0;
            is_branch = 0;
            is_load = 0;
            is_store = 0;
            is_imm = 0;
            imm = 0;
        end
    endcase
end

endmodule
