.data

inMsg: .asciiz "Enter a number: "
msg: .asciiz "Calculating F(n) for n = "
fibNum: .asciiz "\nF(n) is: "
.text

main:

	li $v0, 4
	la $a0, inMsg
	syscall

	# take input from user
	li $v0, 5
	syscall
	addi $a0, $v0, 0
	
	jal print_and_run
	
	# exit
	li $v0, 10
	syscall

print_and_run:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	add $t0, $a0, $0 

	# print message
	li $v0, 4
	la $a0, msg
	syscall

	# take input and print to screen
	add $a0, $t0, $0
	li $v0, 1
	syscall

	jal fib

	addi $a1, $v0, 0
	li $v0, 4
	la $a0, fibNum
	syscall

	li $v0, 1
	addi $a0, $a1, 0
	syscall
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

#################################################
#         DO NOT MODIFY ABOVE THIS LINE         #
#################################################	
	
fib:
	#Starting conditions - return 0/1 if input is 0/1 (accordingly)
	#This part is before saving to stack so that we won't have to pop everything from stack when reaching END0/END1
	beq $a0, $0, END0
	addi $t0, $0, 1
	beq $a0, $t0, END1

	#Push to stack
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $ra, 12($sp)
	
	#Run fib(n-1) and store in $s0
	addi $a0, $a0, -1
	jal fib
	add $s0, $0, $v0

	#Run fib(n-2) and store in $s1
	addi $a0, $a0, -1
	jal fib
	add $s1, $0, $v0

	#Return value is fib(n-1)+fib(n-2)
	add $v0, $s0, $s1
	
	#Retrieve from stack
	lw $a0, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	jr $ra

	END0:
		#No need to retrieve from stack because we did not change anything
		add $v0, $0, $0
		jr $ra
	END1:
		#Same here - no need to retrieve from stack
		addi $v0, $0, 1
		jr $ra