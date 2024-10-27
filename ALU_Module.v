module ALU_Module(
    input [31:0] Operand_EX_A,
    input [31:0] Operand_EX_B,
    input [21:9] ALU_Signals,
    output reg [1:0] flags,         // Adjusted to reg
    output reg [31:0] EX_ALU_Result  // Changed to reg for output
);

// Internal signal declarations
reg isAdd, isSub, isCmp, isMul, isDiv, isMod, isLsl, isLsr, isAsr, isOr, isAnd, isNot, isMov;

always @(*) begin
    // Assigning control signals
    isAdd  = ALU_Signals[9];   
    isSub  = ALU_Signals[10];  
    isCmp  = ALU_Signals[11];  
    isMul  = ALU_Signals[12];  
    isDiv  = ALU_Signals[13];  
    isMod  = ALU_Signals[14];  
    isLsl  = ALU_Signals[15];  
    isLsr  = ALU_Signals[16];  
    isAsr  = ALU_Signals[17];  
    isOr   = ALU_Signals[18];  
    isAnd  = ALU_Signals[19];  
    isNot  = ALU_Signals[20];  
    isMov  = ALU_Signals[21];  

    // Initialize outputs to default
    EX_ALU_Result = 32'b0; 
    // flags; // Clear flags at the start of the operation

    // ALU operations based on control signals
    if (isAdd) begin
        EX_ALU_Result = Operand_EX_A + Operand_EX_B; // Add
    end
    else if (isSub) begin
        EX_ALU_Result = Operand_EX_A - Operand_EX_B; // Subtract
    end
    else if (isCmp) begin
        EX_ALU_Result = Operand_EX_A - Operand_EX_B; // Comparison
        flags[0] = (EX_ALU_Result == 0) ? 1'b1 :flags[0] ; // Zero flag
        flags[1] = (EX_ALU_Result > 0) ? 1'b1 :flags[1];  // Positive flag
    end
    else if (isMul) begin
        EX_ALU_Result = Operand_EX_A * Operand_EX_B; // Multiply
    end
    else if (isDiv) begin
        EX_ALU_Result = Operand_EX_A / Operand_EX_B; // Divide
    end
    else if (isMod) begin
        EX_ALU_Result = Operand_EX_A % Operand_EX_B; // Modulus
    end
    else if (isLsl) begin
        EX_ALU_Result = Operand_EX_A << Operand_EX_B; // Logical Shift Left
    end
    else if (isLsr) begin
        EX_ALU_Result = Operand_EX_A >> Operand_EX_B; // Logical Shift Right
    end
    else if (isAsr) begin
        EX_ALU_Result = Operand_EX_A >>> Operand_EX_B; // Arithmetic Shift Right
    end
    else if (isOr) begin
        EX_ALU_Result = Operand_EX_A | Operand_EX_B;  // Bitwise OR
    end 
    else if (isAnd) begin
        EX_ALU_Result = Operand_EX_A & Operand_EX_B;  // Bitwise AND
    end
    else if (isNot) begin
        EX_ALU_Result = ~Operand_EX_A;                // Bitwise NOT
    end
    else if (isMov) begin
        EX_ALU_Result = Operand_EX_B;                 // Move operation
    end
    // else begin
    //     EX_ALU_Result = 32'b0; // Default case for invalid operations
    // end
end

endmodule



// module ALU_Module(
//     input [31:0] Operand_EX_A,
//     input [31:0] Operand_EX_B,
//     input [21:9] ALU_Signals,
//     output [1:0] flags,
//     output [31:0] EX_ALU_Result
// );
// reg isAdd, isSub, isCmp,isMul, isDiv, isMod, isLsl, isLsr, isAsr, isOr, isAnd, isNot, isMov;

// // initial begin

// //     EX_ALU_Result <=32'b0;
// //     flags <=2'b0;
    
// // end


// always@(*) begin
//     isAdd  <= ALU_Signals[9];                                   // Assign isAdd to bit 9 of ALU_Signals
//     isSub  <= ALU_Signals[10];                                  // Assign isSub to bit 10 of ALU_Signals
//     isCmp  <= ALU_Signals[11];                                  // Assign isCmp to bit 11 of ALU_Signals
//     isMul  <= ALU_Signals[12];                                  // Assign isMul to bit 12 of ALU_Signals
//     isDiv  <= ALU_Signals[13];                                  // Assign isDiv to bit 13 of ALU_Signals
//     isMod  <= ALU_Signals[14];                                  // Assign isMod to bit 14 of ALU_Signals
//     isLsl  <= ALU_Signals[15];                                  // Assign isLsl to bit 15 of ALU_Signals
//     isLsr  <= ALU_Signals[16];                                  // Assign isLsr to bit 16 of ALU_Signals
//     isAsr  <= ALU_Signals[17];                                  // Assign isAsr to bit 17 of ALU_Signals
//     isOr   <= ALU_Signals[18];                                  // Assign isOr to bit 18 of ALU_Signals
//     isAnd  <= ALU_Signals[19];                                  // Assign isAnd to bit 19 of ALU_Signals
//     isNot  <= ALU_Signals[20];                                  // Assign isNot to bit 20 of ALU_Signals
//     isMov  <= ALU_Signals[21];                                  // Assign isMov to bit 21 of ALU_Signals
        


//     // Initialize default outputs


//         // ALU operations based on control signals
//         case (1'b1) // Match on which control signal is active
//             isAdd: begin
//                 EX_ALU_Result = Operand_EX_A + Operand_EX_B; // Add
//             end
//             isSub: begin
//                 EX_ALU_Result = Operand_EX_A - Operand_EX_B; // Subtract
//             end
//             isCmp: begin
//                 EX_ALU_Result = Operand_EX_A - Operand_EX_B;
//                 flags[0] = (EX_ALU_Result == 0); // Zero flag if operands are equal
//                 flags[1] = (EX_ALU_Result > 0);
//             end
//             isMul: begin
//                 EX_ALU_Result = Operand_EX_A * Operand_EX_B; // Multiply
//             end
//             isDiv: begin
//                 EX_ALU_Result = Operand_EX_A / Operand_EX_B; // Divide
//             end
//             isMod: begin
//                 EX_ALU_Result = Operand_EX_A % Operand_EX_B; // Modulus
//             end
//             isLsl: begin
//                 EX_ALU_Result = Operand_EX_A << Operand_EX_B; // Logical Shift Left
//             end
//             isLsr: begin
//                 EX_ALU_Result = Operand_EX_A >> Operand_EX_B; // Logical Shift Right
//             end
//             isAsr: begin
//                 EX_ALU_Result = Operand_EX_A >>> Operand_EX_B; // Arithmetic Shift Right
//             end
//             isOr: begin
//                 EX_ALU_Result = Operand_EX_A | Operand_EX_B;  // Bitwise OR
//             end
//             isAnd: begin
//                 EX_ALU_Result = Operand_EX_A & Operand_EX_B;  // Bitwise AND
//             end
//             isNot: begin
//                 EX_ALU_Result = ~ Operand_EX_A;            // Bitwise NOT
//             end
//             isMov: begin
//                 EX_ALU_Result = Operand_EX_B;             // Move operation
//             end
//             default: EX_ALU_Result = 32'b0; // Default case to handle invalid control signals
//         end

//     endcase
// endmodule
