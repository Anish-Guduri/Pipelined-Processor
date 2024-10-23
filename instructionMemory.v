
module InstructionMemory(
    input [31:0] address,             // 10-bit byte memory address (byte-addressable PC)
    output reg [31:0] instruction     // 32-bit instruction output
);

    reg [7:0] instructionMemory [0:4095];  // Byte-addressable memory (4KB for 32-bit instructions)
    // reg [7:0] instructionMemory [0:4294967295];
    // Temporary variables for file handling
    integer file, readResult;
    reg [31:0] temp;  // Temporary register to hold each instruction
    integer i;        // Index variable for memory

    initial begin
        // Open the hex file for reading
        file = $fopen("instructions.hex", "r");
        if (file == 0) begin
            $display("Error: Could not open file.");
            $finish; // Stop simulation if file opening fails
        end

        // Read instructions from the file and store them in memory
        i = 0;  // Initialize index
        while (!$feof(file)) begin  // Continue until end of file
            readResult = $fscanf(file, "%h\n", temp); // Read a 32-bit hex value
            
            // Check for blank line or unsuccessful read
            if (readResult == 0 || temp === 32'hZ) begin
                // Stop reading if the line is blank
                $display("Reached a blank line or end of file at index %0d", i);
                $finish;
                
            end
            
            // Store it in little-endian format in byte-addressable memory
            instructionMemory[i*4]     = temp[7:0];    // Least significant byte (LSB)
            instructionMemory[i*4 + 1] = temp[15:8];
            instructionMemory[i*4 + 2] = temp[23:16];
            instructionMemory[i*4 + 3] = temp[31:24];  // Most significant byte (MSB)

            i = i + 1;  // Increment index
        end

        // Close the file
        $fclose(file);

        // Debug display: show the first instruction in memory
        $display("Instruction at address 0 (little-endian): %h", {instructionMemory[3], instructionMemory[2], instructionMemory[1], instructionMemory[0]});
    end

    // Fetch the 32-bit instruction by combining 4 consecutive bytes (little-endian)
    always @(address) begin
        instruction <= {instructionMemory[address + 3],      // Most significant byte (MSB)
                        instructionMemory[address + 2],      // Next byte
                        instructionMemory[address + 1],      // Next byte
                        instructionMemory[address]};         // Least significant byte (LSB)
    end

endmodule
