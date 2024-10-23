module Branch_unit(

    input [31:0] EX_branchTarget,
    input [31:0] Operand_EX_A,
    // input [31:0] input_EX_IR,
    input [1:0] flags,
    input [21:0] Input_EX_controlBus,
    output [31:0] EX_branchPC,
    output reg EX_is_Branch_Taken

);
    reg isRet, isBeq, isBgt, isUbranch;

    mux_2x1 #(.regSize(32)) isReturn_mux (
        .output_y(EX_branchPC),          // MUX output: the next value of the PC
        .input0(EX_branchTarget),            // Normal PC increment
        .input1(Operand_EX_A),              // Branch target address
        .selectLine(isRet)    // Selection signal: branch taken or not
    );


    always @(*) begin
        isRet <= Input_EX_controlBus[4];
        isBeq <= Input_EX_controlBus[2];
        isBgt <= Input_EX_controlBus[3];
        isUbranch <= Input_EX_controlBus[7];

        // $display("branchPC: %h", EX_branchPC);
        EX_is_Branch_Taken <= ((isBeq && flags[0]) || (isBgt && flags[1]) || (isUbranch));
        // #2
        // $display("is_Branch_Taken: %b  | flags:%b | is Beq: %b | contrlBus %b  | 19bit %b", EX_is_Branch_Taken,flags, isBeq, Input_EX_controlBus ,Input_EX_controlBus[19] );
    end

endmodule