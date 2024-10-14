// 2x1 MUX: Selects between two 32-bit inputs
module mux2x1(output reg [31:0] output_y, input [31:0] input0, input [31:0] input1, input selectLine);
    always @(*) begin
        if (selectLine)
            output_y = input0;    // Select in1 (branchPC) if branch is taken
        else
            output_y = input1;    // Select in0 (PC + 4) if branch is not taken
    end
endmodule
