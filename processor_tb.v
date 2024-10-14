`timescale 1ns / 1ps

module testbench;

    reg clk;                           // Clock signal
    reg reset;                         // Reset signal
    reg [7:0] memory [0:1023];        // Memory for loading instructions
    integer i;                         // Loop variable for loading instructions
    integer fd;                        // File descriptor for reading the hex file
    reg [31:0] instruction;            // Variable to hold each instruction

    // Instantiate the pipeline_RISCV module
    pipeline_RISCV uut (
        .clk(clk)
    );

    // Generate a clock signal
    initial begin
        clk = 0;                       // Initialize clock to 0
        forever #5 clk = ~clk;         // Toggle clock every 5 ns
    end

    // Load instructions from .hex file into memory
    initial begin
        // Initialize reset signal
        reset = 1;                     // Assert reset
        #10 reset = 0;                 // Release reset after 10 ns

        // Open the .hex file for reading
        fd = $fopen("instructions.hex", "r");
        if (fd == 0) begin
            $display("Error: Could not open instructions.hex");
            $finish;
        end

        // Load instructions from the hex file
        for (i = 0; i < 12; i = i + 1) begin
            // Read a 32-bit instruction as a hex value
            if ($fscanf(fd, "%h\n", instruction) == 1) begin
                // Store each byte in little-endian format
                memory[i*4]     = instruction[7:0];   // Least significant byte
                memory[i*4 + 1] = instruction[15:8];  // Second byte
                memory[i*4 + 2] = instruction[23:16]; // Third byte
                memory[i*4 + 3] = instruction[31:24]; // Most significant byte
                $display(" Index %d: Insruction hexadeimal format is: %h  ",i,{memory[i*4 + 3],memory[i*4 + 2],memory[i*4 + 1],memory[i*4]});
                $display(" Index %d: Insruction hexadeimal format is: %b",i,{memory[i*4 + 3],memory[i*4 + 2],memory[i*4 + 1],memory[i*4]});
            end else begin
                $display("Error: Not enough instructions in instructions.hex");
                // break;
            end
        end
        $fclose(fd); // Close the file after loading
    end

    
    // Simulate for a specific duration and then finish
    initial begin
        #2000;                          // Run simulation for 2000 ns
        $finish;                        // End simulation
    end

endmodule
