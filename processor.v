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

`include "./registerFile.v"
`include "mux_2x1.v"
`include "mux_3x1.v"
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
`include "EX_MA_Latch.v"
`include "MA_Cycle.v"
`include "MA_RW_latch.v"
`include "RW_Cycle.v"
`include "data_interlock.v"
`include "forwarding_src1.v"
`include "forwarding_src2.v"



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
output wire [31:0] Operand_OF_A,
output wire [31:0] Operand_OF_B,
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
output wire EX_is_Branch_Taken,
output wire [31:0] input_MA_PC,
output wire [31:0] input_MA_ALU_Result,
output wire [31:0] input_MA_op2,
output wire [31:0] input_MA_IR,
output wire [21:0] input_MA_controlBus,
output wire [31:0] output_MA_PC,
output wire [31:0] output_MA_ALU_Result,
output wire [31:0] output_MA_IR,
output wire [21:0] output_MA_controlBus,
output wire [31:0] MA_Ld_Result,
output wire [31:0] MDR,
output wire [31:0] readData,
output wire [31:0] address,
output wire writeEnable,
output wire [31:0] writeData,
output wire MA_writeEnable,
output wire [31:0] input_RW_PC,
output wire [31:0] input_RW_Ld_Result,
output wire [31:0] input_RW_ALU_Result,
output wire [31:0] input_RW_IR,
output wire [21:0] input_RW_controlBus,
output wire [31:0] RW_Data_value,
output wire [3:0] RW_rd,
output wire RW_isWb,
output wire[31:0] output_register_file,
output wire [31:0] rdData1,
output wire [31:0] rdData2,
output wire isDataInterLock,
output wire is_RW_OF_conflict_src1,
output wire is_RW_EX_conflict_src1,
output wire is_RW_MA_conflict_src1,
output wire is_MA_EX_conflict_src1,
output wire is_RW_OF_conflict_src2,
output wire is_RW_EX_conflict_src2,
output wire is_RW_MA_conflict_src2,
output wire is_MA_EX_conflict_src2,
output wire isLastInstruction

);


reg [31:0] OF_IR;






  registerFile r_File_processor(
    .clk(clk),
    .reset(reset),
    .rdData1(op1),
    .rdData2(op2),
    .operand1(isReturn_result),
    .operand2(isStore_result),
    .writeEnable(RW_isWb),
    .wrData(RW_Data_value),
    .dReg(RW_rd),
    .output_register_file(output_register_file)
    );


    memory data_memory(
        .clk(clk),
        .reset(reset),
        .readData(readData),
        .writeEnable(MA_writeEnable),
        .address(output_MA_ALU_Result),
        .writeData(MDR)

    );


    IF_cycle iFetch(
        .clk(clk),
        .reset(reset),
        .inputPC(PC),
        .IR(IR),
        .isDataInterLock(isDataInterLock),
        // .isDataInterLock(1'b0),
        .is_Branch_Taken(is_Branch_Taken),
        .branchPC(branchPC),
        .outputPC(output_IF_PC)
    );

    IF_OF_Latch  latch_if_of(
        .clk(clk),
        .output_IF_PC(output_IF_PC),
        .IF_instruction(IR),
        .isDataInterLock(isDataInterLock),
        // .isDataInterLock(1'b0),
        .isBranchInterLock(is_Branch_Taken),
        .Input_OF_PC(input_OF_PC),
        .OF_instruction(Input_OF_IR)
    );

Control_Unit controlUnit(
        .Input_OF_IR (Input_OF_IR),
        .reset(reset),
        .controlBus(Input_OF_controlBus)
    );

OF_stage OperandFetch(
    .Input_OF_PC(input_OF_PC),
    .Input_OF_IR(Input_OF_IR),
    .Input_OF_controlBus(Input_OF_controlBus),
    .op1(op1),
    .op2(op2),
    .output_OF_PC(output_OF_PC),
    .branchTarget(branchTarget),
    .Operand_A(Operand_OF_A),
    .Operand_B(Operand_OF_B),
    .Operand_2(Operand_2),
    .output_OF_IR(output_OF_IR),
    .isStore_result(isStore_result),
    .isReturn_result(isReturn_result),
    .Output_OF_controlBus(Output_OF_controlBus),
    .RW_Data_value(RW_Data_value),
    .RW_rd(RW_rd),
    .is_RW_OF_conflict_src1(is_RW_OF_conflict_src1),
    .is_RW_OF_conflict_src2(is_RW_OF_conflict_src2)
    );


OF_EX_Latch of_ex_latch(
    .clk(clk),
    .output_OF_PC(output_OF_PC),
    .OF_branchTarget(branchTarget),
    .Operand_OF_A(Operand_OF_A),
    .Operand_OF_B(Operand_OF_B),
    .Operand_OF_2(Operand_2),
    .output_OF_IR(output_OF_IR),
    .Output_OF_controlBus(Output_OF_controlBus),
    .isDataInterLock(isDataInterLock),
    // .isDataInterLock(1'b0),
    .isBranchInterLock(is_Branch_Taken),
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
    .EX_is_Branch_Taken(is_Branch_Taken),
    .RW_Data_value(RW_Data_value),
    .RW_rd(RW_rd),
    .input_MA_ALU_Result(input_MA_ALU_Result),
    .is_RW_EX_conflict_src1(is_RW_EX_conflict_src1),
    .is_RW_EX_conflict_src2(is_RW_EX_conflict_src2),
    .is_MA_EX_conflict_src1(is_MA_EX_conflict_src1),
    .is_MA_EX_conflict_src2(is_MA_EX_conflict_src2)
);


EX_MA_Latch  ex_ma_latch(
.clk(clk),
.output_EX_PC(output_EX_PC),
.ALU_Result(ALU_Result),
.EX_op2(EX_op2),
.output_EX_IR(output_EX_IR),
.output_EX_controlBus(output_EX_controlBus),
.input_MA_PC(input_MA_PC),
.input_MA_ALU_Result(input_MA_ALU_Result),
.input_MA_op2(input_MA_op2),
.input_MA_IR(input_MA_IR),
.input_MA_controlBus(input_MA_controlBus)

);
MA_stage MA_cycle(
.input_MA_PC(input_MA_PC),
.input_MA_ALU_Result(input_MA_ALU_Result),
.input_MA_op2(input_MA_op2),
.input_MA_IR(input_MA_IR),
.input_MA_controlBus(input_MA_controlBus),
.readData(readData),
.output_MA_PC(output_MA_PC),
.output_MA_ALU_Result(output_MA_ALU_Result),
.output_MA_IR(output_MA_IR),
.output_MA_controlBus(output_MA_controlBus),
.MA_Ld_Result(MA_Ld_Result),
.MDR(MDR),
.MA_writeEnable(MA_writeEnable),
.RW_Data_value(RW_Data_value),
.RW_rd(RW_rd),
.is_RW_MA_conflict_src2(is_RW_MA_conflict_src2)

);

MA_RW_Latch ma_ra_latch(
    .clk(clk),
    .output_MA_PC(output_MA_PC),
    .output_MA_ALU_Result(output_MA_ALU_Result),
    .output_MA_IR(output_MA_IR),
    .output_MA_controlBus(output_MA_controlBus),
    .MA_Ld_Result(MA_Ld_Result),
    .input_RW_PC(input_RW_PC),
    .input_RW_Ld_Result(input_RW_Ld_Result),
    .input_RW_ALU_Result(input_RW_ALU_Result),
    .input_RW_IR(input_RW_IR),
    .input_RW_controlBus(input_RW_controlBus)
);

RW_stage rw_stage(
    .input_RW_PC(input_RW_PC),
    .input_RW_Ld_Result(input_RW_Ld_Result),
    .input_RW_ALU_Result(input_RW_ALU_Result),
    .input_RW_IR(input_RW_IR),
    .input_RW_controlBus(input_RW_controlBus),
    .RW_Data_value(RW_Data_value),
    .RW_isWb(RW_isWb),
    .RW_rd(RW_rd),
    .isLastInstruction(isLastInstruction)
);

data_interlock is_data_interlock(
 .input_OF_IR(Input_OF_IR),
 .input_EX_IR(input_EX_IR),
 .input_MA_IR(input_MA_IR),
 .input_RW_IR(input_RW_IR),
 .isDataInterLock(isDataInterLock)
);


forwarding_unit_src1 forwarding_src1(
    .input_OF_IR(Input_OF_IR),
    .input_EX_IR(input_EX_IR),
    .input_MA_IR(input_MA_IR),
    .input_RW_IR(input_RW_IR),
    .is_RW_OF_conflict_src1(is_RW_OF_conflict_src1),
    .is_RW_EX_conflict_src1(is_RW_EX_conflict_src1),
    .is_RW_MA_conflict_src1(is_RW_MA_conflict_src1),
    .is_MA_EX_conflict_src1(is_MA_EX_conflict_src1)

);

forwarding_unit_src2 forwarding_src2(
    .input_OF_IR(Input_OF_IR),
    .input_EX_IR(input_EX_IR),
    .input_MA_IR(input_MA_IR),
    .input_RW_IR(input_RW_IR),
    .is_RW_OF_conflict_src2(is_RW_OF_conflict_src2),
    .is_RW_EX_conflict_src2(is_RW_EX_conflict_src2),
    .is_RW_MA_conflict_src2(is_RW_MA_conflict_src2),
    .is_MA_EX_conflict_src2(is_MA_EX_conflict_src2)

);
  
initial begin
        reset = 1;                 
        // is_Branch_Taken = 1'b0;
        // branchPC = 10'b0;
        #4
        reset = 0;               

    end

 
endmodule

