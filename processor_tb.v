`timescale 1ns / 1ps

module testbench;

    reg clk;                           // Clock signal
    wire reset;                         // Reset signal
    // integer i;                         // Loop variable for loading instructions
    // integer fd;                        // File descriptor for reading the hex file
    // wire [31:0] instruction;            // Variable to hold each instruction
    // reg [31:0] writeInstruction;
    // reg [9:0] address;                 // Memory address
    // reg writeEnable;                   // Write enable signal for memory
    // reg [31:0] instructionMemory[0:1023];
wire [31:0] PC;           // PROGRAM COUNTER
wire [31:0] IR;          // INSTRUCTION REGISTER
wire is_Branch_Taken;  // TO DISABLE INSTRUCTION AFTER BRANCH
wire [31:0] branchPC;
wire[31:0] outputPC;
wire [31:0] input_OF_PC;
wire [31:0] output_OF_PC;
wire [31:0] branchTarget;
wire [31:0] Operand_A;
wire [31:0] Operand_B;
wire [31:0] Operand_2;
wire [31:0] Input_OF_IR;
wire [31:0] output_OF_IR;
wire [3:0] isStore_result;
wire [3:0] isReturn_result;
wire [31:0] input_EX_PC;
wire [31:0] EX_branchTarget;
wire [31:0] Operand_EX_A;
wire [31:0] Operand_EX_B;
wire [31:0] Operand_EX_2;
wire [31:0] input_EX_IR;
wire [21:0] Input_OF_controlBus;
wire [21:0] Output_OF_controlBus;
wire [21:0] Input_EX_controlBus;
wire [31:0] output_EX_PC;
wire [31:0] ALU_Result;
wire [31:0] EX_op2;
wire [31:0] output_EX_IR;
wire [21:0] output_EX_controlBus;
wire [31:0] input_MA_PC;
wire [31:0] input_MA_ALU_Result;
wire [31:0] input_MA_op2;
wire [31:0] input_MA_IR;
wire [31:0] output_MA_PC;
wire [31:0] output_MA_IR;
wire [31:0] MA_Ld_Result;
wire [31:0] MDR;
wire [21:0] input_MA_controlBus;
wire [31:0] output_MA_ALU_Result;
wire [21:0] output_MA_controlBus;
wire [31:0] readData;       
wire MA_writeEnable;
wire [31:0] input_RW_PC;
wire [31:0] input_RW_Ld_Result;
wire [31:0] input_RW_ALU_Result;
wire [31:0] input_RW_IR;
wire [21:0] input_RW_controlBus;
wire [31:0] RW_Data_value;
wire [3:0] RW_rd;
wire RW_isWb;
wire[31:0] output_register_file;
wire [31:0] op1;
wire [31:0] op2;
wire isDataInterLock;

    pipeline_top_module processor(
    .clk(clk),
    .reset(reset),
    .PC(PC),
    .IR(IR), 
    .is_Branch_Taken(is_Branch_Taken),
    .branchPC(branchPC),
    .output_IF_PC(outputPC),
    .input_OF_PC(input_OF_PC),
    .output_OF_PC(output_OF_PC),
    .branchTarget(branchTarget),
    .Operand_OF_A(Operand_A),
    .Operand_OF_B(Operand_B),
    .Operand_2(Operand_2),
    .Input_OF_IR(Input_OF_IR),
    .output_OF_IR (output_OF_IR),
    .isStore_result(isStore_result),
    .isReturn_result(isReturn_result),
    .input_EX_PC(input_EX_PC),
    .EX_branchTarget(EX_branchTarget),
    .Operand_EX_A(Operand_EX_A),
    .Operand_EX_B(Operand_EX_B),
    .Operand_EX_2(Operand_EX_2),
    .input_EX_IR(input_EX_IR),
    .Input_OF_controlBus(Input_OF_controlBus),
    .Input_EX_controlBus(Input_EX_controlBus),
    .Output_OF_controlBus(Output_OF_controlBus),
    .output_EX_PC(output_EX_PC),
    .ALU_Result(ALU_Result),
    .EX_op2(EX_op2),
    .output_EX_IR(output_EX_IR),
    .output_EX_controlBus(output_EX_controlBus),
    .input_MA_PC(input_MA_PC),
    .input_MA_ALU_Result(input_MA_ALU_Result),
    .input_MA_op2(input_MA_op2),
    .input_MA_IR(input_MA_IR),
    .input_MA_controlBus(input_MA_controlBus),
    .output_MA_PC(output_MA_PC),
    .output_MA_ALU_Result(output_MA_ALU_Result),
    .output_MA_IR(output_MA_IR),
    .output_MA_controlBus(output_MA_controlBus),
    .MA_Ld_Result(MA_Ld_Result),
    .MDR(MDR),
    .MA_writeEnable(MA_writeEnable),
    .input_RW_PC(input_RW_PC),
    .input_RW_Ld_Result(input_RW_Ld_Result),
    .input_RW_ALU_Result(input_RW_ALU_Result),
    .input_RW_IR(input_RW_IR),
    .input_RW_controlBus(input_RW_controlBus),
    .RW_Data_value(RW_Data_value),
    .RW_isWb(RW_isWb),
    .RW_rd(RW_rd),
    .output_register_file(output_register_file),
    .op1(op1),
    .op2(op2),
    .isDataInterLock(isDataInterLock)
    
   );

    // Generate a clock signal
    initial begin
        clk = 1;                       // Initialize clock to 0
        forever #5 clk = ~clk;         // Toggle clock every 5 ns
    end
 
    initial begin
        $dumpfile("processor.vcd");
        $dumpvars(0, testbench);

    end

    // Simulate for a specific duration and then finish
    initial begin
        #1000;            
        $finish; 

    end                       

endmodule
