module reg_writer(done, regnum, direction, go, clock, reset);

	input direction, go;
	input clock, reset;

	output done;
	output [4:0] regnum;

	wire sGarbage, sStart, sUp1, sUp2, sUp3, sUp4, sDown1, sDown2, sDown3, sDown4, sDone;
	wire sGarbage_next, sStart_next, sUp1_next, sUp2_next, sUp3_next, sUp4_next,
				sDown1_next,sDown2_next,sDown3_next,sDown4_next, sDone_next;
  //add ~reset
	// change wire to assign.

	assign sGarbage_next =(sGarbage & ~go) | reset ;
	assign sStart_next = ((sStart & go) | (sGarbage & go) | (sDone & go)) & ~reset;

	assign sUp1_next = direction & ~go & sStart & ~reset ;//changed
	assign sUp2_next = sUp1 & ~reset;
	assign sUp3_next = sUp2 & ~reset;
	assign sUp4_next = sUp3 & ~reset;

	assign sDown1_next = ~direction & ~go & sStart & ~reset;//changed
	assign sDown2_next = sDown1 & ~reset;
	assign sDown3_next = sDown2 & ~reset;
	assign sDown4_next = sDown3 & ~reset;

	assign sDone_next = ( sUp4 | sDown4 | (sDone & ~go))&~reset;

	dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe fsStart(sStart, sStart_next, clock, 1'b1, 1'b0);

	dffe fsUp1(sUp1, sUp1_next, clock, 1'b1, 1'b0);
	dffe fsUp2(sUp2, sUp2_next, clock, 1'b1, 1'b0);
	dffe fsUp3(sUp3, sUp3_next, clock, 1'b1, 1'b0);
	dffe fsUp4(sUp4, sUp4_next, clock, 1'b1, 1'b0);

	dffe fsDown1(sDown1, sDown1_next, clock, 1'b1, 1'b0);
	dffe fsDown2(sDown2, sDown2_next, clock, 1'b1, 1'b0);
	dffe fsDown3(sDown3, sDown3_next, clock, 1'b1, 1'b0);
	dffe fsDown4(sDown4, sDown4_next, clock, 1'b1, 1'b0);
	dffe fsDone(sDone, sDone_next, clock, 1'b1, 1'b0);

	//done should return fsGarbage again?
//	reset =  1'b1; //clear ?

	assign done = sDone ;

	assign regnum = sStart ? 8 :
			sDown1 ? 7 :
			sDown2 ? 6 :
			sDown3 ? 5 :
			sDown4 ? 4 :
			sUp1   ? 9 :
			sUp2   ? 10:
			sUp3   ? 11:
			sUp4   ? 12:
			0;
endmodule // end reg_writer
