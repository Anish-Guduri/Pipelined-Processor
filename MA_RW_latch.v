module MA_RW_Latch(
    input clk,
    input [31:0] output_MA_PC,
    input [31:0] output_MA_ALU_Result,
    input [31:0] output_MA_IR,
    input [21:0] output_MA_controlBus,
    input [31:0] MA_Ld_Result,
    output reg [31:0] input_RW_PC,
    output reg [31:0] input_RW_Ld_Result,
    output reg [31:0] input_RW_ALU_Result,
    output reg [31:0] input_RW_IR,
    output reg [21:0] input_RW_controlBus
    
);

    always @( negedge clk) begin

        input_RW_controlBus <= output_MA_controlBus;
        input_RW_IR <= output_MA_IR;
        input_RW_Ld_Result <=MA_Ld_Result;
        input_RW_ALU_Result <=output_MA_ALU_Result;
        input_RW_PC <= output_MA_PC;
        
        
        
    end


endmodule