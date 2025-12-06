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
	twoSolutions: .asciiz "There are two real solutions !\n"
	solutionOne: .asciiz "Solution One = "
	solutionTwo: .asciiz "Solution Two = "
	fallThrough: .asciiz "Fallthrough Fail!"
	const0: .double 0.0
	const1: .double 4.0
	const2: .double 2.0
	newLine: .asciiz "\n"
.text
.globl main
	####################
	# Dfn : Calculates the real solutions for a quadratic equation
	# and prints them out
	# assuming that they actually exist
	####################
	main:
		li $v0, 4 # Printing the prompt for A
		la $a0, promptA
		syscall
		
		li $v0, 7 # Reading A from the user
		syscall
		mov.d $f20, $f0 # Saving A for later
		
		li $v0, 4 # Printing the prompt for B
		la $a0, promptB
		syscall
		
		li $v0, 7 # Reading B from the user
		syscall
		mov.d $f22, $f0 # Saving B for later
		
		li $v0, 4 # Printing the prompt for C
		la $a0, promptC
		syscall
		
		li $v0, 7 # Reading C from the user
		syscall
		mov.d $f24, $f0 # Saving C for later
		
		jal calc_discriminate # Calculating the discriminate first
		
		move $s3, $v0 # Saving the results from the discriminate
		
		# If $s3 < 0, then exit
		slt $t0, $s3, $zero
		beq $t0, 1, no_solutions
		# Else call the quadratic equation
		# Don't need to move A, B, or C, only numSolutions
		move $a0, $s3
		
		jal quadratic
		# The result should be in $f0, and the second one will be $f2
		
		beq $s3, 1, one_solution
		beq $s3, 2, two_solutions
		
		# Otherwise it'll fall through into the end
		li $v0, 4
		la $a0, noSolutions
		syscall
	end:
		li $v0, 10 # Exiting the program
		syscall
	no_solutions:
		# We know that there are no solutions available
		li $v0, 4 # Printing out the finale
		la $a0, noSolutions
		syscall
		
		j end # Jumping to the end of the program
	one_solution:
		li $v0, 4 # Printing out the finale
		la $a0, oneSolution
		syscall
		
		la $a0, solutionOne
		syscall
		
		li $v0, 3
		mov.d $f12, $f0
		syscall
		
		j end # Jumping to the end of the program
	two_solutions:
		li $v0, 4 # Printing out the finale
		la $a0, twoSolutions
		syscall
		
		la $a0, solutionOne # Printing the first solution
		syscall
		
		li $v0, 3 # Printing the first floating point number
		mov.d $f12, $f0
		syscall
		
		li $v0, 4 # Printing a newline character
		la $a0, newLine
		syscall
		
		li $v0, 4 # Printing the second solution
		la $a0, solutionTwo
		syscall
		
		li $v0, 3 # Printing out the second floating point number
		mov.d $f12, $f2
		syscall
		
		j end # Jumping to the end of the program
		
	####################
	# Dfn : Calculates the discriminate of a function, used for figuring out the number of solutions
	# Pre : $f20, $f22, and $f24 will hold a, b, and c respectively as double-precision values
	# Post : $f0 will hold the number of real solutions
	####################
	calc_discriminate:
		l.d $f4, const1 # $f4/5 contains 4.0
		mul.d $f6, $f4, $f20 # $f6/7 contains 4.0 * a
		mul.d $f6, $f6, $f24 # $f6/7 contains 4.0 * a * c
		mul.d $f8, $f22, $f22 # $f8/9 holds b * b
		sub.d $f8, $f8, $f6 # $f8/9 holds (b * b) - (4.0 * a * c)
		l.d $f4, const0 # Remapping $f4/5 into 0.0 for comparisons
		c.eq.d $f8, $f4 # Checking if $f8 == 0.0
		bc1t disc_one
		c.lt.d $f8, $f4 # Checking if $f8 < 0.0
		bc1t disc_none
		# If neither are true, then we can fall through into the fact that it must be greater than 0.0 (hopefully)
	disc_two:
		addi $v0, $zero, 2 # Set $v0 to 2 and end the function
		j disc_end
	disc_one:
		addi $v0, $zero, 1 # Set $v0 to 1 and end the function
		j disc_end
	disc_none:
		and $v0, $v0, $zero
		j disc_end
	disc_end:
		jr $ra
		
	####################
	# Dfn : Calculates the real solutions of a quadratic equation
	# Pre : $f20, $f22, and $f24 will hold a, b, and c respectively
	#       $a0 will hold the number of solutions
	# Post : $v0 will hold the first solution, and $v1 will hold the second solution (if it exists)
	####################
	quadratic:
		beq $a0, $zero, quad_one # If there's only one real solution, we can shortcut our math
		l.d $f4, const1 # $f4/5 contains 4.0
		mul.d $f6, $f4, $f20 # $f6/7 contains 4.0 * a
		mul.d $f6, $f6, $f24 # $f6/7 contains 4.0 * a * c
		mul.d $f8, $f22, $f22 # $f8/9 holds b * b
		sub.d $f8, $f8, $f6 # $f8/9 holds (b * b) - (4.0 * a * c)
		
		# $f4 is free to use, $f6 is free to use
		l.d $f4, const2 # Getting a const of 2
		neg.d $f6, $f22 # Getting -b
		sqrt.d $f10, $f8 # $f4 = sqrt((b * b) - (4.0 * a * c))
		mul.d $f8, $f4, $f20 # 2 * a
		
		# Addition
		add.d $f16, $f6, $f10
		div.d $f0, $f16, $f8
		
		# Subtraction
		sub.d $f18, $f6, $f10
		div.d $f2, $f18, $f8
		j quad_end
	quad_one:
		# Because the value inside the sqrt is 0, we can just omit that from our calculations
		l.d $f4, const2 # Getting a const of 2
		neg.d $f6, $f22 # Getting -b
		mul.d $f8, $f4, $f20 # 2 * a
		div.d $f0, $f6, $f8 # -b / (2 * a)
	quad_end:
		jr $ra
