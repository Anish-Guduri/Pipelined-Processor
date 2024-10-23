module Calculate_Immx_BranchTarget(
input [31:0] input_OF_PC,
input [31:0] instruction,
output reg [31:0] Immx,
output reg [31:0] branchTarget
);
reg [31:0] tempBranchTarget;

wire uModifier = instruction[16];
wire hModifier = instruction[17];

always @(*) begin
            // #2
            tempBranchTarget[28:2]<=instruction[26:0];
            #1
            tempBranchTarget[31:29] <= {3{tempBranchTarget[28]}};
            #1
            tempBranchTarget[1:0] <= 2'b00; 
            #1
            branchTarget <= tempBranchTarget + input_OF_PC;
            // #2
            // $display("branchTarget %h",branchTarget);
end
always @(*) begin
    if((!uModifier) && (!hModifier)) begin
        Immx <={{16{instruction[15]}}, instruction[15:0]};
    end

    else if(uModifier) begin
        Immx <={ 16'b0, instruction[15:0] };
    end

    else if((hModifier)) begin
        Immx <={instruction[15:0], 16'b0};
    end
end

endmodule

