//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
          # 10 A = 32'h80000000; B = 32'h80000000; control = `ALU_ADD; // overflow expect.
        # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
        // add more test cases here!
          # 10 A = 0; B = 0; control = `ALU_AND;
        	# 10 A = 0; B = 0; control = `ALU_OR;
        	# 10 A = 0; B = 0; control = `ALU_NOR;
        	# 10 A = 0; B = 0; control = `ALU_XOR;
          # 10 A = 1; B = 2; control = `ALU_AND;
          # 10 A = 3; B = 4; control = `ALU_OR;
          # 10 A = 5; B = 6; control = `ALU_NOR;
          # 10 A = 1; B = 3; control = `ALU_XOR;

          # 10 A = 5; B = 5; control = `ALU_SUB; // try subtracting 5 from 5
          # 10 A = 377; B = 12; control = `ALU_SUB;
	        # 10 A = 12; B = 377; control = `ALU_SUB;
          # 10 A = 32'h7ffffff0; B = 36; control = `ALU_SUB;
          # 10 A = 36; B = 32'h7ffffff0; control = `ALU_SUB;
          # 10 A = 32'hf0000000; B = 32'hf0000000; control = `ALU_ADD;
          # 10 A = 32'hA0000000; B = 32'hA0000000; control = `ALU_SUB;
          # 10 A = 32'h3fffffff; B = 32'h7fffffff; control = `ALU_SUB;
          # 10 A = 32'h00000008; B = 32'h00000008; control = `ALU_ADD;

        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);
endmodule // alu32_test
