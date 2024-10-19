module memory(
    input clk,
    output reg [31:0] instruction,    // 32-bit instruction output
    input [9:0] address,              // 10-bit memory address
    input writeEnable,                // Write enable signal
    input [31:0] writeData            // 32-bit data to be written to memory
);
    reg [7:0] memory[0:1023];         // Byte-addressable memory (1024 bytes)
    integer i;
    // Always read from memory
    // $display("Address: %b and value write Data:%b " ,address, writeData);

    always @(negedge clk) begin
        instruction <= { memory[address + 3],    // MSB
                         memory[address + 2], 
                         memory[address + 1], 
                         memory[address] };      // LSB
    end

    // Perform write operation whenever writeEnable is high
    always @(negedge clk) begin
        if (writeEnable) begin
            // $display("Instruction %d : writeData:%h", address, writeData ); 
            memory[address]     <= writeData[7:0];     // Write LSB to memory[address]
            memory[address + 1] <= writeData[15:8];    // Write next byte
            memory[address + 2] <= writeData[23:16];   // Write next byte
            memory[address + 3] <= writeData[31:24];   // Write MSB
            
            // $display("Instruction: writeData:%h",memory[7:0]);
        end
    end
    // initial begin
    //     #200
    //     i=0;
    //     while(i<34) begin
    //         $display(" %d, Hello Memory %h", i, memory[i]);
    //         i=i+1;      
    //     end
    // end
endmodule
































// module memory(
//     output reg [31:0] instruction,    // 32-bit instruction output
//     input clk,                        // Clock signal
//     input [9:0] address,              // 10-bit memory address
//     input writeEnable,                // Write enable signal
//     input [31:0] writeData            // 32-bit data to be written to memory
// );
//     reg [7:0] memory[0:1023];         // Byte-addressable memory (1024 bytes)

//     // Always read from memory, regardless of the writeEnable signal
//     always @(*) begin
//         instruction <= { memory[address + 3],    // MSB
//                          memory[address + 2], 
//                          memory[address + 1], 
//                          memory[address] };      // LSB
//     end

//     // Write to memory on the negative edge of the clock when writeEnable is 1
//     always @(negedge clk) begin
//         if (writeEnable) begin
//             memory[address]     <= writeData[7:0];     // Write LSB to memory[address]
//             memory[address + 1] <= writeData[15:8];    // Write next byte
//             memory[address + 2] <= writeData[23:16];   // Write next byte
//             memory[address + 3] <= writeData[31:24];   // Write MSB
//         end
//     end
// endmodule

// module memory(instruction ,address,clk,writeEnable,writeData);
// output reg [31:0] instruction;
// input clk;
// input [9:0] address;
// input writeEnable;               // Control signal to enable writing
// input [31:0] writeData;          // Data to be written to memory
// reg[7:0] memory[0:1023];

// always @(negedge clk) begin
//     // If writeEnable is high, perform a write operation
//     if (writeEnable) begin
//         memory[address]     <= writeData[7:0];    // Write LSB to memory[address]
//         memory[address + 1] <= writeData[15:8];   // Write next byte
//         memory[address + 2] <= writeData[23:16];  // Write next byte
//         memory[address + 3] <= writeData[31:24];  // Write MSB
//     end
    
//     else begin
//         // Read 32-bit instruction in little-endian format
//         instruction <= { memory[address + 3],   // Most significant byte (MSB)
//                          memory[address + 2], 
//                          memory[address + 1], 
//                          memory[address] };    // Least significant byte (LSB)
//     end
// end
// endmodule