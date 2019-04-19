module alu1_test;
    // exhaustively test your 1-bit ALU implementation by adapting mux4_tb.v

    reg A = 0;
    always #1 A = !A;

    reg B = 0;
    always #2 B = !B;

    reg carryin =0;
    always #4 carryin = !carryin;

    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu1_test.vcd");
        $dumpvars(0,alu1_test);

        //control is initially 0
        # 16 control = 1; // wait 16 time units and then set it 1
        # 16 control = 2;
        # 16 control = 3;
        # 16 control = 4;
        # 16 control = 5;
        # 16 control = 6;
        # 16 control = 7;
        # 16 $finish; // wait 16 time units and then end the simulation
    end

    wire out, carryout;
    alu1 a1(out,carryout, A,B,carryin,control);



endmodule //alu1_test end
