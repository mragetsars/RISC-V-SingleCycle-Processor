`timescale 1ns/1ns
module tb_RiscV_Top;

    localparam WIDTH = 32;
    localparam MEM_DEPTH = 256;

    reg clk;
    reg rst;
    
    integer file_handle;
    integer i;

    // DUT Instantiation
    RISCV_Top_Module #(
        .WIDTH (WIDTH)
    ) uut (
        .clk (clk),
        .rst (rst)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus & File Dump
    initial begin
        rst = 1;
        #20;
        rst = 0;

        repeat (10000) @(posedge clk);

        file_handle = $fopen("data_mem_output.txt", "w");
        
        if (file_handle) begin
            $display("Writing Data Memory to file...");
            
            for (i = 0; i < MEM_DEPTH; i = i + 1) begin
              // "Addr %0d : %h", i,
                $fdisplay(file_handle, "%h", uut.dp.data_memory.mem[i]);
            end
            
            $fclose(file_handle);
            $display("Memory dump completed: data_mem_output.txt");
        end else begin
            $display("Error: Could not open file for writing.");
        end

        $stop;
    end

endmodule