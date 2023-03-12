//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineers: Braulio Martinez Aceves, Jorge Alberto Padilla Gutierrez
//  Module Description: This module describes the rtl model of a 7 segment
//  display, which receives 4 inputs bits refered to the hexadecimal or
//  BCD value of the input, and the output is the 7 bits that represent the
//  7 segment display LEDs of common anode, which are:
//
//			 aaaa
//			f	  b
//			f	  b
//			f	  b
//			 gggg
//			e	  c
//			e	  c
//			e	  c
//			 dddd
//
//////////////////////////////////////////////////////////////////////////////////
module decoder_bin_hex_7seg(
	 //Inputs
    input w,
    input x,
    input y,
    input z,
	 //Outputs
    output seg_a,
    output seg_b,
    output seg_c,
    output seg_d,
    output seg_e,
    output seg_f,
    output seg_g
    );
    
    //Negated values
    wire seg_a_neg;
    wire seg_b_neg;
    wire seg_c_neg;
    wire seg_d_neg;
    wire seg_e_neg;
    wire seg_f_neg;
    wire seg_g_neg;
    
    //seg_a
    assign seg_a_neg = (~w && ~x && ~y && z) || (~w && x && ~y && ~z) || (w && x && ~y && z) || (w && ~x && y && z);
    
    //seg_b
    assign seg_b_neg = (~w && x && ~y && z) || (w && x && ~z) || (x && y && ~z) || (w && y && z);
    
    //seg_c
    assign seg_c_neg = (~w && ~x && y && ~z) || (w && x && y) || (w && x && ~z);
    
    //seg_d
    assign seg_d_neg = (~x && ~y && z) || (~w && x && ~y && ~z) || (x && y && z) || (w && ~x && y && ~z);
    
    //seg_e
    assign seg_e_neg = (~w && z) || (~w && x && ~y && ~z) || (w && ~x && ~y && z);
    
    //seg_f
    assign seg_f_neg = (~w && ~x && y) || (~w && y && z) || (~w && ~x && z) || (w && x && ~y && z);
    
    //seg_g
    assign seg_g_neg = (~w && ~x && ~y) || (~w && x && y && z) || (w && x && ~y && ~z);
    
    //Negated assignments
    assign seg_a = seg_a_neg;
    assign seg_b = seg_b_neg;
    assign seg_c = seg_c_neg;
    assign seg_d = seg_d_neg;
    assign seg_e = seg_e_neg;
    assign seg_f = seg_f_neg;
    assign seg_g = seg_g_neg;
    
endmodule
