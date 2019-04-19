// module pipelined_machine(clk, reset);
//     input        clk, reset;
//
//     wire [31:0]  PC;
//     wire [31:2]  next_PC, PC_plus4, PC_target;
//     wire [31:0]  inst;
//
//     wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
//     wire [4:0]   rs = inst[25:21];
//     wire [4:0]   rt = inst[20:16];
//     wire [4:0]   rd = inst[15:11];
//     wire [5:0]   opcode = inst[31:26];
//     wire [5:0]   funct = inst[5:0];
//
//     wire [4:0]   wr_regnum;
//     wire [2:0]   ALUOp;
//
//     wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
//     wire         PCSrc, zero;
//     wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;
//
//
//     // DO NOT comment out or rename this module
//     // or the test bench will break
//     register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */1'b1, reset);
//
//     assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
//     adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
//     adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
//     mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
//     assign PCSrc = BEQ & zero;
//
//     // DO NOT comment out or rename this module
//     // or the test bench will break
//     instruction_memory imem(inst, PC[31:2]);
//
//     mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
//                       opcode, funct);
//
//     // DO NOT comment out or rename this module
//     // or the test bench will break
//     regfile rf (rd1_data, rd2_data,
//                rs, rt, wr_regnum, wr_data,
//                RegWrite, clk, reset);
//
//     mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
//     alu32 alu(alu_out_data, zero, ALUOp, rd1_data, B_data);
//
//     // DO NOT comment out or rename this module
//     // or the test bench will break
//     data_mem data_memory(load_data, alu_out_data, rd2_data, MemRead, MemWrite, clk, reset);
//
//     mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);
//     mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);
//
// endmodule // pipelined_machine
module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target;
    wire [31:0]  inst;

    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rd = inst[15:11];
    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];

    wire [4:0]   wr_regnum;
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;


    wire [31:0]  before_inst, before_alu_out_data, forward2Output;
    wire [4:0] before_wr_regnum;
    wire beforeRegWrite, beforeMemRead, beforeMemWrite, beforeMemToReg;

    // Forward
    wire forward1, forward2;
    assign forward1 = RegWrite & (wr_regnum == rs) & ~(rs == 0);
    assign forward2 = RegWrite & (wr_regnum == rt) & ~(rt == 0);

    wire [31:0] forward_data1, forward_data2;
    mux2v #(32) fMux1(forward_data1, rd1_data, alu_out_data, forward1);
    mux2v #(32) fMux2(forward_data2, rd2_data, alu_out_data, forward2);

    // Stall
    wire stall;
    assign stall = MemRead & ((rt == wr_regnum) & ~(wr_regnum == 0) | (rs == wr_regnum) & ~(wr_regnum == 0)) ;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);


    wire [31:2] PC_Plus44;
    register #(30) PC_Plus44Reg(PC_Plus44, PC_plus4, clk, ~stall, (PCSrc | reset));

    adder30 target_PC_adder(PC_target, PC_Plus44, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break


    instruction_memory imem(before_inst, PC[31:2]);
    register #(32) instReg(inst, before_inst, clk, ~stall, (PCSrc | reset));


    mips_decode decode(ALUOp, beforeRegWrite, BEQ, ALUSrc, beforeMemRead, beforeMemWrite, beforeMemToReg, RegDst,
                      opcode, funct);



    // DO NOT comment out or rename this module
    // or the test bench will break


    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, wr_data,
               RegWrite, clk, reset);

    register #(32) forward2OutputReg(forward2Output, forward_data2, clk, /* enable */1'b1, reset);

    mux2v #(32) imm_mux(B_data, forward_data2, imm, ALUSrc);


    alu32 alu(before_alu_out_data, zero, ALUOp, forward_data1, B_data);
    register #(32) alu_out_dataSH(alu_out_data, before_alu_out_data, clk, /* enable */1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data, forward2Output, MemRead, MemWrite, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);


    mux2v #(5) rd_mux(before_wr_regnum, rt, rd, RegDst);


    register #(5) wr_regnumSH(wr_regnum, before_wr_regnum, clk, /* enable */1'b1, reset);


    register #(1) RegWriteSH(RegWrite, beforeRegWrite, clk, /* enable */1'b1, reset);
    register #(1) MemReadSH(MemRead, beforeMemRead, clk, /* enable */1'b1, reset);
    register #(1) MemWriteSH(MemWrite, beforeMemWrite, clk, /* enable */1'b1, reset);
    register #(1) MemToRegSH(MemToReg, beforeMemToReg, clk, /* enable */1'b1, reset);


endmodule // pipelined_machine
