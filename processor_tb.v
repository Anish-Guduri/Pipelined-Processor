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
wire [9:0] PC;           // PROGRAM COUNTER
wire [31:0] IR;          // INSTRUCTION REGISTER
wire is_Branch_Taken;  // TO DISABLE INSTRUCTION AFTER BRANCH
wire [9:0] branchPC;
wire[9:0] outputPC;
wire isStore;
wire isImmendiate;
wire isReturn;
wire isMov;
wire isLd;
wire [9:0] input_OF_PC;
wire [9:0] output_OF_PC;
wire [31:0] branchTarget;
wire [31:0] Operand_A;
wire [31:0] Operand_B;
wire [31:0] Operand_2;
wire [31:0] Input_OF_IR;
wire [31:0] output_OF_IR;
wire [3:0] isStore_result;
wire [3:0] isReturn_result;
wire [9:0] input_EX_PC;
wire [31:0] EX_branchTarget;
wire [31:0] Operand_EX_A;
wire [31:0] Operand_EX_B;
wire [31:0] Operand_EX_2;
wire [31:0] input_EX_IR;

    pipeline_top_module processor(
    .clk(clk),
    .reset(reset),
    .PC(PC),
    .IR(IR), 
    .is_Branch_Taken(is_Branch_Taken),
    .branchPC(branchPC),
    .output_IF_PC(outputPC),
    .isSt(isStore),
    .isRet(isReturn),
    .isMov(isMov),
    .isLd(isLd),
    .isImmendiate(isImmendiate),
    .input_OF_PC(input_OF_PC),
    .output_OF_PC(output_OF_PC),
    .branchTarget(branchTarget),
    .Operand_A(Operand_A),
    .Operand_B(Operand_B),
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
    .input_EX_IR(input_EX_IR)        
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
        #150;            
        $finish; 

    end                       

endmodule
