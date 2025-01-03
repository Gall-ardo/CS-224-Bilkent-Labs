#
# Halil Arda Ozongun ID: 22202709
# CS 224- Lab3
# Solution of preliminary part question 2
#

		.data
prompt: .asciiz "\nEnter a register number (0-31), or a number outside the range to exit: "
result: .asciiz "\nThe register was used this number of times: "

	.text
.globl main

main:
        li $v0, 4
        la $a0, prompt
        syscall
        li $v0, 5
        syscall
        move $a0, $v0
        
        bltz $a0, exit    # Exit if less than 0
        bgt $a0, 31, exit # Exit if greater than 31
        
        # load addresses
        la $a1, count_register_usage  # Start address
        la $a2, end_flag             # End address
        
        # a0-> register num. a1-> start adress a2->end adress
        jal count_register_usage
        
        move $t0, $v0
        
        li $v0, 4
        la $a0, result
        syscall
        
        li $v0, 1
        move $a0, $t0
        syscall
        
        j main  # stay until invalid input
exit:
        li $v0, 10
        syscall
    
count_register_usage:
# a0-> register num. a1-> start adress a2->end adress
# v0 -> number of used of a0
        
        addi $sp, $sp, -32
        sw $ra, 28($sp)
        sw $s0, 24($sp)
        sw $s1, 20($sp)
        sw $s2, 16($sp)
        sw $s3, 12($sp)
        sw $s4, 8($sp)
        sw $s5, 4($sp)
        sw $s6, 0($sp)
        move $s0, $a0    # register to search
        move $s1, $a1    # Start address
        move $s2, $a2    # End address
        li $s3, 0        # Counter
        
        
loop:
        beq $s1, $s2, done
        
        # Load instruction and take 26-31 to s5
        lw $s4, 0($s1)
        srl $s5, $s4, 26
    
        beqz $s5, count_r_type
        beq $s5, 2, before_count # if j reguster -> not exist
        beq $s5, 3, before_count
        j count_i_type # if it is not 0,2,3 it is I
        
count_r_type:
        # Check rs (bits 21-25)
        srl $s6, $s4, 21
        andi $s6, $s6, 0x1F
        bne $s6, $s0, r_check_rt
        addi $s3, $s3, 1
        
r_check_rt:
        # Check rt (bits 16-20)
        srl $s6, $s4, 16
        andi $s6, $s6, 0x1F
        bne $s6, $s0, r_check_rd
        addi $s3, $s3, 1
        
r_check_rd:
        # Check rd (bits 11-15)
        srl $s6, $s4, 11
        andi $s6, $s6, 0x1F
        bne $s6, $s0, before_count
        addi $s3, $s3, 1
        j before_count
        
count_i_type:
        # Check rs (bits 21-25)
        srl $s6, $s4, 21 
        andi $s6, $s6, 0x1F
        bne $s6, $s0, i_check_rt
        addi $s3, $s3, 1
        
i_check_rt:
        # Check rt (bits 16-20)
        srl $s6, $s4, 16
        andi $s6, $s6, 0x1F
        bne $s6, $s0, before_count
        addi $s3, $s3, 1
        j before_count
        
before_count:
        addi $s1, $s1, 4 # increment program counter
        j loop
done:
        #  save result to v0
        move $v0, $s3
        
        lw $ra, 28($sp)
        lw $s0, 24($sp)
        lw $s1, 20($sp)
        lw $s2, 16($sp)
        lw $s3, 12($sp)
        lw $s4, 8($sp)
        lw $s5, 4($sp)
        lw $s6, 0($sp)
        addi $sp, $sp, 32
        
        jr $ra
end_flag: