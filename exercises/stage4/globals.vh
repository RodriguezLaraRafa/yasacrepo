// Design:      Simple RPN calculator
// File:        globals.vh
// Description: Global macros and definitions
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        2021-02-27 (initial)

//// Assembly operation codes
`define LDI     5'd1
`define MOV     5'd2
`define ADD     5'd3
`define SUB     5'd4
`define STOP    5'd5
`define LD      5'd6
`define ST      5'd7
`define LDS     5'd8
`define STS     5'd9
`define JMP     5'd10
`define BRBS    5'd11   // BRCS/BRLO, BRZS/BREQ, BRMI, BRVS, BRLT
`define BRBC    5'd12   // BRCC/BRSH, BRZC/BRNE, BRPL, BRVC, BRGE
`define AND     5'd13
`define OR      5'd14
`define EOR     5'd15
`define ROR     5'd16
`define ROL     5'd17
`define BCLR    5'd18
`define BSET    5'd19
`define CP     5'd20
`define CPI    5'd21
`define ADDI   5'd22
`define NEG   5'd23

//// Registers
`define R0      3'd0
`define R1      3'd1
`define R2      3'd2
`define R3      3'd3
`define R4      3'd4
`define R5      3'd5
`define R6      3'd6
`define R7      3'd7

//// ALU operation codes
`define ALU_ADD  4'd0
`define ALU_TRA  4'd1
`define ALU_SUB  4'd2
`define ALU_TRB  4'd3
`define ALU_NEG  4'd4
`define ALU_AND  4'd5
`define ALU_OR   4'd6
`define ALU_EOR  4'd7
`define ALU_ROR  4'd8
`define ALU_ROL  4'd9


//// Status register flags locations
`define CF      3'd0
`define ZF      3'd1
`define NF      3'd2
`define VF      3'd3
`define SF      3'd4

//// Branch pseudo instructions
`define BRCS    {`BRBS, `CF}
`define BRLO    {`BRBS, `CF}
`define BRZS    {`BRBS, `ZF}
`define BREQ    {`BRBS, `ZF}
`define BRMI    {`BRBS, `NF}
`define BRVS    {`BRBS, `VF}
`define BRLT    {`BRBS, `SF}
`define BRCC    {`BRBC, `CF}
`define BRSH    {`BRBC, `CF}
`define BRZC    {`BRBC, `ZF}
`define BRNE    {`BRBC, `ZF}
`define BRPL    {`BRBC, `NF}
`define BRVC    {`BRBC, `VF}
`define BRGE    {`BRBC, `SF}
`define CLC     {`BCLR, `CF}