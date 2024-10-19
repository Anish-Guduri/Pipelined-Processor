module OF_stage(
    input clk,
    input [9:0] Input_OF_PC,
    input [31:0] Input_OF_IR,
    input isStore,
    input isReturn,
    input isImmendiate,
    output [9:0] output_OF_PC,
    output [31:0] branchTarget,
    output [31:0] Operand_A,
    output [31:0] Operand_B,
    output [31:0] Operand_2,
    output [31:0 ] output_OF_IR
);

    reg[3:0] rd;
    reg[3:0] rs1;
    reg[3:0] rs2;
    reg[3:0] ra = 4'b1111;
    reg[17:0] immediateVlaue;
    assign output_OF_PC = Input_OF_PC;
    assign output_OF_IR = Input_OF_IR;
    // registerFile r_File(
    //     .rdData1(),rdData2,wrData,op1,op2,dReg, writeEnable,reset,clk);

    always @(negedge clk) begin
        #10
        if(Input_OF_PC != 10'b0000000000) begin
            rd  <= Input_OF_IR[25:22];
            rs1 <= Input_OF_IR[21:18];
            rs2 <= Input_OF_IR[17:14];
            immediateVlaue <=Input_OF_IR[17:0];
            
            // #2

            $display("PC : %d rd: %b rs1: %b rs2: %b ",Input_OF_PC, rd,rs1,rs2);

        end
    end



endmodule
