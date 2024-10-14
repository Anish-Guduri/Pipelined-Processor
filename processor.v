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

module pipeline_RISCV (clk);
input clk;                   // TWO PHASE CLK

reg [31:0] PC;           // PROGRAM COUNTER
reg [31:0] IR;          // INSTRUCTION REGISTER
reg [31:0] branchPC;
wire[31:0] nextPC;
// reg [31:0] instruction;


parameter ADD =5'b00000,SUB=5'b00001,MUL = 5'b00010, DIV=5'b00011,
MOD=5'b00100,CMP=5'b00101,AND=5'b00110,OR=5'b00111,NOT=5'b01000,MOV=5'b01001,LSL=5'b01010,LSR=5'b01011,
ASR=5'b01100,NOP=5'b01101,LD=5'b01110,ST=5'b01111,BEQ=5'b10000,BGT=5'b10001,B=5'b10010,CALL=5'b10011, RET=5'b10100;


reg HALTED;

reg is_Branch_Taken;  // TO DISABLE INSTRUCTION AFTER BRANCH


//  ********************  INSTRUCTION FETCH STAGE  ********************

    mux2x1 pc_mux(
        .output_y(nextPC),            // MUX output: the next value of the PC
        .input0(PC + 4),            // Normal PC increment by 4
        .input1(branchPC),          // Branch target address
        .selectLine(is_Branch_Taken)     // Selection signal: branch taken or not
    );



    // Register file signals
    wire [31:0] rdData1, rdData2;
    reg [31:0] wrData;
    reg [3:0] op1, op2, dReg;
    reg writeEnable;
    reg reset;

    // Instantiate the register file
    registerFile regfile(
        .rdData1(rdData1), 
        .rdData2(rdData2), 
        .wrData(wrData), 
        .op1(op1), 
        .op2(op2), 
        .dReg(dReg), 
        .writeEnable(writeEnable), 
        .reset(reset), 
        .clk(clk)
    );

    // Memory signals and instantiation
    wire [31:0] instruction;
    // reg [7:0] memory [0:1023];
    reg [9:0] address;
    reg writeEnableMem;
    reg [31:0] writeDataMem;
    
    // Byte-addressable memory instantiated
    memory mem(
        .instruction(instruction),
        .address(address),
        .clk(clk),
        .writeEnable(writeEnableMem),
        .writeData(writeDataMem)
    );


// ********************  INITIALIZATION  ********************
initial begin
    PC = 0;                 // Initialize PC to 0
    branchPC = 0;           // Initialize branchPC to 0
    is_Branch_Taken = 0;    // Initialize is_Branch_Taken to 0
    HALTED=0;
end

    // ********************  INSTRUCTION FETCH STAGE  ********************
    always @(negedge clk) begin
        if(!HALTED) begin
        // Fetch the instruction from memory at the new PC address
                IR  <= { mem.memory[PC + 3],   // Most significant byte (MSB)
                         mem.memory[PC + 2], 
                         mem.memory[PC + 1], 
                         mem.memory[PC] };    // Least significant byte (LSB)
        
        PC <= nextPC;
        end

    end


endmodule