`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineers: Braulio Martinez Aceves, Jorge Alberto Padilla Gutierrez
//  Module Description: Finite State Machine to control a RS232 Transmiter
////////////////////////////////////////////////////////////////////////////////////
module FSM_UART_Tx(
    input tx_send,
    input clk,
    input rst,
    input end_half_time_i,
    input end_bit_time_i,
    input [3:0] Tx_bit_Count,
    output reg bit_count_enable,
    output reg rst_BR,
    output reg rst_bit_counter,
    output reg enable_in_reg,
    output reg enable_shift_reg,
    output reg shift_shift_reg,
	output reg [2:0] tx_state
);

localparam INI_S				= 3'b000;
localparam SEND_S				= 3'b001;
localparam START_S			= 3'b010;
localparam tx_BITS_S			= 3'b011;
localparam SHIFT_S			= 3'b100;
localparam STOP_S				= 3'b101;



always @(posedge rst, posedge clk)
	begin
		if (rst) 
			tx_state<= INI_S;
		else 
		case (tx_state)
				INI_S: 		if (tx_send)
								tx_state <= SEND_S;
				SEND_S:		tx_state <= START_S;
				START_S:		tx_state <= tx_BITS_S;
				tx_BITS_S:	if (Tx_bit_Count == 4'b1010)
									tx_state <= STOP_S;
								else if (end_bit_time_i)
									tx_state <= SHIFT_S;
				SHIFT_S:		tx_state <= tx_BITS_S;
				STOP_S:		//if (end_bit_time_i)	
								tx_state <= INI_S;
				default:		tx_state <= INI_S;
		endcase
	end
// OUTPUT DEFINITION
always @(tx_state)
	begin
				case(tx_state)
				INI_S: 	
					begin
						enable_in_reg = 1'b0;
						bit_count_enable = 1'b0;
						rst_BR = 1'b1;
						rst_bit_counter = 1'b1;
						enable_shift_reg = 1'b0;
						shift_shift_reg = 1'b0;
						
					end
				SEND_S: 	
					begin
						enable_in_reg = 1'b1;
						bit_count_enable = 1'b0;
						rst_BR = 1'b0;
						rst_bit_counter = 1'b1;
						enable_shift_reg = 1'b0;
						shift_shift_reg = 1'b0;
						
					end
				START_S: 	
					begin
						enable_in_reg = 1'b0;
						bit_count_enable = 1'b0;//was1
						rst_BR = 1'b0;
						rst_bit_counter = 1'b0;
						enable_shift_reg = 1'b1;
						shift_shift_reg = 1'b0;
						
					end
				tx_BITS_S: 	
					begin
						enable_in_reg = 1'b0;
						bit_count_enable = 1'b0;//was1
						rst_BR = 1'b0;
						rst_bit_counter = 1'b0;
						enable_shift_reg = 1'b0;
						shift_shift_reg = 1'b0;
					end
				SHIFT_S: 	
					begin
						enable_in_reg 		= 1'b0;
						bit_count_enable = 1'b1;
						rst_BR = 1'b0;
						rst_bit_counter = 1'b0;
						enable_shift_reg = 1'b0;
						shift_shift_reg = 1'b1;
					end
				STOP_S: 	
					begin
						enable_in_reg = 1'b0;
						bit_count_enable = 1'b0;
						rst_BR = 1'b0;
						rst_bit_counter = 1'b0;
						enable_shift_reg = 1'b0;
						shift_shift_reg = 1'b0;
					end					
				default:
					begin
						enable_in_reg = 1'b0;
						bit_count_enable = 1'b0;
						rst_BR = 1'b0;
						rst_bit_counter = 1'b0;
						enable_shift_reg = 1'b0;
						shift_shift_reg = 1'b0;
					end
			endcase
	end
endmodule
