// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        system.v
// Description: Yasac system on chip.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

module system (
    // External signals
    input wire clk,             // clock (rising edge)
    input wire reset,           // reset (synchronous, active-low)
    input wire start,           // start operation
    output wire ready,          // ready output indicator
    input wire [7:0] din,       // external data input
    output wire [7:0] dout,     // external data output
    output wire [0:6] seg,      // 7-segment output
    output wire [3:0] an,       // anode output
    output wire dp,             // decimal point output
    output reg [7:0] state_dec  // FSM state output for testing
);

    // Clock divider to 1Hz
    reg [24:0] prescaler;
    reg clk_in;
    always @(posedge clk)
        if (prescaler == 25000000-1) begin
            clk_in = ~clk_in;
            prescaler = 'b0;
        end else begin
            prescaler = prescaler + 1;
        end

    // Edge detector for 'start'
    reg start0=0, start1=0;
    wire start_pulse;
    always @(posedge clk_in) begin
        start1 <= start0;
        start0 <= start;
    end
    assign start_pulse = start0 & ~start1;

    // State decoder (for testing)
    wire [1:0] state_out;
    always @* begin
        state_dec = 'b0;
        state_dec[state_out] = 1'b1;
    end

    // Processor instance
    yasac yasac (
        .clk(clk_in),
        .reset(reset),
        .start(start_pulse),
        //.ready(ready),        // disabled for debugging
        .din(din),
        .dout(dout),
        .state_out(state_out)   // state output (for testing)
    );

    // 7-segment controller instance
    display_ctrl #(.cdbits(18), .hex(1)) display_ctrl (
        .ck(clk),               // system clock
        .x3(din[7:4]),          // display digits, from left to right
        .x2(din[3:0]),
        .x1(dout[7:4]),
        .x0(dout[3:0]),
        .dp_in(4'b1011),        // decimal point vector
        .seg(seg),              // 7-segment output
        .an(an),                // anode output
        .dp(dp)                 // decimal point output
    );
endmodule