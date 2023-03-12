`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineers: Braulio Martinez Aceves, Jorge Alberto Padilla Gutierrez
//  Module Description: Parametric Right Shift Register with Paralel Input
//////////////////////////////////////////////////////////////////////////////////
module Shift_Register_PISO_Param #(parameter NUM_BITS = 11)(
    input clk,
    input rst,
    input enable,
    input shift,
    input [NUM_BITS-1:0] D,
    output q
);
	 
	reg [NUM_BITS-1:0] D_FF;
		 
	always @(posedge rst, posedge clk) begin
		if (rst)
			D_FF <= {NUM_BITS{1'b1}};
		else
			if (enable)
				D_FF <= D;
			else if (shift)
				D_FF <= {1'b1, D_FF[NUM_BITS-1:1]};
	end
	
	assign q = D_FF[0];
	
endmodule
