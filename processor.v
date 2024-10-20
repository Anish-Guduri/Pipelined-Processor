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


module pipeline_top_module(
input clk,                  // TWO PHASE CLK
output reg reset,
output reg [9:0] PC,           // PROGRAM COUNTER
output wire [31:0] IR,          // INSTRUCTION REGISTER
output reg is_Branch_Taken,  // TO DISABLE INSTRUCTION AFTER BRANCH
output reg [9:0] branchPC,
output wire[9:0] output_IF_PC,
output wire [31:0] Input_OF_IR, 
output wire isSt,
output wire isImmendiate,
output wire isRet,
output wire isMov,
output wire isLd,
output wire [9:0] input_OF_PC,
output wire [9:0] output_OF_PC,
output wire [31:0] branchTarget,
output wire [31:0] Operand_A,
output wire [31:0] Operand_B,
output wire [31:0] Operand_2,
output wire [31:0] output_OF_IR,
output wire [3:0] isStore_result,
output wire [3:0] isReturn_result,
output wire [9:0] input_EX_PC,
output wire [31:0] EX_branchTarget,
output wire [31:0] Operand_EX_A,
output wire [31:0] Operand_EX_B,
output wire [31:0] Operand_EX_2,
output wire [31:0]input_EX_IR
);
reg [31:0] OF_IR;
// wire isSt;

wire isBeq;
wire isBgt;
// wire isRet;
// wire isImmx;
wire isWb;    
wire isUbranch;
wire isCall;
wire isAdd;
wire isSub;
wire isCmp;
wire isMul;
wire isDiv;
wire isMod;
wire isLsl;
wire isLsr;
wire isAsr;
wire isOr;
wire isAnd;
wire isNot;





  registerFile r_File_processor(
    .clk(clk),
    .reset(reset),
    .rdData1(Operand_A),
    .rdData2(Operand_B),
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
        .isSt(isSt),
        .isLd(isLd),
        .isBeq(isBeq),
        .isBgt(isBgt),
        .isRet(isRet),
        .isImmendiate(isImmendiate),
        .isWb(isWb),
        .isUbranch(isUbranch),
        .isCall(isCall),
        .isAdd(isAdd),
        .isSub(isSub),
        .isCmp(isCmp),
        .isMul(isMul),
        .isDiv(isDiv),
        .isMod(isMod),
        .isLsl(isLsl),
        .isLsr(isLsr),
        .isAsr(isAsr),
        .isOr(isOr),
        .isAnd(isAnd),
        .isNot(isNot),
        .isMov(isMov)
    );

OF_stage OperandFetch(
    .clk(clk),
    .Input_OF_PC(input_OF_PC),
    .Input_OF_IR(Input_OF_IR),
    .isStore(is),
    .isReturn(isRet),
    .isImmendiate(isImmendiate),
    .output_OF_PC(output_OF_PC),
    .branchTarget(branchTarget),
    .Operand_A(Operand_A),
    .Operand_B(Operand_B),
    .Operand_2(Operand_2),
    .output_OF_IR(output_OF_IR),
    .isStore_result(isStore_result),
    .isReturn_result(isReturn_result)
    );


OF_EX_Latch of_ex_latch(
    .clk(clk),
    .output_OF_PC(output_OF_PC),
    .OF_branchTarget(branchTarget),
    .Operand_OF_A(Operand_A),
    .Operand_OF_B(Operand_B),
    .Operand_OF_2(Operand_2),
    .output_OF_IR(output_OF_IR),
    .input_EX_PC(input_EX_PC),
    .EX_branchTarget(EX_branchTarget),
    .Operand_EX_A(Operand_EX_A),
    .Operand_EX_B(Operand_EX_B),
    .Operand_EX_2(Operand_EX_2),
    .input_EX_IR(input_EX_IR)

    );
        // Initialize signals in an always block
initial begin
        reset = 1;                 // Start with reset active
        // PC = 10'b0; 
        is_Branch_Taken = 1'b0;
        branchPC = 10'b0;
        // isStore = 4'b0;
        // isReturn = 4'b0;
        
        #2
        reset = 0;               // Initialize Program Counter

    end
always @(output_OF_PC) begin
    $display("Hello World  PC %d",output_OF_PC);
end
 
endmodule




// // reg [31:0] instruction;

// // parameter ADD =5'b00000,SUB=5'b00001,MUL = 5'b00010, DIV=5'b00011,
// // MOD=5'b00100,CMP=5'b00101,AND=5'b00110,OR=5'b00111,NOT=5'b01000,MOV=5'b01001,LSL=5'b01010,LSR=5'b01011,
// // ASR=5'b01100,NOP=5'b01101,LD=5'b01110,ST=5'b01111,BEQ=5'b10000,BGT=5'b10001,B=5'b10010,CALL=5'b10011, RET=5'b10100;
// reg HALTED;

    // always @(negedge clk) begin
    //     if (reset)
    //         delayed_IF_PC <= 10'b0;
    //     else
    //         delayed_IF_PC <= output_IF_PC;  // Delay the PC for 1 cycle
    // end

    //     #2
    //     // $display("Hello World  PC %d",output_IF_PC);
    //     // if(output_IF_PC == 10'b0000001100)begin
    //     //     assign is_Branch_Taken =1'b1;
    //     //     assign branchPC = 10'b0000011100;
    //     //     #5
    //     //     assign is_Branch_Taken =1'b0;
        
    //     // end
    //     $display("Instruction: %b at PC: %d",IR[25:14],output_IF_PC);
        
    // end