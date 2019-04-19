
module palindrome_control(palindrome, done, select, load, go, a_ne_b, front_ge_back, clock, reset);
	output load, select, palindrome, done;
	input go, a_ne_b, front_ge_back;
	input clock, reset;

	wire garbage, start, intermediate, done_pal, done_no_pal;
	wire garbage_next, start_next, intermediate_next, done_pal_next, done_no_pal_next;

	//assign garbage_next = (garbage & ~go & reset) | (done_pal & reset) | (done_no_pal & reset) | reset;
	assign garbage_next =(garbage & ~go) | reset ;
	assign start_next = (start & go & ~reset) | (garbage & go & ~reset) | (done_pal & go & ~reset) | (done_no_pal & go & ~reset);
//	assign intermediate_next = (start & ~front_ge_back & a_ne_b & ~reset) | (~a_ne_b & front_ge_back & ~reset);
	assign intermediate_next = (start & ~go & ~reset) | (intermediate & ~a_ne_b & ~front_ge_back & ~reset);
	assign done_pal_next =  (intermediate & front_ge_back & ~a_ne_b & ~reset) | (done_pal & ~go & ~reset);
	assign done_no_pal_next = (intermediate & a_ne_b & ~reset) | (done_no_pal & ~go & ~reset);

	//dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	//dffe fsStart(sStart, sStart_next, clock, 1'b1, 1'b0);

	dffe fsGarbage(garbage, garbage_next, clock, 1'b1, 1'b0);
	dffe fsStart(start, start_next, clock, 1'b1, 1'b0);
	dffe fsIntermediate(intermediate, intermediate_next, clock, 1'b1, 1'b0);
	dffe fsDone_Pal(done_pal, done_pal_next, clock, 1'b1, 1'b0);
	dffe fsDone_No_Pal(done_no_pal, done_no_pal_next, clock, 1'b1, 1'b0);

	// assign load = (start & ~garbage & ~intermediate & ~done_pal & ~ done_no_pal)  | (intermediate & ~garbage & ~start & ~done_pal & ~done_no_pal);
	// assign select = (intermediate & ~garbage & ~start & ~done_pal & ~done_no_pal);
	// assign palindrome = (done_pal & ~garbage & ~start & ~intermediate & ~done_no_pal);
	// assign done = (done_pal & ~garbage & ~start & ~intermediate & ~done_no_pal) | (done_no_pal & ~garbage & ~start & ~intermediate & ~done_pal);


	assign load = start | intermediate;
	assign select = intermediate;
	assign palindrome = done_pal;
	assign done = done_pal | done_no_pal;

endmodule // palindrome_control
