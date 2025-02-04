#
# Halil Arda Ozongun ID: 22202709
# CS 224- Lab3
# Solution of preliminary part question 1
#


.data
askSize: .asciiz "\nEnter size of linkedlist please: "
enterKey: .asciiz "\nEnter key of node please: "
enterVal: .asciiz "\nEnter value of node please: "
printKey: .asciiz "\nKey: "
printVal: .asciiz "\nValue: "
printNext: .asciiz "\nNext: "
newline: .asciiz "\n"
processPrint: .asciiz "\nThe list is processed. Here is the new list:\n"

# s0 -> size of the arraylist in main
# s1 -> the address of root
# s2 -> final array adress

.text

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
	
	li $v0, 4
	la $a0, processPrint
	syscall
	
	# after taking input, process
	move $a0, $s1
	jal processArray
	move $s2, $v0

	# print the sum linkedlist
    	move $a0, $s2
	jal printLinkedList
	
	# end program
	li $v0, 10
    	syscall
    	

processArray:    
# take a0 as arguement, the adress of the first array
# v0 is the final array adress

# s0 -> curr node in input list
# s1 -> curr of return list
# s2 -> head of return list
# s3 -> key
# s4 -> value

        addi $sp, $sp, -28
        sw $s0, 24($sp)
        sw $s1, 20($sp)
        sw $s2, 16($sp)
        sw $s3, 12($sp)
        sw $s4, 8($sp)
        sw $s5, 4($sp)
        sw $ra, 0($sp) 
        
        move $s0, $a0  # s0 points to the current node of input list

        # Create the first node of the summary list
        li $a0, 12
        li $v0, 9
        syscall
        move $s1, $v0  # iterator
        move $s2, $v0  # s2 holds head of result
        
        # Initialize the first node
        lw $s3, 4($s0)
        lw $s4, 8($s0)
        sw $s3, 4($s1)
        sw $s4, 8($s1)
        sw $zero, 0($s1)

        lw $s0, 0($s0)  # Move to the next input node

processLoop:
        beqz $s0, endProcess  # check if it is the last node (is it 0)

        # means it is not last node, cont
        lw $s3, 4($s0)
        lw $s4, 4($s1)

        beq $s3, $s4, sameWithPrev # add if keys are same
        
        # means keys are different-> create next node
        
        # create new node
        li $a0, 12 
        li $v0, 9
        syscall
        sw $v0, 0($s1)  # Link new node to prev
        move $s1, $v0   # Move s1 to the new node
        
        lw $s3, 4($s0)
        lw $s4, 8($s0)
        sw $s3, 4($s1)
        sw $s4, 8($s1)
        sw $zero, 0($s1) # Set the next pointer to null
        
        lw $s0, 0($s0)   # Move to next input node
        j processLoop
        
sameWithPrev:
        lw $s4, 8($s0) 
        lw $s3, 8($s1) 
        add $s3, $s3, $s4
        sw $s3, 8($s1)
        lw $s0, 0($s0)
        j processLoop
        
endProcess:
        move $v0, $s2    # Return the head of the summary list in v0

        lw $ra, 0($sp)
        lw $s5, 4($sp)
        lw $s4, 8($sp)
        lw $s3, 12($sp)
        lw $s2, 16($sp)
        lw $s1, 20($sp)
        lw $s0, 24($sp)
        addi $sp, $sp, 28
        jr $ra

	
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
