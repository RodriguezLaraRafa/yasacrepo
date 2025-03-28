// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        alu.v
// Description: Arithmetic-Logic Unit
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

`include "globals.vh"

module alu (
    input wire [7:0] a,         // data input a
    input wire [7:0] b,         // data input b
    input wire [1:0] op,        // operation selector
    input wire [7:0] st_in,     // status input
    output reg [7:0] r,         // output result
    output reg [7:0] st_out     // status output (---SVNZC)
);

    // Result calculation
    always @* begin
        st_out = st_in;     // default output status
        case(op)
        `ALU_ADD: begin
            r = a + b;
            st_out[`CF] = a[7] & b[7] | b[7] & ~r[7] | a[7] & ~r[7];
            st_out[`VF] = a[7] & b[7] & ~r[7] | ~a[7] & ~b[7] & r[7];
            st_out[`ZF] = ~|r;
            st_out[`NF] = r[7];
            st_out[`SF] = st_out[`VF] ^ st_out[`NF];
        end
        `ALU_SUB: begin
            r = a - b;
            st_out[`CF] = ~a[7] & b[7] | b[7] & r[7] | ~a[7] & r[7];
            st_out[`VF] = a[7] & ~b[7] & ~r[7] | ~a[7] & b[7] & r[7];
            st_out[`ZF] = ~|r;
            st_out[`NF] = r[7];
            st_out[`SF] = st_out[`VF] ^ st_out[`NF];
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
