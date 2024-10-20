module Control_Unit(
    input  [31:0] Input_OF_IR,
    output reg isSt,
    output reg isLd,
    output reg isBeq,
    output reg isBgt,
    output reg isRet,
    output reg isImmendiate,
    output reg isWb,    
    output reg isUbranch,
    output reg isCall,
    output reg isAdd,
    output reg isSub,
    output reg isCmp,
    output reg isMul,
    output reg isDiv,
    output reg isMod,
    output reg isLsl,
    output reg isLsr,
    output reg isAsr,
    output reg isOr,
    output reg isAnd,
    output reg isNot,
    output reg isMov
);

reg op1,op2,op3,op4,op5;
reg I;
    always @(Input_OF_IR) begin
        I    <=Input_OF_IR[26];
        op1  <=Input_OF_IR[27];
        op2  <=Input_OF_IR[28];
        op3  <=Input_OF_IR[29];
        op4  <=Input_OF_IR[30];
        op5  <=Input_OF_IR[31];

        isSt <= ( (~op5) & op4 & op3 & op2 & op1 );
        isLd <= ( (~op5) & op4 & op3 & op2 & (~op1) );
        isBeq <= ( op5 & (~op4) & (~op3) & (~op2) & (~op1) );
        isBgt <= ( op5 & (~op4) & (~op3) & (~op2) & op1 );
        isRet <= ( op5 & (~op4) & op3 & (~op2) & (~op1) );
        isImmendiate <= I;
        isWb <= (~( op5 |((~op5)&op3&op1&(op4 | (~op2)))  )) | ( op5 & (~op4) & (~op3) & op2 & op1 );
        isUbranch <= ( op5 & (~op4)) & (((~op3)&op2) | (op3 &(~op2)&(~op1))) ;
        isCall <= ( op5 & (~op4) & (~op3) & op2 & op1 );
        
        // ALU signals
        isAdd <= ( (~op5) & (~op4) & (~op3) & (~op2) & (~op1) ) | ( (~op5) & op4 & op3 & op2 & op1 );
        isSub <= ( (~op5) & (~op4) & (~op3) & (~op2) & op1 );
        isCmp <= ( (~op5) & (~op4) & op3 & (~op2) & op1 );
        isMul <= ( (~op5) & (~op4) & (~op3) & op2 & (~op1) );
        isDiv <= ( (~op5) & (~op4) & (~op3) & op2 & op1);
        isMod  <= ( (~op5) & (~op4) & op3 & (~op2) & (~op1) );
        isLsl <= ( (~op5) & op4 & (~op3) & op2 & (~op1) );
        isLsr <= ( (~op5) & op4 & (~op3) & op2 & op1 );
        isAsr <= ( (~op5) & op4 & op3 & (~op2) & (~op1) );
        isOr <= ( (~op5) & (~op4) & op3 & op2 & op1 );
        isAnd <= ( (~op5) & (~op4) & op3 & op2 & (~op1) );
        isNot <= ( (~op5) & op4 & (~op3) & (~op2) & (~op1) );
        isMov <= ( (~op5) & op4 & (~op3) & (~op2) & op1 );        
end

endmodule