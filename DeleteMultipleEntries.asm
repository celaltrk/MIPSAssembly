# DeleteMultipleEntries.asm
# Deletes duplicates from a linked list
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
	
	move	$a0, $s0
	jal	deleteMultipleEntries
	move	$s1, $v0	# s1 = new head
	
	# print new list
	la	$a0, prompt5
	li	$v0, 4
	syscall
	
	move	$a0, $s1
	jal 	printLinkedList
	j exit
	
deleteMultipleEntries: # a0 = address of the head, v0 = address of the new head
	addi	$sp, $sp, -8
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	move	$v0, $a0
	move 	$s0, $a0 	# s0 = prev
	lw 	$s1, 0($s0)	# s1 = cur
	beq	$s0, $0, done2	# size == 0
	beq 	$s1, $0, done2	# size == 1
	while1:
		lw	$t0, 4($s0)
		beq	$s1, $0, done1	# cur == null
		lw	$t1, 4($s1)
		bne	$t0, $t1, done1
		move	$s0, $s1	# prev = cur
		lw	$s1, 0($s1)	# cur = cur->next
		j while1
	done1:
		move	$v0, $s0	# v0 = constant head
	while2:
		beq $s1, $0, done2
		lw $t0, 4($s0)
		lw $t1, 4($s1)
		bne $t0, $t1, done3
		while4:
			beq $s1, $0, done4
			lw $s1, 0($s1)
			beq $s1, $0, done4
			lw $t1, 4($s1)
			beq $t1, $t0, while4
		done4:
		sw	$s1, 0($s0)	
		j while2
		done3:
		move	$s0, $s1	# prev = cur
		lw	$s1, 0($s1)	# cur = cur->next
		j while2
	done2:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	addi	$sp, $sp, 8
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
prompt1:	.asciiz "Enter size: "
prompt2: 	.asciiz "Enter value: "
prompt4: 	.asciiz "\nOld List:"
prompt5: 	.asciiz "\nNew List:"
nodeNumberLabel: 
		.asciiz	"\nNode No.: "
addressOfCurrentNodeLabel:
		.asciiz	"\nAddress of Current Node: "
addressOfNextNodeLabel:
		.asciiz	"\nAddress of Next Node: "
dataValueOfCurrentNode:
		.asciiz	"\nData Value of Current Node: "

