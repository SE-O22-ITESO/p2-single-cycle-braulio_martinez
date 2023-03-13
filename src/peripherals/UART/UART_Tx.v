//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineers: Braulio Martinez Aceves, Jorge Alberto Padilla Gutierrez
//  Module Description: TOP Module where every component is implemented
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module UART_Tx (
	input clk,
	input n_rst,
	input tx_send,
	input [7:0] Tx_Data,
	output tx,
	output wire [2:0] tx_state
);

	wire rst, rst_bit_counter_w, rst_BR_w;
	wire shift_bit_w, tx_send_one;
	wire end_bit_time_w, end_half_time_w;
	wire enable_shift_reg_w, enable_in_reg_w;
	wire parity;
	wire [3:0] count_bits_w;
	wire [8:0] Q_SR_w /* synthesis keep */;
	wire [7:0] Tx_Data_w;

	assign rst = ~n_rst;
	
	assign parity = ^(Tx_Data_w);

	assign tx_send_one = tx_send;

	//Input register
	Reg_Param  #(.width(8)) rx_Data_Reg_i (
		.rst(rst), 
		.D(Tx_Data[7:0]), 
		.clk(clk),
		.enable(enable_in_reg_w), 
		.Q(Tx_Data_w)    
	);	

	//Shift register PISO
	Shift_Register_PISO_Param  #(.NUM_BITS(11)) rx_Shift_Reg_i (
		.rst(rst), 
		.D({1'b1,parity,Tx_Data_w,1'b0}), 
		.clk(clk),
		.enable(enable_shift_reg_w), 
		.shift(shift_bit_w),
		.q(tx)    
	);

	//FSM
	FSM_UART_Tx FSM_Tx (
		.tx_send(tx_send_one), 
		.clk(clk), 
		.rst(rst), 
		.end_half_time_i(end_half_time_w),
		.end_bit_time_i(end_bit_time_w), 
		.Tx_bit_Count(count_bits_w), 
		.bit_count_enable(bit_count_enable_w), 
		.rst_BR(rst_BR_w),
		.rst_bit_counter(rst_bit_counter_w), 
		.enable_in_reg(enable_in_reg_w), 
		.enable_shift_reg(enable_shift_reg_w), 
		.shift_shift_reg(shift_bit_w),
		.tx_state(tx_state)
	);	  

// For a baud rate of 9600 baudios: bit time 104.2 us, half time 52.1 us
// For a clock frequency of 50 MHz bit time = 5210 T50MHz;

Bit_Rate_Pulse # (.delay_counts(5210) ) BR_pulse (.clk(clk), .rst(rst_BR_w), 
			   .enable(1'b1), .end_bit_time(end_bit_time_w), .end_half_time (end_half_time_w)    );
			   		   
		
Counter_Param # (.n(4) ) Counter_bits (.clk(clk), .rst(rst_bit_counter_w), .enable(bit_count_enable_w), .Q(count_bits_w)    );


endmodule		