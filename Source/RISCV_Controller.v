module RISCV_Controller (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,

    output reg        RegWrite,
    output reg        ALUSrc,
    output reg        Data_Sel,
    output reg        Data_Sel2,
    output reg        PC_sel2,
    output reg        branch,
    output reg        branch_ne,
    output reg        jump,
    output reg        mem_Wr,
    output reg        mem_R,
    output reg  [2:0] extnd_sel,
    output reg  [2:0] ALU_op
);

    parameter [6:0] OP_R       = 7'b0110011;
    parameter [6:0] OP_I_ARITH = 7'b0010011;
    parameter [6:0] OP_LOAD    = 7'b0000011;
    parameter [6:0] OP_STORE   = 7'b0100011;
    parameter [6:0] OP_BRANCH  = 7'b1100011;
    parameter [6:0] OP_JALR    = 7'b1100111;
    parameter [6:0] OP_JAL     = 7'b1101111;
    parameter [6:0] OP_LUI     = 7'b0110111;

    parameter [2:0] ALU_ADD    = 3'b000;
    parameter [2:0] ALU_SUB    = 3'b001;
    parameter [2:0] ALU_AND    = 3'b010;
    parameter [2:0] ALU_OR     = 3'b011;
    parameter [2:0] ALU_SLT    = 3'b100;
    parameter [2:0] ALU_XOR    = 3'b101;

    always @(*) begin
        RegWrite  = 1'b0;
        ALUSrc    = 1'b0;
        ALU_op    = ALU_ADD;
        extnd_sel = 3'd0;
        Data_Sel  = 1'b0;
        Data_Sel2 = 1'b0;
        PC_sel2   = 1'b0;
        jump      = 1'b0;
        branch    = 1'b0;
        branch_ne = 1'b0;
        mem_Wr    = 1'b0;
        mem_R     = 1'b0;

        case (opcode)
            OP_R: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b0;
                
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: ALU_op = ALU_ADD;
                    {7'b0100000, 3'b000}: ALU_op = ALU_SUB;
                    {7'b0000000, 3'b111}: ALU_op = ALU_AND;
                    {7'b0000000, 3'b110}: ALU_op = ALU_OR;
                    {7'b0000000, 3'b010}: ALU_op = ALU_SLT;
                    default:              ALU_op = ALU_ADD;
                endcase
            end

            OP_I_ARITH: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                extnd_sel = 3'd0;

                case (funct3)
                    3'b000:  ALU_op = ALU_ADD;
                    3'b110:  ALU_op = ALU_OR;
                    3'b010:  ALU_op = ALU_SLT;
                    3'b100:  ALU_op = ALU_XOR;
                    default: ALU_op = ALU_ADD;
                endcase
            end

            OP_LOAD: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                extnd_sel = 3'd0;
                Data_Sel  = 1'b1;
                ALU_op    = ALU_ADD;
                mem_R     = 1'b1;
            end

            OP_JALR: begin
                Data_Sel2 = 1'b1;
                RegWrite  = 1'b1;
                extnd_sel = 3'd0;
                ALUSrc    = 1'b1;
                PC_sel2   = 1'b1;
                ALU_op    = ALU_ADD;
            end

            OP_STORE: begin
                ALUSrc    = 1'b1;
                ALU_op    = ALU_ADD;
                extnd_sel = 3'b001;
                mem_Wr    = 1'b1;
            end

            OP_JAL: begin
                Data_Sel2 = 1'b1;
                extnd_sel = 3'b100;
                RegWrite  = 1'b1;
                jump      = 1'b1;
            end

            OP_BRANCH: begin
                ALU_op    = ALU_SUB;
                extnd_sel = 3'b010;
                branch    = 1'b1;
                if (funct3 == 3'b001) begin
                    branch_ne = 1'b1; // bne
                end
            end

            OP_LUI: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                extnd_sel = 3'b011;
                ALU_op    = ALU_ADD;
            end
        endcase
    end

endmodule