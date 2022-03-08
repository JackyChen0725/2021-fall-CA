.globl __start

.rodata
    Jumptable: .word L0, L1, L2, L3, L4, L5, L6
    division_by_zero: .string "division by zero"
    remainder_by_zero: .string "remainder by zero"

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0

    slt t3, s1, x0;
    bne t3, x0, exit;
    slti t3, s1, 7;
    beq t3, x0, exit;
    la t4, Jumptable;
    slli t5, s1, 2;
    add t5, t5, t4;
    lw t6, 0(t5);
    jr t6; 
    
    
# todo    
L0:   add s3, s0, s2;
      j output;
    
L1:   sub s3, s0, s2;
      j output;
    
L2:   MUL s3, s0, s2;
      j output;
    
L3:   beq s2, x0, division_by_zero_except;
      DIV s3, s0, s2;
      j output;

L4:   beq s2, x0, remainder_by_zero_except;
      DIV s4, s0, s2;
      MUL s4, s2, s4;
      sub s3, s0, s4;
      j output;
    
L5:   beq s2, x0, set_1;
      addi s5, x0, 1;
      add s3, s0, x0;
loop1:beq s2, s5, output;
      MUL s3, s3, s0;
      addi s2, s2, -1;
      j loop1;
      
L6:   beq s0, x0, set_1;
      add s5, s0, x0;
      add s3, s0, x0;
loop2:addi s5, s5, -1;
      beq s5, x0, output;
      MUL s3, s3, s5;
      j loop2;                 
    

set_1: addi s3, s3, 1;
       j output;

#end
output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    jal zero, exit

remainder_by_zero_except:
    li a0, 4
    la a1, remainder_by_zero
    ecall
    jal zero, exit