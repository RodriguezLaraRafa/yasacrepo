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
        // Reads data from port8, adds to previous value at memory
        // address 10h, saves the result to address 10h and outputs
        // the result to output port1.
        // Example
        // input:
        //      data_mem[0x10] = 0
        //      port08 = 5
        // expected output execution 1
        //      data_mem[0x10] = 0x05
        //      port01 = 0x05
        // expected output execution 2
        //      data_mem[0x10] = 0x0a
        //      port01 = 0x0a

            /*
        code['h0] = {`LDI, `R1, 8'h10};       // LDI R1,0x10
        code['h1] = {`LDI, `R2, 8'hf1};       // LDI R2,0xf1
        code['h2] = {`LDS, `R3, 8'hf8};       // LDS R3,0xf8 ; load from port08
        code['h3] = {`LD,  `R4, 5'd0, `R1};   // LD  R4,R1
        code['h4] = {`ADD, `R3, 5'd0, `R4};   // ADD R3,R4
        code['h5] = {`STS, `R3, 8'h10};       // STS 0x10,R3
        code['h6] = {`ST,  `R3, 5'd0, `R2};   // ST  R2,R3   ; store to port01
        code['h7] = {`STOP, 11'd0};           // STOP

        Esto es lo que habia originalmente*/

        /*Exercise 3. (Stage 1 or 2) Assuming that the last two values in the Fibonacci sequence are stored in
registers R0 and R1, write a program that display the next value of the sequence and updates R0 and
R1. Modify the sample test bench as needed and simulate the program
    */
    
    /*
        code['h0] = {`MOV, `R6, 5'd0, `R0}; //Asumo que R1 es el mas alto. R0 pasa al output
        code['h1] = {`ADD, `R6, 5'd0, `R1}; //El output ya es el resultado final
        code['h2] = {`MOV, `R0, 5'd0, `R1}; //R0 toma el antigua valor de R1
        code['h3] = {`MOV, `R1, 5'd0, `R6}; //R1 toma el valor de R6
        code['h4] = {`STOP, 11'd0};

        */

        //Ejercicio 3
        
        code['h0] = {`LDI, `R0, 8'h03};
        code['h1] = {`LDI, `R1, 8'h05};

        code['h2] = {`MOV, `R6, 5'd0, `R0}; //Asumo que R1 es el mas alto. R0 pasa al output
        code['h3] = {`ADD, `R6, 5'd0, `R1}; //El output ya es el resultado final
        code['h4] = {`MOV, `R0, 5'd0, `R1}; //R0 toma el antiguo valor de R1
        code['h5] = {`MOV, `R1, 5'd0, `R6}; //R1 toma el valor de R6
        
        //quiero que en el puerto0 se muestre el valor de R0
        
        //code['h6] = {`STS, 8'hF1, `R0}; //en el puerto 8 se muestra el valor de R0
        code['h6] = {`STS, 8'hF0, `R0}; //en el puerto 0 se muestra el valor de R0
        /*
        code['h5] = {`STS, 1, `}; 
        */
        code['h7] = {`STOP, 11'd0};
        





        //Ejercicio 5

        /*Write a program that outputs to port01 the number in port08 multiplied by 5.
Test it by simulation. Modify the sample test bench as appropriate.

*/

code['h0] = {`LD, `R0, 8'F8};
        code['h1] = {`MOV, `R6, 5'd0, `R0}; 
        code['h3] = {`ADD, `R6, 5'd0, `R1}; 
        code['h4] = {`MOV, `R0, 5'd0, `R1}; //Flip-flop
        code['h5] = {`MOV, `R1, 5'd0, `R6};
                
        code['h6] = {`STS, 8'hF0, `R0}; 
   
        code['h7] = {`STOP, 11'd0};



    end
endmodule