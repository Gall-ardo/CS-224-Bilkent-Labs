#
# Halil Arda Ozongun ID: 22202709
# CS 224- Lab2 
# Solution of question 2 in lab part
#

.data
    prompt: .asciiz "\nEnter a number: "
    original: .asciiz "\nOriginal number: "
    result: .asciiz "\nReversed number: "
    continue_prompt: .asciiz "\nDo you want to continue? (1 for yes, 0 for no): "
    invalid_input: .asciiz "\nInvalid input. Please try again.\n"

.text
.globl main

# s0 -> original number
# s1 -> reversed number

main:
    main_loop:
        li $v0, 4
        la $a0, prompt
        syscall

        li $v0, 5
        syscall
        move $s0, $v0

        li $v0, 4
        la $a0, original
        syscall

        move $a0, $s0
        jal print_hex


        move $a0, $s0
        jal reverse_bits
        move $s1, $v0  # reversed number $s1

        li $v0, 4
        la $a0, result
        syscall

        move $a0, $s1
        jal print_hex

        # Ask wanna continue
        li $v0, 4
        la $a0, continue_prompt
        syscall

        li $v0, 5
        syscall

        beq $v0, 1, main_loop

    	li $v0, 10
    	syscall

reverse_bits: # returns reversed number in v0. a0 is the original number as parameter.
	# put s0 into stack.
	addi $sp, $sp, -4
    	sw $s0, 0($sp)
    	
    	# init iterator in s0
    	li $s0, 0
    	
    	li $v0, 0 # the value we will create
    	
    
    
reverse_loop:
	beq $s0, 32, reverse_finish
	# shift result to left
	sll $v0, $v0, 1
	
	# determine the last bit of input
	andi $s2, $a0, 1
	srl $a0, $a0, 1
	# last value is in s2. now or it with v0
	or $v0, $v0, $s2
	addi $s0, $s0, 1
	
	j reverse_loop
	

reverse_finish:
    	sw $s0, 0($sp) 
	addi $sp, $sp, 4
	jr $ra


print_hex:
    li $v0, 34
    syscall
    jr $ra