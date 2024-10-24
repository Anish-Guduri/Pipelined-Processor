module EX_MA_Latch(
    input clk,
    input [31:0] output_EX_PC,
    input [31:0] ALU_Result,
    input [31:0] EX_op2,
    input [31:0] output_EX_IR,
    input [21:0] output_EX_controlBus,
    output reg [31:0] input_MA_PC,
    output reg [31:0] input_MA_ALU_Result,
    output reg [31:0  ] input_MA_op2,
    output reg [31:0] input_MA_IR,
    output reg [21:0] input_MA_controlBus

);

    always @(negedge clk) begin
        
        input_MA_PC <= output_EX_PC;
        input_MA_ALU_Result <= ALU_Result;
        input_MA_op2 <= EX_op2;
        input_MA_IR <= output_EX_IR;
        input_MA_controlBus <= output_EX_controlBus;

    end

endmodule