module ALU #(
    parameter WIDTH = 32
) (
    input  wire signed [WIDTH-1:0] a,
    input  wire signed [WIDTH-1:0] b,
    input  wire        [2:0]       sel,
    output reg  signed [WIDTH-1:0] y,
    output wire                    Zero
);

    always @(*) begin
        case (sel)
            3'b000:  y = a + b;       // ALU_ADD
            3'b001:  y = a - b;       // ALU_SUB
            3'b010:  y = a & b;       // ALU_AND
            3'b011:  y = a | b;       // ALU_OR
            3'b100: begin             // ALU_SLT
                if (a < b) begin
                    y = {{WIDTH-1{1'b0}}, 1'b1};
                end else begin
                    y = {WIDTH{1'b0}};
                end
            end
            3'b101:  y = a ^ b;       // ALU_XOR
            default: y = {WIDTH{1'b0}};
        endcase
    end

    assign Zero = (y == {WIDTH{1'b0}}) ? 1'b1 : 1'b0;

endmodule