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
    output wire [7:0] port00, port01, port02, port03,   // output ports
                      port04, port05, port06, port07,
    input wire [7:0]  port08, port09, port10, port11,   // input ports
                      port12, port13, port14, port15,
    output wire [1:0] state_out     // FSM state output for testing
);

    // Internal signals
    wire [4:0] opcode;
    wire [1:0] op;
    wire ipc, clpc, wir, wreg, inm, wmem, rmem, wmar;

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
        .wmem(wmem),            // write data memory
        .rmem(rmem),            // read data memory
        .wmar(wmar),            // write memory address register
        .state_out(state_out)   // state output (for testing)
    );

    // Data unit instance
    data_unit data_unit (
        .clk(clk),              // clock (rising edge)
        .op(op),                // ALU operation code
        .ipc(ipc),              // PC increment
        .clpc(clpc),            // PC clear
        .wir(wir),              // write IR
        .wreg(wreg),            // write register array
        .inm(inm),              // use inmediate value
        .opcode(opcode),        // operation code of current instruction
        .wmem(wmem),            // write data memory
        .rmem(rmem),            // read data memory
        .wmar(wmar),            // write memory address register
        .port00(port00), .port01(port01),   // output ports
        .port02(port02), .port03(port03),
        .port04(port04), .port05(port05),
        .port06(port06), .port07(port07),
        .port08(port08), .port09(port09),   // input ports
        .port10(port10), .port11(port11),
        .port12(port12), .port13(port13),
        .port14(port14), .port15(port15)
    );
endmodule