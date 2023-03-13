.text 

#Load address of UART_TX into t0
lui t0, 0x10010
addi t0, t0, 0x100

#Load addrss of UART_RX into t1
lui t1, 0x10010
addi t1, t1, 0x104

#Load address of UART_RX_DONE into t2
lui t2, 0x10010
addi t2, t2, 0x10c

#Load address of GPIO_OUT into t3
lui t3, 0x10010
addi t3, t3, 0x024

_check_uart_rx_done:
#Load the uart_rx_done
	lw s0, 0(t2)
	beq s0, zero, _check_uart_rx_done
#Load the word when done
lw s1, 0(t1)

#Initialize t4 and t5 to 1 for factorial
andi t4, t4, 0x0
andi t5, t5, 0x0
addi t4, t4, 0x1
addi t5, t5, 0x0
#Skip to next value if 0
beq s1, zero, _check_uart_rx_done
loop:
	addi t5, t5, 0x1
       	mul t4, t4, t5
       	bne t5, s1, loop # if t1 != a0, loop
       	
#Store result to GPIO
sw t4, 0(t3)

#Repeat
beq zero, zero, _check_uart_rx_done
