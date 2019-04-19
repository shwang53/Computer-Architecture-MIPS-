module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle

    wire  timeRead, timeWrite, acknowledge;
    wire [31:0] qCycle, dCycle, qInterrupt;

    register #(, 32'hffffffff) interrupt_cycle(qInterrupt, data, clock, timeWrite, reset);

    register cycle_counter(qCycle, dCycle, clock, 1'd1, reset);

    register #(1, ) interupt_line(TimerInterrupt, 1'd1, clock, (qCycle == qInterrupt), reset | acknowledge);

    alu32 alu1(dCycle, , , `ALU_ADD, qCycle, 32'd1);

    tristate trid(cycle, qCycle, timeRead);

    assign timeRead = (32'hffff001c == address) & MemRead;
    assign timeWrite = (32'hffff001c == address) & MemWrite;
    assign acknowledge = (32'hffff006c == address) & MemWrite;
    assign TimerAddress = (32'hffff001c == address) | (32'hffff006c == address);


endmodule
