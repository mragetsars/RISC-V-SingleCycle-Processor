module Instr_Mem #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter MEM_DEPTH  = 32,
    parameter MEM_PATH   = "program.mem"
)(
    input  wire [ADDR_WIDTH-1:0] Addr,
    output reg  [DATA_WIDTH-1:0] Instr
);

    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    initial begin
        if (MEM_PATH != "") begin
            $readmemh(MEM_PATH, mem);
        end
    end

    always @(*) begin
        Instr = mem[Addr[ADDR_WIDTH-1:2]];
    end

endmodule