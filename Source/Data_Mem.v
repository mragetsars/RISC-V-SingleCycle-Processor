module Data_Mem #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter MEM_DEPTH  = 256,
    parameter MEM_PATH   = "data.mem"
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire                  r_en,
    input  wire                  w_en,
    input  wire [ADDR_WIDTH-1:0] Addr,
    input  wire [DATA_WIDTH-1:0] writeData,
    output reg  [DATA_WIDTH-1:0] readData
);

    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    initial begin
        if (MEM_PATH != "") begin
            $readmemh(MEM_PATH, mem);
        end
    end

    // Write Logic (Synchronous)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Memory is typically not reset in hardware to save area.
            // If needed, a loop can be added here for simulation.
        end else if (w_en) begin
            mem[Addr[ADDR_WIDTH-1:2]] <= writeData;
        end
    end

    // Read Logic (Combinational)
    always @(*) begin
        if (r_en) begin
            readData = mem[Addr[ADDR_WIDTH-1:2]];
        end else begin
            readData = {DATA_WIDTH{1'b0}};
        end
    end

endmodule