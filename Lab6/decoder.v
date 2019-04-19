// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// lui          (output) - the instruction is a lui
// slt          (output) - the instruction is an slt
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire ADD = (opcode == 6'b0) & (funct == `OP0_ADD);
    wire SUB = (opcode == 6'b0) & (funct == `OP0_SUB);
    wire AND = (opcode == 6'b0) & (funct == `OP0_AND);
    wire OR = (opcode == 6'b0) & (funct == `OP0_OR);
    wire NOR = (opcode == 6'b0) & (funct == `OP0_NOR);
    wire XOR = (opcode == 6'b0) & (funct == `OP0_XOR);

    wire ADDI = opcode == `OP_ADDI;
    wire ANDI = opcode == `OP_ANDI;
    wire ORI = opcode == `OP_ORI;
    wire XORI = opcode == `OP_XORI;

    wire BEQ = opcode == `OP_BEQ;
    wire BNE = opcode == `OP_BNE;
    wire J = opcode == `OP_J;
    wire JR = (opcode == 6'b0) & (funct == `OP0_JR);
    wire LUI = opcode == `OP_LUI;
    wire SLT = (opcode == 6'b0) & (funct == `OP0_SLT);
    wire LW = opcode == `OP_LW;
    wire LBU = opcode == `OP_LBU;
    wire SW = opcode == `OP_SW;
    wire SB = opcode == `OP_SB;

    wire ADDM = (opcode == 6'b0) & (funct == `OP0_ADDM);


    assign alu_op[2:0] = {(AND | OR | NOR | XOR | ANDI | ORI | XORI), (ADD | SUB | NOR | XOR | ADDI | XORI | BEQ | BNE | LUI | SLT | LW | LBU | SW | SB), (SUB | OR | XOR | ORI | XORI | BEQ | BNE | LUI | SLT)};
    assign rd_src = ADDI | ANDI | ORI | XORI | LUI | LW | LBU | SW | SB;
    assign writeenable = ADD | SUB | AND | OR | NOR | XOR | ADDI | ANDI | ORI | XORI | LUI | SLT | LW | LBU | ADDM;
    assign alu_src2 = ADDI | ANDI | ORI | XORI | LW | LBU | SW | SB;
    assign control_type[1:0] = {(J | JR), (JR | (BEQ & zero)) | (BNE & ~zero)};
  //  assign control_type[0] = ((BEQ&zero) | (BNE& ~zero) | JR);
  //  assign control_type[1] = (J | JR);
    assign mem_read = LW | LBU | ADDM;
    assign word_we = SW;
    assign byte_we = SB;
    assign byte_load = LBU;
    assign lui = LUI;
    assign slt = SLT;

    assign addm = ADDM;

    assign except = ~(ADD | SUB | AND | OR | NOR | XOR | ADDI | ANDI | ORI | XORI | BEQ | BNE | J | JR | LUI | SLT | LW | LBU | SW | SB |ADDM);


endmodule // mips_decode
