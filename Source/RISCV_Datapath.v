module RISCV_DataPath #(
    parameter WIDTH = 32
) (
    input  wire              clk,
    input  wire              rst,

    input  wire              We,
    input  wire              ALUSrc,
    input  wire              Data_Sel,
    input  wire              Data_Sel2,
    input  wire              PC_sel2,
    input  wire              jump,
    input  wire              branch,
    input  wire              branch_ne,
    input  wire              mem_R,
    input  wire              mem_Wr,
    input  wire [2:0]        extnd_sel,
    input  wire [2:0]        ALU_op,

    output wire [6:0]        opcode,
    output wire [2:0]        funct3,
    output wire [6:0]        funct7
);

    // Internal Signals
    wire        [WIDTH-1:0]       addr;
    wire        [WIDTH-1:0]       instr;
    wire        [WIDTH-1:0]       next;
    wire        [WIDTH-1:0]       new_addr;
    wire        [WIDTH-1:0]       mux_Pc1_out;
    wire        [WIDTH-1:0]       imm_Pc;
    
    wire signed [WIDTH-1:0]       readData1;
    wire signed [WIDTH-1:0]       readData2;
    wire signed [WIDTH-1:0]       writeData;
    wire signed [WIDTH-1:0]       alu_out;
    wire signed [WIDTH-1:0]       mux_mem1_out;
    wire signed [WIDTH-1:0]       ALU_in;
    wire signed [WIDTH-1:0]       mem_Data;
    wire signed [WIDTH-1:0]       imm;
    
    wire        [4:0]             rs1;
    wire        [4:0]             rs2;
    wire        [4:0]             rd;
    
    wire                          Zero;
    wire                          PC_sel;
    wire        [WIDTH-1:0]       alu_out_jalr;

    // --- Logic Assignments ---
    assign alu_out_jalr = {alu_out[WIDTH-1:1], 1'b0};
    assign PC_sel       = jump || ((Zero ^ branch_ne) && branch);

    // --- Modules Instantiation ---

    Register #(
        .WIDTH (WIDTH)
    ) pc_reg (
        .clk  (clk),
        .rst  (rst), 
        .in   (next),
        .out  (addr)
    );

    Adder #(
        .WIDTH (WIDTH)
    ) pc_adder (
        .a (32'd4),
        .b (addr),
        .y (new_addr)
    );

    Instr_Mem #(
        .DATA_WIDTH (WIDTH),
        .ADDR_WIDTH (WIDTH)
    ) inst_mem (
        .Addr  (addr),
        .Instr (instr)
    );
     
    Decode_type #(
        .INSTR_WIDTH (WIDTH)
    ) decoder (
        .Instr  (instr),
        .opcode (opcode),
        .rd     (rd),
        .funct3 (funct3),
        .rs1    (rs1),
        .rs2    (rs2),
        .funct7 (funct7) 
    );

    Sgn_Extend #(
        .WIDTH (WIDTH)
    ) extender (
        .in  (instr),
        .sel (extnd_sel),
        .out (imm)
    );

    Register_File #(
        .DATA_WIDTH (WIDTH),
        .ADDR_WIDTH (5)
    ) register_file (
        .clk       (clk),
        .rst       (rst),
        .w_en      (We),         
        .writeAddr (rd),
        .readAddr1 (rs1),
        .readAddr2 (rs2),
        .writeData (writeData),
        .readData1 (readData1),
        .readData2 (readData2)
    );

    Data_Mem #(
        .DATA_WIDTH (WIDTH),
        .ADDR_WIDTH (WIDTH),
        .MEM_DEPTH  (256)
    ) data_memory (
        .clk       (clk),
        .rst       (rst),
        .r_en      (mem_R),     
        .w_en      (mem_Wr),    
        .Addr      (alu_out),
        .writeData (readData2),  
        .readData  (mem_Data)
    );

    Mux #(
        .WIDTH (WIDTH)
    ) mux_alu_src (
        .a   (readData2),
        .b   (imm),
        .sel (ALUSrc),
        .y   (ALU_in)
    );

    Mux #(
        .WIDTH (WIDTH)
    ) mux_mem_data (
        .a   (alu_out),
        .b   (mem_Data),
        .sel (Data_Sel),
        .y   (mux_mem1_out)
    );

    Mux #(
        .WIDTH (WIDTH)
    ) mux_write_back (
        .a   (mux_mem1_out),
        .b   (new_addr),
        .sel (Data_Sel2),
        .y   (writeData)
    );

    Mux #(
        .WIDTH (WIDTH)
    ) mux_pc_source (
        .a   (new_addr),
        .b   (imm_Pc),
        .sel (PC_sel),
        .y   (mux_Pc1_out)
    );

    Mux #(
        .WIDTH (WIDTH)
    ) mux_pc_next (
        .a   (mux_Pc1_out),
        .b   (alu_out_jalr),
        .sel (PC_sel2),
        .y   (next)
    );

    Adder #(
        .WIDTH (WIDTH)
    ) branch_adder (
        .a (imm),
        .b (addr),
        .y (imm_Pc)
    );

    ALU #(
        .WIDTH (WIDTH)
    ) main_alu (
        .a    (readData1),
        .b    (ALU_in),
        .sel  (ALU_op),
        .y    (alu_out),
        .Zero (Zero)
    );

endmodule