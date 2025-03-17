// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        control_unit.v
// Description: Control unit.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

`include "globals.vh"

module control_unit (
    // External signals
    input wire clk,             // clock (rising edge)
    input wire reset,           // reset (synchronous, active-high)
    input wire start,           // start operation
    output reg ready,           // ready output indicator

    // Data unit signals
    input wire [4:0] opcode,    // instruction operation code
    output reg [1:0] op,        // ALU operation code
    output reg ipc,             // PC increment
    output reg clpc,            // PC clear
    output reg wir,             // write IR
    output reg wreg,            // write register array
    output reg inm,             // use inmediate value
    output reg wmem,            // write data memory
    output reg rmem,            // read data memory
    output reg wmar,            // write memory address register

    output wire [1:0] state_out // FSM state output for testing
);

    // State definition
    localparam [2:0] READY = 0,
                     FETCH = 1,
                     EXEC1 = 2,
                     EXEC2 = 3;

    // State variables
    reg [2:0] state, next_state;

    // Route state signal to the outside for testing
    assign state_out = state;

    // State change process
    always @(posedge clk)
        if (reset == 1'b1)
            state <= READY;
        else
            state <= next_state;

    // Next state process
    always @* begin
        // Default next state
        next_state = 'bx;
        case (state)
        READY:
            if (start)
                next_state = FETCH;
            else
                next_state = READY;
        FETCH:
            next_state = EXEC1;
        EXEC1:
            case (opcode)
            `LDI, `MOV, `ADD, `SUB:
                next_state = FETCH;
            `LD, `ST, `LDS, `STS:
                next_state = EXEC2;
            default:                    // Including STOP
                next_state = READY;
            endcase
        EXEC2:
            next_state = FETCH;
        default:                        // Should not reach this point
            next_state = 'bx;
        endcase
    end

    // Output process
    always @* begin
        // Default output values
        ready = 1'b0; op = 'b0; ipc = 1'b0; clpc = 1'b0;
        wir = 1'b0; wreg = 1'b0; inm = 1'b0;
        wmem = 1'b0; rmem = 1'b0; wmar = 1'b0;
        case (state)
        READY: begin
            ready = 1'b1;
            if (start)
                clpc = 1'b1;
        end
        FETCH: begin
            wir = 1'b1;
            ipc = 1'b1;
        end
        EXEC1:
            case (opcode)
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
            `LD, `ST, `LDS, `STS: begin
                op = `ALU_TRB;
                wmar = 1'b1;
                if (opcode == `LDS || opcode == `STS)
                    inm = 1'b1;
            end
            endcase
        EXEC2:
            case (opcode)
            `LD, `LDS: begin
                rmem = 1'b1;
                wreg = 1'b1;
            end
            `ST, `STS: begin
                op = `ALU_TRA;
                wmem = 1'b1;
            end
            endcase
        endcase
    end
endmodule