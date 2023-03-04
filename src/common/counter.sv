//////////////////////////////////////////////////////////////////////////////////
//  Company: ITESO
//  Engineers: Braulio Martinez Aceves, Jorge Alberto Padilla Gutierrez
//  Module Description: Definition of a Counter, that converts clock signals
//////////////////////////////////////////////////////////////////////////////////

module counter
    //Parameter to override bits number when desirable
    #( parameter MAX_COUNT = 2, parameter NUMBER_OF_BITS = $clog2(MAX_COUNT))
    (
	 //Inputs
    input clk,
    input enable,
    input rst,
	 //Outputs
    output max_cnt_hit,
    output reg [NUMBER_OF_BITS-1:0] cnt = 'h0
    );

    assign max_cnt_hit = ((cnt == (MAX_COUNT - 1'b1)) & enable);
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            cnt <= 'h0;
        end else begin
        if (enable) begin
            if (cnt == (MAX_COUNT - 1)) begin
                cnt <= 'h0;                
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
        end
    end

endmodule
