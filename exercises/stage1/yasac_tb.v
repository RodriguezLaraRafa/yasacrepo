// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        yasac.v
// Description: Yasac processor. Test bench.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

`timescale 1ns / 1ps

module test ();

    reg clk;             // clock (rising edge)
    reg reset;           // reset (synchronous, active-low)
    reg start;           // start operation
    wire ready;           // ready output indicator
    reg [7:0] din;       // external data input
    wire [7:0] dout;      // external data output


    yasac uut (
        .clk(clk),              // clock (rising edge)
        .reset(reset),          // reset (synchronous, active-high)
        .start(start),          // start operation
        .ready(ready),          // ready output indicator
        .din(din),              // external data input
        .dout(dout)             // external data output
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
        $dumplimit(10000000);           // limit dump file to 10MB
        $dumpvars(0, test);
        $monitor("start=%b, reset=%b, ready=%b, din=%d, dout=%d", start, reset, ready, din, dout);


        // input signal initialization
        clk = 1'b0;
        reset = 1'b0;
        start = 1'b0;
        din = 8'd6;

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

        // Print input and output ports (quick check results)
        $display("din: %d, dout: %d", din, dout);

        $finish;
    end

    // Force finish after 1000 clock cycles
    initial begin
        #(20*1000);
        $display("'ready' not detected. Abnormal simulation end.");
        $display("Check the design.");
    end
endmodule
