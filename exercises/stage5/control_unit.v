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
    input wire [2:0] s,         // status bit selector
    input wire [7:0] status,    // status from status register
    output reg [3:0] op,        // ALU operation code
    output reg ipc,             // increment PC
    output reg clpc,            // clear PC
    output reg wpc,             // write PC (branch)
    output reg rpc,             // read PC (call)
    output reg wir,             // write IR
    output reg wreg,            // write register array
    output reg inm,             // use inmediate value
    output reg wmem,            // write data memory
    output reg rmem,            // read data memory
    output reg wmar,            // write memory address register
    output reg wsreg,           // write status register
    output reg clsb,            // clear status register bit
    output reg sesb,            // set status register bit
    output reg prsp,            // preset stack pointer
    output reg incsp,           // increment stack pointer
    output reg decsp,           // decrement stack pointer
    output reg rsp,             // read stack pointer
    output reg disp,            // displacement

    output wire [1:0] state_out // FSM state output for testing
);

    // State definition
    localparam [2:0] READY = 0,
                     FETCH = 1,
                     EXEC1 = 2,
                     EXEC2 = 3,
                     EXEC3 = 4;

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
            `STOP:
                next_state = READY;
            `LDI, `MOV, `ADD, `SUB, `JMP, `BRBS, `BRBC,
            `AND, `OR, `EOR, `ROR, `ROL, `BCLR, `BSET, `CPI, `SUBI,  `NOP:
                next_state = FETCH;
            `LD, `ST, `LDS, `STS, `PUSH, `POP, `CALL, `RET, `LDD, `STD:
                next_state = EXEC2;
            default:
                next_state = 'bx;
            endcase
        EXEC2:
            case (opcode)
            `LD, `ST, `LDS, `STS, `PUSH, `LDD, `STD:
                next_state = FETCH;
            `POP, `CALL, `RET:
                next_state = EXEC3;
            default:
                next_state = 'bx;
            endcase
        EXEC3:
            case (opcode)
            `POP, `CALL, `RET:
                next_state = FETCH;
            default:
                next_state = 'bx;
            endcase
        default:                        // Should not reach this point
            next_state = 'bx;
        endcase
    end

    // Output process
    always @* begin
        // Default output values
        ready = 1'b0; op = 'b0;
        ipc = 1'b0; clpc = 1'b0; wpc = 1'b0; rpc = 1'b0;
        wir = 1'b0; wreg = 1'b0; inm = 1'b0;
        wmem = 1'b0; rmem = 1'b0; wmar = 1'b0;
        wsreg = 1'b0; clsb = 1'b0; sesb = 1'b0;
        prsp = 1'b0; incsp = 1'b0; decsp = 1'b0; rsp = 1'b0; disp = 1'b0;

        case (state)
        READY: begin
            ready = 1'b1;
            if (start) begin
                clpc = 1'b1;
                prsp = 1'b1;
            end
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
                wsreg = 1'b1;
            end
            `SUB: begin
                op = `ALU_SUB;
                wreg = 1'b1;
                wsreg = 1'b1;
            end
            `SUBI: begin
            op = `ALU_SUB;
            wreg = 1'b1;
            wsreg = 1'b1;
            inm = 1'b1; 
        end
            `CPI: begin
            op = `ALU_SUB;
            inm = 1'b1;
            wsreg = 1'b1;
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
            `LDD, `STD: begin
                op = `ALU_ADD;
                wmar = 1'b1;
                disp = 1'b1;
            end

            `JMP: begin
                op = `ALU_TRB;
                inm = 1'b1;
                wpc = 1'b1;
            end
            `BRBS:
                if (status[s] == 1'b1) begin
                    op = `ALU_TRB;
                    inm = 1'b1;
                    wpc = 1'b1;
                end
            `BRBC:
                if (status[s] == 1'b0) begin
                    op = `ALU_TRB;
                    inm = 1'b1;
                    wpc = 1'b1;
                end
            `AND: begin
                op = `ALU_AND;
                wreg = 1'b1;
                wsreg = 1'b1;
            end
            `OR: begin
                op = `ALU_OR;
                wreg = 1'b1;
                wsreg = 1'b1;
            end
            `EOR: begin
                op = `ALU_EOR;
                wreg = 1'b1;
                wsreg = 1'b1;
            end
            `ROR: begin
                op = `ALU_ROR;
                wreg = 1'b1;
                wsreg = 1'b1;
            end
            `ROL: begin
                op = `ALU_ROL;
                wreg = 1'b1;
                wsreg = 1'b1;
            end
            `BCLR:
                clsb = 1'b1;
            `BSET:
                sesb = 1'b1;
            `PUSH, `CALL: begin
                rsp = 1'b1;
                wmar = 1'b1;
                decsp = 1'b1;
            end
            `POP, `RET:
                incsp = 1'b1;
            endcase
        EXEC2:
            case (opcode)
            `LD, `LDS, `LDD: begin
                rmem = 1'b1;
                wreg = 1'b1;
            end
            `ST, `STS, `PUSH, `STD: begin
                op = `ALU_TRA;
                wmem = 1'b1;
            end
            `POP, `RET: begin
                rsp = 1'b1;
                wmar = 1'b1;
            end
            `CALL: begin
                rpc = 1'b1;
                wmem = 1'b1;
            end
            endcase
        EXEC3:
            case (opcode)
            `POP: begin
                rmem = 1'b1;
                wreg = 1'b1;
            end
            `CALL: begin
                inm = 1'b1;
                op = `ALU_TRB;
                wpc = 1'b1;
            end
            `RET: begin
                rmem = 1'b1;
                wpc = 1'b1;
            end
            endcase
        endcase
    end
endmodule