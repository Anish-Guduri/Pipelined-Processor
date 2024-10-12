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

module pipeline_RISCV (clk1, clk2);
input clk1, clk2;                   // TWO PHASE CLK

reg [31:0] PC, IF_ID_IR,IF_ID_NPC;
reg [31:0] ID_EX_IR,ID_EX_NPC;
reg [2:0] ID_EX_type, EX_MEM_type, MEM_WB_type;
reg[31:0] EX_MEM_IR,EX_MEM_ALUout, EX_MEM_B;
reg EX_MEM_condition;
reg[31:0] MEM_WB_IR, MEM_WB_ALUout, MEM_WB_LMD;

reg [31:0] RegFile [0:31];      // REGISTER FILE (32 X 32)
reg [31:0] Memory[0:1023];     //  MEMORY (1024 X 32)

parameter ADD =6'b000000,SUB=6'b000001,AND =6'b000010, OR=6'b000011,
SLT=6'b000100,MUL=6'b000101,HLT=6'b111111,LW=6'b001000,SW=6'b001001,ADDI=6'b001010,SUBI=6'b001011,SLTI=6'b001100,
BNEQZ=6'b001101,BEQZ=6'b001110;

parameter RR_ALU=3'b000,RM_ALU=3'b001, LOAD=3'b010, STORE=3'b011,BRANCH=3'b100,HAT=3'b101;

reg HALTED;   // SET TO TERMINATE PROGRAM AFTER (SERVES AS LAST INSTRUCTION)

reg TAKEN_BRANCH;  // TO DISABLE INSTRUCTION AFTER BRANCH

//  ********************  INSTRUCTION FETCH STAGE  ********************

always @(posedge clk1)    
if(HALTED == 0)
begin
    if(((EX_MEM_IR[31:26] == BEQZ) && (EX_MEM_condition == 1)) || 
    ((EX_MEM_IR[31:26] == BNEQZ) && (EX_MEM_condition == 0)))
        begin
                IF_ID_IR      <= #2 Memory[EX_MEM_ALUout];
                TAKEN_BRANCH  <= #2 1'b1;
                IF_ID_NPC     <= #2 EX_MEM_ALUout +1;
                PC            <= #2 EX_MEM_ALUout +1;
        end
    else
        begin
            IF_ID_IR        <= #2 Memory[PC];
            IF_ID_NPC       <= #2 PC + 1;
            PC              <= #2 PC + 1;
        end
end


endmodule