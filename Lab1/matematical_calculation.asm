# Halil Arda Ozongun ID: 22202709
# CS 224- Lab1
# Solution of question 3 in lab part
        .data
prompt_B:  .asciiz "Enter value for B: "
prompt_C:  .asciiz "Enter value for C: "
prompt_D:  .asciiz "Enter value for D: "
result:    .asciiz "Result of ((b*c)modd) / (b-c) is: "
error_msg: .asciiz "Error: Division by zero. Please enter new values.\n"
error_mod: .asciiz "Error: Mod by zero. Please enter new values.\n"

# $s0 -> B
# $s1 -> C
# $s2 -> D
# ((b*c)modd) / (b-c)

        .text
        .globl main
main:
    # Prompt for B
    li $v0, 4
    la $a0, prompt_B
    syscall
    li $v0, 5
    syscall
    move $s0, $v0            # store B in $s0
    
    # Prompt for C
    li $v0, 4 
    la $a0, prompt_C     
    syscall
    li $v0, 5  
    syscall
    move $s1, $v0            # store C in $s1
    
    # Prompt for D
    li $v0, 4        
    la $a0, prompt_D     
    syscall
    li $v0, 5
    syscall
    move $s2, $v0            # store D in $s2
    
    # Check if D is zero
    beqz $s2, mod_by_zero_error
    
    # calculation is: ((b*c)modd) / (b-c) 
    
    # Step 1: Calculate b * c
    mult $s0, $s1        # $s0 * $s1, result in hi:lo
    mflo $t0             # $t0 = b * c (assuming result fits in 32 bits)
    
    # Step 2: Calculate (b*c) mod d
    div $t0, $s2         # (b*c) / d
    mfhi $t1             # $t1 = (b*c) mod d
    
    # Step 3: Calculate b - c
    sub $t2, $s0, $s1    # $t2 = b - c
    
    # Check if (b-c) is zero
    beqz $t2, division_by_zero_error
    
    # Step 4: Calculate ((b*c)modd) / (b-c)
    div $t1, $t2         # ((b*c)modd) / (b-c)
    mflo $t0             # $t0 = final result
    
    # print and finish
    li $v0, 4
    la $a0, result
    syscall
 
    li $v0, 1         
    move $a0, $t0
    syscall
    j exit

division_by_zero_error:
    li $v0, 4
    la $a0, error_msg
    syscall
    j main  # Restart the program
    
mod_by_zero_error:
    li $v0, 4
    la $a0, error_mod
    syscall
    j main 
 
exit:
    li $v0, 10
    syscall