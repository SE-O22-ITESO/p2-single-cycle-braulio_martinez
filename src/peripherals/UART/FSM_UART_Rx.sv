`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineers: Braulio Martinez Aceves, Jorge Alberto Padilla Gutierrez
//  Module Description: Finite State Machine to control a RS232 Receiver
////////////////////////////////////////////////////////////////////////////////////

import uart_pkg::*;

module FSM_UART_Rx(
    input rx,
    input clk,
    input rst,
    input end_half_time_i,
    input end_bit_time_i,
    input [3:0] Rx_bit_Count,
	 input [7:0] Tx_Data,
	
	 output rx_state_t Rx_state_out,
	 
    output reg sample_o,
    output reg bit_count_enable,
    output reg rst_BR,
    output reg rst_bit_counter,
    output reg enable_out_reg
    );

rx_state_t Rx_state;
assign Rx_state_out = Rx_state;


always @(posedge rst, posedge clk)
	begin
		if (rst) 
			Rx_state<= INIT;
		else 
		case (Rx_state)
			INIT:
				Rx_state <= (rx === '0) ? START_BIT : INIT;

			START_BIT:
				Rx_state <= (end_bit_time_i === '1) ? DATA_BITS : START_BIT;
			
			DATA_BITS:
				if (Rx_bit_Count === 4'd9)
					Rx_state <= STOP_BIT;
				else
					Rx_state <= (end_half_time_i === '1) ? SAMPLE_DATA_BIT : DATA_BITS;

			SAMPLE_DATA_BIT:
				Rx_state <= WAIT_DATA_BIT_END;

			WAIT_DATA_BIT_END:
				Rx_state <= (end_bit_time_i === '1) ? DATA_BITS : WAIT_DATA_BIT_END;

			STOP_BIT:
				Rx_state <= (end_bit_time_i === '1) ? SAVE_DATA_BITS : STOP_BIT;

			SAVE_DATA_BITS:
				Rx_state <= INIT;

			default:
				Rx_state <= INIT;
		endcase
	end
// OUTPUT DEFINITION
always @(Rx_state)
	begin
				case(Rx_state)
				INIT: 	
					begin
						sample_o = 1'b0;
						bit_count_enable = 1'b0;
						rst_BR = 1'b1;
						rst_bit_counter = 1'b1;
						enable_out_reg = 1'b0;
						
					end
				START_BIT: 	
					begin
						sample_o = 1'b0;
						bit_count_enable = 1'b0;
						rst_BR = 1'b0;
						rst_bit_counter = 1'b1;
						enable_out_reg = 1'b0;
						
					end
				DATA_BITS: 	
					begin
						sample_o = 1'b0;
						bit_count_enable = 1'b0;
						rst_BR = 1'b0;
						rst_bit_counter = 1'b0;
						enable_out_reg = 1'b0;
					end
				SAMPLE_DATA_BIT: 	
					begin
						sample_o 		= 1'b1;
						bit_count_enable = 1'b1;
						rst_BR = 1'b0;
						rst_bit_counter = 1'b0;
						enable_out_reg = 1'b0;
					end
				WAIT_DATA_BIT_END:
					begin
						sample_o 		= 1'b0;
						bit_count_enable = 1'b0;
						rst_BR = 1'b0;
						rst_bit_counter = 1'b0;
						enable_out_reg = 1'b0;
					end
				STOP_BIT: 	
					begin
						sample_o = 1'b0;
						bit_count_enable = 1'b0;
						rst_BR = 1'b0;
						rst_bit_counter = 1'b0;
						enable_out_reg = 1'b0;
					end
				SAVE_DATA_BITS: 	
					begin
						sample_o = 1'b0;
						bit_count_enable = 1'b0;
						rst_BR = 1'b0;
						rst_bit_counter = 1'b0;
						enable_out_reg = 1'b1;
					end						
				default:
					begin
						sample_o = 1'b0;
						bit_count_enable = 1'b0;
						rst_BR = 1'b0;
						rst_bit_counter = 1'b0;
						enable_out_reg = 1'b0;
					end
			endcase
	end
endmodule
