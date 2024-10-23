module OF_stage(
    input clk,
    input [31:0] Input_OF_PC,
    input [31:0] Input_OF_IR,
    input [21:0] Input_OF_controlBus,
    input [31:0] op1,
    input [31:0] op2,
    output reg [31:0] output_OF_PC,
    output [31:0] branchTarget,
    output reg [31:0] Operand_A,
    output [31:0] Operand_B,
    output reg [31:0] Operand_2,
    output reg [31:0 ] output_OF_IR,
    output [3:0] isStore_result,
    output [3:0] isReturn_result,
    output reg [21:0] Output_OF_controlBus
);

    reg[3:0] rd;
    reg[3:0] rs1;
    reg[3:0] rs2;
    reg[3:0] ra = 4'b1111;
    wire [31:0] immediateVlaue;
    reg reset;
    reg isStore;
    reg isReturn;
    reg isImmediate;
   
    
    mux_2x1 #(.regSize(4)) isStore_mux (
        .output_y(isStore_result),          // MUX output: the next value of the PC
        .input0(rs2),            // Normal PC increment
        .input1(rd),              // Branch target address
        .selectLine(isStore)    // Selection signal: branch taken or not
    );

    mux_2x1 #(.regSize(4)) isRet_Mux (
        .output_y(isReturn_result),          // MUX output: the next value of the PC
        .input0(rs1),            // Normal PC increment
        .input1(ra),              // Branch target address
        .selectLine(isReturn)    // Selection signal: branch taken or not
    );

    Calculate_Immx_BranchTarget calc_Immx_branchTarget(
        .input_OF_PC(Input_OF_PC),
        .instruction(Input_OF_IR),
        .Immx(immediateVlaue),
        .branchTarget(branchTarget)

    );

    mux_2x1 #(.regSize(32)) isImmediate_mux (
        .output_y(Operand_B),          // MUX output: the next value of the PC
        .input0(op2),            // Normal PC increment
        .input1(immediateVlaue),              // Branch target address
        .selectLine(isImmediate)    // Selection signal: branch taken or not
    );


    always @(*) begin
            // $display("PC : %d OF_IR  %h ",Input_OF_PC,Input_OF_IR);
            rd  <= Input_OF_IR[25:22];
            rs1 <= Input_OF_IR[21:18];
            rs2 <= Input_OF_IR[17:14];
            // #2
            isStore <= Input_OF_controlBus[0];
            isReturn <= Input_OF_controlBus[4];
            isImmediate <= Input_OF_controlBus[5];

            // immediateVlaue <=Input_OF_IR[17:0];
            output_OF_PC <= Input_OF_PC;
            output_OF_IR <= Input_OF_IR;
            Operand_2 <= op2;
            Operand_A <= op1;
            Output_OF_controlBus <= Input_OF_controlBus;



            // $display(" isStore  %d, isReturn  %d", isStore_result, isReturn_result);
            // $display("rs1 value: %d rs2 value %d ",Operand_A,Operand_B);  
    end




endmodule
