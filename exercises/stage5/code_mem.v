// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        code_mem.v
// Description: Code memory.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

//// Instruction formats
//
// format A: <opcode>(5) <Ra>(3) <zero>(5) <Rb>(3)
// format B: <opcode>(5) <Ra>(3) <k>(8)
// format C: <opcode>(5) <s>(3) <k>(8)
//
// k -> inmediate value
// s -> branch condition code

`include "globals.vh"

module code_mem (
    input wire [7:0] addr,      // address port
    output wire [15:0] data     // data port
);

    reg [15:0] code[0:255];
    integer i;

    assign data = code[addr];

    initial begin
        // Xilinx ISE synthesis needs all the positions to be initialized
        for (i=0; i<256; i=i+1)
            code[i] = 16'h0000;

        // Code memory contents (program)

//`include "code/branch_test.code"
//`include "code/fibonacci.code"
//`include "code/logic_test.code"
//`include "code/shift_cl_se_test.code"
`include "code/eightteen.code"

    end
endmodule