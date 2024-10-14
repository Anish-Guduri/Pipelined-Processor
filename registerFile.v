// 32 x 32 Register File

module registerFile(rdData1,rdData2,wrData,op1,op2,dReg, writeEnable,reset,clk);
input clk, writeEnable, reset;
input[3:0] op1, op2, dReg;
input[31:0] wrData;
output[31:0] rdData1, rdData2;

integer k;
reg[31:0] registerfile[0:15];

assign rdData1 =registerfile[op1];
assign rdData2 =registerfile[op2];

always @(negedge clk) begin
 if(reset) begin
    for(k=0;k<16;k=k+1) begin
        registerfile[k]<=32'b0;
    end
 end
 else begin
    if(writeEnable && (!4'b1110) && (!4'b1111))
        registerfile[dReg]<=wrData;
 end   
end
endmodule