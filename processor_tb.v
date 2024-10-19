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
output wire isStore;
output wire isImmendiate;
output wire isReturn;
wire [9:0] input_OF_PC;
wire [9:0] output_OF_PC;
wire [31:0] branchTarget;
wire [31:0] Operand_A;
wire [31:0] Operand_B;
wire [31:0] Operand_2;
wire [31:0] Input_OF_IR;
wire [31:0] output_OF_IR;

    pipeline_top_module processor(
    .clk(clk),
    .reset(reset),
    .PC(PC),
    .IR(IR), 
    .is_Branch_Taken(is_Branch_Taken),
    .branchPC(branchPC),
    .output_IF_PC(outputPC),
    .isStore(isStore),
    .isReturn(isReturn),
    .isImmendiate(isImmendiate),
    .input_OF_PC(input_OF_PC),
    .output_OF_PC(output_OF_PC),
    .branchTarget(branchTarget),
    .Operand_A(Operand_A),
    .Operand_B(Operand_B),
    .Operand_2(Operand_2),
    .Input_OF_IR(Input_OF_IR),
    .output_OF_IR (output_OF_IR)              
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
        #100;            
        $finish; 

    end                       

endmodule
