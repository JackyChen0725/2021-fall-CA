.globl __start

.rodata

.data
array: .word 0
.text
__start:

    #輸入n
    li a0, 5
    ecall
    mv s0, a0 
    #宣告陣列
    la s1, array
    #宣告array長度
    add s2, x0, x0 
    #設定最後的跳躍位址
    la x1, output 
    j recaman
    
recaman:
    addi sp, sp, -8
    sw s0, 4(sp)
    sw x1, 0(sp)
    bne s0, x0, L1
    add s3, s0, x0 #A0的值
    jalr x0, 0(x1)
L1:
    addi s0, s0, -1
    jal recaman
    lw x1, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    sub t0, s3, s0
    bge x0, t0, Else #An-1 - n <= 0 就跳到Else
    add t1, s0, x0
Loop:
    #尋找前面是否有出現相同的值，若有就跳到Else
    beq t1, x0, End    
    addi t1, t1, -1
    slli t2, t1, 2
    add  t2, s1, t2
    lw t3, 0(t2)
    beq t0, t3, Else
    j Loop
End:
    #值為An-1 - n
    mv s3, t0
    j add_to_array
    
Else:
    #值為An-1 + n
    add s3, s3, s0
    j add_to_array
    
add_to_array:
    #將每個數的對應值存在陣列
    slli t4, s2, 2
    add t4, t4, s1
    sw s3, 0(t4)
    addi s2, s2, 1
    jalr x0, 0(x1)
output: 
    # Output the result
    li a0, 1
    mv a1, s3
    ecall
    li a0, 10
    ecall