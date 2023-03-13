.text 

#Load address of UART_TX into t0
lui t0, 0x10010
addi t0, t0, 0x100

#Load addrss of UART_Busy into t1
lui t1, 0x10010
addi t1, t1, 0x104

#Save last ASCII character in a0
andi a0, a0, 0x0
addi a0, a0, 0x7f

_start_ascii:
#Save ASCII ! character into s0
andi s0, s0, 0x0
addi s0, s0, 0x21

_send_char:
#Call store word
sw s0, 0(t0)

_check_uart_busy:
#Load the uart busy
lw s1, 0(t1)
bne s1, zero, _check_uart_busy

#Increase by 1
addi s0, s0, 0x1
beq s0, a0, _start_ascii
beq zero, zero, _send_char
