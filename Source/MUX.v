module Mux #(
    parameter WIDTH = 32
)(
    input  wire signed [WIDTH-1:0] a,
    input  wire signed [WIDTH-1:0] b,
    input  wire                    sel,
    output reg  signed [WIDTH-1:0] y
);
    always @(*) begin
        case (sel)
            1'b0:    y = a;
            1'b1:    y = b;
            default: y = {WIDTH{1'b0}};
        endcase
    end

endmodule