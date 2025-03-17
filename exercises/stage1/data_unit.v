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
    input wire [7:0] din,       // external data input
    output wire [7:0] dout      // external data output
);

    reg [7:0] pc;               // PC register
    reg [15:0] ir;              // IR register
    reg [7:0] regs [0:7];       // register array

    //// Internal signals

    wire [15:0] inst;           // instruction from code memory
    wire [2:0] sa, sb;          // resgister selection
    wire [7:0] k;               // inmediate value
    wire [7:0] rega, regb;      // register array output data
    wire [7:0] alu_b;           // ALU b input
    wire [7:0] bus;             // internal bus

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
        else
            regs[7] <= din;

    assign rega = regs[sa];
    assign regb = regs[sb];
    assign dout = regs[6];

    //// Code memory

    code_mem code_mem (
        .addr(pc),
        .data(inst)
    );

    //// ALU

    assign alu_b = inm ? k : regb;

    alu alu (
        .a(rega),
        .b(alu_b),
        .op(op),
        .r(bus)
    );
endmodule