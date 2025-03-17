// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        alu.v
// Description: Arithmetic-Logic Unit
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

// Output flags calculated based on the Atmel AVR Instruction Set Manual

`include "globals.vh"

module alu (
    input wire [7:0] a,         // data input a
    input wire [7:0] b,         // data input b
    input wire [3:0] op,        // operation selector
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
        `ALU_NEG: begin
            r = -a;
            st_out[`CF] = |a;
            st_out[`VF] = (a == 8'h80) ? 1'b1 : 1'b0;
            st_out[`ZF] = ~|r;
            st_out[`NF] = r[7];
            st_out[`SF] = st_out[`VF] ^ st_out[`NF];
        end
        `ALU_AND: begin
            r = a & b;
            st_out[`VF] = 1'b0;
            st_out[`ZF] = ~|r;
            st_out[`NF] = r[7];
            st_out[`SF] = st_out[`VF] ^ st_out[`NF];
        end
        `ALU_OR: begin
            r = a | b;
            st_out[`VF] = 1'b0;
            st_out[`ZF] = ~|r;
            st_out[`NF] = r[7];
            st_out[`SF] = st_out[`VF] ^ st_out[`NF];
        end
        `ALU_EOR: begin
            r = a ^ b;
            st_out[`VF] = 1'b0;
            st_out[`ZF] = ~|r;
            st_out[`NF] = r[7];
            st_out[`SF] = st_out[`VF] ^ st_out[`NF];
        end
        `ALU_ROR: begin
            r = {st_in[`CF], a[7:1]};
            st_out[`CF] = a[0];
            st_out[`VF] = st_in[`CF] ^ a[0];    // N^C after the shift
            st_out[`ZF] = ~|r;
            st_out[`NF] = r[7];
            st_out[`SF] = st_out[`VF] ^ st_out[`NF];
        end
        `ALU_ROL: begin
            r = {a[6:0], st_in[`CF]};
            st_out[`CF] = a[7];
            st_out[`VF] = a[7] ^ a[6];          // N^C after the shift
            st_out[`ZF] = ~|r;
            st_out[`NF] = r[7];
            st_out[`SF] = st_out[`VF] ^ st_out[`NF];
        end
        default:            // Should not happen
            r = 'bx;
        endcase
    end
endmodule
