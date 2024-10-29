module IF_cycle(
    input clk,                       // Clock signal
    input reset,                     // Reset signal
    input [31:0] inputPC,                  // Program Counter (changed to input)
    input is_Branch_Taken,           // Branch taken signal
    input [31:0] branchPC,            // Branch target address
    input isDataInterLock,
    output [31:0] IR,             // Instruction Register
    output reg [31:0] outputPC          // Next Program Counter
);

    wire [31:0] mux_nextPC;           // Internal wire to hold the output of MUX
    reg [31:0] PC;

    // MUX instantiation
    mux_2x1 #(.regSize(32))  pc_mux(
        .output_y(mux_nextPC),          // MUX output: the next value of the PC
        .input0(PC +32'b100),            // Normal PC increment
        .input1(branchPC),              // Branch target address
        .selectLine(is_Branch_Taken)    // Selection signal: branch taken or not
    );

    // Memory signals and instantiation
    wire [31:0] instruction;           // Wire to hold the fetched instruction
    reg [31:0] address;                 // Memory address

    // Instruction memory instantiation
    InstructionMemory iMemory(
        .address(address),
        .instruction(IR)
    );

    // ********************  INSTRUCTION FETCH STAGE  ********************
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            // address <= 10'b0;            // Reset memory address
            PC <= 32'b0;
            // #2
            // $display("Resetting everything");
        end 
        else begin
            // #4
            // $display("PC: %d  %h",PC, IR);
            if(isDataInterLock  == 1'b0) begin
                // $display("PC: %d  %h",PC, IR);
                address <= PC;        // Set address based on mux output;
                outputPC<=PC;
                PC <=  mux_nextPC;  // Increment PC
            end
            
     
        end
    end
endmodule
