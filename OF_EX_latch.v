module OF_EX_Latch(
input clk,
input [31:0]  output_OF_PC,
input [31:0] OF_branchTarget,
input [31:0] Operand_OF_A,
input [31:0] Operand_OF_B,
input [31:0] Operand_OF_2,
input [31:0] output_OF_IR,
input [21:0] Output_OF_controlBus,
output reg [31:0] input_EX_PC,
output reg [31:0] EX_branchTarget,
output reg [31:0] Operand_EX_A,
output reg [31:0] Operand_EX_B,
output reg [31:0] Operand_EX_2,
output reg [31:0] input_EX_IR,
output reg [21:0] Input_EX_controlBus

);

always @(negedge clk) begin
    // $display(" output_OF_PC %d  output_OF_IR %h",output_OF_PC, output_OF_IR );
    input_EX_PC <= output_OF_PC;
    EX_branchTarget <= OF_branchTarget;
    Operand_EX_A <= Operand_OF_A;
    Operand_EX_B <= Operand_OF_B;
    Operand_EX_2 <= Operand_OF_2;
    input_EX_IR <= output_OF_IR;
    Input_EX_controlBus <= Output_OF_controlBus;

end
endmodule