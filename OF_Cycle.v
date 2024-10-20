module OF_stage(
    input clk,
    input [9:0] Input_OF_PC,
    input [31:0] Input_OF_IR,
    input isStore,
    input isReturn,
    input isImmendiate,
    output reg [9:0] output_OF_PC,
    output [31:0] branchTarget,
    input  [31:0] Operand_A,
    input  [31:0] Operand_B,
    output [31:0] Operand_2,
    output reg [31:0 ] output_OF_IR,
    output [3:0] isStore_result,
    output [3:0] isReturn_result
);

    reg[3:0] rd;
    reg[3:0] rs1;
    reg[3:0] rs2;
    reg[3:0] ra = 4'b1111;
    reg[17:0] immediateVlaue;
    // wire [31:0] opA;
    // wire [31:0] opB;
    reg reset;
    
    mux2x1_4bit isStore_mux(
        .output_y(isStore_result),          // MUX output: the next value of the PC
        .input0(rs2),            // Normal PC increment
        .input1(rd),              // Branch target address
        .selectLine(isStore)    // Selection signal: branch taken or not
    );

    mux2x1_4bit isRet_Mux(
        .output_y(isReturn_result),          // MUX output: the next value of the PC
        .input0(rs1),            // Normal PC increment
        .input1(ra),              // Branch target address
        .selectLine(isReturn)    // Selection signal: branch taken or not
    );

    // registerFile r_File(
    // .clk(clk),
    // .rdData1(Operand_A),
    // .rdData2(Operand_B),
    // .op1(rs1),
    // .op2(rs2),
    // .reset(reset)

    // );


    always @(*) begin
            // $display("PC : %d OF_IR  %h ",Input_OF_PC,Input_OF_IR);
            rd  <= Input_OF_IR[25:22];
            rs1 <= Input_OF_IR[21:18];
            rs2 <= Input_OF_IR[17:14];
            immediateVlaue <=Input_OF_IR[17:0];
            output_OF_PC <= Input_OF_PC;
            output_OF_IR <= Input_OF_IR;
            // #2
            // $display("PC %d ,rs1 : %d rs2  %d s %D r  %D",Input_OF_PC,rs1,rs2,isStore,isReturn);
            // /$display("rs1 value: %d rs2 value %d ",Operand_A,Operand_B);  
    end




endmodule
