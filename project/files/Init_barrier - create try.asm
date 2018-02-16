.data
	screen_start: 		.word 0x10000000		# Screen Top left Memory Location
	# screen_top_right:	.word 0x10000080
	# screen_bottom_left:	.word 0x10000f80
	# screen_bottom_right:	.word 0x10000ffc
	screen_end:		.word 0x10000ffc		# Screen bottom right Memory Location
	ground_start:		.word 0x10000184		# Memory of Third row second memory address for ground starting point
	Input_Character:	.word 0xffff0004		# Memory Address to Store Input Character
	# start memory address for anchor pixels
	Anchor_one:		.word 0x10000088
	Anchor_two:		.word 0x10000104
	Anchor_three:		.word 0x10000108
	Anchor_four:		.word 0x1000010c
	pixel:  		.word 1024			# Total Number of Pixel in Whole Map
	barrier_length: 	.word 32			# Length of Barrier in One Direction
	
	# RGB code for colors
	red:			.word 0x00ff0000			
	green:			.word 0x0000ff00
	blue:			.word 0x000000ff
	black:			.word 0x00000000
	white:			.word 0x00ffffff
	yellow:			.word 0x00ffff00

.text
	main:
	############################################################################################################
	# start draw map		
	drawMap:	
		j	drawBarrier				# jump to start draw barrier
	############################################################################################################		
	# Function to set barrier color
	drawBarrier:
		lw	$t2,green				# load t2 to barrier color
	############################################################################################################		
	# Function to set Start location and number of barrier pixel
	setNorthStart:
		lw	$t0, screen_start			# load t0 to barrier start location
		lw	$t4, barrier_length			# load t4 to length of barrier in one direction	
	############################################################################################################	
	# Function to recurion draw barrier in north	
	drawNorthBarrierLoop:
		sw	$t2, ($t0)				# store color in object location
		addi	$t0,$t0,4				# add address to next location
		subi	$t4,$t4,1				# decrease remianing barrier length by one
		bgtz	$t4,drawNorthBarrierLoop		# recursion until remaining barrier length is zero
	############################################################################################################	
	# Function to reset Start location and number of barrier pixel	
	setNorthStartTwo:
		lw	$t0, screen_start			# load t0 to barrier start location
		lw	$t4, barrier_length			# load t4 to length of barrier in one direction	
	############################################################################################################	
	# Function to recurion draw barrier in west
	drawWestBarrierLoop:
		sw	$t2, ($t0)				# store color in object location
		addi	$t0,$t0,128				# add address to next location
		subi	$t4,$t4,1				# decrease remianing barrier length by one
		bgtz	$t4,drawWestBarrierLoop			# recursion until remaining barrier length is zero
	############################################################################################################	
	# Function to reset Start location and number of barrier pixel	
	setEndStart:
		lw	$t0, screen_end				# load t0 to barrier end location
		lw	$t4, barrier_length			# load t4 to length of barrier in one direction	
	############################################################################################################	
	# Function to recurion draw barrier in south	
	drawSouthBarrierLoop:
		sw	$t2, ($t0)				# store color in object location
		subi	$t0,$t0,4				# subtract address to previous location
		subi	$t4,$t4,1				# decrease remianing barrier length by one
		bgtz	$t4,drawSouthBarrierLoop		# recursion until remaining barrier length is zero
	############################################################################################################	
	# Function to reset Start location and number of barrier pixel		
	setEndStartTwo:
		lw	$t0, screen_end				# load t0 to barrier start location
		lw	$t4, barrier_length			# load t4 to length of barrier in one direction	
	############################################################################################################
	# Function to recurion draw barrier in east	
	drawEastBarrierLoop:
		sw	$t2, ($t0)				# store color in object location
		subi	$t0,$t0,128				# subtract address to previous location
		subi	$t4,$t4,1				# decrease remianing barrier length by one
		bgtz	$t4,drawEastBarrierLoop			# recursion until remaining barrier length is zero
	############################################################################################################	
	# Function to reset Start location and number of barrier pixel		
	setGroundStart:
		lw	$t0,ground_start			# load t0 to barrier start location
		lw	$t4, barrier_length			# load t4 to length of barrier in one direction	
		subi	$t4,$t4,2				# subtract barrier length by two because ground must not overwrite barrier 
		lw	$t2, white				# load t2 to barrier color
	############################################################################################################
	# Function to recurion draw ground		
	drawGround:
		sw	$t2, ($t0)				# store color in object location
		addi	$t0,$t0,4				# add address to next location
		subi	$t4,$t4,1				# decrease remianing ground length by one
		bgtz	$t4,drawGround				# recursion until remaining gound length is zero
	############################################################################################################	
	# Function to draw anchor
	# $t1 save memory location for up-medium bracket
	# $t3 save memory location for dowm-left bracket
	# $t5 save memory location for down-medium bracket
	# $t7 save memory location for down-right bracket
	drawAnchor:
		lw	$t2,blue				# load t2 to Anchor color
		lw	$t1,Anchor_one				# load t1 to Anchor First location
		sw	$t2,($t1)				# store color in object location
		lw	$t5,Anchor_two				# load t3 to Anchor Second location
		sw	$t2,($t5)				# store color in object location
		lw	$t6,Anchor_three			# load t5 to Anchor Third location
		sw	$t2,($t6)				# store color in object location
		lw	$t7,Anchor_four				# load t7 to Anchor Fourth location
		sw	$t2,($t7)				# store color in object location
	
	############################################################################################################

	# create random golds
	create_gold:
		lw 	$t2,yellow				# Use t2 to store gold color
		
		lw 	$t0,mid_p1				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 15 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8					# get the memory position to store gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,4					# create second position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,128					# create third position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		subi	$t0,$t0,4					# create forth position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		
		lw 	$t0,mid_p1				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 15 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		add	$t0,$t0,$t8					# get the memory position to store gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,4					# create second position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,128					# create third position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		subi	$t0,$t0,4					# create forth position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		
		lw 	$t0,mid_p2				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 15 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8					# get the memory position to store gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,4					# create second position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,128					# create third position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		subi	$t0,$t0,4					# create forth position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		
		lw 	$t0,mid_p2				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 15 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		add	$t0,$t0,$t8					# get the memory position to store gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,4					# create second position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,128					# create third position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		subi	$t0,$t0,4					# create forth position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		
		lw 	$t0,mid_p3				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 15 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8					# get the memory position to store gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,4					# create second position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,128					# create third position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		subi	$t0,$t0,4					# create forth position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		
		lw 	$t0,mid_p3				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 15 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		add	$t0,$t0,$t8					# get the memory position to store gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,4					# create second position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,128					# create third position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		subi	$t0,$t0,4					# create forth position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		
		lw 	$t0,mid_p4				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 15 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8					# get the memory position to store gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,4					# create second position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,128					# create third position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		subi	$t0,$t0,4					# create forth position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		
		lw 	$t0,mid_p4				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 15 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		add	$t0,$t0,$t8					# get the memory position to store gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,4					# create second position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,128					# create third position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		subi	$t0,$t0,4					# create forth position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		
		lw 	$t0,mid_p5				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 15 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8					# get the memory position to store gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,4					# create second position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,128					# create third position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		subi	$t0,$t0,4					# create forth position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		
		lw 	$t0,mid_p5				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 15 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		add	$t0,$t0,$t8					# get the memory position to store gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,4					# create second position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		addi	$t0,$t0,128					# create third position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
		subi	$t0,$t0,4					# create forth position for gold
		sw	$t2,($t0)					# store memory with yellow to represent gold
	
	############################################################################################################	
	exit:
		li	$v0,10
		syscall
