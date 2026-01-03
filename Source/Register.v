module Register #(
    parameter             WIDTH = 32,
    parameter [WIDTH-1:0] INIT  = {WIDTH{1'b0}}
) (
    input  wire             clk,
    input  wire             rst,
    input  wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);
    reg [WIDTH-1:0] data;

    initial data = INIT;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data <= {WIDTH{1'b0}};
        end else begin
            data <= in;
        end
    end

    assign out = data;

endmodule