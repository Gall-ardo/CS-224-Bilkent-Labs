#
# Halil Arda Ozongun ID: 22202709
# CS 224- Lab3
# Solution of lab part question 1
#  
        

                             .data
prompt_Dividend:  .asciiz "\nEnter value for Dividend (0 for exit): "
prompt_Divisor:  .asciiz "\nEnter value for Divisor(0 for exit): "
result:    .asciiz "\nResult of integer division is: "
entered_zero: .asciiz "\nYou entered zero for one of dividend or divison, exiting program"


        .text
        .globl main
main:
    # Prompt for Dividend
    li $v0, 4
    la $a0, prompt_Dividend
    syscall
    li $v0, 5
    syscall
    move $s0, $v0            # store Dividend in $s0
    
    # Prompt for Divisor
    li $v0, 4 
    la $a0, prompt_Divisor  
    syscall
    li $v0, 5  
    syscall
    move $s1, $v0            # store Divisor in $s1
    
    # check if values are zero or not
    beqz $s0, exit
    beqz $s1, exit
    
    # both values are not zero, calculate integer division
    
    move $a0, $s0
    move $a1, $s1
    jal integerDivision
   
    # print the value of quotient
    move $s2, $v0
    
    li $v0, 4
    la $a0, result
    syscall
    
    li $v0, 1
    move $a0, $s2
    syscall
    
    
    j main

# a0 is Dividend
# a1 is Divisor
# v0 is Quotient

integerDivision:
	move $s1, $a1
	move $s0, $a0 
	li $v0, 0
	

recursion:
	addi	$sp, $sp, -8
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)
	
	# do subtraction. if t0 is zero, then it is base case.
	sub $s2, $s0, $s1
	bge  $s2, 0, else
	# here is the base case
	addi $v0, $v0, 0
	jr $ra

else:
	sub $s0, $s0, $s1
	addi $v0, $v0, 1
	jal recursion
	
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	addi	$sp, $sp, 8

	jr	$ra
 
exit:
	li $v0, 4
    	la $a0, entered_zero
    	syscall
    
    	li $v0, 10
    	syscall
