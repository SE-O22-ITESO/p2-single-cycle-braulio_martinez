//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineers: Braulio Martinez Aceves, Jorge Alberto Padilla Gutierrez
//  Module Description: Definition of a basic FullAdder with one bit inputs
//  This is used for the addersubtractr model implemented with parameters
//  where we generate multiple instances of this module
//////////////////////////////////////////////////////////////////////////////////
module full_adder(
	 //Inputs
    input a,
    input b,
    input c_in,
	 //Outputs
    output s_out,
    output c_out
    );
        
    //Combinatorial assign of c_in (a ^ b ^ c_in)
    assign s_out = a ^ b ^ c_in;
    
    //Combinatorial assign of c_out
    assign c_out = (a & b)|(a & c_in)|(b & c_in);    
    
endmodule
