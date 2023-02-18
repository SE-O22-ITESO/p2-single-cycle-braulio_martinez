def decode(instruction):
    opcode = instruction & 0b1111111
    
    if opcode == 0b0110111:
        # LUI
        imm = instruction >> 12
        rd = (instruction >> 7) & 0b11111
        return ("lui", rd, imm)
    
    elif opcode == 0b0010111:
        # AUIPC
        imm = instruction >> 12
        rd = (instruction >> 7) & 0b11111
        return ("auipc", rd, imm)
    
    elif opcode == 0b1101111:
        # JAL
        imm20 = (instruction >> 31) & 0b1
        imm10_1 = (instruction >> 21) & 0b1111111111
        imm11 = (instruction >> 20) & 0b1
        imm19_12 = (instruction >> 12) & 0b11111111
        imm = (imm20 << 20) | (imm19_12 << 12) | (imm11 << 11) | (imm10_1 << 1)
        rd = (instruction >> 7) & 0b11111
        return ("jal", rd, imm)
    
    elif opcode == 0b1100111:
        # JALR
        imm = instruction >> 20
        rd = (instruction >> 7) & 0b11111
        rs1 = (instruction >> 15) & 0b11111
        return ("jalr", rd, rs1, imm)
    
    elif opcode == 0b1100011:
        funct3 = (instruction >> 12) & 0b111
        rs1 = (instruction >> 15) & 0b11111
        rs2 = (instruction >> 20) & 0b11111
        imm11_0 = instruction >> 20
        imm11 = (instruction >> 7) & 0b1
        imm10_5 = (instruction >> 25) & 0b111111
        imm4_1 = (instruction >> 8) & 0b1111
        imm = (imm11_0 << 1) | (imm11 << 11) | (imm10_5 << 5) | (imm4_1 << 1)
        
        if funct3 == 0b000:
            # BEQ
            return ("beq", rs1, rs2, imm)
        elif funct3 == 0b001:
            # BNE
            return ("bne", rs1, rs2, imm)
        elif funct3 == 0b100:
            # BLT
            return ("blt", rs1, rs2, imm)
        elif funct3 == 0b101:
            # BGE
            return ("bge", rs1, rs2, imm)
        elif funct3 == 0b110:
            # BLTU
            return ("bltu", rs1, rs2, imm)
        elif funct3 == 0b111:
            # BGEU
            return ("bgeu", rs1, rs2, imm)
    
    elif opcode == 0b0000011:
        funct3 = (instruction >> 12) & 0b111
        rd = (instruction >> 7) & 0b11111
        rs1 = (instruction >> 15) & 0b11111
