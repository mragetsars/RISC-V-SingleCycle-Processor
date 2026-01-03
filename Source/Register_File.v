module Register_File #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5
) (
    input  wire                         clk,
    input  wire                         rst,
    input  wire                         w_en,
    input  wire        [ADDR_WIDTH-1:0] writeAddr,
    input  wire        [ADDR_WIDTH-1:0] readAddr1,
    input  wire        [ADDR_WIDTH-1:0] readAddr2,
    input  wire signed [DATA_WIDTH-1:0] writeData,
    output reg  signed [DATA_WIDTH-1:0] readData1,
    output reg  signed [DATA_WIDTH-1:0] readData2
);

    reg signed [DATA_WIDTH-1:0] data [0:(1<<ADDR_WIDTH)-1];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin
                data[i] <= {DATA_WIDTH{1'b0}};
            end
        end else if (w_en && (writeAddr != {ADDR_WIDTH{1'b0}})) begin
            data[writeAddr] <= writeData;
        end
    end

    always @(*) begin
        if (readAddr1 == {ADDR_WIDTH{1'b0}}) begin
            readData1 = {DATA_WIDTH{1'b0}};
        end else begin
            readData1 = data[readAddr1];
        end

        if (readAddr2 == {ADDR_WIDTH{1'b0}}) begin
            readData2 = {DATA_WIDTH{1'b0}};
        end else begin
            readData2 = data[readAddr2];
        end
    end

endmodule