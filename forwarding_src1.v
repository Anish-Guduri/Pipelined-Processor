module forwarding_unit_src1(
    input [31:0] input_OF_IR,
    input [31:0] input_EX_IR,
    input [31:0] input_MA_IR,
    input [31:0] input_RW_IR,
    output reg is_RW_OF_conflict_src1,
    output reg is_RW_EX_conflict_src1,
    output reg is_RW_MA_conflict_src1,
    output reg is_MA_EX_conflict_src1
);

    reg [4:0] OF_opcode;
    reg [4:0] EX_opcode;
    reg [4:0] MA_opcode;
    reg [4:0] RW_opcode;

    // reg is_RW_B_conflict;
    // reg is_MA_B_conflict;
    reg [3:0] RW_dest;
    reg [3:0] MA_dest;
    reg [3:0] OF_src1;
    reg [3:0] MA_src1;
    reg [3:0] EX_src1;

    reg [3:0] ra = 4'b1111;
    // reg first_Done =0;

    // Determine opcode conflicts
    always @(*) begin
        // first_Done =0;
        OF_opcode = input_OF_IR[31:27];
        EX_opcode = input_EX_IR[31:27];
        MA_opcode = input_MA_IR[31:27];
        RW_opcode = input_RW_IR[31:27];
        // is_RW_B_conflict =0;
        // is_MA_B_conflict = 0;

        is_RW_OF_conflict_src1 = 0;
        is_RW_EX_conflict_src1 = 0;
        is_RW_MA_conflict_src1 = 0;
        is_MA_EX_conflict_src1 = 0;

        // Check for B conflicts
        if(((RW_opcode == 5'b01101) || (RW_opcode == 5'b00101) || (RW_opcode == 5'b01111) || (RW_opcode == 5'b10010) || (RW_opcode == 5'b10000) || (RW_opcode == 5'b10001) || (RW_opcode == 5'b10100)) == 0) begin

                if(((OF_opcode == 5'b01101) || (OF_opcode == 5'b10010) || 
                    (OF_opcode == 5'b10000) || (OF_opcode == 5'b10001) || 
                    (OF_opcode == 5'b10011) || (OF_opcode == 5'b01000) || 
                    (OF_opcode == 5'b01001)) == 0) begin
                        RW_dest = input_RW_IR[25:22];
                        OF_src1 = input_OF_IR[21:18];
                        if (OF_opcode == 5'b10100) OF_src1 = ra;
                        if (RW_opcode == 5'b10011) RW_dest = ra;

                        if(OF_src1 == RW_dest) begin
                            // $display("  %h | %h |  %b | %b | %b | %b", input_RW_IR, input_OF_IR ,RW_dest,OF_src1, RW_opcode , OF_opcode);
                            is_RW_OF_conflict_src1 = 1;
                        end else begin
                            is_RW_OF_conflict_src1 = 0;
                        end

                    end else begin
                        is_RW_OF_conflict_src1 = 0;
                    end

                if(((EX_opcode == 5'b01101) || (EX_opcode == 5'b10010) || 
                    (EX_opcode == 5'b10000) || (EX_opcode == 5'b10001) || 
                    (EX_opcode == 5'b10011) || (EX_opcode == 5'b01000) || 
                    (EX_opcode == 5'b01001))==0) begin
                        RW_dest = input_RW_IR[25:22];
                        EX_src1 = input_EX_IR[21:18];
                        if (EX_opcode == 5'b10100) EX_src1 = ra;
                        if (RW_opcode == 5'b10011) RW_dest = ra;

                        if(EX_src1 == RW_dest) begin
                            $display("  %h | %h |  %b | %b |", input_RW_IR, input_EX_IR ,RW_dest,EX_src1);
                            is_RW_EX_conflict_src1 = 1;
                        end else begin
                            is_RW_EX_conflict_src1 = 0;
                        end
                        
                    end else begin
                        is_RW_EX_conflict_src1 = 0;
                    end
                if(((MA_opcode == 5'b01101) || (MA_opcode == 5'b10010) || 
                    (MA_opcode == 5'b10000) || (MA_opcode == 5'b10001) || 
                    (MA_opcode == 5'b10011) || (MA_opcode == 5'b01000) || 
                    (MA_opcode == 5'b01001)) == 0) begin
                        RW_dest = input_RW_IR[25:22];
                        MA_src1 = input_MA_IR[21:18];
                        if (MA_opcode == 5'b10100) MA_src1 = ra;
                        if (RW_opcode == 5'b10011) RW_dest = ra;

                        if(MA_src1 == RW_dest) begin
                            is_RW_MA_conflict_src1 = 1;
                        end else begin
                            is_RW_MA_conflict_src1 = 0;
                        end
                    end  else begin
                        is_RW_MA_conflict_src1 = 0;
                    end 

            end else begin
                is_RW_OF_conflict_src1 = 0;
                is_RW_EX_conflict_src1 = 0;
                is_RW_MA_conflict_src1 = 0;
            end

        if(((MA_opcode == 5'b01101) || (MA_opcode == 5'b00101) ||
            (MA_opcode == 5'b01111) || (MA_opcode == 5'b10010) ||
            (MA_opcode == 5'b10000) || (MA_opcode == 5'b10001) ||
            (MA_opcode == 5'b10100))==0) begin
                
                if(((EX_opcode == 5'b01101) || (EX_opcode == 5'b10010) || 
                    (EX_opcode == 5'b10000) || (EX_opcode == 5'b10001) || 
                    (EX_opcode == 5'b10011) || (EX_opcode == 5'b01000) || 
                    (EX_opcode == 5'b01001))==0) begin
                        MA_dest = input_MA_IR[25:22];
                        EX_src1 = input_EX_IR[21:18];
                        if (EX_opcode == 5'b10100) EX_src1 = ra;
                        if (MA_opcode == 5'b10011) MA_dest = ra;
                        if(EX_src1 == MA_dest) begin
                            is_MA_EX_conflict_src1 = 1;
                        end else begin
                            is_MA_EX_conflict_src1 = 0;
                        end


                    end else begin
                        is_MA_EX_conflict_src1 = 0;
                    end

            end else begin
                is_MA_EX_conflict_src1 = 0;
            end


    end
    initial begin
                is_RW_OF_conflict_src1 = 0;
                is_RW_EX_conflict_src1 = 0;
                is_RW_MA_conflict_src1 = 0; 
                is_MA_EX_conflict_src1 = 0;
    end

endmodule







































// module forwarding_unit(
//     input [31:0] input_OF_IR,
//     input [31:0] input_EX_IR,
//     input [31:0] input_MA_IR,
//     input [31:0] input_RW_IR
//     // output reg isDataInterLock

// );
//     reg [4:0] OF_opcode;
//     reg [4:0] EX_opcode;
//     reg [4:0] MA_opcode;
//     reg [4:0] RW_opcode;

//     reg is_B_conflict;
//     reg is_RW_EX__conflict;
//     reg is_RW_OF_conflict_src1;
//     reg is_RW_MA_conflict_src1;

//     reg [3:0] RW_dest;
//     reg [3:0] OF_src1;
//     reg [3:0] MA_src1;
//     reg [3:0] EX_src1;

//     reg [3:0] src2;
//     reg [3:0] ra = 4'b1111;
// // conflict on first operations

//  always @(*) begin

//         OF_opcode = input_OF_IR[31:27];
//         EX_opcode = input_EX_IR[31:27];
//         MA_opcode = input_MA_IR[31:27];
//         RW_opcode = input_RW_IR[31:27];


//     // src1 conflict  B ---> A forwaridng   RW --> OF , RW -->EX ,  RW --> MA
//      is_B_conflict = ~((RW_opcode == 5'B01101) || (RW_opcode == 5'B00101) ||
//                         (RW_opcode == 5'B01111) || (RW_opcode == 5'B10010) ||
//                         (RW_opcode == 5'B10000) || (RW_opcode == 5'B10001) ||
//                         (RW_opcode == 5'B10100));


//     is_RW_OF_conflict_src1 = ~((OF_opcode == 5'B01101) || (OF_opcode == 5'B10010) || 
//                        (OF_opcode == 5'B10000) || (OF_opcode == 5'B10001) || 
//                        (OF_opcode == 5'B10011) || (OF_opcode == 5'B01000) || 
//                        (OF_opcode == 5'B01001) );

//     is_RW_EX_conflict_src1 = ~((EX_opcode == 5'B01101) || (EX_opcode == 5'B10010) || 
//                        (EX_opcode == 5'B10000) || (EX_opcode == 5'B10001) || 
//                        (EX_opcode == 5'B10011) || (EX_opcode == 5'B01000) || 
//                        (EX_opcode == 5'B01001) );
    
//     is_RW_MA_conflict_src1 = ~((MA_opcode == 5'B01101) || (MA_opcode == 5'B10010) || 
//                        (MA_opcode == 5'B10000) || (MA_opcode == 5'B10001) || 
//                        (MA_opcode == 5'B10011) || (MA_opcode == 5'B01000) || 
//                        (MA_opcode == 5'B01001) );
//  end

//   always @(*) begin
//     if( is_B_conflict ) begin

//     OF_src1 = input_OF_IR[21:18];
//     if (OF_opcode == 5'B10100) begin
//         OF_src1 = ra;
//     end

//     EX_src1 = input_EX_IR[21:18];
//     if (EX_opcode == 5'B10100) begin
//         EX_src1 = ra;
//     end

//     MA_src1 = input_EX_IR[21:18];
//     if (MA_opcode == 5'B10100) begin
//         MA_src1 = ra;
//     end

//     RW_dest = input_RW_IR[25:22];
//     if (RW_opcode == 5'B10011) begin
//         RW_dest = ra;

//     end
    
//     // RW --> OF FORWARDING 
//     if(is_RW_OF_conflict_src1 && (OF_src1 == RW_dest)) begin
    
//         is_RW_OF_conflict_src1 <=
        
//     end



//     // RW --> EX FORWARDING 


//     // RW --> MA FORWARDING 


//     end

//   end



// endmodule




