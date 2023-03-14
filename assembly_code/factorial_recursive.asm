.text

#Load address of UART_TX into s11
lui s11, 0x10010
addi s11, s11, 0x300

#UART_RX = 0x4(UART_TX)
#UART_BUSY = 0x8(UART_TX)
#UART_RX_DONE = 0xC(UART_TX)

#Initialize SP
lui sp, 0x10010
addi sp, sp, 0x100

main:

    _check_uart_rx_done:
    #Load the uart_rx_done
        lw s0, 0xc(s11)
        beq s0, zero, _check_uart_rx_done
    #Load the word when done
    lw a2, 0x4(s11)
    #Check if its lower than 13
    slti s6, a2, 0xd
    beq s6, zero, _check_uart_rx_done

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

    #Stop iteration count
    andi s10, zero, 0x0
    addi s10, s10, 0x3
    #Const: num of shifts
    addi s8, zero, 0x8

shift_cycle:
    mul s9, s8, s10
    srl s7, a0, s9 
    sw s7, 0(s11)
    jal zero, _check_uart_busy
return_shift:
    addi s10, s10, -1
    slt s0, s10, zero
    beq s0, zero, shift_cycle
    jal zero, repeat


_check_uart_busy:
    #Load the uart busy
    lw s0, 0x8(s11)
    bne s0, zero, _check_uart_busy
    jal zero, return_shift



repeat:
beq zero, zero, main
