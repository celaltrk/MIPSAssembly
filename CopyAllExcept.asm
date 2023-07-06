# CopyAllExcept.asm
# Copies a linked list except the given value
# Author: Celal Salih Turkmen	
	.text
main:
	la	$a0, prompt1
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$a0, $v0
	jal 	createLinkedListUser
	move	$s0, $v0	# s0 = head
	
	# print old list
	la	$a0, prompt4
	li	$v0, 4
	syscall
	
	move	$a0, $s0
	jal 	printLinkedList 
	
	la	$a0, prompt3
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$s1, $v0	# s1 = deleted value
	
	move	$a0, $s0
	move	$a1, $s1
	jal	copyAllExcept
	
	move	$s2, $v0	# s2 = new head
	move	$s3, $v1	# s3 = size
	
	# print new list
	la	$a0, prompt5
	li	$v0, 4
	syscall
	
	move	$a0, $s2
	jal 	printLinkedList
	
	# print size
	la	$a0, prompt6
	li	$v0, 4
	syscall
	move	$a0, $s3
	li	$v0, 1
	syscall
	j exit

copyAllExcept: # a0 = address of the head. a1 = deleted value. returns head in $v0 and its size in $v1
	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	
	add 	$s0, $0, $a0 	# s0 = address of the head (old).
	add	$s1, $0, $a1 	# s1 = deleted value
	add	$s4, $0, $0 	# s4 = size
	while1:
		beq	$s0, $0, done1
		lw	$t0, 4($s0) 	# t0 = cur val
		beq	$t0, $s1, pass1
		addi 	$s4, $s4, 1 # size++
		li	$a0, 8
		li	$v0, 9
		syscall
		move	$s2, $v0	# s2 = new head
		sw	$t0, 4($s2)	# value stored
		sw	$0, 0($s2)	# nullptr stored
		lw	$s0, 0($s0) # head = head->next
		j done1
	pass1:	lw	$s0, 0($s0) # head = head->next
		j	while1
	done1:
		move	$s3, $s2	# s3 = constant head
	while2:
		beq	$s0, $0, done2
		lw	$t0, 4($s0)
		beq	$t0, $s1, pass2
		addi 	$s4, $s4, 1 # size++
		li	$a0, 8
		li	$v0, 9
		syscall
		sw	$v0, 0($s2)	# prev. node points cur node
		move	$s2, $v0	# s2 points cur node
		sw	$t0, 4($s2)	# value stored
		sw	$0, 0($s2)	# nullptr stored
	pass2:	lw	$s0, 0($s0) # head = head->next
		j	while2
	done2:
	move	$v0, $s3
	move	$v1, $s4
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra

createLinkedListUser:
# $a0: No. of nodes to be created ($a0 >= 1) $v0: returns head
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	la 	$a0, prompt2
	addi 	$v0, $0, 4
	syscall
	addi 	$v0, $0, 5
	syscall
	add 	$s4, $0, $v0 	# s4 = data value	
	sw	$s4, 4($s2)	# Store the data value.
	
addNodeUser:
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDoneUser
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	la	$a0, prompt2
	addi 	$v0, $0, 4
	syscall
	addi 	$v0, $0, 5
	syscall
	add 	$s4, $0, $v0 	# s4 = data value	
	sw	$s4, 4($s2)	# Store the data value.
	j	addNodeUser
allDoneUser:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$0, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
#=========================================================
printLinkedList: # a0 = address of the head
# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# $s1: Address of next
# $s2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $0, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#=========================================================	
exit:	
	.data
line:		.asciiz "\n--------------------------------------"
prompt1:	.asciiz  "Enter size: "
prompt2: 	.asciiz "Enter value: "
prompt3: 	.asciiz "\nEnter value to be deleted: "
prompt4: 	.asciiz "\nOld List:"
prompt5: 	.asciiz "\nNew List:"
prompt6: 	.asciiz "\nNew Size: "
nodeNumberLabel: 
		.asciiz	"\nNode No.: "
addressOfCurrentNodeLabel:
		.asciiz	"\nAddress of Current Node: "
addressOfNextNodeLabel:
		.asciiz	"\nAddress of Next Node: "
dataValueOfCurrentNode:
		.asciiz	"\nData Value of Current Node: "
