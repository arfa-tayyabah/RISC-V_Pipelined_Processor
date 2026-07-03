module register_file (
    input clk,
    input we,
    input [4:0] rs1, rs2, rd,
    input [31:0] wd,
    output [31:0] rd1, rd2
);
    reg [31:0] registers [31:0];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end

    assign rd1 = registers[rs1];
    assign rd2 = registers[rs2];

    always @(posedge clk) begin
        if (we && rd != 0)
            registers[rd] <= wd;
    end
endmodule