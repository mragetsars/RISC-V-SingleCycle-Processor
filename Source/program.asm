    addi x5, x0, 0 //i=0 
    addi x20, x0, 19 // i < 19 

outer_loop: 
    slt x21, x5, x20 
    beq x21, x0, outer_done 

    addi x6, x0, 0 // j=0 
    addi x22, x0, 19 // j < 19 
    sub  x22, x22, x5 // j< 19-i 

inner_loop: 
    slt x23, x6, x22 
    beq x23, x0, inner_done 

    add x24, x6, x6 
    add x24, x24, x24 
    add x24, x24, x10 // x24 = addr + 4j 

    lw x25, 0(x24) // x25 = a[j] 
    lw x26, 4(x24)  // x25 = a[j+1] 

    slt x27, x26, x25 
    beq x27, x0, no_swap 

    sw x26, 0(x24) 
    sw x25, 4(x24) 

no_swap: 
    addi x6, x6, 1 // j++ 
    jal x0, inner_loop 

inner_done: 
    addi x5, x5, 1         // i++ 
    jal  x0, outer_loop   // برگشت به حلقه بیرونی

outer_done: 
        nop   // (addi x0, x0, 0) 