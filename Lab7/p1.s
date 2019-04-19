.text

## bool has_single_bit_set(unsigned value) {  // returns 1 if a single bit is set
##   if (value == 0) {
##     return 0;   // has no bits set
##   }
##   if (value & (value - 1)) {
##     return 0;   // has more than one bit set
##   }
##   return 1;
## }

.globl has_single_bit_set

has_single_bit_set:
	bne		$a0,	 0,	 next			# if value !=0, go to next.
	li 		$v0,	 0						# if value == 0, return 0.
	jr 		$ra									# Exit

next:
	sub	 	$t1, $a0, 	1						# t1 = value -1
	and	  $t2, $a0, 	$t1					# t2 = value & (value-1)

	beq	  $t2, 	 0, 	final				# if(value & value-1 == 0), go to final
	li		$v0,	 0								# return 0
	jr		$ra											# Exit

final:
	li 		$v0,		1						 # return 1.
	jr		$ra									 # Exit


## unsigned get_lowest_set_bit(unsigned value) {
##   for (int i = 0 ; i < 16 ; ++ i) {
##     if (value & (1 << i)) {          # test if the i'th bit position is set
##       return i;                      # if so, return i
##     }
##   }
##   return 0;
## }

.globl get_lowest_set_bit

get_lowest_set_bit:
	li		$t0, 			0 			   	#i = 0

loop:
	li 		   	$t3,	 	 		1								  	# store $t3 = 1.
	sllv		  $t2, 	    	$t3,			$t0				# $t2 = (1 << t)
	and		    $t1, 	    	$a0, 			$t2				# $t1 = value & (1 << i)
	bne 		  $t1, 		  	0,		   	final2		# if $t1 != 0, go to final2 and return i.

	add 	  	$t0,		   $t0,		    1			  	# i++
	blt 		  $t0,			 16, 	  		loop		  # i<16

	li 		  	$v0, 				0									  # if nothing was returned, return 0/
	jr		  	$ra													  	# Exit

final2:
	move 	  	$v0,			$t0									  # return i.
	jr		    $ra								     				  # Exit
