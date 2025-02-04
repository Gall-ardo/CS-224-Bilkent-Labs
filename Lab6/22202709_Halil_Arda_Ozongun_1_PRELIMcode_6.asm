.text
.globl main

main:
    # Get matrix size
    li $v0, 4
    la $a0, prompt_size
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0  # $s0 = N (matrix size)
    
    # Calculate array size (N*N*4)
    mul $a0, $s0, $s0
    sll $a0, $a0, 2
    
    # Allocate memory
    li $v0, 9
    syscall
    move $s1, $v0  # $s1 = base address
    
    # Initialize matrix column by column
    li $t0, 1      # counter
    li $t1, 0      # column
    
init_loop:
    bge $t1, $s0, menu_loop
    li $t2, 0      # row
    
col_loop:
    bge $t2, $s0, next_col
    
    # Calculate offset: (j-1)*N*4 + (i-1)*4
    mul $t3, $t1, $s0
    add $t3, $t3, $t2
    sll $t3, $t3, 2
    add $t3, $s1, $t3
    
    sw $t0, ($t3)
    addi $t0, $t0, 1
    addi $t2, $t2, 1
    j col_loop
    
next_col:
    addi $t1, $t1, 1
    j init_loop
    
menu_loop:
    li $v0, 4
    la $a0, menu
    syscall
    
    li $v0, 5
    syscall
    
    beq $v0, 1, access_element
    beq $v0, 2, row_major_sum
    beq $v0, 3, col_major_sum
    beq $v0, 4, exit
    j menu_loop # if invalid value, menu again

access_element:
    # Get row and column
    li $v0, 4
    la $a0, prompt_row
    syscall
    li $v0, 5
    syscall
    addi $t0, $v0, -1  # row-1
    
    li $v0, 4
    la $a0, prompt_col
    syscall
    li $v0, 5
    syscall
    addi $t1, $v0, -1  # col-1
    
    # Calculate offset
    mul $t2, $t1, $s0
    add $t2, $t2, $t0
    sll $t2, $t2, 2
    add $t2, $s1, $t2
    
    li $v0, 4
    la $a0, element_msg
    syscall
    
    lw $a0, ($t2)
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    j menu_loop

row_major_sum:
    li $s2, 0      # total sum
    li $t1, 0      # row
    
row_sum_loop:
    bge $t1, $s0, print_total
    li $t2, 0      # col
    
row_inner_loop:
    bge $t2, $s0, row_next
    
    # Calculate offset: row*N + col
    mul $t3, $t1, $s0    # row * N
    add $t3, $t3, $t2    # + col
    sll $t3, $t3, 2      # * 4
    add $t3, $s1, $t3
    
    lw $t4, ($t3)
    add $s2, $s2, $t4    # Add directly to total
    addi $t2, $t2, 1
    j row_inner_loop
    
row_next:
    addi $t1, $t1, 1
    j row_sum_loop

col_major_sum:
    li $s2, 0      # total sum
    li $t1, 0      # col
    
col_sum_loop:
    bge $t1, $s0, print_total
    li $t2, 0      # row
    
col_inner_loop:
    bge $t2, $s0, col_next
    
    # Calculate offset: col*N + row
    mul $t3, $t1, $s0    # col * N
    add $t3, $t3, $t2    # + row
    sll $t3, $t3, 2      # * 4
    add $t3, $s1, $t3
    
    lw $t4, ($t3)
    add $s2, $s2, $t4    # Add directly to total
    addi $t2, $t2, 1
    j col_inner_loop
    
col_next:
    addi $t1, $t1, 1
    j col_sum_loop

print_total:
    li $v0, 4
    la $a0, total_msg
    syscall
    
    move $a0, $s2
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    j menu_loop

exit:
    li $v0, 10
    syscall
    
    
.data
    prompt_size: .asciiz "Enter matrix size (N): "
    prompt_row: .asciiz "Enter row number (1-N): "
    prompt_col: .asciiz "Enter column number (1-N): "
    menu: .asciiz "\n1. Access element\n2. Row-major sum\n3. Column-major sum\n4. Exit\nChoice: "
    newline: .asciiz "\n"
    element_msg: .asciiz "Element value: "
    total_msg: .asciiz "Total sum: "
