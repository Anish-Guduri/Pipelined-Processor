module IF_cycle(
    input clk,                       // Clock signal
    input reset,                     // Reset signal
    input [9:0] inputPC,                  // Program Counter (changed to input)
    input is_Branch_Taken,           // Branch taken signal
    input [9:0] branchPC,            // Branch target address
    output [31:0] IR,             // Instruction Register
    output reg [9:0] outputPC          // Next Program Counter
);

    wire [9:0] mux_nextPC;           // Internal wire to hold the output of MUX
    reg [9:0] PC;

    // MUX instantiation
    mux2x1 pc_mux(
        .output_y(mux_nextPC),          // MUX output: the next value of the PC
        .input0(PC +10'b0000000100),            // Normal PC increment
        .input1(branchPC),              // Branch target address
        .selectLine(is_Branch_Taken)    // Selection signal: branch taken or not
    );

    // Memory signals and instantiation
    wire [31:0] instruction;           // Wire to hold the fetched instruction
    reg [9:0] address;                 // Memory address

    // Instruction memory instantiation
    InstructionMemory iMemory(
        .address(address),
        .instruction(IR)
    );

    // ********************  INSTRUCTION FETCH STAGE  ********************
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            // address <= 10'b0;            // Reset memory address
            PC <= 10'b0;
            #2
            $display("Resetting everything");
        end 
        else begin
            #4
            address <= PC;        // Set address based on mux output;
            outputPC<=PC;
            PC <=  mux_nextPC;     // Increment PC
             $display("Instruction: %B at PC: %d",IR,outputPC);
        end
    end
endmodule
