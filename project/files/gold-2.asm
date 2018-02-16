.data
	screen_start: 		.word 0x10000000		# Screen Top left Memory Location
	# screen_top_right:	.word 0x10000080
	# screen_bottom_left:	.word 0x10000f80
	# screen_bottom_right:	.word 0x10000ffc
	screen_end:		.word 0x10000ffc		# Screen bottom right Memory Location
	ground_start:		.word 0x10000184		# Memory of Third row second memory address for ground starting point
	mid_start:		.word 0x100000bc		# Design Mid-line of game		
	mid_p1:			.word 0x10000684
	mid_p2:			.word 0x10000C4C
	mid_p3:			.word 0x10001214
	mid_p4:			.word 0x100017DC
	mid_p5:			.word 0x10001DA4
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

	############################################################################################################	
	exit:
		li	$v0,10
		syscall