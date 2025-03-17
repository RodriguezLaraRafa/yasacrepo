// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        yasac.v
// Description: Yasac processor.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

module yasac (
    input wire clk,                 // clock (rising edge)
    input wire reset,               // reset (synchronous, active-high)
    input wire start,               // start operation
    output wire ready,              // ready output indicator
    input wire [7:0] din,           // external data input
    output wire [7:0] dout,         // external data output
    output wire [1:0] state_out     // FSM state output for testing

);

    // Internal signals
    wire [4:0] opcode;
    wire [1:0] op;
    wire ipc, clpc, wir, wreg, inm;

    // Control unit instance
    control_unit control_unit (
        .clk(clk),              // clock (rising edge)
        .reset(reset),          // reset (synchronous, active-low)
        .start(start),          // start operation
        .ready(ready),          // ready output indicator
        .opcode(opcode),        // instruction operation code
        .op(op),                // ALU operation code
        .ipc(ipc),              // PC increment
        .clpc(clpc),            // PC clear
        .wir(wir),              // write IR
        .wreg(wreg),            // write register array
        .inm(inm),              // use inmediate value
        .state_out(state_out)   // FSM state output for testing
);

    // Data unit instance
    data_unit data_unit (
        .clk(clk),
        .op(op),                // ALU operation code
        .ipc(ipc),              // PC increment
        .clpc(clpc),            // PC clear
        .wir(wir),              // write IR
        .wreg(wreg),            // write register array
        .inm(inm),              // use inmediate value
        .opcode(opcode),        // operation code of current instruction
        .din(din),              // external data input
        .dout(dout)             // external data output
);

endmodule