module registerFile(
    rdData1,
    rdData2,
    wrData,
    operand1,
    operand2,
    dReg,
    writeEnable,
    reset,
    clk,
    output_register_file
);
    input clk, writeEnable, reset;
    input [3:0] operand1;
    input [3:0] operand2;
    input [3:0] dReg;
    input [31:0] wrData;
    output reg [31:0] rdData1;
    output reg [31:0] rdData2;
    output reg [31:0] output_register_file;

    integer k;
    reg [31:0] registerfile [0:15];
    reg temp = 32'b100;

    // Asynchronous Read
    always @(*) begin
        rdData1 = registerfile[operand1];
        rdData2 = registerfile[operand2];
    end

    // Synchronous Reset and Write on Negative Edge of Clock
    always @(negedge clk) begin
        if (reset) begin
            for (k = 0; k < 16; k = k + 1) begin
                registerfile[k] <= 32'b0;
            end
        end
        else if (writeEnable && (dReg != 4'b1110) && (dReg != 4'b1111)) begin
            registerfile[dReg] <= wrData;
            // $display("Write operation: Register[%d] <= %d", dReg, wrData);
        end
        output_register_file <= registerfile[dReg];
    end
endmodule
