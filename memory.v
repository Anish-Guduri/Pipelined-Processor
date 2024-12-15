module memory(
    input clk,
    input reset,
    output reg [31:0] readData,    // 32-bit instruction output
    input [31:0] address,              // 10-bit memory address
    input writeEnable,                // Write enable signal
    input [31:0] writeData            // 32-bit data to be written to memory
);
    reg [7:0] memory[0:536870912];         // Byte-addressable memory (1024 bytes)
    integer i;
    reg [32:0] k;
    // Always read from memory
    // $display("Address: %b and value write Data:%b " ,address, writeData);

    always @(address) begin
        readData    = { memory[address + 3],    // MSB
                         memory[address + 2], 
                         memory[address + 1], 
                         memory[address] };      // LSB
        // $display("address %d : ReadData:%d", address, readData ); 
    end

    // Perform write operation whenever writeEnable is high
    // negedge clk
    always @(negedge clk) begin
        if (writeEnable) begin
            // $display("WriteEnable %b , writeData %d address %h" ,writeEnable ,writeData , address); 
            memory[address]     = writeData[7:0];     // Write LSB to memory[address]
            memory[address + 1] = writeData[15:8];    // Write next byte
            memory[address + 2] = writeData[23:16];   // Write next byte
            memory[address + 3] = writeData[31:24];   // Write MSB
            // #1
            // $display("address %d   | memory value: %d", address,{memory[address + 3],memory[address + 2],memory[address + 1], memory[address] }); 
            // $display("Instruction: writeData:%h",memory[7:0]);
        end
    end
    always @(posedge reset) begin
        // #200
        i=0;
        k=0;
        while(i<4000) begin
            // memory[i] <= i;

             // Store in little-endian format (LSB first)
        memory[i]     = k[7:0];         // Least significant byte
        memory[i+1]   = k[15:8];        // Next byte
        memory[i+2]   = k[23:16];       // Next byte
        memory[i+3]   = k[31:24];       // Most significant byte
            // k=k+32'b1;
            i=i+4;  
        // $display("i:%d  | k : %d ", i,k);    
        end

    end
endmodule
































// // module memory(
// //     output reg [31:0] instruction,    // 32-bit instruction output
// //     input clk,                        // Clock signal
// //     input [9:0] address,              // 10-bit memory address
// //     input writeEnable,                // Write enable signal
// //     input [31:0] writeData            // 32-bit data to be written to memory
// // );
// //     reg [7:0] memory[0:1023];         // Byte-addressable memory (1024 bytes)

// //     // Always read from memory, regardless of the writeEnable signal
// //     always @(*) begin
// //         instruction <= { memory[address + 3],    // MSB
// //                          memory[address + 2], 
// //                          memory[address + 1], 
// //                          memory[address] };      // LSB
// //     end

// //     // Write to memory on the negative edge of the clock when writeEnable is 1
// //     always @(negedge clk) begin
// //         if (writeEnable) begin
// //             memory[address]     <= writeData[7:0];     // Write LSB to memory[address]
// //             memory[address + 1] <= writeData[15:8];    // Write next byte
// //             memory[address + 2] <= writeData[23:16];   // Write next byte
// //             memory[address + 3] <= writeData[31:24];   // Write MSB
// //         end
// //     end
// // endmodule

// // module memory(instruction ,address,clk,writeEnable,writeData);
// // output reg [31:0] instruction;
// // input clk;
// // input [9:0] address;
// // input writeEnable;               // Control signal to enable writing
// // input [31:0] writeData;          // Data to be written to memory
// // reg[7:0] memory[0:1023];

// // always @(negedge clk) begin
// //     // If writeEnable is high, perform a write operation
// //     if (writeEnable) begin
// //         memory[address]     <= writeData[7:0];    // Write LSB to memory[address]
// //         memory[address + 1] <= writeData[15:8];   // Write next byte
// //         memory[address + 2] <= writeData[23:16];  // Write next byte
// //         memory[address + 3] <= writeData[31:24];  // Write MSB
// //     end
    
// //     else begin
// //         // Read 32-bit instruction in little-endian format
// //         instruction <= { memory[address + 3],   // Most significant byte (MSB)
// //                          memory[address + 2], 
// //                          memory[address + 1], 
// //                          memory[address] };    // Least significant byte (LSB)
// //     end
// // end
// // endmodule




// module memory(
//     input clk,
//     input reset,
//     output reg [31:0] readData,     // 32-bit instruction output
//     input [31:0] address,           // Memory address
//     input writeEnable,              // Write enable signal
//     input [31:0] writeData          // 32-bit data to be written to memory
// );
//     reg [7:0] memory[0:524287];     // 512 KB of memory, byte-addressable
//     integer i;

//     // Asynchronous read block
//     always @(*) begin
//         readData = { memory[address + 3],    // MSB
//                      memory[address + 2], 
//                      memory[address + 1], 
//                      memory[address] };      // LSB
//     end

//     // Write on negative clock edge
//     always @(negedge clk) begin
//         if (writeEnable) begin
//             memory[address]     <= writeData[7:0];     // Write LSB to memory[address]
//             memory[address + 1] <= writeData[15:8];    // Write next byte
//             memory[address + 2] <= writeData[23:16];   // Write next byte
//             memory[address + 3] <= writeData[31:24];   // Write MSB
//         end
//     end

//     // Synchronous reset on positive clock edge
//     // always @(posedge reset) begin
//     //     for (i = 0; i < 524288; i = i + 1) begin
//     //         memory[i] <= 0;
//     //     end
//     // end
// endmodule
