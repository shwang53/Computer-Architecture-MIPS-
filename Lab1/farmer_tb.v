module fm_test;


reg f_in, x_in, g_in, b_in;                           // these are inputs to "circuit under test"
// use "reg" not "wire" so can assign a value
wire e_out;                     // wires for the outputs of "circuit under test"

farmer fm1 (e_out, f_in, x_in, g_in, b_in);  // the circuit under test

initial begin                             // initial = run at beginning of simulation
// begin/end = associate block with initial

$dumpfile("fm.vcd");                  // name of dump file to create
$dumpvars(0,fm_test);                 // record all signals of module "sc_test" and sub-modules
// remember to change "sc_test" to the correct
// module name when writing your own test benches

// test all four input combinations
// remember that 2 inputs means 2^2 = 4 combinations
// 3 inputs would mean 2^3 = 8 combinations to test, and so on
// this is very similar to the input columns of a truth table
f_in = 0; x_in = 0; g_in=0; b_in=0; # 10;             // set initial values and wait 10 time units
f_in = 0; x_in = 0; g_in=0; b_in=1; # 10;             // set initial values and wait 10 time units
f_in = 0; x_in = 0; g_in=1; b_in=0; # 10;             // set initial values and wait 10 time units
f_in = 0; x_in = 0; g_in=1; b_in=1; # 10;             // set initial values and wait 10 time units
f_in = 0; x_in = 1; g_in=0; b_in=0; # 10;             // set initial values and wait 10 time units
f_in = 0; x_in = 1; g_in=0; b_in=1; # 10;             // set initial values and wait 10 time units
f_in = 0; x_in = 1; g_in=1; b_in=0; # 10;             // set initial values and wait 10 time units
f_in = 0; x_in = 1; g_in=1; b_in=1; # 10;             // set initial values and wait 10 time units
f_in = 1; x_in = 0; g_in=0; b_in=0; # 10;             // set initial values and wait 10 time units
f_in = 1; x_in = 0; g_in=0; b_in=1; # 10;             // set initial values and wait 10 time units
f_in = 1; x_in = 0; g_in=1; b_in=0; # 10;             // set initial values and wait 10 time units
f_in = 1; x_in = 0; g_in=1; b_in=1; # 10;             // set initial values and wait 10 time units
f_in = 1; x_in = 1; g_in=0; b_in=0; # 10;             // set initial values and wait 10 time units
f_in = 1; x_in = 1; g_in=0; b_in=1; # 10;             // set initial values and wait 10 time units
f_in = 1; x_in = 1; g_in=1; b_in=0; # 10;             // set initial values and wait 10 time units
f_in = 1; x_in = 1; g_in=1; b_in=1; # 10;             // set initial values and wait 10 time units


$finish;                              // end the simulation
end

initial
$monitor("At time %2t, f_in = %d x_in = %d g_in = %d b_in = %d e_out = %d",
$time, f_in, x_in, g_in, b_in, e_out);



endmodule // farmer_test
