.data

message: .asciiz "Input: "
outputMsg: .asciiz "Output: "
input: .space 64

.text

    main:
		li   $v0, 4           
    		la   $a0, message    # Please enter the coefficients: 
    		syscall
    		
    		li $v0, 8            # syscall code for reading string
    		la $a0, input        # load address of buffer
    		li $a1, 64           # maximum number of characters to read
    		syscall
    		
		li $v0, 5            # syscall code for reading integer
    		syscall
    		move $s0, $v0        # $s0 = n
    		
		
		move $t4, $zero      # $t4 = len = 0
		la   $t0, input       # $t0 = addr. of input
		move $t1, $zero      # $t1 = 0 = i
	loop1:	add  $t2, $t0, $t1   # $t2 = addr. of input[i]
		lb   $t3, 0($t2)     # $t3 = input[i]
		beq  $t3, $zero, exit1
		addi $t4, $t4, 1     # counter++
		addi $t1, $t1, 1     # i++
		add  $t2, $t2, $t1             	
		j    loop1
	
	exit1:	addi $t4, $t4, -1
		move $a0, $t0     # $a0 = str
		move $a1, $t4     # $a1 = len
		move $a2, $zero   # $a2 = 0
		move $a3, $s0     # $a3 = n
		jal  shuffle
		li   $v0, 4           
    		la   $a0, outputMsg    # Please enter the coefficients: 
    		syscall
    		li   $v0, 4           
    		la   $a0, 0($t0)    # Please enter the coefficients: 
    		syscall
    		
    		li    $v0, 10
		syscall
    		
		 
    shuffle:
    		addi $sp, $sp, -24
    		sw   $ra, 20($sp)
    		sw   $a0, 16($sp)
		sw   $a1, 12($sp)
		sw   $a2, 8($sp)
		sw   $a3, 4($sp)
		sw   $s0, 0($sp)     # $s0 = half 
		beq  $a2, $a3, ret
		srl  $s0, $a1, 1   # half = len / 2
		move $a1, $s0 
		addi $a2, $a2, 1   # level + 1	
		jal  shuffle
		add  $a0, $a0, $s0 # str + half
		jal  shuffle
		lw   $a0, 16($sp)
		add  $a1, $a0, $s0
		move $a2, $s0
		jal  swap
	ret:	lw   $ra, 20($sp)
    		lw   $a0, 16($sp)
		lw   $a1, 12($sp)
		lw   $a2, 8($sp)
		lw   $a3, 4($sp)
		lw   $s0, 0($sp)     
		addi $sp, $sp, 24
		jr   $ra
		
		
    swap:
    		addi $sp, $sp, -8
    		sw   $t0, 4($sp)   # $t0 = i
    		sw   $t1, 0($sp)   # $t1 = temp 
    		move $t0, $zero
    	loop2:	bge  $t0, $a2, exit2
    		add  $t2, $a0, $t0 # $t2 = a + i
    		lb   $t3, 0($t2)   # $t3 = *(a + i)
    		move $t1, $t3      # temp = *(a + i)
    		add  $t4, $a1, $t0 # $t4 = b + i
    		lb   $t5, 0($t4)   # $t5 = *(b + i)
    		sb   $t5, 0($t2)   # *(a + i) = *(b + i)
    		sb   $t1, 0($t4)   # *(b + i) = temp
    		addi $t0, $t0, 1   # i++
    		j    loop2
	exit2:	lw   $t0, 4($sp)   # $t0 = i
    		lw   $t1, 0($sp)   # $t1 = temp 
    		addi $sp, $sp, 8
		jr   $ra
    		
    		
		
				
    		
    		
		
		
		
		
