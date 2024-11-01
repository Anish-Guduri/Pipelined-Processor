module forwarding_unit_src2(
    input [31:0] input_OF_IR,
    input [31:0] input_EX_IR,
    input [31:0] input_MA_IR,
    input [31:0] input_RW_IR,
    output reg is_RW_OF_conflict_src2,
    output reg is_RW_EX_conflict_src2,
    output reg is_RW_MA_conflict_src2,
    output reg is_MA_EX_conflict_src2
);
    reg [4:0] OF_opcode;
    reg [4:0] EX_opcode;
    reg [4:0] MA_opcode;
    reg [4:0] RW_opcode;

    reg is_RW_B_conflict;
    reg is_MA_B_conflict;
    reg [3:0] RW_dest;
    reg [3:0] MA_dest;
    reg [3:0] OF_src2;
    reg [3:0] MA_src2;
    reg [3:0] EX_src2;
    reg RW_OF_hasSrc2;
    reg RW_EX_hasSrc2;
    reg RW_MA_hasSrc2;
    reg MA_EX_hasSrc2;



    reg [3:0] ra = 4'b1111;

    reg first_Done = 0;

    always @(input_OF_IR or input_EX_IR or input_MA_IR or input_RW_IR) begin
        OF_opcode = input_OF_IR[31:27];
        EX_opcode = input_EX_IR[31:27];
        MA_opcode = input_MA_IR[31:27];
        RW_opcode = input_RW_IR[31:27];
        is_RW_B_conflict =0;
        is_MA_B_conflict =0;
        is_RW_OF_conflict_src2 = 0;
        is_RW_EX_conflict_src2 = 0;
        is_RW_MA_conflict_src2 = 0;
        is_MA_EX_conflict_src2 = 0;
        // Check for B conflicts
        // is_RW_B_conflict = ~((RW_opcode == 5'b01101) || (RW_opcode == 5'b00101) ||
        //                   (RW_opcode == 5'b01111) || (RW_opcode == 5'b10010) ||
        //                   (RW_opcode == 5'b10000) || (RW_opcode == 5'b10001) ||
        //                   (RW_opcode == 5'b10100));

     is_RW_B_conflict =((RW_opcode == 5'b01101) || (RW_opcode == 5'b00101) || 
                        (RW_opcode == 5'b01111) || (RW_opcode == 5'b10010) || 
                        (RW_opcode == 5'b10000) || (RW_opcode == 5'b10001) || 
                        (RW_opcode == 5'b10100));
            
        //     disable conflict_block;
        // end
        is_MA_B_conflict = ~((MA_opcode == 5'b01101) || (MA_opcode == 5'b00101) ||
                          (MA_opcode == 5'b01111) || (MA_opcode == 5'b10010) ||
                          (MA_opcode == 5'b10000) || (MA_opcode == 5'b10001) ||
                          (MA_opcode == 5'b10100));

        is_RW_OF_conflict_src2 = ~((OF_opcode == 5'b01101) || (OF_opcode == 5'b10010) || 
                              (OF_opcode == 5'b10000) || (OF_opcode == 5'b10001) || 
                              (OF_opcode == 5'b10011) );

        is_RW_EX_conflict_src2 = ~((EX_opcode == 5'b01101) || (EX_opcode == 5'b10010) || 
                              (EX_opcode == 5'b10000) || (EX_opcode == 5'b10001) || 
                              (EX_opcode == 5'b10011));

        is_RW_MA_conflict_src2 = ~((MA_opcode == 5'b01101) || (MA_opcode == 5'b10010) || 
                              (MA_opcode == 5'b10000) || (MA_opcode == 5'b10001) || 
                              (MA_opcode == 5'b10011) );
        
        is_MA_EX_conflict_src2 = ~((EX_opcode == 5'b01101) || (EX_opcode == 5'b10010) || 
                              (EX_opcode == 5'b10000) || (EX_opcode == 5'b10001) || 
                              (EX_opcode == 5'b10011));
        first_Done =1;
     end
    always @(input_OF_IR or input_EX_IR or input_MA_IR or input_RW_IR) begin :conflict_block
        if(first_Done) begin
        
        if (OF_opcode != 5'B01111 && input_OF_IR[26] == 1'b1) begin
               RW_OF_hasSrc2 = 1'b0;
            end
        if (EX_opcode != 5'B01111 && input_EX_IR[26] == 1'b1) begin
               RW_EX_hasSrc2 = 1'b0;
            end
        if (MA_opcode != 5'B01111 && input_MA_IR[26] == 1'b1) begin
               RW_MA_hasSrc2 = 1'b0;
            end
        if (is_RW_B_conflict == 1 ) begin

         $display("Hello RW iR  %b | %B | %B | %B | %B" , is_RW_B_conflict, OF_opcode,EX_opcode,MA_opcode,RW_opcode);

            OF_src2 = input_OF_IR[17:14];
            EX_src2 = input_EX_IR[17:14];
            MA_src2 = input_MA_IR[17:14];
            RW_dest = input_RW_IR[25:22];

            // Update based on special opcode cases
            if (OF_opcode == 5'b10100) OF_src2 = input_OF_IR[25:22];
            if (EX_opcode == 5'b10100) EX_src2 = input_EX_IR[25:22];
            if (MA_opcode == 5'b10100) MA_src2 = input_MA_IR[25:22];
            if (RW_opcode == 5'b10011) RW_dest = ra;



            // RW to OF forwarding
            if (is_RW_OF_conflict_src2 && RW_OF_hasSrc2 && (OF_src2 == RW_dest)) begin
                is_RW_OF_conflict_src2 = 1;
            end else begin
                is_RW_OF_conflict_src2 = 0;
            end

            // RW to EX forwarding
            if (is_RW_EX_conflict_src2 && RW_EX_hasSrc2 && (EX_src2 == RW_dest)) begin
                is_RW_EX_conflict_src2 = 1;
            end else begin
                is_RW_EX_conflict_src2 = 0;
            end

            // RW to MA forwarding
            if (is_RW_MA_conflict_src2 && RW_MA_hasSrc2 && (MA_src2 == RW_dest)) begin
                is_RW_MA_conflict_src2 = 1;
            end else begin
                is_RW_MA_conflict_src2 = 0;
            end
        end


        if( is_MA_B_conflict) begin
            // $display("Hello RW iR  %b %H %H" , is_MA_B_conflict, input_EX_IR,input_MA_IR);
            EX_src2 = input_EX_IR[21:18];
            MA_dest = input_MA_IR[25:22];

            if (EX_opcode == 5'b10100) EX_src2 = input_EX_IR[25:22];
            if (MA_opcode == 5'b10011) MA_dest = ra;

            
            if (is_MA_EX_conflict_src2 && (EX_src2 == MA_dest)) begin
                
                is_MA_EX_conflict_src2 = 1;

            end else begin

                is_MA_EX_conflict_src2 = 0;
            end

        end
        end
    end

endmodule