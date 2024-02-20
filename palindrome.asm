# check if user provided string is palindrome

.data

userInput: .space 64
stringAsArray: .space 256

welcomeMsg: .asciiz "Enter a string: "
calcLengthMsg: .asciiz "Calculated length: "
newline: .asciiz "\n"
yes: .asciiz "The input is a palindrome!"
no: .asciiz "The input is not a palindrome!"
notEqualMsg: .asciiz "Outputs for loop and recursive versions are not equal"

.text

main:

	li $v0, 4
	la $a0, welcomeMsg
	syscall
	la $a0, userInput
	li $a1, 64
	li $v0, 8
	syscall

	li $v0, 4
	la $a0, userInput
	syscall
	
	# convert the string to array format
	la $a1, stringAsArray
	jal string_to_array
	
	addi $a0, $a1, 0
	
	# calculate string length
	jal get_length
	addi $a1, $v0, 0
	
	li $v0, 4
	la $a0, calcLengthMsg
	syscall
	
	li $v0, 1
	addi $a0, $a1, 0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	la $a0, stringAsArray
	
	# Swap a0 and a1
	addi $t0, $a0, 0
	addi $a0, $a1, 0
	addi $a1, $t0, 0
	addi $t0, $zero, 0
	
	# Function call arguments are caller saved
	addi $sp, $sp, -8
	sw $a0, 4($sp)
	sw $a1, 0($sp)
	
	# check if palindrome with loop
	jal is_pali_loop
	
	# Restore function call arguments
	lw $a0, 4($sp)
	lw $a1, 0($sp)
	addi $sp, $sp, 8
	
	addi $s0, $v0, 0
	
	# check if palindrome with recursive calls
	jal is_pali_recursive
	bne $v0, $s0, not_equal
	
	beq $v0, 0, not_palindrome

	li $v0, 4
	la $a0, yes
	syscall
	j end_program

	not_palindrome:
		li $v0, 4
		la $a0, no
		syscall
		j end_program
	
	not_equal:
		li $v0, 4
		la $a0, notEqualMsg
		syscall
		
	end_program:
	li $v0, 10
	syscall
	
string_to_array:	
	add $t0, $a0, $zero
	add $t1, $a1, $zero
	addi $t2, $a0, 64

	
	to_arr_loop:
		lb $t4, ($t0)
		sw $t4, ($t1)
		
		addi $t0, $t0, 1
		addi $t1, $t1, 4
	
		bne $t0, $t2, to_arr_loop
		
	jr $ra


#################################################
#         DO NOT MODIFY ABOVE THIS LINE         #
#################################################
	
get_length:
	addi $sp, $sp, -4
	sw $a0, 0($sp)

	lb $t0, newline
	addi $t1, $0, -1

	LOOP:
		lw $t2, 0($a0)

		addi $a0, $a0, 4
		addi $t1, $t1, 1

		bne $t2, $t0, LOOP
		
	add $v0, $t1, $0

	lw $a0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
is_pali_loop:
	addi $sp, $sp, -4
	sw $a1, 0($sp)

	#save last char's address in $t1
	sll $a0, $a0, 2
	add $t1, $a1, $a0
	addi $t1, $t1, -4
	sra $a0, $a0, 2

	addi $t2, $0, 0 #Counter
	sra $a0, $a0, 1
	addi $v0, $0, 0
	
	LOOP1:
		lw $t4, 0($t1)
		lw $t5, 0($a1)

		beq $t2, $a0, YES #Reached end
		bne $t4, $t5, NO #Found non-equal char

		addi $t1, $t1, -4
		addi $a1, $a1, 4

		addi $t2, $t2, 1
		beq $t4, $t5, LOOP1 #Next iteration

	YES:
		addi $v0, $v0, 1
	NO:
		addi $v0, $v0, 0

	lw $a1, 0($sp)
	addi $sp, $sp, 4

	jr $ra

is_pali_recursive:

	beq $a0, 1, SUCCESS #One character string is a palindrome

	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)

	#Save last char's address into $t1
	sll $a0, $a0, 2
	add $t1, $a1, $a0
	addi $t1, $t1, -4
	sra $a0, $a0, 2

	#Compare last and first
	lw $t2, 0($a1)
	lw $t3, 0($t1)

	bne $t2, $t3, FAILURE

	#Run recursion with new parameters
	addi $a1, $a1, 4
	addi $a0, $a0, -2
	jal is_pali_recursive

	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	jr $ra

	SUCCESS:
		addi $v0, $0, 1
		jr $ra
	FAILURE:
		addi $v0, $0, 0
		jr $ra