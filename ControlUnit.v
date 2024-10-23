module Control_Unit(
    input  [31:0] Input_OF_IR,
    input reset,
    output reg[21:0] controlBus
);

reg op1,op2,op3,op4,op5;
reg I;
reg isSt;
reg isLd;
reg isBeq;
reg isBgt;
reg isRet;
reg isImmediate;
reg isWb;    
reg isUbranch;
reg isCall;
reg isAdd;
reg isSub;
reg isCmp;
reg isMul;
reg isDiv;
reg isMod;
reg isLsl;
reg isLsr;
reg isAsr;
reg isOr;
reg isAnd;
reg isNot;
reg isMov;

    always @( posedge reset) begin
        controlBus <=22'B0;
    end

    always @(*) begin
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
        isImmediate <= I;
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

        // controlBus <={isSt,isLd, isBeq, isBgt, isRet, isImmediate, isWb, isUbranch, isCall,isAdd,isSub,isCmp,isMul,isDiv,isMod,isLsl,isLsr,isAsr,isOr,isAnd,isNot,isMov};       
        controlBus <= {isMov, isNot, isAnd, isOr, isAsr, isLsr, isLsl, isMod, isDiv, isMul, isCmp, isSub, isAdd, isCall, isUbranch, isWb, isImmediate, isRet, isBgt, isBeq, isLd, isSt};

end

endmodule


// controlBus <={isSt,isLd, isBeq, isBgt, isRet, isImmediate, isWb, isUbranch, isCall,isAdd,isSub,isCmp,isMul,isDiv,isMod,isLsl,isLsr,isAsr,isOr,isAnd,isNot,isMov};       


// isSt = 0;
// isLd = 1;
// isBeq = 2;
// isBgt = 3;
// isRet = 4;
// isImmediate = 5;
// isWb = 6;    
// isUbranch = 7;
// isCall = 8;
// isAdd = 9;
// isSub = 10;
// isCmp = 11;
// isMul = 12;
// isDiv = 13;
// isMod = 14;
// isLsl = 15;
// isLsr = 16;
// isAsr = 17;
// isOr = 18;
// isAnd = 19;
// isNot = 20;
// isMov = 21;
