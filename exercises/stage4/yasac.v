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
    wire [3:0] op;
    wire [2:0] s;
    wire [7:0] status;
    wire ipc, clpc, wir, wreg, inm, wmem, rmem, wmar, wpc, wsreg;
    wire clsb, sesb;

    // Control unit instance
    control_unit control_unit (
        .clk(clk),              // clock (rising edge)
        .reset(reset),          // reset (synchronous, active-low)
        .start(start),          // start operation
        .ready(ready),          // ready output indicator
        .opcode(opcode),        // instruction operation code
        .s(s),                  // status bit selector
        .status(status),        // status from status register
        .op(op),                // ALU operation code
        .ipc(ipc),              // PC increment
        .clpc(clpc),            // PC clear
        .wpc(wpc),              // PC write (branch)
        .wir(wir),              // write IR
        .wreg(wreg),            // write register array
        .inm(inm),              // use inmediate value
        .wmem(wmem),            // write data memory
        .rmem(rmem),            // read data memory
        .wmar(wmar),            // write memory address register
        .wsreg(wsreg),          // write status register
        .state_out(state_out),  // state output (for testing)
        .clsb(clsb),            // clear status register bit
        .sesb(sesb)             // set status register bit
    );

    // Data unit instance
    data_unit data_unit (
        .clk(clk),              // clock (rising edge)
        .op(op),                // ALU operation code
        .ipc(ipc),              // PC increment
        .clpc(clpc),            // PC clear
        .wpc(wpc),              // PC write (branch)
        .wir(wir),              // write IR
        .wreg(wreg),            // write register array
        .inm(inm),              // use inmediate value
        .opcode(opcode),        // operation code of current instruction
        .s(s),                  // status bit selector
        .status(status),        // status from status register
        .wmem(wmem),            // write data memory
        .rmem(rmem),            // read data memory
        .wmar(wmar),            // write memory address register
        .wsreg(wsreg),          // write status register
        .clsb(clsb),            // clear status register bit
        .sesb(sesb),            // set status register bit
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