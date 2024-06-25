.data
a_ls: .space 8   # a list with 2 elements
b_ls: .space 408 # b list with 102 elements



newLine: .asciiz "\n"
message: .asciiz "Please enter the coefficients: "
message2: .asciiz "Please enter first two numbers of the sequence: "
message3: .asciiz "Enter the number you want to calculate (it must be greater than 1): "
errMsg: .asciiz "Invalid number, Enter a number that is greater than 1: "
outputMsg: .asciiz "Output: "
outputMsg2: .asciiz "th element of the sequence is "
dot: .asciiz "."

.text
    main: 
		move $s0, $zero
		
		li   $v0, 4           
    		la   $a0, message      # Please enter the coefficients: 
    		syscall
    		
    		li $v0, 5          # syscall code for reading integer
    		syscall
   		move $t0, $v0      # store the integer read into $t0
   		sw $t0, a_ls($s0)
   		
   		addi $s0, $s0, 4
   		li $v0, 5          # syscall code for reading integer
    		syscall
   		move $t0, $v0      # store the integer read into $t0
   		sw $t0, a_ls($s0)
   		
   		move $s0, $zero
   		li   $v0, 4           
    		la   $a0, message2      # Please enter the coefficients: 
    		syscall
   		
   		li $v0, 5          # syscall code for reading integer
    		syscall
   		move $t0, $v0      # store the integer read into $t0
   		sw $t0, b_ls($s0)
   		
   		addi $s0, $s0, 4
   		li $v0, 5          # syscall code for reading integer
    		syscall
   		move $t0, $v0      # store the integer read into $t0
   		sw $t0, b_ls($s0)
   		
   		li   $v0, 4           
    		la   $a0, message3      # Please enter the coefficients: 
    		syscall
   		
   		li $v0, 5          # syscall code for reading integer
    		syscall
   		move $s0, $v0      # store the integer read into $t0
   		
   		addi $t0, $zero, 1
   	loop1:	bgt  $s0, $t0, exit1
   		li   $v0, 4           
    		la   $a0, errMsg      # Please enter the coefficients: 
    		syscall
   		li $v0, 5          # syscall code for reading integer
    		syscall
   		move $s0, $v0      # store the integer read into $t0
   		j loop1
	
	
	exit1:	la   $t1, a_ls        # $t1 = base addr. of a_ls
		la   $t2, b_ls        # $t2 = base addr. of b_ls
		addi $t0, $zero, 2    # $t0 = i = 2
	loop2:	bge  $t0, $s0, exit2  # i < n
		sll  $t3, $t0, 2      # $t3 = 4i
		add  $t4, $t2, $t3    # $t4 = addr. of b[i]
		addi $t5, $t0, -1     # $t5 = i - 1
		sll  $t5, $t5, 2      # $t5 = 4*(i-1)
		add  $t5, $t2, $t5    # $t5 = addr. of b[i - 1]
		addi $t6, $zero, 4    # $t6 = 4
		add  $t6, $t1, $t6    # $t6 = addr. of a[1]
		addi $s1, $t0, -2     # $s1 = i - 2
		sll  $s1, $s1, 2      # $s1 = 4*(i-2)
		add  $s1, $t2, $s1    # $s1 = addr. of b[i - 2]
		la   $s2, a_ls        # $s2 = addr. of a[0]
		lw   $s3, 0($s2)      # $s3 = a[0]
		lw   $s4, 0($t5)      # $s4 = b[i - 1]
		lw   $s5, 0($t6)      # $s5 = a[1]
		lw   $s6, 0($s1)      # $s6 = b[i - 2]
		mul  $s3, $s3, $s4    # $s3 = a[0] * b[i - 1]
		mul  $s4, $s5, $s6    # $s4 = a[1] * b[i - 2]
		add  $s3, $s3, $s4    # $s3 = a[0] * b[i - 1] + a[1] * b[i - 2]
		addi $s3, $s3, -2     # $s3 = a[0] * b[i - 1] + a[1] * b[i - 2] - 2
		sw   $s3, 0($t4)      # b[i] = a[0] * b[i - 1] + a[1] * b[i - 2] - 2
		addi $t0, $t0, 1      # i++
		j    loop2		    		    		    		
    	exit2:	li   $v0, 4           
    		la   $a0, outputMsg      # Please enter the coefficients: 
    		syscall
    		li $v0, 1         # syscall for print_int
    		move $a0, $s0     # load integer from register $t0 (you can replace $t0 with $a0)
    		syscall           # print the integer
    		li   $v0, 4           
    		la   $a0, outputMsg2      # Please enter the coefficients: 
    		syscall
    		
    		addi $t0, $s0, -1  # $t0 = n - 1
    		sll  $t0, $t0, 2   # $t0 = 4*(n - 1)
    		add  $t0, $t2, $t0 # $t0 = addr. of b[n - 1]
    		lw   $t3, 0($t0)   # $t3 = b[n - 1]
    		
    		li $v0, 1         # syscall for print_int
    		move $a0, $t3     # load integer from register $t0 (you can replace $t0 with $a0)
    		syscall   
    		li   $v0, 4           
    		la   $a0, dot      # Please enter the coefficients: 
    		syscall
    		li $v0, 10
    		syscall
    		
