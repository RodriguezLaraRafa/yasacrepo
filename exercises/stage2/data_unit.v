// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        data_unit.v
// Description: Data unit.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

module data_unit(
    input wire clk,             // clock (rising edge)
    input wire [1:0] op,        // ALU operation code
    input wire ipc,             // PC increment
    input wire clpc,            // PC clear
    input wire wir,             // write IR
    input wire wreg,            // write register array
    input wire inm,             // use inmediate value
    output wire [4:0] opcode,   // operation code of current instruction
    input wire wmem,            // write data memory
    input wire rmem,            // read data memory
    input wire wmar,            // write memory address register
    output wire [7:0] port00, port01, port02, port03,   // output ports
                      port04, port05, port06, port07,
    input wire [7:0]  port08, port09, port10, port11,   // input ports
                      port12, port13, port14, port15
);

    reg [7:0] pc;               // PC register
    reg [15:0] ir;              // IR register
    reg [7:0] regs [0:7];       // register array
    reg [7:0] mar;              // data memory address register

    //// Internal signals

    wire [15:0] inst;           // instruction from code memory
    wire [2:0] sa, sb;          // resgister selection
    wire [7:0] k;               // inmediate value
    wire [7:0] rega, regb;      // register array output data
    wire [7:0] alu_b;           // ALU b input
    wire [7:0] bus;             // internal bus
    wire [7:0] alu_out;         // alu output
    wire [7:0] data_out;        // data memory output

    //// PC register

    always @(posedge clk)
        if(clpc)
            pc <= 'b0;
        else if (ipc)
            pc <= pc + 1;

    //// IR register

    always @(posedge clk)
        if (wir)
            ir <= inst;

    assign opcode = ir[15:11];
    assign sa = ir[10:8];
    assign sb = ir[2:0];
    assign k = ir[7:0];

    //// Register array

    always @(posedge clk)
        if(wreg)
            regs[sa] <= bus;

    assign rega = regs[sa];
    assign regb = regs[sb];

    //// Code memory

    code_mem code_mem (
        .addr(pc),
        .data(inst)
    );

    //// Memory address register

    always @(posedge clk)
        if (wmar)
            mar <= bus;

    //// Data memory

    data_mem data_mem (
        .clk(clk),
        .wmem(wmem),
        .addr(mar),
        .data_in(bus),
        .data_out(data_out),
        .port00(port00), .port01(port01), .port02(port02), .port03(port03),
        .port04(port04), .port05(port05), .port06(port06), .port07(port07),
        .port08(port08), .port09(port09), .port10(port10), .port11(port11),
        .port12(port12), .port13(port13), .port14(port14), .port15(port15)
    );

    //// ALU

    assign alu_b = inm ? k : regb;

    alu alu (
        .a(rega),
        .b(alu_b),
        .op(op),
        .r(alu_out)
    );

    //// Bus multiplexer

    assign bus = rmem ? data_out : alu_out;

endmodule
