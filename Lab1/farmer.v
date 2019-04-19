// Complete the farmer module in this file
// Don't put any code in this file besides the farmer circuit

module farmer(e, f, x, g, b);

    output e;
    input f,x,g,b;
    wire w1,w2,w3,not_f,not_x,not_g,not_b;

    not n1 (not_f, f);
    not n2 (not_x, x);
    not n3 (not_g, g);
    not n4 (not_b, b);

    and a1 (w1, not_f,not_x,g,b);
    and a2 (w2, not_f,x,g,not_b);
    and a3 (w3, not_f,x,g,b);


    or o1 (e, w1,w2,w3);


endmodule // farmer
