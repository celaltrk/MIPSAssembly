# RecursiveDivision.asm
# Performs division and finds quotient & remainder
# Author: Celal Salih Turkmen	
.text
j main
recursiveDivision: # inputs (int): a0 = &a, a1 = b, return (int): v0 = &q, v1 = &r.
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	blt $a0, $a1, end # a < b
	sub $a0, $a0, $a1 # a = a - b
	addi $v0, $v0, 1 # q++
	jal recursiveDivision
	end:  	
	add $v1, $0, $a0 # r = a
	lw $ra, 0($sp)
	lw $a1, 4($sp)
	addi $sp, $sp, 8
	jr $ra
main:
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	
	la $a0, prompt1
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	add $s0, $0, $v0 # s0 = a
	
	la $a0, prompt2
	addi $v0, $0, 4
	syscall
	addi $v0, $0, 5
	syscall
	add $s1, $0, $v0 # s1 = b
	
	add $v0, $0, $0
	add $v1, $0, $0
	add $a0, $0, $s0
	add $a1, $0, $s1
	jal recursiveDivision
	
	add $s2, $0, $v0 # s2 = q
	add $s3, $0, $v1 # s3 = r

	la $a0, result1
	addi $v0, $0, 4
	syscall
	add $a0, $0, $s2
	addi $v0, $0, 1
	syscall
	
	la $a0, result2
	addi $v0, $0, 4
	syscall
	add $a0, $0, $s3
	addi $v0, $0, 1
	syscall
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
.data
prompt1: .asciiz "Enter a: "
prompt2: .asciiz "Enter b: "
result1: .asciiz "Quotient is: "
result2: .asciiz "\nRemainder is: "	
