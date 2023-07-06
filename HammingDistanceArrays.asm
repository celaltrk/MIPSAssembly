# Program1.asm
# Calculates Hamming distance of two arrays
# Author: Celal Salih Turkmen
.text
j Main
CreateArray: # takes $a0 = word size, returns $v0 = address.
	addi $sp, $sp, -12
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	add $s1, $0, $a0 # s1 = size
	sll $a0, $s1, 2 # a0 = byte size
	add $v0, $0, 9 # syscall to allocate on heap
	syscall
	add $s0, $0, $v0 # s0 = address
	add $a0, $0, $s1
	add $a1, $0, $s0
	jal InitializeArray # pass $a0 = word size, $a1 = address, returns void
	add $v0, $0, $s0
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
InitializeArray: # takes $a0 = word size, $a1 = address, returns void
	addi $sp, $sp, -20
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	add $s0, $0, $a0 # s0 = word size
	add $s1, $0, $a1 # s1 = address
	add $s2, $0, $0 # s2 = index
	loop1:
		beq $s2, $s0, done1
		addi $v0, $0, 4
		la $a0, enterNum
		syscall
		addi $v0, $0, 5 # syscall to read int
		syscall
		sll $s3, $s2, 2 # calculate address on s3
		add $s3, $s3, $s1
		sw $v0, 0($s3)
		addi $s2, $s2, 1
		j loop1
	done1:
	addi $v0, $0, 4
	la $a0, success
	syscall
	add $v0, $0, $0 # returns void
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra
PrintArray: # takes a0 = addr, a1 = word size, returns void
	addi $sp, $sp, -20
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	add $s0, $0, $a0 # s0 = addr
	add $s1, $0, $a1 # s1 = word size
	add $s2, $0, $0 # index
	loop2:
		beq $s2, $s1, done2
		sll $s3, $s2, 2 # calculate address on t0
		add $s3, $s3, $s0
		lw $a0, 0($s3)
		addi $v0, $0, 1 # syscall to print int
		syscall
		addi $v0, $0, 4
		la $a0, separator
		syscall
		addi $s2, $s2, 1 # index++
		j loop2
	done2:
	addi $a0, $0, '\n'
	addi $v0, $0, 11
	syscall
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	add $v0, $0, $0 # returns void
	jr $ra
CalculateDistance: # a0 = array1 address, a1 = array2 address, a2 = size, v0 = returns int
	addi $sp, $sp, -36
	sw $s7, 32($sp)
	sw $s6, 28($sp)
	sw $s5, 24($sp)
	sw $s4, 20($sp)
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	add $s0, $0, $a0 # s0 = array1 address
	add $s1, $0, $a1 # s1 = array2 address
	add $s2, $0, $a2 # s2 = array size
	add $s3, $0, $0 # s3 = index
	add $v0, $0, $0 # v0 = answer
	loop3:
		beq $s3, $s2, done3
		sll $s4, $s3, 2
		add $s4, $s4, $s0 # s4 = array1 cur address
		sll $s5, $s3, 2
		add $s5, $s5, $s1 # s5 = array2 cur address
		lw $s6, 0($s4) # s6 = array1 cur val
		lw $s7, 0($s5) # s7 = array2 cur val
		beq $s6, $s7, pass
		addi $v0, $v0, 1 # increase answer
		pass:
		addi $s3, $s3, 1
		j loop3
	done3:
	lw $s7, 32($sp)
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 36
	jr $ra
Main: 
	addi $s0, $s0, -20
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $ra, 0($sp)
	
	addi $v0, $0, 4
	la $a0, enterSize
	syscall
	
	addi $v0, $0, 5
	syscall
	add $s2, $0, $v0 # s2 = size
	
	add $a0, $0, $s2
	jal CreateArray
	add $s0, $0, $v0 # s0: arr1 address
	
	add $a0, $0, $s2
	jal CreateArray
	add $s1, $0, $v0 # s1: arr2 address
	
	add $a0, $0, $s0
	add $a1, $0, $s2
	jal PrintArray
	
	add $a0, $0, $s1
	add $a1, $0, $s2
	jal PrintArray
	
	addi $v0, $0, 4
	la $a0, result
	syscall
	
	add $a0, $0, $s0
	add $a1, $0, $s1	
	add $a2, $0, $s2
	jal CalculateDistance
	add $s3, $0, $v0 # s3 = answer
	
	addi $v0, $0, 1
	add $a0, $0, $s3
	syscall # print answer
	
	lw $s0, 16($sp)
	lw $s1, 12($sp)
	lw $s2, 8($sp)
	lw $s3, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	
	addi $v0, $0, 10 # exit
	syscall
	
.data 
enterSize: .asciiz "Enter the size of the arrays: \n"
enterNum: .asciiz "Enter array element: "
success: .asciiz "Array is initialized!\n"
separator: .asciiz ", "
result: .asciiz "\nHamming distance is: "
	
		
	
