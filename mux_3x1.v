module mux_3x1 #(parameter regSize = 32) (
    output reg [regSize-1:0] output_y, 
    input [regSize-1:0] input0, 
    input [regSize-1:0] input1, 
    input [regSize-1:0] input2,
    input [1:0] selectLine  // 2-bit select line
);
    always @(*) begin
        case (selectLine)
            2'b00: output_y = input0;   // Select input0
            2'b01: output_y = input1;   // Select input1
            2'b10: output_y = input2;   // Select input2
        endcase
        // $display("Selected input: %d, Output: %d", selectLine, output_y);
    end
endmodule








// module mux_4x2 #(parameter regSize = 4)(output reg [regSize-1:0] output_y, input [regSize-1:0] input0, input [regSize-1:0] input1,in input selectLine);
//     always @(*) begin
//         if (selectLine) begin
//             output_y = input1;    // Select in1 (branchPC) if branch is taken
//             //  $display("mux 1");
//         end else begin
//             output_y = input0;    // Select in0 (PC + 4) if branch is not taken
//             // $display("mux 0");
//     end
//     // $display("nextPC is %d %d %d %d" ,input0, input1 , selectLine, output_y);
//     end
// endmodule