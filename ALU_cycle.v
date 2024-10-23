module ALU_Stage(
    input [31:0] input_EX_PC,
    input [31:0] EX_branchTarget,
    input [31:0] Operand_EX_A,
    input [31:0] Operand_EX_B,
    input [31:0] Operand_EX_2,
    input [31:0] input_EX_IR,
    input [21:0] Input_EX_controlBus,
    output reg [31:0] output_EX_PC,
    output wire [31:0] ALU_Result,
    output reg [31:0] EX_op2,
    output reg [31:0] output_EX_IR,
    output reg [21:0] output_EX_controlBus,
    output [31:0] EX_branchPC,
    output wire EX_is_Branch_Taken


);
wire [1:0] flags;

Branch_unit branchUnit(
    .EX_branchTarget(EX_branchTarget),
    .Operand_EX_A(Operand_EX_A),
    .flags(flags),
    .Input_EX_controlBus(Input_EX_controlBus),
    .EX_branchPC(EX_branchPC),
    .EX_is_Branch_Taken(EX_is_Branch_Taken)

);

ALU_Module ALU_module(
    .Operand_EX_A(Operand_EX_A),
    .Operand_EX_B(Operand_EX_B),
    .ALU_Signals(Input_EX_controlBus[21:9]),
    .flags(flags),
    .EX_ALU_Result(ALU_Result)
);

always @(*) begin
    output_EX_PC <= input_EX_PC;
    output_EX_IR <= input_EX_IR;
    output_EX_controlBus <= Input_EX_controlBus;
    EX_op2 <=Operand_EX_2;
    

end



endmodule