/*
Problem: Implement a fully pipelined processor with interlocks and
forwarding. No delayed branches. Predict not-taken. The input will be
a file with SimpleRisc machine code. Use the .encode directive of the
SimpleRisc assembler to generate the machine code. Interrupts need not
be implemented in the no-bonus version.

Version 1: In Logisim. Maximum marks: 90%. No bonus

Version 2: In Bluespec/PyHDL/Chisel/... : 110%, bonus allowed

Version 3: Verilog/VHDL: 140%, bonus allowed. No synthesis in the
no-bonus version.
*/
// clk, reset, PC, IR, is_Branch_Taken, branchPC, output_IF_PC)
`include "registerFile.v"
`include "mux_2x1.v"
`include "memory.v"
`include "IF_cycle.v"
`include "instructionMemory.v"
`include "OF_Cycle.v"
`include "IF_OF_latch.v"
`include "4_bit_mux2x1.v"
`include "ControlUnit.v"
`include "OF_EX_latch.v"
`include "Calculate_Immx_Branchtarget.v"
`include "ALU_cycle.v"
`include "branchUnit.v"
`include "ALU_Module.v"


module pipeline_top_module(
input clk,                  // TWO PHASE CLK
output reg reset,
output reg [31:0] PC,           // PROGRAM COUNTER
output wire [31:0] IR,          // INSTRUCTION REGISTER
output wire is_Branch_Taken,  // TO DISABLE INSTRUCTION AFTER BRANCH
output wire [31:0] branchPC,
output wire[31:0] output_IF_PC,
output wire [31:0] Input_OF_IR, 
output wire [31:0] input_OF_PC,
output wire [31:0] output_OF_PC,
output wire [31:0] branchTarget,
output wire [31:0] op1,
output wire [31:0] op2,
output wire [31:0] Operand_A,
output wire [31:0] Operand_B,
output wire [31:0] Operand_2,
output wire [31:0] output_OF_IR,
output wire [3:0] isStore_result,
output wire [3:0] isReturn_result,
output wire [31:0] input_EX_PC,
output wire [31:0] EX_branchTarget,
output wire [31:0] Operand_EX_A,
output wire [31:0] Operand_EX_B,
output wire [31:0] Operand_EX_2,
output wire [31:0] input_EX_IR,
output wire [21:0] Input_OF_controlBus,
output wire [21:0] Output_OF_controlBus,
output wire [21:0] Input_EX_controlBus,
output wire [31:0] output_EX_PC,
output wire [31:0] ALU_Result,
output wire [31:0] EX_op2,
output wire [31:0] output_EX_IR,
output wire [21:0] output_EX_controlBus,
output wire [31:0] EX_branchPC,
output wire EX_is_Branch_Taken
);
reg [31:0] OF_IR;






  registerFile r_File_processor(
    .clk(clk),
    .reset(reset),
    .rdData1(op1),
    .rdData2(op2),
    .op1(isReturn_result),
    .op2(isStore_result)
    );


    IF_cycle iFetch(
        .clk(clk),
        .reset(reset),
        .inputPC(PC),
        .IR(IR),
        .is_Branch_Taken(is_Branch_Taken),
        .branchPC(branchPC),
        .outputPC(output_IF_PC)
    );

    IF_OF_Latch  latch_if_of(
        .clk(clk),
        .output_IF_PC(output_IF_PC),
        .IF_instruction(IR),
        .Input_OF_PC(input_OF_PC),
        .OF_instruction(Input_OF_IR)
    );

Control_Unit controlUnit(
        .Input_OF_IR (Input_OF_IR),
        .reset(reset),
        .controlBus(Input_OF_controlBus)
    );

OF_stage OperandFetch(
    .clk(clk),
    .Input_OF_PC(input_OF_PC),
    .Input_OF_IR(Input_OF_IR),
    .Input_OF_controlBus(Input_OF_controlBus),
    .op1(op1),
    .op2(op2),
    .output_OF_PC(output_OF_PC),
    .branchTarget(branchTarget),
    .Operand_A(Operand_A),
    .Operand_B(Operand_B),
    .Operand_2(Operand_2),
    .output_OF_IR(output_OF_IR),
    .isStore_result(isStore_result),
    .isReturn_result(isReturn_result),
    .Output_OF_controlBus(Output_OF_controlBus)
    );


OF_EX_Latch of_ex_latch(
    .clk(clk),
    .output_OF_PC(output_OF_PC),
    .OF_branchTarget(branchTarget),
    .Operand_OF_A(Operand_A),
    .Operand_OF_B(Operand_B),
    .Operand_OF_2(Operand_2),
    .output_OF_IR(output_OF_IR),
    .Output_OF_controlBus(Output_OF_controlBus),
    .input_EX_PC(input_EX_PC),
    .EX_branchTarget(EX_branchTarget),
    .Operand_EX_A(Operand_EX_A),
    .Operand_EX_B(Operand_EX_B),
    .Operand_EX_2(Operand_EX_2),
    .input_EX_IR(input_EX_IR),
    .Input_EX_controlBus(Input_EX_controlBus)

    );

ALU_Stage ALU_cycle(
    .input_EX_PC(input_EX_PC),
    .EX_branchTarget(EX_branchTarget),
    .Operand_EX_A(Operand_EX_A),
    .Operand_EX_B(Operand_EX_B),
    .Operand_EX_2(Operand_EX_2),
    .input_EX_IR(input_EX_IR),
    .Input_EX_controlBus(Input_EX_controlBus),
    .output_EX_PC(output_EX_PC),
    .ALU_Result(ALU_Result),
    .EX_op2(EX_op2),
    .output_EX_IR(output_EX_IR),
    .output_EX_controlBus(output_EX_controlBus),
    .EX_branchPC(branchPC),
    .EX_is_Branch_Taken(is_Branch_Taken)
);





        // Initialize signals in an always block
initial begin
        reset = 1;                 // Start with reset active 
        // is_Branch_Taken = 1'b0;
        // branchPC = 10'b0;
        #2
        reset = 0;               // Initialize Program Counter

    end

 
endmodule




// // reg [31:0] instruction;

// // parameter ADD =5'b00000,SUB=5'b00001,MUL = 5'b00010, DIV=5'b00011,
// // MOD=5'b00100,CMP=5'b00101,AND=5'b00110,OR=5'b00111,NOT=5'b01000,MOV=5'b01001,LSL=5'b01010,LSR=5'b01011,
// // ASR=5'b01100,NOP=5'b01101,LD=5'b01110,ST=5'b01111,BEQ=5'b10000,BGT=5'b10001,B=5'b10010,CALL=5'b10011, RET=5'b10100;
// reg HALTED;



        // .isSt(isSt),
        // .isLd(isLd),
        // .isBeq(isBeq),
        // .isBgt(isBgt),
        // .isRet(isRet),
        // .isImmediate(isImmediate),
        // .isWb(isWb),
        // .isUbranch(isUbranch),
        // .isCall(isCall),
        // .isAdd(isAdd),
        // .isSub(isSub),
        // .isCmp(isCmp),
        // .isMul(isMul),
        // .isDiv(isDiv),
        // .isMod(isMod),
        // .isLsl(isLsl),
        // .isLsr(isLsr),
        // .isAsr(isAsr),
        // .isOr(isOr),
        // .isAnd(isAnd),
        // .isNot(isNot),
        // .isMov(isMov)



// reg [31:0] op1;
// reg [31:0] op2;
// wire isBeq;
// wire isBgt;
// wire isWb;    
// wire isUbranch;
// wire isCall;
// wire isAdd;
// wire isSub;
// wire isCmp;
// wire isMul;
// wire isDiv;
// wire isMod;
// wire isLsl;
// wire isLsr;
// wire isAsr;
// wire isOr;
// wire isAnd;
// wire isNot;