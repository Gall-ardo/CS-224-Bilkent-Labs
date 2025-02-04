
#
# Halil Arda Ozongun ID: 22202709
# CS 224- Lab2 
# Solution of preliminary part
#

.data
    FreqTable: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    promptSize: .asciiz "Enter the size of the array: "
    promptElement: .asciiz "Enter an integer: "
    newline: .asciiz "\n"
    space: .asciiz " "
    freqMessage: .asciiz "Frequency table:\n"
    numberMessage: .asciiz "Number "
    colonMessage: .asciiz ": "
    
#  s0 -> array size
#  s1 -> array address
.text
    .globl main
main:
    jal CreateArray # array address -> v0,  size -> v1
    move $s0, $v1
    move $s1, $v0
    
    la $a2, FreqTable
    # give arguments in a0 -> array size a1-> address a2-> freq table
    move $a0, $s0
    move $a1, $s1
    # it returns freq table's address in v0
    jal FindFreq
    
    # Print frequency table
    la $s2, FreqTable
    li $s3, 0
    
    li $v0, 4
    la $a0, freqMessage
    syscall
    
print_loop:
    beq $s3, 11, print_done
    
    li $v0, 4
    la $a0, numberMessage
    syscall
    
    li $v0, 1
    move $a0, $s3
    syscall
    
    li $v0, 4
    la $a0, colonMessage
    syscall
    
    li $v0, 1
    lw $a0, 0($s2)
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    addi $s3, $s3, 1
    addi $s2, $s2, 4  # add the address counter
    j print_loop
    
print_done:
    # Exit program
    li $v0, 10
    syscall

FindFreq: 
    #arguments in a0 -> array size a1-> address a2-> freq table
    addi $sp, $sp, -28
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    
    move $s0, $a0 #size
    move $s1, $a1 #address
    move $s2, $a2 #freqtable
    li $s3, 0 # iterator
 
finding_loop:
    beq $s3, $s0, finding_finished
    # load the current array value
    lw $s4, 0($s1)
    bgt $s4, 9, numbersNotListed
    
    sll $s5, $s4, 2
    add $s5, $s5, $s2
    lw $a0, 0($s5)
    addi $a0, $a0, 1
    sw $a0, 0($s5)
    
    j next_iteration

numbersNotListed:
    lw $a0, 40($s2) 
    addi $a0, $a0, 1
    sw $a0, 40($s2)

next_iteration:
    addi $s3, $s3, 1 
    addi $s1, $s1, 4 
    j finding_loop
    
finding_finished:
    move $v0, $s2
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    addi $sp, $sp, 28
    jr $ra

CreateArray: # Arguments: NONE Return values: v0-> arrayAddress v1-> arraySize
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    li $v0, 4
    la $a0, promptSize
    syscall
    
    li $v0, 5  # Read array's size
    syscall
    move $s0, $v0  # Save array's size in $s0
    
    li $v0, 9
    move $a0, $s0
    sll $a0, $a0, 2 
    syscall
    move $s1, $v0 

    move $a0, $s1
    move $a1, $s0
    jal InitializeArray
     
    # Print array
    move $a0, $s1
    move $a1, $s0
    jal PrintArray
    
    # Return array address and size to main
    move $v0, $s1  # Array address
    move $v1, $s0  # Array size
    
    # Restore $ra and return
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

InitializeArray: # Arguments: a0 = address, a1 = size 
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    
    move $s0, $a0  # array address
    move $s1, $a1  # array size
    li $s2, 0  # iterator
    
init_loop:
    beq $s2, $s1, init_done
    
    li $v0, 4
    la $a0, promptElement
    syscall
    
    # Read integer
    li $v0, 5
    syscall
    
    # Store to array
    sw $v0, 0($s0)
    
    addi $s2, $s2, 1  # increment counter
    addi $s0, $s0, 4  # move to next element
    j init_loop
init_done:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra

PrintArray: # Arguments: a0 = address, a1 = size
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    
    move $s0, $a0  # array address
    move $s1, $a1  # array size
    li $s2, 0  # iterator
    
print_array_loop:
    beq $s2, $s1, print_array_done  # counter == size
    
    li $v0, 1
    lw $a0, 0($s0)
    syscall
    
    # print " "
    li $v0, 4
    la $a0, space
    syscall
    
    addi $s2, $s2, 1  # Increment counter
    addi $s0, $s0, 4  # Move to next element
    j print_array_loop
    
print_array_done:
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra