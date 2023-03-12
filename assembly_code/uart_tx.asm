.text 

#Load address of UART_TX into t0
lui t0, 0x10010
addi t0, t0, 0x100
lui t1, 0x10010
addi t1, t1, 0x104

#Save ASCII B character into s0
addi s0, s0, 0x42

_send_char:
#Call store word
sw s0, 0(t0)

_check_uart_busy:
#Load the uart busy
lw s1, 0(t1)
bne s1, zero, _check_uart_busy
beq zero, zero, _send_char

_dumb_loop:
beq zero, zero, _dumb_loop



