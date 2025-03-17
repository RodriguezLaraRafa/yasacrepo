// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        alu.v
// Description: Arithmetic-Logic Unit
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

`include "globals.vh"

module alu #(
    parameter W = 8     // Data width
)(
    input wire [7:0] a,        // data input a
    input wire [7:0] b,        // data input b
    input wire [1:0] op,                // operation selector
    output reg [7:0] r  // output result
);

    always @* begin
        case(op)
        `ALU_ADD: begin
            r = a + b;
        end
        `ALU_SUB: begin
            r = a - b;
        end
        `ALU_TRA: begin
            r = a;
        end
        `ALU_TRB: begin
            r = b;
        end
        default:            // Should not happen
            r = 'bx;
        endcase

    end
endmodule
