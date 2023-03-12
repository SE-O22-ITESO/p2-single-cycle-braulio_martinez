package uart_pkg;

typedef enum logic [2:0] {
	INIT,
	START_BIT,
	DATA_BITS,
	SAMPLE_DATA_BIT,
	WAIT_DATA_BIT_END,
	STOP_BIT,
	SAVE_DATA_BITS
} rx_state_t;

endpackage