//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineers: Braulio Martinez Aceves, Jorge Alberto Padilla Gutierrez
//  Module Description: Definition of a complex FullAdder with the
//  capability of being parmetizedd
//////////////////////////////////////////////////////////////////////////////////
	module adder_nbits
		 //Parameter to override bits number when desirable
		 #( parameter NUMBER_OF_BITS = 4)
		 (
		 //Declare wire inputs, we can use parameter to make it flexible
		 input [NUMBER_OF_BITS-1:0] a,
		 input [NUMBER_OF_BITS-1:0] b,
		 input c_in,
		 output c_out,
		 output [NUMBER_OF_BITS-1:0] s_out,
		 output [NUMBER_OF_BITS:0] carry_bus
		 );
		 
		 //Generate a bus to have the carry values for interconnection
		 //We need NUMBER_OF_BITS+1 since c_in is connected to the first instance
		 //Rest will be connected as carry_bus[n+1]
		 assign carry_bus[0] = c_in;
		 
		 assign c_out = carry_bus[NUMBER_OF_BITS];
		 
		 //Generate as many instances of full_adder as needed
		 generate
		 genvar i;
		 for (i=0; i<NUMBER_OF_BITS; i=i+1) begin : quartus_generate_fix
			  full_adder  full_adder_i    (
													.a      (a[i]),
													.b      (b[i]),
													.c_in   (carry_bus[i]),
													.c_out  (carry_bus[i+1]),
													.s_out  (s_out[i])
													);
		 end
		 endgenerate
		 
		 
	endmodule
