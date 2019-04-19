.text

## bool
## rule1(unsigned short board[GRID_SQUARED][GRID_SQUARED]) {
##   bool changed = false;
##   for (int i = 0 ; i < GRID_SQUARED ; ++ i) {
##     for (int j = 0 ; j < GRID_SQUARED ; ++ j) {
##       unsigned value = board[i][j];

##       if (has_single_bit_set(value)) {
##         for (int k = 0 ; k < GRID_SQUARED ; ++ k) {
##           // eliminate from row
##           if (k != j) {
##             if (board[i][k] & value) {
##               board[i][k] &= ~value;
##               changed = true;
##             }
##           } next1
##           // eliminate from column
##           if (k != i) {
##             if (board[k][j] & value) {
##               board[k][j] &= ~value;
##               changed = true;
##             }
##           }
##         }
##
##         // elimnate from square
##         int ii = get_square_begin(i);
##         int jj = get_square_begin(j);
##         for (int k = ii ; k < ii + GRIDSIZE ; ++ k) {
##           for (int l = jj ; l < jj + GRIDSIZE ; ++ l) {
##             if ((k == i) && (l == j)) {
##               continue;
##             }
##             if (board[k][l] & value) {
##               board[k][l] &= ~value;
##               changed = true;
##             }
##           }
##         }
##       }

##     }
##   }
##   return changed;
## }

.globl rule1
rule1:
			sub 	$sp,  $sp, 	36				#allocating 36bytes on stack.

			sw		$ra, 	0($sp)					# allocate return in stack.

			sw		$s0, 	4($sp)					# creating safe register in stack
			li		$s0,  0								# allocate (i) in safe register.

			sw		$s1, 	8($sp)					# creating safe register in stack
			li		$s1,  0								# allocate (j) in safe register.

			sw		$s2, 	12($sp)					# creating safe register in stack


			sw		$s3, 	16($sp)					# creating safe register in stack
			li		$s3,  0				  			# allocate  (bool changed) in safe register

			sw 		$s4,	20($sp)					# (value) stored.

			sw		$s5,	24($sp)					# (k1) stored.
			li		$s5,	0								#	allocate (k1) in safe register.

			sw		$s6,	28($sp)					#

			sw		$s7,	32($sp)					#	(board) stored
			move	$s7,  $a0					  	# allocate  (argument) in safe register

rule1_loop:
			mul		$t0,	$s0,	16				# N(size) * i
			add 	$t0,	$t0,	$s1				# N*i +j
			mul		$t0,	$t0,	2					# (N*i +j) * sizeOfElement(2,short)
			add 	$t0,	$s7,	$t0				# &board[i][j]
			lhu		$a0,	0($t0)					# at $a0(value), dereference board [i][j]

			move 	$s4,	$a0 						# s4 = value

			jal		has_single_bit_set					# jump and link to the function.
			beq 	$v0,	0,	skip_in_loop 			# if(bool) is false -> go to skip_in_loop



first_loop:
			## for loop again ##
			beq 	$s5,	$s1,	next1				#k == j ? go next1

			mul		$t0,	$s0,	16					# N(size) * i
			add 	$t0,	$t0,	$s5					# N*i + k(t1)
			mul		$t0,	$t0,	2						# (N*i +k) * sizeOfElement(2,short)
			add 	$t0, 	$s7,	$t0					# A[0][0] + (N*i +k) , &board[i][k]

			move	$s6,	$t0								#store address of board[i][k]

			lhu		$s2,	0($s6)						# s2  = value of board[i][k]

			#if (board[i][k] & value)

			and 	$t2,	$s4, 	$s2					# t2 = board[i][k] & value
			bne		$t2,	$s4,	next1					# if false, next1

			not 	$t3,	$s4								# ~value
			and 	$s2,	$s2,	$t3					# board[i][k] &= ~value
			sh 		$s2 	0($s6)
			li		$s3,		1								# changed = true;

next1:
			beq 	$s5,	$s0,	next2				#k == i ? go next2

			mul		$t0,	$s5,	16					#  N(size) * k
			add 	$t0,	$t0,	$s1					#  N*k +j
			mul		$t0,	$t0,	2						# (N*k +j) * sizeOfElement(2,short)
			add 	$t0,	$s7,	$t0					# &board[k][j]

			move	$s6,	$t0								#store address of board[k][j]

			lhu		$s2,	0($s6)						# s2 = value of board[k][j]

			#if (board[k][j] & value)

			and 	$t2,	$s4,	$s2
			bne		$t2,	$s4,	next2

			not 	$t3,	$s4								# ~value
			and 	$s2,	$s2,	$t3					# board[i][k] &= ~value
			sh 		$s2 	0($s6)
			li		$s3,		1								# changed = true;

next2:
			add 	$s5,	$s5,	1						# k++;
			blt 	$s5,	16,	first_loop		# if k<16, come back to first_loop
      li 		$s5,		0									# reset k = 0

body1:
			move	$a0,	$s0
			jal		get_square_begin
			move	$t6, $v0								# int ii = get_square_begin(i);

			move	$a0,	$s1
			jal		get_square_begin
			move	$t7, $v0								# int jj = get_square_begin(j);
      move $t5, $t7  #store jj

			add 		$t8, 	$t6,	4
			add 		$t9,	$t7,	4

second_loop:


			mul		$t0,	$t6,	16				  # N(size) * k
			add 	$t0,	$t0,	$t7				# N*k +l
			mul		$t0,	$t0,	2					# (N*k +l) * sizeOfElement(2,short)
			add 	$t0,	$s7,	$t0				# &board[k][l]

			move	$s6,	$t0
			lhu		$s2,	0($s6)


			bne  	$t6,	$s0,	next3			#two conditional
			bne 	$t7,	$s1, 	next3
			j			next4

next3:

			and 	$t2,	$s4,	$s2
			beq		$t2,	0,	next4

			not 	$t3,	$s4									# ~value
			and 	$s2,	$s2,	$t3					  # board[i][k] &= ~value
			sh 		$s2 	0($s6)
			li		$s3,		1									# changed = true;


next4:
			add 	$t7,	$t7,	1							# l++;
			blt 	$t7,	$t9, 	second_loop		# if l<l+4, come back to loop.
			move  $t7, $t5									# reset l = jj

			add 	$t6,	$t6,	1							# k++;
			blt 	$t6,	$t8, 	second_loop		# if k<K+4, come back to loop.


skip_in_loop:

			add 	$s1,	$s1,	1							# j++;
			blt 	$s1,	16, 	rule1_loop		# if j<16, come back to loop.
			li 		$s1,		0									# reset j = 0

			add 	$s0,	$s0,	1							# i++;
			blt 	$s0,	16, 	rule1_loop		# if i<16, come back to loop.


finally:
			move 	$v0,	$s3							# return v0 = changed.

			lw		$ra,	0($sp)					# load return value again.
			lw 		$s0, 	4($sp)					# load s0 to i again
			lw 		$s1, 	8($sp)					# load s1 to j again
			lw		$s2, 	12($sp)					# load s2 to (argument) again
			lw		$s3, 	16($sp)					# load s3 to (changed) again
			lw		$s4,	20($sp)
			lw		$s5,	24($sp)
			lw 		$s6,	28($sp)
			lw		$s7		32($sp)

			add 	$sp,  $sp, 	36				# clear the memory.
			jr		$ra										# Exit
