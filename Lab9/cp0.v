`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here

   wire   [31:0] user_status_, decoder_out_;

   wire   [31:0] cause_register  = {16'b0, TimerInterrupt, 15'b0};
   wire   [31:0] status_register = {16'b0, user_status_[15:8], 6'b0, exception_level, user_status_[0]};

   wire   [29:0] temp, EPC_D;
   assign EPC = temp;

   wire	  exception_level;

   wire   decode12th = decoder_out_[12];
   wire   decode14th = decoder_out_[14];

   wire check1 = reset | ERET;
   wire check2 = decode14th | TakenInterrupt;
   wire check3 = cause_register[15]&status_register[15];
   wire check4 = ~status_register[1]&status_register[0];

   wire TakenInterrupt = check3 & check4;


   register reg_user_status(user_status_, wr_data, clock, decode12th, reset);

   register #(1,) reg_exception_level(exception_level, 1, clock, TakenInterrupt, check1);

   register #(30,) reg_EPC(temp, EPC_D, clock, check2, reset);

   mux2v #(30) takeninterrupt(EPC_D, wr_data[31:2], next_pc, TakenInterrupt);

   mux32v regnumnum(rd_data, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, status_register, cause_register, {temp, 2'b0}, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, regnum);

   decoder32 decoderrr(decoder_out_, regnum, MTC0);

endmodule
