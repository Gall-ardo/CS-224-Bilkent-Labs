#
# Halil Arda Ozongun ID: 22202709
# CS 224- Lab2 
# Solution of lab part question 1

.data
wannacont: .asciiz "\nIf you want to continue, please enter 1, otherwise it will exit: "
wantinput1: .asciiz "\nPlease enter a value for register $s0: "
wantinput2: .asciiz "\nPlease enter a value for register $s1: "
resultmsg: .asciiz "\nHamming distance of your values: "
value_msg1: .asciiz "\nValue in $s0 (hexadecimal): "
value_msg2: .asciiz "\nValue in $s1 (hexadecimal): "

.text
.globl main

main:
    # Take inputs
    jal wantInput
    
    # s0 holds num1, s1 -> num2
    move $s0, $v0
    move $s1, $v1
    
    jal printHexValues
    
    # a0 a1 parameters
    move $a0, $s0
    move $a1, $s1
    jal calculateHammingDistance
    
    # Print result
    move $a0, $v0
    jal printResult
    
    # Ask if user wants to continue
    jal askContinue
    beq $v0, 1, main
  
    
    li $v0, 10
    syscall

wantInput: # Return values in $v0 and $v1
    li $v0, 4            
    la $a0, wantinput1
    syscall
    li $v0, 5
    syscall
    move $s1, $v0  # first input -> $t0
   
    li $v0, 4 
    la $a0, wantinput2
    syscall
    li $v0, 5
    syscall
    move $s2, $v0  # second input -> $t1

    move $v0, $s1
    move $v1, $s2
    jr $ra 

printHexValues: # numbers are in a0 a1
    li $v0, 4
    la $a0, value_msg1
    syscall
    
    li $v0, 34
    move $a0, $s0
    syscall
    
    li $v0, 4
    la $a0, value_msg2
    syscall
    
    li $v0, 34
    move $a0, $s1
    syscall

    jr $ra
    
calculateHammingDistance:  # $a0 $a1 argument
    xor $s0, $a0, $a1
    
    # iterator
    li $v0, 0
    
countBit:
    beq $s0, $zero, returnAnswer
    andi $s1, $s0, 1 # Now if t1 is 1, increment counter
    add $v0, $v0, $s1
    srl $s0, $s0, 1
    j countBit
        
returnAnswer:
    jr $ra

printResult:
    # $a0 contains the Hamming distance
    move $s0, $a0  # Save Hamming distance in $t0
    
    li $v0, 4
    la $a0, resultmsg
    syscall
    
    li $v0, 1
    move $a0, $s0
    syscall
    
    jr $ra

askContinue:
    li $v0, 4
    la $a0, wannacont
    syscall
    
    li $v0, 5
    syscall
    
    jr $ra  # choice $v0
