// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        control_unit.v
// Description: Control unit.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

`include "globals.vh"

module control_unit (
    // External signals
    input wire clk,         // clock (rising edge)
    input wire reset,       // reset (synchronous, active-high)
    input wire start,       // start operation
    output reg ready,       // ready output indicator

    // Data unit signals
    input wire [4:0] opcode,    // instruction operation code
    output reg [1:0] op,        // ALU operation code
    output reg ipc,             // PC increment
    output reg clpc,            // PC clear
    output reg wir,             // write IR
    output reg wreg,            // write register array
    output reg inm,             // use inmediate value
    output wire [1:0] state_out // FSM state output for testing
);

    // State definition
    localparam [1:0] READY = 0,
                     FETCH = 1,
                     EXEC  = 2;

    // State variables
    reg [1:0] state, next_state;

    // Route state signal to the outside for testing
    assign state_out = state;

    // State change process
    always @(posedge clk)
        if (reset == 1'b1)
            state <= READY;
        else
            state <= next_state;

    // Next state and output process
    always @* begin
        // Default output values
        ready = 1'b0; op = 'b0; ipc = 1'b0; clpc = 1'b0;
        wir = 1'b0; wreg = 1'b0; inm = 1'b0;
        next_state = 'bx;
        case (state)
        READY: begin
            ready = 1'b1;
            if (start) begin
                clpc = 1'b1;
                next_state = FETCH;
            end else begin
                next_state = READY;
            end
        end
        FETCH: begin
            wir = 1'b1;
            ipc = 1'b1;
            next_state = EXEC;
        end
        EXEC: begin
            next_state = FETCH;     // except if STOP or unknown instruction
            case(opcode)
            `LDI: begin
                op = `ALU_TRB;
                wreg = 1'b1; inm = 1'b1;
            end
            `ADD: begin
                op = `ALU_ADD;
                wreg = 1'b1;
            end
            `SUB: begin
                op = `ALU_SUB;
                wreg = 1'b1;
            end
            `MOV: begin
                op = `ALU_TRB;
                wreg = 1'b1;
            end
            default:        // including STOP
                next_state = READY;
            endcase
        end
        default: begin          // Should not reach this point
            next_state = 'bx;
        end
        endcase
    end
endmodule