#
# Halil Arda Ozongun ID: 22202709
# CS 224- Lab3
# Solution of lab part question 2: printing list in reverse order program
#

.data
askSize: .asciiz "\nEnter size of linkedlist please: "
enterKey: .asciiz "\nEnter key of node please: "
enterVal: .asciiz "\nEnter value of node please: "
printKey: .asciiz "\nKey: "
printVal: .asciiz "\nValue: "
newline: .asciiz "\n"
originalList: .asciiz "\nOriginal list:\n"
reversedList: .asciiz "\nReversed list:\n"

# s0 -> size of the linkedlist in main
# s1 -> the address of root

.text
.globl main

main:
	# learn the length
	li $v0, 4
    	la $a0, askSize
    	syscall
    	li $v0, 5
    	syscall
    	move $s0, $v0
    	
    	move $a0, $s0
    	jal createLinkedList
    	
	# store the returned list head
    	move $s1, $v0
    	
    	move $a0, $s1
	jal printLinkedList
	
	# Print reversed list
    	li $v0, 4
    	la $a0, reversedList
    	syscall
    
    	move $a0, $s1
    	jal printReverse
	
	# end program
	li $v0, 10
    	syscall
    	

printReverse:
    # $a0 contains the address of the current node
    
    # Base case: if the current node is null, return
    beqz $a0, end_printReverse
    
    # Save registers
    addi $sp, $sp, -12
    sw   $ra, 8($sp)
    sw   $s0, 4($sp)
    sw   $a0, 0($sp)
    
    lw   $a0, 0($a0)  # Load address of next node
    jal  printReverse
    
    lw   $s0, 0($sp)
    
    li   $v0, 4
    la   $a0, printKey
    syscall
    
    lw   $a0, 4($s0)
    li   $v0, 1
    syscall
    
    li   $v0, 4
    la   $a0, printVal
    syscall
    
    lw   $a0, 8($s0)
    li   $v0, 1
    syscall
    
    li   $v0, 4
    la   $a0, newline
    syscall
    
    lw   $ra, 8($sp)
    lw   $s0, 4($sp)
    addi $sp, $sp, 12
    
end_printReverse:
    jr   $ra

	
createLinkedList:
# a0 -> size of list we will create
# v0 -> returns list head
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 
	
	move	$s0, $a0	# $s0: number of nodes
	
# Create the first node: header.
	li	$a0, 12
	li	$v0, 9
	syscall
	
	move $s2, $v0    # $s2: address of current node
    	move $s3, $v0    # $s3: always adress of the head
    	
    	# take 'n store root's key
    	li $v0, 4
    	la $a0, enterKey
    	syscall
    	li $v0, 5
    	syscall
    	sw $v0, 4($s2) 
    	
    	 # take 'n store root's value
    	li $v0, 4
    	la $a0, enterVal
    	syscall
    	li $v0, 5
    	syscall
    	sw $v0, 8($s2)  
    	
    	li $s1, 1 # create iterator

addNode:
	beq	$s1, $s0, allDone

	li	$a0, 12
	li	$v0, 9
	syscall
	
	sw $v0, 0($s2) # save prev nodes adress (s2) to the curr node
	
	move $s2, $v0 # save curr node adress to s2
	
	# read array key
	li $v0, 4
    	la $a0, enterKey
    	syscall
    	li $v0, 5
    	syscall 
    	sw $v0, 4($s2)
    	
  
    	# read array value
    	li $v0, 4
    	la $a0, enterVal
    	syscall
    	li $v0, 5
    	syscall 
    	sw $v0, 8($s2)
   		
	addi $s1, $s1, 1
	j	addNode
	
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	

	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra


printLinkedList:
# a0 -> adress of head

	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 
	
	move $s0, $a0	# $s0: points to the current node.
	li   $s4, 0

printNextNode:
	beq	$s0, $zero, printedAll
		
	# do print staff
	li $v0, 4
    	la $a0, printKey
    	syscall
    	lw $a0, 4($s0)
    	li $v0, 1
    	syscall

    	# Print Value
    	li $v0, 4
    	la $a0, printVal
    	syscall
    	lw $a0, 8($s0)
    	li $v0, 1
    	syscall
	
	li $v0, 4
    	la $a0, newline
 	syscall
	
	lw	$s1, 0($s0)	# $s1: Address of  next node
	move 	$s0, $s1
	addi	$s4, $s4, 1
	j printNextNode
	
printedAll:

	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
