.data
matrix: .byte 5, 6, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0,
1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0


temp_matrix: .space 100
			        #temp_matrix is to print inital matrix

total: .word 0    # int total = 0 as global variable

space: .asciiz " "
newLine: .asciiz "\n"
message: .asciiz "The number of the 1s on the largest island is "
dot: .asciiz "."

.text

    main:
        	addi  $sp, $sp, -16    # there are 3 local variable, and a $ra 
        	sw    $ra, 12($sp)
        	sw    $s0, 8($sp)
        	sw    $s1, 4($sp)
        	sw    $s2, 0($sp)
        	jal   initialize_temp_matrix
        	la    $s3, matrix      # $s3 = matrix[0][0], bur first 2 item is size
        	lb    $t0, 0($s3)      # $t0 = ROW number of matrix     
        	lb    $t1, 1($s3)
        	move  $s2, $zero
        	move  $s0, $zero
        loop5:	bge   $s0, $t0, exit5  # i < ROW
		move  $s1, $zero       # j = 0
	loop6:	bge   $s1, $t1, exit6  # j < COL
        	mul  $t2, $s0, $t1
		add  $t2, $t2, $s1
		addi $t3, $t2, 2
		lb    $s4, matrix($t3)      # $s3 = matrix[i][j]
		beq   $s4, 1, cond2    # if(matrix[i][j] == 1) -> go cond1
	incr2:	addi  $s1, $s1, 1      # j++
		j     loop6            # go loop2
	cond2:	move  $a0, $s0
		move  $a1, $s1
		jal   search_neighboor
		lw    $t4, total
		ble   $t4, $s2, cond3
		move  $s2, $t4
	cond3:	move  $t4, $zero
		sw    $t4, total
		j     incr2 
	exit6:	addi  $s0, $s0, 1
		j     loop5
	exit5:	jal   print_temp_matrix
        	li    $v0, 4             # for print space
    		la    $a0, message       # for print space 
		syscall 	       # for print space
		move  $a0, $s2	       # for print
		li    $v0, 1           # for print
		syscall               # for print
		li    $v0, 4             # for print space
    		la    $a0, dot           # for print space 
		syscall 
        	lw    $ra, 12($sp)
        	lw    $s0, 8($sp)
        	lw    $s1, 4($sp)
        	lw    $s2, 0($sp)
	 	addi  $sp, $sp, 16
		li    $v0, 10
		syscall


    initialize_temp_matrix:
		addi $sp, $sp, -8     # for local variables, it is used stack for 2 items
		sw   $s0, 4($sp)      # storing s0, s0 is for i variable
		sw   $s1, 0($sp)      # storing s1, s1 is for j variable
		la   $s2, matrix      # base address of matrix
		lb   $t0, 0($s2)      # $t0 = ROW
		lb   $t1, 1($s2)      # $t1 = COL
		move $s0, $zero       # i = 0
	loop1:	bge  $s0, $t0, exit1  # i < ROW
		move $s1, $zero       # j = 0
	loop2:	bge  $s1, $t1, exit2  # j < COL
		mul  $t2, $s0, $t1
		add  $t2, $t2, $s1
		addi $t3, $t2, 2
		lb   $s3, matrix($t3)      # $s3 = matrix[i][j]
		sb   $s3, temp_matrix($t2) # temp_matrix[i][j] = matrix[i][j]
	incr1:	addi $s1, $s1, 1      # j++
		j loop2               # go loop2
	exit2:	addi $s0, $s0, 1      # i++
		j loop1		      # go loop1
	exit1:	lw   $s0, 4($sp)     # load stored values from stack to regs.
		lw   $s1, 0($sp)     # load stored values from stack to regs.
		addi $sp, $sp, 8     # reset stack pointer
		jr $ra               # jump to return address
			

    search_neighboor:                     # $a0 = i, $a1 = j
		addi $sp, $sp, -12
		sw   $ra, 8($sp)
		sw   $a0, 4($sp)
		sw   $a1, 0($sp)	
		addi $t3, $t0, -1          # $t3 = ROW - 1
		addi $t4, $t1, -1          # $t4 = COL - 1 
		slt  $t5, $a0, $zero	    # $t5 = i < 0
		sgt  $t6, $a0, $t3         # $t6 = i > ROW - 1
		slt  $s4, $a1, $zero       # $s4 = j < 0
		sgt  $s5, $a1, $t4         # $s5 = j > COL - 1
		or   $t3, $t5, $t6         # $t3 = i < 0 || i > ROW - 1
		or   $t4, $s4, $s5         # $t4 = j < 0 || j > COL - 1
		or   $t3, $t3, $t4         # or for all of them in $t3
		addi $t4, $zero, 1         # $t4 = 1
		beq  $t3, $t4, ret         # if $t3 == 1 go -> return	
		mul  $t3, $a0, $t1
		add  $t3, $t3, $a1
		addi $t3, $t3, 2		
		lb   $t4, matrix($t3)           # $t4 = matrix[i][j]
		beq  $t4, $zero, ret       # if (matrix[i][j] == 0) -> go return
		lw   $t4, total		    # $t4 = total
		addi $t4, $t4, 1           # total++
		sw   $t4, total            # total = $t4
		move $s4, $zero            # $s4 = 0
		sb   $s4, matrix($t3)           # matrix[i][j] = 0
		addi $a0, $a0, 1           # i+1, j for parameters
		jal  search_neighboor      # and call function recursively
		lw   $a0, 4($sp)
		lw   $a1, 0($sp)
		addi $a0, $a0, -1          # i-1, j for parameters
		jal  search_neighboor      # and call it
		lw   $a0, 4($sp)
		lw   $a1, 0($sp)
		addi $a1, $a1, 1           # i, j+1 for parameters
		jal  search_neighboor      # and call it
		lw   $a0, 4($sp)
		lw   $a1, 0($sp)
		addi $a1, $a1, -1          # i, j-1 for parameters
		jal  search_neighboor      # and call it
		
	ret:	lw   $ra, 8($sp)
		lw   $a0, 4($sp)
		lw   $a1, 0($sp)
		addi $sp, $sp, 12
		jr   $ra
		
		
    print_temp_matrix:
    		addi $sp, $sp, -8
		sw   $s0, 4($sp)
		sw   $s1, 0($sp)
		la   $s3, matrix
		lb   $t0, 0($s3)      # $t0 = ROW
		lb   $t1, 1($s3)      # $t1 = COL
		move $s0, $zero
	loop3:	bge  $s0, $t0, exit3
		move $s1, $zero
	loop4:	bge  $s1, $t1, exit4
		mul  $t2, $s0, $t1
		add  $t2, $t2, $s1
		lb   $s4, temp_matrix($t2)      # $s3 = temp_matrix[i][j]
		move $a0, $s4	       # for print
		li   $v0, 1           # for print
		syscall               # for print
		li $v0, 4             # for print space
    		la $a0, space         # for print space 
		syscall 	       # for print space
		addi $s1, $s1, 1      # j++
		j loop4               # go loop4
	exit4:	li $v0, 4             # for print \n
    		la $a0, newLine       # for print \n   
		syscall               # for print \n
		addi $s0, $s0, 1      # i++
		j loop3
	exit3:	lw   $s0, 4($sp)
		lw   $s1, 0($sp)
		addi $sp, $sp, 8
		jr $ra
	
	
    
		
		
		
		
	
	
