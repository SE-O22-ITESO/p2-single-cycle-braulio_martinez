.text
    # Cargar en el registro s0(0x8) el valor 0x10010000
	auipc s0, 0xFC10

    # Sumar 0x10010000 + 0x24 = 0x10010024
    # Guardar resultado en registro s1(0x9)
	addi s1, s0, 0x0024
	addi s2, s0, 0x0028
	lw s5, 0(s2)
LOOP_1:
	addi s3, zero, 1
	addi s4, zero, 8
LOOP_2:
	sw s3, 0(s1)
	slli s3, s3, 1
	addi s4, s4, -1
	bne s4, zero, LOOP_2
	addi s5, s5, -1
	bne s5,zero, LOOP_1
EXIT:
