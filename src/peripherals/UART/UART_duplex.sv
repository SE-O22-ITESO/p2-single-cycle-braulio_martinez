import uart_pkg::*;
`include "macros.sv"

module UART_duplex(
	input clk,
	input n_rst,
	input rx,
	input rx_flag_clr,
	
	input [7:0] Tx_Data,
	input tx_send,
	
	output tx,

	output [7:0] Rx_Data_w,
	
	output parity_error,
	output reg rx_flag,
	output reg uart_busy
	
	);

rx_state_t Rx_state_out;
wire [2:0] Tx_state_out;

assign uart_busy = 	(Rx_state_out != INIT) ? '1 :
				 	(Tx_state_out != '0) ? '1 : '0;

wire rst, rst_sr_w, rst_bit_counter_w, rst_BR_w;
wire sample_bit_w;
wire end_bit_time_w, end_half_time_w;
wire bit_count_enable_w, enable_out_reg_w;
wire [3:0] count_bits_w;
wire [8:0] Q_SR_w /* synthesis keep */;
wire parity;
wire rx_flag_clr_one;
wire in_save_data_bits = (Rx_state_out == SAVE_DATA_BITS);

assign rst = ~n_rst;
assign rst_sr_w = rst;

assign rx_flag_clr_one = rx_flag_clr;

assign parity_error = (parity != ^Rx_Data_w) ? 1'b1 : 1'b0;

`FF_D_RST_EN(clk, rx_flag_clr_one, in_save_data_bits, 1'b1, rx_flag)

UART_Tx UART_Tx_i (
	.clk(clk),
	.n_rst(n_rst),
	.tx_send(tx_send),
	.Tx_Data(Tx_Data),
	.tx(tx),
	.tx_state(Tx_state_out)
);

Shift_Register_R_Param #(.width(9) ) shift_reg
    (.clk(clk), .rst(rst_sr_w), .enable(sample_bit_w),
     .d(rx), .Q(Q_SR_w) );

// Output Reg
Reg_Param  #(.width(8) ) rx_Data_Reg_i (.rst(rst), .D(Q_SR_w[7:0]), .clk(clk),
							   .enable(enable_out_reg_w), .Q(Rx_Data_w)     );	

FF_D_enable ff_par (.clk(clk),.rst(rst_sr_w),.enable(enable_out_reg_w),
				 .d(Q_SR_w[8]), .q(parity)   );    

// For a baud rate of 9600 baudios: bit time 104.2 us, half time 52.1 us
// For a clock frequency of 50 MHz bit time = 5210 T50MHz;

Bit_Rate_Pulse # (.delay_counts(5210) ) BR_pulse (.clk(clk), .rst(rst_BR_w), 
			   .enable(1'b1), .end_bit_time(end_bit_time_w), .end_half_time (end_half_time_w)    );
			   
FSM_UART_Rx FSM_Rx (.rx(rx), .clk(clk), .rst(rst), .end_half_time_i(end_half_time_w),
				.end_bit_time_i(end_bit_time_w), .Rx_bit_Count(count_bits_w), 
				.sample_o(sample_bit_w), .bit_count_enable(bit_count_enable_w), .rst_BR(rst_BR_w),
				.rst_bit_counter(rst_bit_counter_w), .enable_out_reg(enable_out_reg_w), .Rx_state_out(Rx_state_out));			   
		
Counter_Param # (.n(4) ) Counter_bits (.clk(clk), .rst(rst_bit_counter_w), .enable(bit_count_enable_w), .Q(count_bits_w)    );
											
endmodule		