###################
# Emerson Rogers
# erogers23@georgefox.edu
# Calculating the root(s) of a quadratic equation
###################
.data
	promptA: .asciiz "Enter an integer for A: "
	promptB: .asciiz "Enter an integer for B: "
	promptC: .asciiz "Enter an integer for C: "
	noSolutions: .asciiz "There are no real solutions"
	oneSolution: .asciiz "There is one real solution"
	twoSolutions: .asciiz "There are two real solutions"
	solutionOne: .asciiz "Solution One = "
	solutionTwo: .asciiz "Solution Two = "
.text
.globl main
	####################
	main:
		li $v0, 4 # Printing the prompt for A
		la $a0, promptA
		syscall
		
		li $v0, 5 # Reading A from the user
		syscall
		move $s0, $v0 # Saving A for later
		
		li $v0, 4 # Printing the prompt for B
		la $a0, promptB
		syscall
		
		li $v0, 5 # Reading B from the user
		syscall
		move $s1, $v0 # Saving B for later
		
		li $v0, 4 # Printing the prompt for C
		la $a0, promptB
		syscall
		
		li $v0, 5 # Reading C from the user
		syscall
		move $s2, $v0 # Saving C for later
		
		add $a0, $zero, $s0 # Adding A, B, and C into arguments
		add $a1, $zero, $s1
		add $a2, $zero, $s2
		jal calc_discriminate # Calculating the discriminate first
		
		move $s3, $v0 # Saving the results from the discriminate
		
		# If $s3 == 0, then exit
		beq $s3, $zero, no_solutions
		# Else call the quadratic equation
		# Don't need to move A, B, or C, only numSolutions
		move $s3, $a3
		
	end:
		li $v0, 10 # Exiting the program
		syscall
	no_solutions:
		# We know that there are no solutions available
		li $v0, 4 # Printing out the finale
		la $a0, noSolutions
		syscall
		
		j end # Jumping to the end of the program
	calc_discriminate:
		mul $t0, $a1, $a1 # (b * b)
		mul $v0, $a0, 4 # 4 * a
		mul $v0, $v0, $a2 # 4 * a * c
		sub $v0, $t0, $v0 # (b * b) - (4 * a * c)
		beq $v0, $zero, disc_end # if $v0 == 0, just end the function
		

	disc_end:
		jr $ra
