.text

## bool
## board_done(unsigned short board[16][16]) {
##   for (int i = 0 ; i < 16 ; ++ i) {
##     for (int j = 0 ; j < 16 ; ++ j) {
##       if (!has_single_bit_set(board[i][j])) {
##         return false;
##       }
##     }
##   }
##   return true;
## }

.globl board_done

board_done:
				sub 	$sp,  $sp, 	16				#allocating 16bytes on stack.

				sw		$ra, 	0($sp)					# allocate return in stack.

				sw		$s0, 	4($sp)					# creating safe register in stack
				li		$s0,  0								# allocate (i) in safe register.

				sw		$s1, 	8($sp)					# creating safe register in stack
				li		$s1,  0								# allocate (j) in safe register.

				sw		$s2, 	12($sp)					# creating safe register in stack
				move	$s2,  $a0					  	# allocate  (argument) in safe register.

p2_loop:
				mul		$t2,	$s0,	16				# N(size) * i
				add 	$t3,	$t2,	$s1				# N*i +j
				mul		$t4,	$t3,	2					# (N*i +j) * sizeOfElement(2,short)
				add 	$t4,	$s2,	$t4				# &board[i][j]
				lhu		$a0,	0($t4)					# at $a0, dereference board [i][j]

				jal		has_single_bit_set		# jump and link to the function.
				beq 	$v0,	0,		skip 			# if(bool) is false -> go to skip and return false.


				add 	$s1,	$s1,	1					# j++;
				blt 	$s1,	16, 	p2_loop		# if j<16, come back to loop.
				li 		$s1,		0							# reset j = 0

				add 	$s0,	$s0,	1					# i++;
				blt 	$s0,	16, 	p2_loop		# if i<16, come back to loop.

				li 		$v0,	1							  # if nothing was returned, return 1, true.
				lw		$ra,	0($sp)					# load return value again.
				lw 		$s0, 	4($sp)					# load s0 to i again
				lw 		$s1, 	8($sp)					# load s1 to j again
				lw		$s2, 	12($sp)					# load s2 to argument again
				add 	$sp,  $sp, 	16				# clear the memory.
				jr		$ra										# Exit


skip:
				li		$v0,	0								#return 0. false.
				lw		$ra,	0($sp)					# load return value again.
				lw 		$s0, 	4($sp)					# load s0 to i again
				lw 		$s1, 	8($sp)					# load s1 to j again
				lw		$s2, 	12($sp)					# load s2 to argument again
				add 	$sp,  $sp, 	16				# clear the memory.
				jr		$ra										# Exit



## void
## print_board(unsigned short board[16][16]) {
##   for (int i = 0 ; i < 16 ; ++ i) {
##     for (int j = 0 ; j < 16 ; ++ j) {
##       int value = board[i][j];
##       char c = '*';
##       if (has_single_bit_set(value)) {
##         int num = get_lowest_set_bit(value) + 1;
##         c = symbollist[num];
##       }
##       putchar(c);
##     }
##     putchar('\n');
##   }
## }

.globl print_board
print_board:
				sub 	$sp,  $sp, 	16				#allocating 16bytes on stack.

				sw		$ra, 	0($sp)					# allocate return in stack.

				sw		$s0, 	4($sp)					# creating safe register in stack
				li		$s0,  0								# allocate (i) in safe register.

				sw		$s1, 	8($sp)					# creating safe register in stack
				li		$s1,  0								# allocate (j) in safe register.

				sw		$s2, 	12($sp)					# creating safe register in stack
				move	$s2,  $a0					  	# allocate  (argument) in safe register



p22_loop :
				mul		$t2,	$s0,	16				# N(size) * i
				add 	$t3,	$t2,	$s1				# N*i +j
				mul		$t4,	$t3,	2					# (N*i +j) * sizeOfElement(2,short)
				add 	$t4,	$s2,	$t4				# &board[i][j]

				lhu		$a0,	0($t4)					# at $a0, value = board [i][j]

				jal		has_single_bit_set		# jump and link to the function.
				bne 	$v0,	0,	 p22_skip 	# if(bool) is true -> go to skip

				#putchar(c)
				li		$a0,	'*'
				li		$v0,  11
				syscall

dine_printing_char:
				add 	$s1,	$s1,	1				  	# j++;
				blt 	$s1,	16, 	p22_loop  	# if j<16, come back to loop.

				#putchar('\n')
				li		$a0,	'\n'
				li		$v0,   11
				syscall

				li 		$s1,		0						  	# reset j = 0

				add 	$s0,	$s0,	1				    # i++;
				blt 	$s0,	16, 	p22_loop		# if i<16, come back to loop.


				lw		$ra,	0($sp)					# load return value again.
				lw 		$s0, 	4($sp)					# load s0 to i again
				lw 		$s1, 	8($sp)					# load s1 to j again
				lw		$s2, 	12($sp)					# load s2 to argument again
				add 	$sp,  $sp, 	16				# clear the memory.
				jr		$ra										# Exit


p22_skip:

				mul		$t2,	$s0,	16				# N(size) * i
				add 	$t3,	$t2,	$s1				# N*i +j
				mul		$t4,	$t3,	2					# (N*i +j) * sizeOfElement(2,short)
				add 	$t4,	$s2,	$t4				# &board[i][j]
				lhu		$a0,	0($t4)					# at $a0, value = board [i][j]

				#int num = get_lowest_set_bit(value) + 1;
				jal		get_lowest_set_bit
				add   $t5,	$v0,	1

				# c = symbollist[num];
				la 		$t6, symbollist
				add 	$t6,	$t5,	$t6				#
				lbu		$a0,	0($t6)					#
				li		$v0,   11
				syscall

				j			dine_printing_char

p22_note:

				lw		$ra,	0($sp)					# load return value again.
				lw 		$s0, 	4($sp)					# load s0 to i again
				lw 		$s1, 	8($sp)					# load s1 to j again
				lw		$s2, 	12($sp)					# load s2 to argument again
				add 	$sp,  $sp, 	16				# clear the memory.
				jr		$ra										# Exit
