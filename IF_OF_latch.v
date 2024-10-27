module IF_OF_Latch(
    input clk,
    input [31:0] output_IF_PC,
    input [31:0] IF_instruction,
    input isDataInterLock,
    input isBranchInterLock,
    output  reg[31:0] Input_OF_PC,
    output reg [31:0] OF_instruction
);

always @(negedge clk) begin
    if (isDataInterLock == 1'b0) begin
        Input_OF_PC <= output_IF_PC;
        OF_instruction <= IF_instruction;
    end
    if(isBranchInterLock == 1'b1) begin
        Input_OF_PC <=32'b0;
        OF_instruction <=32'h68000000;

    end
end

endmodule