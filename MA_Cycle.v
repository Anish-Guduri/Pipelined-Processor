module MA_stage(
    input [31:0] input_MA_PC,
    input [31:0] input_MA_ALU_Result,
    input [31:0] input_MA_op2,
    input [31:0] input_MA_IR,
    input [21:0] input_MA_controlBus,
    output reg [31:0] output_MA_PC,
    output reg [31:0] output_MA_ALU_Result,
    output reg [31:0] output_MA_IR,
    output reg [21:0] output_MA_controlBus,
    output reg [31:0] MA_Ld_Result,
    output reg [31:0] MDR,
    output reg MA_writeEnable
);
    
    reg [31:0] MAR;
    reg isSt, isLd;

    always@(*) begin
    //    $display("Hello"); 
       MA_writeEnable <=1'b0;
       isSt <= input_MA_controlBus[0];
       isLd <= input_MA_controlBus[1];
       if( isSt) begin
           MA_writeEnable <=1'b1;
       end

       MAR <= input_MA_ALU_Result;
       MDR <= input_MA_op2;
       output_MA_PC <= input_MA_PC;
       output_MA_ALU_Result <=input_MA_ALU_Result;
       output_MA_IR <= input_MA_IR;
       output_MA_controlBus <= input_MA_controlBus;

    end
    // initial begin
    //     MA_writeEnable <=1'b0;
    //     $display("Hello"); 
    // end

endmodule