module ID_EX (
    input clk,
    input reset,
    input stall,
    input flush,          


    input [31:0] read_data1_in,
    input [31:0] read_data2_in,
    input [31:0] immediate_in,
    input [4:0]  rd_in,
    input [4:0]  rs1_addr_in,   
    input [4:0]  rs2_addr_in,   
    input [2:0]  funct3_in,     
    input funct7_in,     

    
    input RegWrite_in,
    input MemRead_in,
    input MemWrite_in,
    input ALUSrc_in,
    input MemtoReg_in,
    input Branch_in,
    input [1:0] ALUOp_in,

    
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] immediate_out,
    output reg [4:0]  rd_out,
    output reg [4:0] rs1_addr_out,  
    output reg [4:0] rs2_addr_out,  
    output reg [2:0] funct3_out,   
    output reg funct7_out, 

  
    output reg RegWrite_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg ALUSrc_out,
    output reg MemtoReg_out,
    output reg Branch_out,
    output reg [1:0] ALUOp_out
);

always @(posedge clk or posedge reset) begin
    if (reset || flush) begin
        
        read_data1_out <= 32'b0;
        read_data2_out <= 32'b0;
        immediate_out  <= 32'b0;
        rd_out         <= 5'b0;
        rs1_addr_out   <= 5'b0;
        rs2_addr_out   <= 5'b0;
        funct3_out     <= 3'b0;
        funct7_out     <= 1'b0;

        RegWrite_out   <= 1'b0;
        MemRead_out    <= 1'b0;
        MemWrite_out   <= 1'b0;
        ALUSrc_out     <= 1'b0;
        MemtoReg_out   <= 1'b0;
        Branch_out     <= 1'b0;
        ALUOp_out      <= 2'b00;
    end
    else if (!stall) begin
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        immediate_out  <= immediate_in;
        rd_out         <= rd_in;
        rs1_addr_out   <= rs1_addr_in;
        rs2_addr_out   <= rs2_addr_in;
        funct3_out     <= funct3_in;
        funct7_out     <= funct7_in;

        RegWrite_out   <= RegWrite_in;
        MemRead_out    <= MemRead_in;
        MemWrite_out   <= MemWrite_in;
        ALUSrc_out     <= ALUSrc_in;
        MemtoReg_out   <= MemtoReg_in;
        Branch_out     <= Branch_in;
        ALUOp_out      <= ALUOp_in;
    end
end

endmodule