// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        data_mem.v
// Description: Data memory and memory-mapped I/O.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-28 (initial)

// Memory map
//   00:EF: RAM
//   F0:F7: output ports
//   F8:FF: input ports
//
// Strategy
//   * Use a synchronous RAM block for RAM. It should be mapped to block RAM.
//   * Use registers for input and output ports.
//   * Input ports are written at each clock cycle (registered input).
//   * Select RAM or registers for input/output depending on the address.
//   * Output ports can also be read.

module data_mem (
    input wire clk,                 // clock (rising edge)
    input wire wmem,                // write data memory
    input wire [7:0] addr,          // address
    input wire [7:0] data_in,       // input data
    output wire [7:0] data_out,     // output data
    output wire [7:0] port00, port01, port02, port03,   // output ports
                      port04, port05, port06, port07,
    input wire [7:0]  port08, port09, port10, port11,   // input ports
                      port12, port13, port14, port15
);

    reg [7:0] mem[0:239];
    reg [7:0] port_reg00, port_reg01, port_reg02, port_reg03,
              port_reg04, port_reg05, port_reg06, port_reg07,
              port_reg08, port_reg09, port_reg10, port_reg11,
              port_reg12, port_reg13, port_reg14, port_reg15;
    reg [7:0] port_out;

    // Initialize RAM memory and I/O to zero for simulation
    initial begin: mem_init
        integer i;
        for (i=0; i<'hf0; i=i+1)
            mem[i] = 'b0;

        port_reg00 = 'b0;
        port_reg01 = 'b0;
        port_reg02 = 'b0;
        port_reg03 = 'b0;
        port_reg04 = 'b0;
        port_reg05 = 'b0;
        port_reg06 = 'b0;
        port_reg07 = 'b0;
        port_reg08 = 'b0;
        port_reg09 = 'b0;
        port_reg10 = 'b0;
        port_reg11 = 'b0;
        port_reg12 = 'b0;
        port_reg13 = 'b0;
        port_reg14 = 'b0;
        port_reg15 = 'b0;
    end

    // RAM write
    always @(posedge clk)
        // Write only RAM and output ports
        if (wmem && addr < 8'hf0)
            mem[addr] <= data_in;

    // Output port write
    always @(posedge clk)
        if (wmem && addr >= 8'hf0 && addr < 8'hf8)
            case(addr[3:0])
            4'h0:   port_reg00 <= data_in;
            4'h1:   port_reg01 <= data_in;
            4'h2:   port_reg02 <= data_in;
            4'h3:   port_reg03 <= data_in;
            4'h4:   port_reg04 <= data_in;
            4'h5:   port_reg05 <= data_in;
            4'h6:   port_reg06 <= data_in;
            4'h7:   port_reg07 <= data_in;
            endcase

    // Output port read
    assign port00 = port_reg00;
    assign port01 = port_reg01;
    assign port02 = port_reg02;
    assign port03 = port_reg03;
    assign port04 = port_reg04;
    assign port05 = port_reg05;
    assign port06 = port_reg06;
    assign port07 = port_reg07;

    // Input port write (from external pins)
    always @(posedge clk) begin
        port_reg08 <= port08;
        port_reg09 <= port09;
        port_reg10 <= port10;
        port_reg11 <= port11;
        port_reg12 <= port12;
        port_reg13 <= port13;
        port_reg14 <= port14;
        port_reg15 <= port15;
    end

    // Asynchronous read
    //
    // Xilinx ISE does not like arrays in the sensitivity list so we read
    // ports first and multiplex with RAM using 'assign'.
    always @*
        case(addr[3:0])
        4'h0:   port_out = port_reg00;
        4'h1:   port_out = port_reg01;
        4'h2:   port_out = port_reg02;
        4'h3:   port_out = port_reg03;
        4'h4:   port_out = port_reg04;
        4'h5:   port_out = port_reg05;
        4'h6:   port_out = port_reg06;
        4'h7:   port_out = port_reg07;
        4'h8:   port_out = port_reg08;
        4'h9:   port_out = port_reg09;
        4'ha:   port_out = port_reg10;
        4'hb:   port_out = port_reg11;
        4'hc:   port_out = port_reg12;
        4'hd:   port_out = port_reg13;
        4'he:   port_out = port_reg14;
        4'hf:   port_out = port_reg15;
        default: port_out = 'bx;
        endcase

    // Data output generation
    assign data_out = (addr < 8'hf0) ? mem[addr] : port_out;
endmodule