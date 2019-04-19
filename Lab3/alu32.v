//implement your 32-bit ALU
module alu32(out, overflow, zero, negative, A, B, control);
    output [31:0] out;
    output        overflow, zero, negative;
    input  [31:0] A, B;
    input   [2:0] control;

    wire [31:0] carry;

     alu1 al0(out[0], carry[0], A[0],B[0], control[0], control);
     alu1 al1(out[1], carry[1], A[1],B[1],carry[0], control);
     alu1 al2(out[2],carry[2], A[2], B[2], carry[1], control);
    alu1 al3(out[3],carry[3], A[3], B[3], carry[2], control);
    alu1 al4(out[4],carry[4], A[4], B[4], carry[3], control);
    alu1 al5(out[5],carry[5], A[5], B[5], carry[4], control);
    alu1 al6(out[6],carry[6], A[6], B[6], carry[5], control);
    alu1 al7(out[7],carry[7], A[7], B[7], carry[6], control);
    alu1 al8(out[8],carry[8], A[8], B[8], carry[7], control);
    alu1 al9(out[9],carry[9], A[9], B[9], carry[8], control);
    alu1 al10(out[10],carry[10], A[10], B[10], carry[9], control);
    alu1 al11(out[11],carry[11], A[11], B[11], carry[10], control);
    alu1 al12(out[12],carry[12], A[12], B[12], carry[11], control);
    alu1 al13(out[13],carry[13], A[13], B[13], carry[12], control);
    alu1 al14(out[14],carry[14], A[14], B[14], carry[13], control);
    alu1 al15(out[15],carry[15], A[15], B[15], carry[14], control);
    alu1 al16(out[16],carry[16], A[16], B[16], carry[15], control);
    alu1 al17(out[17],carry[17], A[17], B[17], carry[16], control);
    alu1 al18(out[18],carry[18], A[18], B[18], carry[17], control);
    alu1 al19(out[19],carry[19], A[19], B[19], carry[18], control);
    alu1 al20(out[20],carry[20], A[20], B[20], carry[19], control);
    alu1 al21(out[21],carry[21], A[21], B[21], carry[20], control);
    alu1 al22(out[22],carry[22], A[22], B[22], carry[21], control);
    alu1 al23(out[23],carry[23], A[23], B[23], carry[22], control);
    alu1 al24(out[24],carry[24], A[24], B[24], carry[23], control);
    alu1 al25(out[25],carry[25], A[25], B[25], carry[24], control);
    alu1 al26(out[26],carry[26], A[26], B[26], carry[25], control);
    alu1 al27(out[27],carry[27], A[27], B[27], carry[26], control);
    alu1 al28(out[28],carry[28], A[28], B[28], carry[27], control);
    alu1 al29(out[29],carry[29], A[29], B[29], carry[28], control);
    alu1 al30(out[30],carry[30], A[30], B[30], carry[29], control);
    alu1 al31(out[31],carry[31], A[31], B[31], carry[30], control);


    assign negative = out[31];
    xor x1(overflow, carry[31], carry[30]);
    nor n1(zero, out[0],out[1],out[2],out[3],out[4],out[5],out[6],out[7],out[8],out[9],out[10],out[11],out[12],out[13],out[14],out[15],out[16],out[17],out[18],out[19],out[20],out[21],out[22],out[23],out[24],out[25],out[26],out[27],out[28],out[29],out[30],out[31]);



endmodule // alu32
