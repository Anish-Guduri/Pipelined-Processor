module memory(instruction ,address,clk,writeEnable,writeData);
output reg [31:0] instruction;
input clk;
input [9:0] address;
input writeEnable;               // Control signal to enable writing
input [31:0] writeData;          // Data to be written to memory
reg[7:0] memory[0:1023];

always @(negedge clk) begin
    // If writeEnable is high, perform a write operation
    if (writeEnable) begin
        memory[address]     <= writeData[7:0];    // Write LSB to memory[address]
        memory[address + 1] <= writeData[15:8];   // Write next byte
        memory[address + 2] <= writeData[23:16];  // Write next byte
        memory[address + 3] <= writeData[31:24];  // Write MSB
    end
    
    else begin
        // Read 32-bit instruction in little-endian format
        instruction <= { memory[address + 3],   // Most significant byte (MSB)
                         memory[address + 2], 
                         memory[address + 1], 
                         memory[address] };    // Least significant byte (LSB)
    end
end
endmodule
