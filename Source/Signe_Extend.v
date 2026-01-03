module Sgn_Extend #(
    parameter WIDTH = 32
) (
    input  wire        [WIDTH-1:0] in,
    input  wire        [2:0]       sel,
    output reg  signed [WIDTH-1:0] out
);

    wire signed [WIDTH-1:0] imm_I;
    wire signed [WIDTH-1:0] imm_S;
    wire signed [WIDTH-1:0] imm_B;
    wire signed [WIDTH-1:0] imm_U;
    wire signed [WIDTH-1:0] imm_J;

    // I-type: Sign-extend 12-bit immediate
    assign imm_I = {{20{in[31]}}, in[31:20]};

    // S-type: Sign-extend 12-bit immediate (split)
    assign imm_S = {{20{in[31]}}, in[31:25], in[11:7]};

    // B-type: Sign-extend 13-bit immediate (SB format)
    assign imm_B = {{19{in[31]}}, in[31], in[7], in[30:25], in[11:8], 1'b0};

    // U-type: Upper 20 bits
    assign imm_U = {in[31:12], 12'b0};

    // J-type: Sign-extend 21-bit immediate (UJ format)
    assign imm_J = {{11{in[31]}}, in[31], in[19:12], in[20], in[30:21], 1'b0};

    always @(*) begin
        case (sel)
            3'b000:  out = imm_I;
            3'b001:  out = imm_S;
            3'b010:  out = imm_B;
            3'b011:  out = imm_U;
            3'b100:  out = imm_J;
            default: out = {WIDTH{1'b0}};
        endcase
    end

endmodule