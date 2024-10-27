module data_interlock(
    input [31:0] OF_instruction,
    input [31:0] input_EX_IR,
    input [31:0] input_MA_IR,
    input [31:0] input_RW_IR,
    output reg isDataInterLock
);
    reg [4:0] OF_opcode;
    reg [4:0] EX_opcode;
    reg [4:0] MA_opcode;
    reg [4:0] RW_opcode;

    reg is_OF_read;
    reg is_EX_write;
    reg is_MA_write;
    reg is_RW_write;

    reg [3:0] src1;
    reg [3:0] src2;
    reg [3:0] ra = 4'b1111;

    reg [3:0] EX_dest;
    reg [3:0] MA_dest;
    reg [3:0] RW_dest;
    reg OF_hasSrc1;
    reg OF_hasSrc2;

    // Separate block to calculate opcode and write/read enables
    always @(*) begin
        OF_opcode = OF_instruction[31:27];
        EX_opcode = input_EX_IR[31:27];
        MA_opcode = input_MA_IR[31:27];
        RW_opcode = input_RW_IR[31:27];

        // Calculate is_OF_read
        is_OF_read = ~((OF_opcode == 5'B01101) || (OF_opcode == 5'B10010) || 
                       (OF_opcode == 5'B10000) || (OF_opcode == 5'B10001) || 
                       (OF_opcode == 5'B10011));

        // Calculate write enable signals for each stage
        is_EX_write = ~((EX_opcode == 5'B01101) || (EX_opcode == 5'B00101) ||
                        (EX_opcode == 5'B01111) || (EX_opcode == 5'B10010) ||
                        (EX_opcode == 5'B10000) || (EX_opcode == 5'B10001) ||
                        (EX_opcode == 5'B10100));

        is_MA_write = ~((MA_opcode == 5'B01101) || (MA_opcode == 5'B00101) ||
                        (MA_opcode == 5'B01111) || (MA_opcode == 5'B10010) ||
                        (MA_opcode == 5'B10000) || (MA_opcode == 5'B10001) ||
                        (MA_opcode == 5'B10100));

        is_RW_write = ~((RW_opcode == 5'B01101) || (RW_opcode == 5'B00101) ||
                        (RW_opcode == 5'B01111) || (RW_opcode == 5'B10010) ||
                        (RW_opcode == 5'B10000) || (RW_opcode == 5'B10001) ||
                        (RW_opcode == 5'B10100));
    end

    // Main interlock detection logic
    always @(*) begin
        isDataInterLock = 1'b0;

        if (is_OF_read) begin
            // Identify sources
            src1 = OF_instruction[21:18];
            src2 = OF_instruction[17:14];
            if (OF_opcode == 5'B01111) begin
                src2 = OF_instruction[25:22];
            end
            if (OF_opcode == 5'B10100) begin
                src1 = ra;
            end

            // Determine if there are sources
            OF_hasSrc1 = 1'b1;
            if (OF_opcode == 5'B01000 || OF_opcode == 5'B01001) begin
                OF_hasSrc1 = 1'b0;
            end

            OF_hasSrc2 = 1'b1;
            if (OF_opcode != 5'B01111 && OF_instruction[26] == 1'b1) begin
                OF_hasSrc2 = 1'b0;
            end

            // Check data interlock conditions
            if (is_EX_write) begin
                EX_dest = input_EX_IR[25:22];
                if (EX_opcode == 5'B01111) begin
                    EX_dest = ra;
                end

                // Check for interlock with EX stage
                if ((OF_hasSrc1 && src1 == EX_dest) || (OF_hasSrc2 && src2 == EX_dest)) begin
                    isDataInterLock = 1'b1;
                end
            end
            if (is_MA_write) begin
                MA_dest = input_MA_IR[25:22];
                if (MA_opcode == 5'B01111) begin
                    MA_dest = ra;
                end

                // Check for interlock with EX stage
                if ((OF_hasSrc1 && src1 == MA_dest) || (OF_hasSrc2 && src2 == MA_dest)) begin
                    isDataInterLock = 1'b1;
                end
            end
            if (is_RW_write) begin
                RW_dest = input_RW_IR[25:22];
                if (RW_opcode == 5'B01111) begin
                    RW_dest = ra;
                end

                // Check for interlock with EX stage
                if ((OF_hasSrc1 && src1 == RW_dest) || (OF_hasSrc2 && src2 == RW_dest)) begin
                    isDataInterLock = 1'b1;
                end
            end
        end
    end
endmodule
