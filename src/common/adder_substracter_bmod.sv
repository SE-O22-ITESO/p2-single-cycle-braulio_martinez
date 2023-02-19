module adder_substracter_bmod #(
    parameter NUMBER_OF_BITS = 32
) (
    input wire signed [NUMBER_OF_BITS-1:0] a, b,
    // 0 for adder, 1 for substracter
    input wire mode,

    output wire signed [NUMBER_OF_BITS-1:0] result
);

assign result   =   (mode == '0) ?  
                    (a + b) : (a - b);
    
endmodule : adder_substracter_bmod