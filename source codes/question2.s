.data

array: .space 400
n: .space 4
message: .asciiz "Input Size: "
message2: .asciiz "Input: "
newLine: .asciiz "\n"
outputMsg: .asciiz "The new array is: "
space: .asciiz " "

.text

    main:
		li   $v0, 4           
    		la   $a0, message      # Please enter the coefficients: 
    		syscall
    		
    		
    		li $v0, 5          # syscall code for reading integer
    		syscall
    		la $t4, n
   		sw $v0, 0($t4)     # $t0 = n
   		
   		li   $v0, 4           
    		la   $a0, message2     # Please enter the coefficients: 
    		syscall
   		
   		lw   $t0, 0($t4)
   		move $t1, $zero    # $t1 = i = 0
   	loop1:	bge  $t1, $t0, exit1
   		li $v0, 5          # syscall code for reading integer
    		syscall
   		move $t2, $v0        # $t2 = input
   		sll  $t3, $t1, 2     # $t3 = 4i
   		sw   $t2, array($t3) # array[i] = input
   		addi $t1, $t1, 1     # i++
   		j    loop1
   	exit1:	
   		la $t5, array        # $t5 = base addr. of array
   		move $a0, $t5        # $a0 = array
   		move $a1, $t4        # $a1 = &n
   		jal  switchArray
    		
    
    		
    		li   $v0, 4           
    		la   $a0, outputMsg     # Please enter the coefficients: 
    		syscall
    		
    		move $t0, $zero         # i = 0
    		la   $t1, n             # $t1 = base address of n
    		la   $t4, array          # $t4 = base addr. of array
    		lw   $t2, 0($t1)        # t2 = n
    	loop4:	bge  $t0, $t2, exit4    # i < n
    		sll  $t3, $t0, 2        # $t3 = 4i
    		add  $t5, $t4, $t3      # $t5 = addr. of array[i]
    		lw   $t6, 0($t5)        # $t6 = array[i]
		move $a0, $t6          
		li $v0, 1         
		syscall
		li   $v0, 4           
    		la   $a0, space     # Please enter the coefficients: 
    		syscall
    		addi $t0, $t0, 1
    		j    loop4
    			
    	exit4:	li $v0, 10
    		syscall

     gcd:
    		addi $sp, $sp, -4
    		sw   $t0, 0($sp)      # $t0 = temp
    	loop8:	beq  $a1, $zero, ret8 # b != 0
    		move $t0, $a1         # temp = b
    		div  $a0, $a1         # a / b
    		mfhi $t1	       # a % b
    		move $a1, $t1	       # b = a % b
    		move $a0, $t0         # a = temp
    		j    loop8	
    	ret8:	lw   $t0, 0($sp)      # $t0 = temp
    		addi $sp, $sp, 4
    		move $v0, $a0         # $v0 = a, return a
    		jr   $ra
    		

    switchArray:
		
		addi $sp, $sp, -24
		sw   $ra, 20($sp)
		sw   $t0, 16($sp)     # $t0 = index
		sw   $t1, 12($sp)     # $t1 = lcm
		sw   $t2, 8($sp)      # $t2 = i
		sw   $a0, 4($sp)     
		sw   $a1, 0($sp)     
		
		la   $s1, array      # $s1 = base addr. of array
		move $t0, $zero      # index = 0
	loop2:	lw   $s0, 0($a1)     # $s0 = *n   
		addi $s0, $s0, -1    # $s0 = *n - 1
		bge  $t0, $s0, ret3  # index < *n - 1
		sll  $t3, $t0, 2     # $t3 = 4*index
		add  $t3, $t3, $s1   # $t3 = 4*index + array = array[index]
		addi $t4, $t0, 1     # $t4 = index + 1
		sll  $t4, $t4, 2     # $t4 = 4*(index+1)
		add  $t4, $t4, $s1   # $t4 = 4*(index+1) + array = array[index + 1]
		lw   $t5, 0($t3)     # $t5 = array[index]
		lw   $t6, 0($t4)     # $t6 = array[index + 1]
		move $a0, $t5        # $a0 = array[index]
		move $a1, $t6	      # $a1 = array[index + 1]
		jal  gcd
		lw   $a0, 4($sp)     
		lw   $a1, 0($sp)     
		move $t3, $v0        # $t3 = result of gcd(arr[index], arr[index + 1]
		addi $t4, $zero, 1   # $t4 = 1
		bne  $t3, $t4, cond2
		addi $t0, $t0, 1     # index++
		j    loop2
	cond2:	mul  $t4, $t5, $t6   # $t4 = arr[index] * arr[index + 1]
		move $a0, $t5        # $a0 = array[index]
		move $a1, $t6	      # $a1 = array[index + 1]
		jal  gcd
		lw   $a0, 4($sp)     
		lw   $a1, 0($sp)  
		move $t3, $v0        # $t3 = result of gcd(arr[index], arr[index + 1]
		div  $t4, $t4, $t3   # $t4 = arr[index] * arr[index + 1]) / gcd(arr[index], arr[index + 1]
		move $t1, $t4        # $t1 = lcm = arr[index] * arr[index + 1]) / gcd(arr[index], arr[index + 1]
		sll  $t3, $t0, 2     # $t3 = 4 * index
		add  $t3, $a0, $t3   # $t3 = addr of array[index]
		sw   $t1, 0($t3)     # array[index] = lcm
		# Burdayýzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz!!!''!!'!
		addi $s2, $t0, 1     # $s2 = index + 1
		move $t2, $s2        # i = index + 1
		lw   $s3, 0($a1)     # $s3 = *a
		addi $s3, $s3, -1    # $s3 = *a - 1
	loop3:	bge  $t2, $s3, exit3 # i < *n - 1
		sll  $s4, $t2, 2     # $s4 = 4i
		add  $s4, $s4, $a0   # $s4 = addr. of array[i] 	
		addi $s5, $t2, 1     # $s5 = i + 1
		sll  $s5, $s5, 2     # $s5 = 4*(i+1)
		add  $s5, $s5, $a0   # $s5 = addr. of array[i + 1]
		lw   $s6, 0($s5)     # $s6 = array[i + 1]
		sw   $s6, 0($s4)     # array[i] = array[i + 1]
		addi $t2, $t2, 1     # i++
		j    loop3
	exit3:	sw   $s3, 0($a1)     # (*n)--
		move $t0, $zero      # index = 0
		j    loop2
													
	ret3:	lw   $ra, 20($sp)
		lw   $t0, 16($sp)     # $t0 = index
		lw   $t1, 12($sp)     # $t1 = lcm
		lw   $t2, 8($sp)     # $t2 = i
		lw   $a0, 4($sp)     
		lw   $a1, 0($sp)
		addi $sp, $sp, 24
		jr   $ra
		







