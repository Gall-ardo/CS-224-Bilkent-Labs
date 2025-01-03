#
# Halil Arda Ozongun ID: 22202709
# CS 224- Lab1 
# Solution of question 1 in preliminary part
#
	

	.data 
askinput: .asciiz "Enter the size of array please: "
asknumber: .asciiz "Enter the array element: "
newline: .asciiz  "\n"
space: .asciiz " "
printinitialarray: .asciiz "Array before changes: "
printfinalarrayword: .asciiz "Array after changes: "
array: .align 4  # Ensure word alignment
       .space 80 # allocate max, 4*20

# t0 -> input, array size
# t1 -> counter, to count the current element. initialize with 0
# t2 -> 4*counter, so it is the current bit in array
# t3 -> array adress
# t4 -> current element in array

.text	j main
main:
	# want number of elements
	li $v0, 4
	la $a0, askinput
    	syscall
    	
    	# read number of elements and store it
    	li $v0, 5
    	syscall
    	move $t0, $v0 # array size in t0
    	
    	# make a counter, take input and count until input size is done.
    	add $t1, $zero, $zero # initialize counter
    	
arrayinput:
	bge $t1, $t0, arrayinputdone # check if array input is done
	
	li $v0, 4
	la $a0, asknumber
    	syscall
    	# take number
    	
    	li $v0, 5
    	syscall
    	# store it in to array
    	# Each integer is 4 bytes, so we calculate the offset as t1 * 4
    	sll $t2, $t1, 2   # t2 = t1 * 4
    	la $t3, array     # load base address of array
    	add $t3, $t3, $t2 # t3 = base + offset
    	sw $v0, 0($t3)    # store the input at array[t1]
    	addi $t1, $t1, 1    	# Increment the counter
	j arrayinput

arrayinputdone:     
	add $t1, $zero, $zero # make counter is zero
	li $v0, 4
	la $a0, printinitialarray
	syscall
	
printarray:
	bge $t1, $t0, swap_part

	sll $t2, $t1, 2 # t2 = t1 * 4 
	la $t3, array     # load base address of array
	add $t3, $t3, $t2 # t3 = base + offset
	lw $a0, 0($t3)    # load the array element into $a0
	
	li $v0, 1         # syscall for print integer
	syscall
	
	li $v0, 4         # syscall for print string
	la $a0, space   # load newline string
	syscall

	addi $t1, $t1, 1 	# increment counter
	j printarray
	
swap_part:
	# t1 is start pointer t5 is end pointer
	li $t1, 0
	addi $t5, $t0, -1 
	
	# print newline
	li $v0, 4
    	la $a0, newline
    	syscall

swaploop:
	bge $t1, $t5, swapdone

	# Load elements at t1 and t5
	sll $t2, $t1, 2
	la $t3, array
	add $t3, $t3, $t2
	lw $t6, ($t3)  # t6 = array[t1]
    
	sll $t2, $t5, 2
	la $t3, array
	add $t3, $t3, $t2
	lw $t7, ($t3)  # t7 = array[t5]
    
	# Swap elements
	sll $t2, $t1, 2
	la $t3, array
	add $t3, $t3, $t2
	sw $t7, ($t3)  # array[t1] = t7
    
	sll $t2, $t5, 2
	la $t3, array
	add $t3, $t3, $t2
	sw $t6, ($t3)  # array[t5] = t6
    
	addi $t1, $t1, 1
	subi $t5, $t5, 1

	j swaploop
	
swapdone:
	li $t1, 0 
	li $v0, 4
	la $a0, printfinalarrayword
	syscall

printfinalarray:
	bge $t1, $t0, exit

	sll $t2, $t1, 2 # t2 = t1 * 4 
	la $t3, array     # load base address of array
	add $t3, $t3, $t2 # t3 = base + offset
	lw $a0, 0($t3)    # load the array element into $a0
	
	li $v0, 1         # syscall for print integer
	syscall
	
	li $v0, 4         # syscall for print string
	la $a0, space   # load newline string
	syscall

	addi $t1, $t1, 1 	# increment counter
	j printfinalarray

exit:
    	li $v0, 4
    	la $a0, newline
    	syscall
    
    	# Exit program
    	li $v0, 10
    	syscall

