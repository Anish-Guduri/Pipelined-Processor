// 2x1 MUX: Selects between two 32-bit inputs
module mux2x1(output reg [9:0] output_y, input [9:0] input0, input [9:0] input1, input selectLine);
    always @(*) begin
        if (selectLine) begin
            output_y = input1;    // Select in1 (branchPC) if branch is taken
            //  $display("mux 1");
        end else begin
            output_y = input0;    // Select in0 (PC + 4) if branch is not taken
            // $display("mux 0");
    end
    // $display("nextPC is %d %d %d %d" ,input0, input1 , selectLine, output_y);
    end
endmodule

// module flexible_mux #(parameter WIDTH = 32) (
//     input [WIDTH-1:0] data_in0,  // Input 0
//     input [WIDTH-1:0] data_in1,  // Input 1
//     input [WIDTH-1:0] data_in2,  // Input 2
//     input [WIDTH-1:0] data_in3,  // Input 3
//     input [1:0] select,          // 2-bit select line
//     output reg [WIDTH-1:0] data_out // Output
// );

//     always @(*) begin
//         case (select)
//             2'b00: data_out = data_in0;
//             2'b01: data_out = data_in1;
//             2'b10: data_out = data_in2;
//             2'b11: data_out = data_in3;
//             default: data_out = {WIDTH{1'b0}}; // Default to 0
//         endcase
//     end
// endmodule
