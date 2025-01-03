#
# Halil Arda Ozongun ID: 22202709
# CS 224- Lab1 
# Solution of question 2 in preliminary part
#
		.data

prompt_B:  .asciiz "Enter value for B: "
prompt_C:  .asciiz "Enter value for C: "
prompt_D:  .asciiz "Enter value for D: "
result:    .asciiz "Result is: "

# $s0 -> B
# $s1 -> C
# $s2 -> D

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


    # calculation is: A= (B / C + D Mod B - C ) / B and then print A
    
    # B/C
    move $a0, $s0
    move $a1, $s1
    jal divide
    # hold B/C in t0
    move $t0, $v0

    # D Mod B
    move $a0, $s2
    move $a1, $s0
    jal mod
    # hold D Mod B in t1
    move $t1, $v0

    # B/C + D Mod B
    add $t0, $t0, $t1
    
    # (B/C + D Mod B) - C
    sub $t0, $t0, $s1

    # ((B/C + D Mod B - C) / B)
    move $a0, $t0
    move $a1, $s0
    jal divide
    move $t0, $v0

    # print and finish
    li $v0, 4
    la $a0, result
    syscall 
    li $v0, 1                
    move $a0, $t0
    syscall
    li $v0, 10
    syscall
    
    
mod: # this function takes a mod b, a is in $a0, $a1 and returns to the answer into $v0
	move $v0, $a0
mod_loop:
	blt $v0, $a1, mode_done
	sub $v0, $v0, $a1
	j mod_loop
mode_done:
	jr $ra



divide: # this function takes a / b, a is in $a0, $a1 and returns to the quotient into v0 and remaining into v1
	li $v0, 0 # quotient to 0
	move $t0, $a0

divide_loop:
	blt $t0, $a1, divide_done
	sub $t0, $t0, $a1
	addi $v0, $v0, 1
	j divide_loop


divide_done:
	jr $ra
