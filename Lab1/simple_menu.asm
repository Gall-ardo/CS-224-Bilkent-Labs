#
# Halil Arda Ozongun ID: 22202709
# CS 224- Lab1
# Solution of question 4 in lab part
#



.data
array: .align 4  # Ensure word alignment
       .space 400 # 100 element array
askSize: .asciiz "Enter the size of array (1-100): "
menuPrompt: .asciiz "\nMenu:\n1. Display maximum number\n2. Display count of maximum occurrences\n3. Display count of divisors of maximum\n4. Quit\nEnter your choice: "
invalidChoice: .asciiz "\nInvalid choice. Please try again."
asknumber: .asciiz "Enter the array element: "
maxMessage: .asciiz "\nThe maximum number in the array is: "
occurrenceMessage: .asciiz "\nThe maximum number appears "
timesMessage: .asciiz " time(s) in the array."
divisorMessage: .asciiz "\nNumbers that divide the maximum without remainder: "

# s0 size of array       
# s1 is the address of array
# s2 is the maximum value of array
# s3 is the count of maximum occurrences
# s4 is the count of divisors of maximum
       
.text
.globl main
main:
    # ask array size
    li $v0, 4
    la $a0, askSize
    syscall
    
    # take size input to s0
    li $v0, 5
    syscall
    move $s0, $v0
    
    la $s1, array
    li $t0, 0 # initialize counter with 0
takearrayelement:
    bge $t0, $s0, arrayinputdone
    
    li $v0, 4
    la $a0, asknumber
    syscall
    
    li $v0, 5
    syscall
    # store the input
    sll $t3, $t0, 2
    add $t3, $t3, $s1
    sw $v0, 0($t3)
    
    addi $t0, $t0, 1
    j takearrayelement

arrayinputdone:

    jal find_maximum
    jal count_maximum
    jal count_divisors

displaymenu:
    li $v0, 4
    la $a0, menuPrompt
    syscall
    li $v0, 5
    syscall
    move $t0, $v0  # Store user choice in $t0
    
    beq $t0, 1, display_maximum
    beq $t0, 2, display_count_maximum
    beq $t0, 3, display_count_divisors
    beq $t0, 4, quit_program
    
    li $v0, 4
    la $a0, invalidChoice
    syscall
    j displaymenu

find_maximum:
    lw $s2, 0($s1)  # Initialize max with first element
    li $t0, 1  # Start counter from 1
find_max_loop:
    bge $t0, $s0, find_max_done
    sll $t3, $t0, 2
    add $t3, $t3, $s1
    lw $t4, 0($t3)  # Load current element
    ble $t4, $s2, not_greater
    move $s2, $t4  # Update max if current element is greater
not_greater:
    addi $t0, $t0, 1
    j find_max_loop
find_max_done:
    jr $ra

count_maximum:
    li $s3, 0  # Initialize counter for occurrences
    li $t0, 0  # Loop counter
count_max_loop:
    bge $t0, $s0, count_max_done
    sll $t3, $t0, 2
    add $t3, $t3, $s1
    lw $t4, 0($t3)
    bne $t4, $s2, not_equal
    addi $s3, $s3, 1  # Increment occurrence counter
not_equal:
    addi $t0, $t0, 1
    j count_max_loop
count_max_done:
    jr $ra

count_divisors:
    li $s4, 0  # Initialize counter for divisors
    li $t0, 0  # Loop counter
count_div_loop:
    bge $t0, $s0, count_div_done
    sll $t3, $t0, 2
    add $t3, $t3, $s1
    lw $t4, 0($t3)
    beq $t4, $s2, not_divisor  # Skip if it's the max number itself
    beq $t4, $zero, not_divisor  # Skip if it's zero to avoid division by zero
    div $s2, $t4
    mfhi $t5  # Get remainder
    bne $t5, $zero, not_divisor
    addi $s4, $s4, 1  # Increment divisor counter
not_divisor:
    addi $t0, $t0, 1
    j count_div_loop
count_div_done:
    jr $ra

display_maximum:
    li $v0, 4
    la $a0, maxMessage
    syscall
    li $v0, 1
    move $a0, $s2
    syscall
    j displaymenu

display_count_maximum:
    li $v0, 4
    la $a0, occurrenceMessage
    syscall
    li $v0, 1
    move $a0, $s3
    syscall
    li $v0, 4
    la $a0, timesMessage
    syscall
    j displaymenu

display_count_divisors:
    li $v0, 4
    la $a0, divisorMessage
    syscall
    li $v0, 1
    move $a0, $s4
    syscall
    j displaymenu

quit_program:
    li $v0, 10
    syscall
