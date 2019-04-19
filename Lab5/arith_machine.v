// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst, PC, nextPC, rsData, rtData, rdData, B, imm32;
    wire [4:0] rdNum;
    wire [2:0] alu_op;
    wire rd_src, alu_src2, rdWriteEnable;

    assign imm32[31:0] =  { {16{inst[15]}}, {inst[15:0]} }; //sign extender


    //wire [31:0] PC;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], rdNum, rdData, rdWriteEnable, clock, reset);

    /* add other modules */
    mux2v mx1(rdNum, inst[15:11], inst[20:16], rd_src);
    mux2v mx2(B, rtData, imm32, alu_src2);
    mips_decode md1(alu_op, rdWriteEnable, rd_src, alu_src2, except, inst[31:26], inst[5:0]);
    alu32 al1(rdData, , , ,rsData, B, alu_op);
    alu32 al2(nextPC, , , ,PC, 32'b100, 3'b010);

endmodule // arith_machine
