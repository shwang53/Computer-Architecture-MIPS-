// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
     output      except;
     input       clock, reset;

     wire [31:0] inst, PC, nextPC, B, rtData, imm32, rsData, rdData, PC_01, PC_02, PC_03, out, data_out ;
     wire [31:0] slt_in, slt_out, mem_out, mem_in, lui_in, lui_out, branchoffset, choosing, addm_out, allZero, extended_byte;
 	   wire [7:0] byte_out;
     wire [4:0] rdNum;
     wire [2:0] alu_op;
     wire [1:0] control_type;
     wire rdWriteEnable, rd_src, alu_src2, overflow, zero, negative, mem_read, word_we, byte_we, byte_load, lui, slt, addm;

    assign allZero[31:0] = 32'b0;
    assign imm32[31:0] =  { {16{inst[15]}}, {inst[15:0]} }; //sign extender
    assign PC_03[31:0] = { {PC[31:28]}, {inst[25:0]}, {allZero[1:0]}};
    assign extended_byte[31:0] = {allZero[31:8], byte_out[7:0]};
    assign lui_in[31:0] = {inst[15:0], allZero[15:0]};
    assign slt_in[31:0] = {allZero[31:1], (negative & ~overflow) | (~negative & overflow)};
    assign branchoffset[31:0] = {{14{inst[15]}}, inst[15:0], 2'b0};

        // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2] );

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], rdNum, rdData, rdWriteEnable, clock, reset);

    /* add other modules */

      mux2v mx1(B, rtData, imm32, alu_src2);
      mux2v #(5) mx2(rdNum, inst[15:11], inst[20:16], rd_src);
      mux2v mx3(slt_out, out, slt_in, slt);
      mux2v mx4(lui_out, mem_out, lui_in, lui);
      mux2v mx5(mem_out, slt_out, mem_in, mem_read);
      mux4v #(8) mx6(byte_out, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], out[1:0]);
      mux2v mx7(choosing, out, rsData, addm);	//addm
      mux2v mx8(rdData, lui_out, addm_out, addm);
      mux4v mx9(nextPC, PC_01, PC_02, PC_03, rsData, control_type);
      mux2v mx10(mem_in, data_out, extended_byte, byte_load);

      alu32 a1(PC_01, , , , PC, 32'h4, `ALU_ADD);
      alu32 a2(out, overflow, zero, negative, rsData, B, alu_op);
      alu32 a3(PC_02, , , , PC_01, branchoffset, `ALU_ADD);
      alu32 a4(addm_out, , , , data_out, rtData, `ALU_ADD);

     data_mem dm(data_out, choosing, rtData, word_we, byte_we, clock, reset);

     mips_decode d1(alu_op, rdWriteEnable, rd_src, alu_src2, except, control_type, mem_read, word_we,
                    byte_we, byte_load, lui, slt, addm,inst[31:26], inst[5:0], zero);


 endmodule // full_machine
