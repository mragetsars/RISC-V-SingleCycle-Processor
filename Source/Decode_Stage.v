module Decode_type #(
    parameter INSTR_WIDTH = 32
) (
    input  wire [INSTR_WIDTH-1:0] Instr,
    output reg  [6:0]             opcode,
    output reg  [4:0]             rd,
    output reg  [2:0]             funct3,
    output reg  [4:0]             rs1,
    output reg  [4:0]             rs2,
    output reg  [6:0]             funct7
);

    parameter [6:0] OP_LUI = 7'b0110111;

    always @(*) begin
        // Default assignments
        opcode = Instr[6:0];
        rd     = Instr[11:7];
        funct3 = Instr[14:12];
        rs1    = Instr[19:15];
        rs2    = Instr[24:20];
        funct7 = Instr[31:25];

        // Specific override for LUI
        if (opcode == OP_LUI) begin
            rs1 = 5'd0;
        end
    end

endmodule