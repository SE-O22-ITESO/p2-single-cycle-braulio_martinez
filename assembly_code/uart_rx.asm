.text 

#Load address of UART_TX into t0
lui t0, 0x10010
addi t0, t0, 0x300

#Load addrss of UART_RX into t1
lui t1, 0x10010
addi t1, t1, 0x304

#Load address of UART_RX_DONE into t2
lui t2, 0x10010
addi t2, t2, 0x30c

#Load address of GPIO_OUT into t3
lui t3, 0x10010
addi t3, t3, 0x204

_check_uart_rx_done:
#Load the uart_rx_done
	lw s0, 0(t2)
	beq s0, zero, _check_uart_rx_done
#Load the word when done
lw s1, 0(t1)
       	
#Store result to GPIO
sw s1, 0(t3)

#Store result to UART TX
sw s1, 0(t0)

#Repeat
beq zero, zero, _check_uart_rx_done
