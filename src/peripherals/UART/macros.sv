//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineers: Braulio Martinez Aceves, Jorge Alberto Padilla Gutierrez
//  Module Description: Definition of the D Flip Flop Macro
//////////////////////////////////////////////////////////////////////////////////
`define FF_D_RST_EN(clk, rst, en, d, q)\
    always @(posedge clk, posedge rst) begin \
        if (rst) \
            q <= 'd0;\
        else if (en)\
            q <= d;\
		end
