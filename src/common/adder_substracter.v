//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineers: Braulio Martinez Aceves, Jorge Alberto Padilla Gutierrez
//  Module Description: Definition of a complex FullAdder with the
//  capability of adding or subtracting depending on the operation mode
//////////////////////////////////////////////////////////////////////////////////
module adder_substracter
    //Parmetized model
    #(parameter NUMBER_OF_BITS = 5)
    (
        //Inputs
        input [NUMBER_OF_BITS-1:0] a,
        input [NUMBER_OF_BITS-1:0] b,
        input mode,
        //Outputs
        output [NUMBER_OF_BITS:0] result,
        output carry,
        output overflow,
        output zero,
        output negative
    );
    
	 //Internl wires
    wire [NUMBER_OF_BITS-1:0] adder_i_b;
    wire [NUMBER_OF_BITS:0] carry_bus;
    wire c_out;
    //Flags assignment
    assign adder_i_b = mode ? ~b : b;
    assign carry = c_out ^ mode;
    assign overflow = c_out ^ carry_bus[NUMBER_OF_BITS-1];
    assign zero = result == 0;
    assign negative = result[NUMBER_OF_BITS] == 1'b1;
    
    //Assignment of Result
    assign result[NUMBER_OF_BITS] = (overflow & ~result[NUMBER_OF_BITS-1]) | (~overflow & result[NUMBER_OF_BITS-1]);
    
    //Instantiate an adder_nbits
    adder_nbits     #(
                     .NUMBER_OF_BITS(NUMBER_OF_BITS)
                     )
                     adder_nbits_dut (
                                     .a(a),
                                     .b(adder_i_b),
                                     .c_in(mode),
                                     .c_out(c_out),
                                     .s_out(result[NUMBER_OF_BITS-1:0]),
												 .carry_bus(carry_bus)
                                     );                                                                  
                                   
endmodule
