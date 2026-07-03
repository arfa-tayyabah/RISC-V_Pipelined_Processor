module data_memory(
    input clk,
    input [31:0] address,
    input [31:0] write_data,
    input MemRead,
    input MemWrite,
    output reg [31:0] read_data
);
    reg [31:0] mem [0:255];
    integer i;
    
    initial begin
        for(i = 0; i < 256; i = i + 1) mem[i] = 32'd0;
        mem[0] = 32'd100;
        mem[1] = 32'd200;
        mem[2] = 32'd300;
        mem[3] = 32'd400;
        mem[4] = 32'd500;
        mem[5] = 32'd600;
        mem[6] = 32'd700;
        mem[7] = 32'd800;
        mem[8] = 32'd900;
        mem[9] = 32'd1000;
        mem[10] = 32'd1100;
        mem[11] = 32'd1200;
        mem[12] = 32'd1300;
        mem[13] = 32'd1400;
        mem[14] = 32'd1500;
        mem[15] = 32'd1600;
    end
    
    always @(posedge clk) begin
        if(MemWrite) mem[address[9:2]] <= write_data;
    end
    
    always @(*) begin
        read_data = MemRead ? mem[address[9:2]] : 32'd0;
    end
endmodule