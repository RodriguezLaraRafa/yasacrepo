// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        yasac.v
// Description: Yasac processor. Test bench.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

`timescale 1ns / 1ps

module test ();

    reg clk;                // clock (rising edge)
    reg reset;              // reset (synchronous, active-low)
    reg start;              // start operation
    wire ready;             // ready output indicator
    wire [7:0] port00, port01, port02, port03,  // output ports
               port04, port05, port06, port07;
    reg [7:0]  port08, port09, port10, port11,  // imput ports
               port12, port13, port14, port15;


    yasac uut (
        .clk(clk),                          // clock (rising edge)
        .reset(reset),                      // reset (synchronous, active-high)
        .start(start),                      // start operation
        .ready(ready),                      // ready output indicator
        .port00(port00), .port01(port01),   // output ports
        .port02(port02), .port03(port03),
        .port04(port04), .port05(port05),
        .port06(port06), .port07(port07),
        .port08(port08), .port09(port09),   // input ports
        .port10(port10), .port11(port11),
        .port12(port12), .port13(port13),
        .port14(port14), .port15(port15)
    );

    // Clock generator (T=20ns, f=50MHz)
    always
        #10 clk = ~clk;

    // Main simulation process
    //
    // Simple strategy:
    //   - Activate the reset signal for 1 clock cycle
    //   - Wait for the "ready" signal and end the simulation.
    //   - Stop the simulation after 100 cycles if ready not activated first.
    //   - Save all waveforms (will be too much as the design grows)
    initial begin
        // output generation
        $dumpfile("yasac_tb.vcd");
        // $dumplimit(10000000);           // limit dump file to 10MB
        $dumpvars(0, test);
        //$dumpvars(0, uut.data_unit.data_mem.mem['hf1]);

        // Simple debugger
        $display("pc |ir    |port08         |port01         |port02\n",
                 "---|------|---------------|---------------|--------------");
        $monitor("%h | %h | %h (%b) | %h (%b) | %h (%b)",
            uut.data_unit.pc,
            uut.data_unit.ir,
            port08, port08,
            port01, port01,
            port02, port02);

        // input signal initialization
        clk = 1'b0;
        reset = 1'b0;
        start = 1'b0;
        port08 = 8'h07;

        // global reset
        @(posedge clk) #1 reset = 1'b1;
        @(posedge clk) #1 reset = 1'b0;

        repeat(3) @(posedge clk) #1;

        // start program execution
        start = 1'b1;
        @(posedge clk) #1;
        start = 1'b0;

        // wait for "ready"
        wait(ready)
            $display("'ready' activation detected.");

        repeat(3) @(posedge clk) #1;

        $display("Normal simulation end.");

        // Check input and output ports
        $display("port08 (in): %d, port02 (out): %d, port01 (out): %d",
                 port08, port02, port01);

        $finish;
    end

    // Force finish after 100 clock cycles
    initial begin
        #(20*1000);
        $display("'ready' not detected. Abnormal simulation end.");
        $display("Test bench result: FAIL.");
        $finish;
    end
endmodule