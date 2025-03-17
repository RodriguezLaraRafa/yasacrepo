// Design:      Yet Another Simple Academic Computer (YASAC)
// File:        code_mem.v
// Description: Code memory.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-03-23 (initial)

//// Instruction formats
//
// format A: <opcode>(5) <Ra>(3) <zero>(5) <Rb>(3)
// format B: <opcode>(5) <Ra>(3) <k>(8)
//
// k -> inmediate value

`include "globals.vh"

module code_mem (
    input wire [7:0] addr,
    output wire [15:0] data
);

    reg [15:0] code[0:255];
    integer i;

    assign data = code[addr];

    initial begin
        // Xilinx ISE synthesis needs all the positions to be initialized
        for (i=0; i<256; i=i+1)
            code[i] = 16'h0000;

        // Code memory contents (program)

        // Calculates dout = 2*din - 5
        // Example
        // input:
        //      din = 6
        // expected output:
        //      dount = 7

            /*
        
        code['h0] = {`MOV, `R1, 5'd0, `R7};     // instruction format A
        code['h1] = {`MOV, `R0, 5'd0, `R1};
        code['h2] = {`ADD, `R0, 5'd0, `R1};
        code['h3] = {`LDI, `R2, 8'h05};         // instruction format B
        code['h4] = {`SUB, `R0, 5'd0, `R2};
        code['h5] = {`MOV, `R6, 5'd0, `R0};5
        code['h6] = {`STOP, 11'd0};

        Esto es lo que tenia JJ originalmente, abajo pongo los ejercicios
        */ 

        // Ejercicio 1 
        //Write a program that displays the number in din multiplied by 5. Test it by
//simulation. Modify the sample test bench as appropriate

        code['h0] = {`MOV, `R6, 5'd0, `R7};     
        code['h1] = {`ADD, `R6 , 5'd0, `R6};     
        code['h2] = {`ADD, `R6 , 5'd0, `R6}; 
        code['h3] = {`ADD, `R6 , 5'd0, `R7}; 
        code['h4] = {`STOP, 11'd0};
        

    end
endmodule