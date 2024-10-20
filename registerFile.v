// 32 x 32 Register File

module registerFile(rdData1,rdData2,wrData,op1,op2,dReg, writeEnable,reset,clk);
input clk, writeEnable, reset;
input [3:0] op1;
input [3:0] op2; 
input [3:0] dReg;
input[31:0] wrData;
output reg[31:0] rdData1;
output reg[31:0] rdData2;

integer k;
reg[31:0] registerfile[0:15];
reg temp=32'b100;

always @(*) begin
    rdData1 = registerfile[op1];
    rdData2 = registerfile[op2];
    // #4
    // $display("Register File op1 %b op2 %b  data1 %b data 2 %b ", op1, op2,registerfile[op1],registerfile[op2]);
end

// assign rdData1 =registerfile[op1];
// assign rdData2 =registerfile[op2];
always @(negedge clk or posedge reset) begin
    // 
 if(reset) begin
    // $display("Hello World reset value: %d",reset);
    for(k=0;k<16;k=k+1) begin
        //  #1
         registerfile[k]<=k;
        // temp= temp+32'b1;
        // #2
        // $display(" K: %d register value is:%b",k,registerfile[k]);
    end
 end
 else begin
    if(writeEnable && (!4'b1110) && (!4'b1111))
        registerfile[dReg]<=wrData;
 end   
end
endmodule