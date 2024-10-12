module test_RISCV;
reg clk1, clk2;
integer k;
pipeline_RISCV risc_p(clk1, clk2);
initial begin
    clk1=0; clk2=0;
    repeat (20)             // GENERATION OF TWO-PHAE CLOCK
    begin
        #5 clk1=1;  #5 clk1=0;
        #5 clk2=1;  #5 clk2=0;
    end   
end
initial begin
    for(k=0;k<32;k=k+1)
       risc_p.RegFile[k]=0;

    risc_p.Memory[0]=32'h2801000a;    // ADD R1, R0, 10
    risc_p.Memory[1]=32'h28020014;    // ADDi R2, R0, 20
    risc_p.Memory[2]=32'h00222000;   // ADD R4, R1, R2  
    risc_p.Memory[3]=32'hfc000000;   // HLT

    risc_p.HALTED=0;
    risc_p.PC=0;
    risc_p.TAKEN_BRANCH = 0;

    #250
    for(k=0;k<6;k++)
    $display ("R%1d  - %2d",k, risc_p.RegFile[k]);
    for(k=0;k<6;k++)
    $display ("MEM[%1d]  - %2d",k, risc_p.Memory[k]);
end

initial 
    begin
        $dumpfile ("risc_p.vcd");
        $dumpvars(0, test_RISCV);
    end

endmodule