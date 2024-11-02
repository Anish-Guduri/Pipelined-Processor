module RW_stage(
    input [31:0] input_RW_PC,
    input [31:0] input_RW_Ld_Result,
    input [31:0] input_RW_ALU_Result,
    input [31:0] input_RW_IR,
    input [21:0] input_RW_controlBus,
    output [31:0] RW_Data_value,
    output [3:0] RW_rd,
    output reg RW_isWb,
    output reg isLastInstruction

);

    reg isLd, isCall;
    reg[1:0] mux_selectLines;

    reg [3:0] rd;
    reg [3:0] ra =4'B1111;
 

    mux_3x1 isLD_or_isCall_MUX(
        .input0(input_RW_ALU_Result),
        .input1(input_RW_Ld_Result),
        .input2(input_RW_PC +32'B100),
        .selectLine(mux_selectLines),
        .output_y(RW_Data_value)
    );

        mux_2x1 #(.regSize(4)) isCall_mux (
        .output_y(RW_rd),          
        .input0(rd),            
        .input1(ra),              
        .selectLine(isCall)    
    );

    always @(*) begin
        if(input_RW_IR[31:27] == 5'b11111) begin
            $display("Last Instruction");
            isLastInstruction = 1'b1;
        end
        isLd <= input_RW_controlBus[1];
        isCall <= input_RW_controlBus[8];
        RW_isWb <= input_RW_controlBus[6];
        rd <= input_RW_IR[25:22];
        mux_selectLines <= { isCall, isLd };

    end
   

endmodule