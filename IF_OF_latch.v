module IF_OF_Latch(
    input clk,
    input [31:0] output_IF_PC,
    input [31:0] IF_instruction,
    output  reg[31:0] Input_OF_PC,
    output reg [31:0] OF_instruction
);

always @(negedge clk) begin
    Input_OF_PC <= output_IF_PC;
    OF_instruction <= IF_instruction;
end

endmodule