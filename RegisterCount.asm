# RegisterCount.asm
# Finds the number of the given register in the subprogram
# Author: Celal Salih Turkmen	
	.text
main:
	la $a0, prompt
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	add $a0, $0, $v0
	bgt $a0, 31, exit
	blt $a0, 1, exit
	
	jal start
	add $a0, $0, $v0 # a0 = answer
	li $v0, 1
	syscall
	j main
	
start: # a0 = num (1-31)
	addi 	$sp, $sp, -36
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)
	sw	$ra, 32($sp)
	
	add	$s2, $0, $0 # s2 = answer
	add 	$s3, $0, $a0 # s3 = target
	la	$t0, start
	la	$t1, end
	addi	$t1, $t1, 4

next:	bgt	$t0, $t1, done
# Load the instruction pointed by $t0 to $s0
	lw	$s0, 0($t0) 	# s0 = instruction
	andi 	$s1, $s0, 0xFC000000
	srl 	$s1, $s1, 26 	# s1 = opcode
	beq 	$s1, 2, Jtype
	beq 	$s1, 3, Jtype 	# pass if J-reg
	srl	$s0, $s0, 11
	andi	$s4, $s0, 31 	# s4 = rd
	srl	$s0, $s0, 5
	andi	$s5, $s0, 31 	# s5 = rt
	srl	$s0, $s0, 5
	andi	$s6, $s0, 31 	# s6 = rs
	bne	$s1, $0, Itype

	add 	$s7, $0, $0
	seq	$s7, $s4, $s3
	add	$s2, $s2, $s7

Itype:	add 	$s7, $0, $0
	seq	$s7, $s5, $s3
	add	$s2, $s2, $s7
	
	add 	$s7, $0, $0
	seq	$s7, $s6, $s3
	add	$s2, $s2, $s7

Jtype:	addi	$t0, $t0, 4 	# Advance program pointer
	j	next	
	
done:	
	add	$v0, $0, $s2
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	lw	$ra, 32($sp)	
	addi 	$sp, $sp, 36
end:	jr $ra	

exit:	li $v0, 10
	syscall
	.data
prompt: .asciiz	"\nEnter register no: "
