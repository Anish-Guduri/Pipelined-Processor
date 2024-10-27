// // 32 x 32 Register File

// module registerFile(rdData1,rdData2,wrData,operand1,operand2,dReg, writeEnable,reset,clk,output_register_file);
// input clk, writeEnable, reset;
// input [3:0] operand1;
// input [3:0] operand2; 
// input [3:0] dReg;
// input[31:0] wrData;
// output reg[31:0] rdData1;
// output reg[31:0] rdData2;
// output reg [31:0] output_register_file;

// integer k;
// reg[31:0] registerfile[0:15];
// reg temp=32'b100;


// always @(operand1 or operand2) begin
//     rdData1 = registerfile[operand1];
//     rdData2 = registerfile[operand2];
//     // #4
//     // $display("Register File operand1 %b operand2 %b  data1 %b data 2 %b ", operand1, operand2,registerfile[operand1],registerfile[operand2]);
// end

// // assign rdData1 =registerfile[operand1];
// // assign rdData2 =registerfile[operand2];
// always @(reset)begin
//     if(reset) begin
//         for(k=0;k<16;k=k+1) begin

//         registerfile[k]<=k;

//         end
//     end
// end
// // writeEnable or wrData or dReg
// always @(writeEnable or dReg or wrData ) begin
//     // 
//     // $display("Registerfile WriteEnable %b  | r14 %b  | r15 %b", writeEnable ,registerfile[14],registerfile[15] );
//     if(writeEnable && (dReg != 4'b1110) && (dReg != 4'b1111)) begin
//         $display("Hello WOrld Registerfile %d ", dReg );
//         registerfile[dReg]<=wrData;
//         // $display("Hello WOrld Registerfile");
//     end

//     output_register_file <= registerfile[dReg];
//     // $display("Hello WOrld Registerfile  %d   %d" , registerfile[dReg],output_register_file);

    

// end
// endmodule

module registerFile(
    rdData1,
    rdData2,
    wrData,
    operand1,
    operand2,
    dReg,
    writeEnable,
    reset,
    clk,
    output_register_file
);
    input clk, writeEnable, reset;
    input [3:0] operand1;
    input [3:0] operand2;
    input [3:0] dReg;
    input [31:0] wrData;
    output reg [31:0] rdData1;
    output reg [31:0] rdData2;
    output reg [31:0] output_register_file;

    integer k;
    reg [31:0] registerfile [0:15];
    reg temp = 32'b100;

    // Asynchronous Read
    always @(*) begin
        rdData1 = registerfile[operand1];
        rdData2 = registerfile[operand2];
    end

    // Synchronous Reset and Write on Negative Edge of Clock
    always @(negedge clk) begin
        if (reset) begin
            for (k = 0; k < 16; k = k + 1) begin
                registerfile[k] <= k;
            end
        end
        else if (writeEnable && (dReg != 4'b1110) && (dReg != 4'b1111)) begin
            registerfile[dReg] <= wrData;
            $display("Write operation: Register[%d] <= %d", dReg, wrData);
        end
        output_register_file <= registerfile[dReg];
    end
endmodule
