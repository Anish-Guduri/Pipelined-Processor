module mux2x1_4bit(output reg [3:0] output_y, input [3:0] input0, input [3:0] input1, input selectLine);
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