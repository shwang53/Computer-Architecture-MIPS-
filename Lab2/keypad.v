module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;

	// adding all the combination that contains 1 in 0th digit of 4bit binary.
	assign number[0] = ((a && !b && !c && d && !e && !f && !g) || (!a && !b && c && d && !e && !f && !g) || 
				   		(!a && b && !c && !d && e && !f && !g) || (a && !b && !c && !d && !e && f && !g) ||
				  		(!a && !b && c && !d && !e && f && !g)); 

	// adding all the combination that contains 1 in 1th digit of 4bit binary.
	assign number[1] = ((!a && b && !c && d && !e && !f && !g) || (!a && !b && c && d && !e && !f && !g) || 
				   		(!a && !b && c && !d && e && !f && !g) || (a && !b && !c && !d && !e && f && !g) );

	// adding all the combination that contains 1 in 2th digit of 4bit binary.
	assign number[2] =  ((a && !b && !c && !d && e && !f && !g) || (!a && b && !c && !d && e && !f && !g) || 
				   		(!a && !b && c && !d && e && !f && !g) || (a && !b && !c && !d && !e && f && !g) );

	// adding all the combination that contains 1 in 3th digit of 4bit binary.
	assign number[3] = ((!a && b && !c && !d && !e && f && !g) || (!a && !b && c && !d && !e && f && !g) );

	assign valid = number[0] || number [1] || number[2] || number[3] || (!a && b && !c && !d && !e && !f && g);


	
	



endmodule // keypad
