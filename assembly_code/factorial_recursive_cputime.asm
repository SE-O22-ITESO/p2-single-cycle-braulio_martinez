.text

#Load address of UART_TX into s11
andi s11, s11, 0x0

#UART_RX = 0x4(UART_TX)
#UART_BUSY = 0x8(UART_TX)
#UART_RX_DONE = 0xC(UART_TX)

main:

    #Load the word when done
    andi a2, zero, 0x0
    addi a2, s11, 0x0
    #Check if its lower than 15
    slti s6, a2, 0x10
    addi s11, s11, 0x1
    beq s6, zero, stop

	jal factorial
	#j exit
	jal exit

factorial:
	slti t0, a2, 1
	beq t0, zero, loop
	addi a0, zero, 1

	jalr ra, 0
	
loop:
	addi sp, sp, -8
	sw ra, 4(sp)
	sw a2, 0(sp)
	addi a2, a2, -1
	jal factorial
	lw a2, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	mul a0, a2, a0
	#jr ra
	jalr ra, 0
exit:

repeat:
andi s10, s10, 0x0
beq zero, zero, main


stop:
