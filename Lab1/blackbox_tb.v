module bb_test;

    reg m_in, b_in, t_in;                           // these are inputs to "circuit under test"
                                              // use "reg" not "wire" so can assign a value
    wire p_out;                       // wires for the outputs of "circuit under test"

    blackbox bb1 (p_out, m_in, b_in, t_in);  // the circuit under test
    
    initial begin                             // initial = run at beginning of simulation
                                              // begin/end = associate block with initial
 
        $dumpfile("bb.vcd");                  // name of dump file to create
        $dumpvars(0,bb_test);                 // record all signals of module "sc_test" and sub-modules
                                              // remember to change "sc_test" to the correct
                                              // module name when writing your own test benches
        
        // test all four input combinations
        // remember that 2 inputs means 2^2 = 4 combinations
        // 3 inputs would mean 2^3 = 8 combinations to test, and so on
        // this is very similar to the input columns of a truth table
        m_in = 0; b_in = 0; t_in = 0; # 10;             // set initial values and wait 10 time units
        m_in = 0; b_in = 0; t_in = 1; # 10;
		m_in = 0; b_in = 1; t_in = 0; # 10;
		m_in = 0; b_in = 1; t_in = 1; # 10;
		m_in = 1; b_in = 0; t_in = 0; # 10;
		m_in = 1; b_in = 0; t_in = 1; # 10;
		m_in = 1; b_in = 1; t_in = 0; # 10;
		m_in = 1; b_in = 1; t_in = 1; # 10;
 
        $finish;                              // end the simulation
    end                      
    
    initial
        $monitor("At time %2t, m_in = %d b_in = %d t_in = %d p_out = %d",
                 $time, m_in, b_in, t_in, p_out);
endmodule // bb_test
