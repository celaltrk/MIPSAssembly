# Program2.asm
# Calculates Hamming distance of two integers
# Author: Celal Salih Turkmen
.text
j Main
Hamming: # takes a0 and a1, returns v0 int
	addi $sp, $sp, -12
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	xor $s0, $a0, $a1 # s0 = xor of the numbers
	add $s1, $0, $0 # s1 = temporary
	add $v0, $0, $0 # v0 = answer
	loop:
		beq $s0, $0, done
		andi $s1, $s0, 1
		add $v0, $v0, $s1
		srl $s0, $s0, 1
		j loop
	done:
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
Display: # takes a0, displays as hex, returns void
	addi $sp, $sp, -8
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	add $s0, $0, $a0 # s0 = num
	addi $v0, $0, 34
	add $a0, $0, $s0
	syscall
	addi $v0, $0, 11
	addi $a0, $0, '\n'
	syscall
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra	
Main:
	addi $sp, $sp, -16
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	addi $v0, $0, 4
	la $a0, num1
	syscall
	addi $v0, $0, 5
	syscall
	add $s0, $0, $v0 # s0 = num1 
	
	addi $v0, $0, 4
	la $a0, num2
	syscall
	addi $v0, $0, 5
	syscall
	add $s1, $0, $v0 # s1 = num2 
	
	addi $v0, $0, 4
	la $a0, num1
	syscall
	add $a0, $0, $s0
	jal Display
	
	addi $v0, $0, 4
	la $a0, num2
	syscall
	add $a0, $0, $s1
	jal Display
	
	add $a0, $0, $s0
	add $a1, $0, $s1
	jal Hamming
	add $s2, $0, $v0 # s2 = answer

	addi $v0, $0, 4
	la $a0, result
	syscall # print output
	
	addi $v0, $0, 1
	add $a0, $0, $s2
	syscall # print answer
	
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	addi $v0, $0, 4
	la $a0, cont
	syscall # ask
	addi $v0, $0, 12
	syscall
	addi $v0, $v0, -121
	beq $v0, $0, Main
	addi $v0, $0, 10
	syscall # exit
.data
num1: .asciiz "\nnum1: "
num2: .asciiz "num2: "
result: .asciiz "Hamming distance is: "
cont: .asciiz "\nDo you want to continue? (y/n): "
	 