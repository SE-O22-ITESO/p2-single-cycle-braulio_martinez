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

#Load addrss of UART_Busy into t1
lui t3, 0x10010
addi t3, t3, 0x108

#Load address of GPIO_OUT into t4
lui t4, 0x10010
addi t4, t4, 0x024

_check_uart_rx_done:
#Load the uart_rx_done
	lw s0, 0(t2)
	beq s0, zero, _check_uart_rx_done
#Load the word when done
lw s1, 0(t1)

#Initialize t5 and t6 to 1 for factorial
andi t5, t5, 0x0
andi t6, t6, 0x0
addi t5, t5, 0x1
addi t6, t6, 0x0
#Skip to next value if 0
beq s1, zero, _check_uart_rx_done
loop:
	addi t6, t6, 0x1
       	mul t5, t5, t6
       	bne t6, s1, loop
       	
#Store result to GPIO
sw t5, 0(t4)

andi a0, a0, 0x0
addi a0, a0, 0x4
_save_uart_bits:
#Save to UART_TX
sw t5, 0(t0)

_check_uart_busy:
#Load the uart busy
lw s1, 0(t3)
bne s1, zero, _check_uart_busy

srli t5, t5, 0x8
addi a0, a0, -1
bne a0, zero, _save_uart_bits

#Repeat
beq zero, zero, _check_uart_rx_done
