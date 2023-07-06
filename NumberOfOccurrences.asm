# Program3.asm
# Calculates number of occurrences in an index
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
Calc: # takes a0 =  arr address, a1 = index, a2 = size, returns v0 = no of occurrences
	addi $sp, $sp, -16
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	add $v0, $0, $0 # v0 = answer
	sll $a1, $a1, 2
	add $a1, $a1, $a0
	lw $s0, 0($a1)  # s0 = target
	add $s1, $0, $0 # s1 = index
	add $s2, $0, $0 # s2 = cur val
	loop3:
		beq $s1, $a2, done3
		sll $s2, $s1, 2
		add $s2, $s2, $a0 
		lw $s2, 0($s2) # s2 = cur val
		bne $s0, $s2, pass
		addi $v0, $v0, 1
		pass:
		addi $s1, $s1, 1
		j loop3
	done3:
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
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
	add $s0, $0, $v0 # s0: arr address
	
	add $a0, $0, $s0
	add $a1, $0, $s2
	jal PrintArray
	
	addi $v0, $0, 4
	la $a0, enterIndex
	syscall	
	addi $v0, $0, 5
	syscall
	add $s1, $0, $v0 # s1 = index
	
	addi $v0, $0, 4
	la $a0, result
	syscall
	
	add $a0, $0, $s0
	add $a1, $0, $s1	
	add $a2, $0, $s2
	jal Calc
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
enterSize: .asciiz "Enter the size of the array: \n"
enterIndex: .asciiz "Enter the target index: \n"
enterNum: .asciiz "Enter array element: "
success: .asciiz "Array is initialized!\n"
separator: .asciiz ", "
result: .asciiz "\Number of occurrences is: "

	
	