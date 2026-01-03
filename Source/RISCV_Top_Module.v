module RISCV_Top_Module #(
    parameter WIDTH = 32
) (
    input  wire clk,
    input  wire rst
);

    // --- Control Signals ---
    wire       We;
    wire       ALUSrc;
    wire       Data_Sel;
    wire       Data_Sel2;
    wire       PC_sel2;
    wire       jump;
    wire       branch;
    wire       branch_ne;
    wire       mem_R;
    wire       mem_Wr;
    wire [2:0] extnd_sel;
    wire [2:0] ALU_op;

    // --- Data/Instruction Signals ---
    wire [6:0] opcode;
    wire [6:0] funct7;
    wire [2:0] funct3;

    // --- Modules Instantiation ---

    RISCV_DataPath #(
        .WIDTH (WIDTH)
    ) dp (
        .clk       (clk),
        .rst       (rst),
        .We        (We),
        .ALUSrc    (ALUSrc),
        .Data_Sel  (Data_Sel),
        .Data_Sel2 (Data_Sel2),
        .PC_sel2   (PC_sel2),
        .jump      (jump),
        .branch    (branch),
        .branch_ne (branch_ne),
        .mem_R     (mem_R),
        .mem_Wr    (mem_Wr),
        .extnd_sel (extnd_sel),
        .ALU_op    (ALU_op),
        .opcode    (opcode),
        .funct3    (funct3),
        .funct7    (funct7)
    );

    RISCV_Controller ctrl (
        .opcode    (opcode),
        .funct3    (funct3),
        .funct7    (funct7),
        .RegWrite  (We),         // Connected to 'We' wire
        .ALUSrc    (ALUSrc),
        .Data_Sel  (Data_Sel),
        .Data_Sel2 (Data_Sel2),
        .PC_sel2   (PC_sel2),
        .branch    (branch),
        .branch_ne (branch_ne),
        .jump      (jump),
        .mem_Wr    (mem_Wr),
        .mem_R     (mem_R),
        .extnd_sel (extnd_sel),
        .ALU_op    (ALU_op)
    );

endmodule