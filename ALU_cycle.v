module ALU_Stage(
    input [31:0] input_EX_PC,
    input [31:0] EX_branchTarget,
    input [31:0] Operand_EX_A,
    input [31:0] Operand_EX_B,
    input [31:0] Operand_EX_2,
    input [31:0] input_EX_IR,
    input [21:0] Input_EX_controlBus,
    input [31:0] RW_Data_value,
    input [3:0] RW_rd,
    input is_RW_EX_conflict_src1,
    input is_RW_EX_conflict_src2,
    input is_MA_EX_conflict_src1,
    input is_MA_EX_conflict_src2,
    input [31:0] input_MA_ALU_Result,
    output reg [31:0] output_EX_PC,
    output wire [31:0] ALU_Result,
    output reg [31:0] EX_op2,
    output reg [31:0] output_EX_IR,
    output reg [21:0] output_EX_controlBus,
    output [31:0] EX_branchPC,
    output wire EX_is_Branch_Taken


);
wire [1:0] flags;
wire [31:0] ALU_Operand_A;
wire [31:0] ALU_Operand_B;
wire [31:0] ALU_Operand_2;

mux_3x1 #(.regSize(32)) is_RW_EX_forwarding_src1(
        .output_y(ALU_Operand_A),          
        .input0(Operand_EX_A),            
        .input1(RW_Data_value),
        .input2(input_MA_ALU_Result),                
        .selectLine({ is_MA_EX_conflict_src1 , is_RW_EX_conflict_src1}) 
    );
    
    

mux_3x1 #(.regSize(32)) is_RW_EX_forwarding_src2(
        .output_y(ALU_Operand_B),          
        .input0(Operand_EX_B),            
        .input1(RW_Data_value),
        .input2(input_MA_ALU_Result),                
        .selectLine({ is_MA_EX_conflict_src2 , is_RW_EX_conflict_src2}) 
    );

mux_2x1 #(.regSize(32)) is_RW_EX_OP2_forwarding_src2(
        .output_y(ALU_Operand_2),          
        .input0(Operand_EX_2),            
        .input1(RW_Data_value),              
        .selectLine(is_RW_EX_conflict_src2)
    );

Branch_unit branchUnit(
    .EX_branchTarget(EX_branchTarget),
    .Operand_EX_A(ALU_Operand_A),
    .flags(flags),
    .Input_EX_controlBus(Input_EX_controlBus),
    .EX_branchPC(EX_branchPC),
    .EX_is_Branch_Taken(EX_is_Branch_Taken)

);



ALU_Module ALU_module(
    .Operand_EX_A(ALU_Operand_A),
    .Operand_EX_B(ALU_Operand_B),
    .ALU_Signals(Input_EX_controlBus[21:9]),
    // .isCmp(Input_EX_controlBus[11]),
    .flags(flags),
    .EX_ALU_Result(ALU_Result)
);

always @(*) begin
    output_EX_PC <= input_EX_PC;
    output_EX_IR <= input_EX_IR;
    output_EX_controlBus <= Input_EX_controlBus;
    EX_op2 <=ALU_Operand_2;
    

end



endmodule