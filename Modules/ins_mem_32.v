module instruction_memory_32
(
    input [7:0] addr,
    output [31:0] instruction
);
    reg [31:0] memory [0:255];
    integer i;
    
    initial begin
        
        for (i = 0; i < 256; i = i + 1) memory[i] = 32'h00000013;
        
        
        memory[0]  = 32'h00500093;  // addi x1, x0, 5
     
        memory[1]  = 32'h00A00113;  // addi x2, x0, 10
       
        memory[2]  = 32'h002081B3;  // add x3, x1, x2
    
        memory[3]  = 32'h0031A023;  // sw x3, 0(x1)
   
        memory[4]  = 32'h0001A283;  // lw x5, 0(x1)
   
        memory[5]  = 32'h0000006F;  // jal x0, 0
    end
    
    assign instruction = memory[addr];
endmodule