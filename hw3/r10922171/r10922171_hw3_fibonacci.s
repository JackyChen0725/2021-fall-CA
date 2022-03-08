.globl __start

.rodata

.text
__start:
    li a0, 5
    ecall
    blt a0, x0, Exit #input為負數
    la x1, output
    j fibonacci
    
fibonacci:
    addi sp, sp, -12
    sw x1, 8(sp)
    sw s1, 4(sp)
    sw a0, 0(sp)
    addi t0, x0, 1
    blt t0, a0, L1
    add s2, a0, x0
    addi sp, sp, 12
    jalr x0,0(x1)
L1: addi a0, a0, -1
    jal x1, fibonacci
    add s1, s2, x0 #s1 = F(n-1)
    addi a0, a0, -1
    jal x1, fibonacci
    add s2, s2, s1 #s2:F(n) = F(n-2) + F(n-1)
    lw a0, 0(sp)
    lw s1, 4(sp)
    lw x1, 8(sp)
    addi sp, sp, 12
    jalr x0,0(x1)
    
output: 
    # Output the result
    li a0, 1
    mv a1, s2
    ecall
    li a0, 10
    ecall

Exit:
    #input為負數 或 執行完畢
    li a0, 10
    ecall
    