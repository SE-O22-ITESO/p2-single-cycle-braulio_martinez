//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineers: Braulio Martinez Aceves, Jorge Alberto Padilla Gutierrez
//  Module Description: N bit Register
//////////////////////////////////////////////////////////////////////////////////
module Reg_Param  #(parameter width=4)(
    input rst,
    input [width-1:0]D,
    input clk,
    input enable,
    output reg [width-1:0]Q
    );
always @(posedge rst, posedge clk)
    begin
        if (rst)
            Q <= {width{1'b0}};
        else
            if (enable)
                Q <= D;
            else
                Q <= Q;    
    end    
endmodule
