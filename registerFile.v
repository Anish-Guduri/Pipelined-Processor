// 32 x 32 Register File

module registerFile(rdData1,rdData2,wrData,op1,op2,dReg, writeEnable,reset,clk,output_register_file);
input clk, writeEnable, reset;
input [3:0] op1;
input [3:0] op2; 
input [3:0] dReg;
input[31:0] wrData;
output reg[31:0] rdData1;
output reg[31:0] rdData2;
output reg [31:0] output_register_file;

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
always @(*) begin
    // 
 if(reset) begin
    // $display("Hello World reset value: %d",reset);
    for(k=0;k<16;k=k+1) begin

         registerfile[k]<=32'b0;

    end
 end
 else begin
    // $display("Registerfile WriteEnable %b  | r14 %b  | r15 %b", writeEnable ,registerfile[14],registerfile[15] );
    if(writeEnable && (dReg != 4'b1110) && (dReg != 4'b1111)) begin
        registerfile[dReg]<=wrData;
        // $display("Hello WOrld Registerfile");
    end
    output_register_file <= registerfile[dReg];
    // $display("Hello WOrld Registerfile  %d   %d" , registerfile[dReg],output_register_file);

    
 end

end
endmodule