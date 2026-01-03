module Adder #(
    parameter WIDTH = 32
) (
    input  wire signed [WIDTH-1:0] a,
    input  wire signed [WIDTH-1:0] b,
    output wire signed [WIDTH-1:0] y
);

    assign y = a + b;

endmodule