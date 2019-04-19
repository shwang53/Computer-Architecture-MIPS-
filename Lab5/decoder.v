// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;

    // wire add_ = (opcode == 6'b0) & (funct == 6'h20);
    // wire sub_ = (opcode == 6'b0) & (funct == 6'h22);
    // wire and_ = (opcode == 6'b0) & (funct == 6'h24);
    // wire or_ = (opcode == 6'b0) & (funct == 6'h25);
    // wire nor_ = (opcode == 6'b0) & (funct == 6'h27);
    // wire xor_ = (opcode == 6'b0) & (funct == 6'h26);
    //
    // wire addi_ = (opcode == 6'h08);
    // wire andi_ = (opcode == 6'h0c);
    // wire ori_ = (opcode == 6'h0d);
    // wire xori_ = (opcode == 6'h0e);

    wire add_ = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
    wire sub_ = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);
    wire and_ = (opcode == `OP_OTHER0) & (funct == `OP0_AND);
    wire or_ =  (opcode == `OP_OTHER0) & (funct == `OP0_OR);
    wire nor_ = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);
    wire xor_ = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);

    wire addi_ = (opcode == `OP_ADDI);
    wire andi_ = (opcode == `OP_ANDI);
    wire ori_ = (opcode == `OP_ORI);
    wire xori_ = (opcode == `OP_XORI);

    assign alu_op[2:0] = {(and_|or_|nor_|xor_|andi_|ori_|xori_), (add_|sub_|nor_|xor_|addi_|xori_), (sub_|or_|xor_|ori_|xori_)};
    assign rd_src = addi_ | andi_ | ori_ | xori_;
    assign alu_src2 = addi_ | andi_ | ori_ | xori_;
    assign writeenable = add_ |and_| sub_ | or_ | nor_ | xor_ | addi_ | andi_ | ori_ | xori_;
    assign except = ~writeenable;


endmodule // mips_decode
