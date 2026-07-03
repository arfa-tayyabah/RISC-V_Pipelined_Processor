module alu(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUControl,
    output reg [31:0] Result,
    output reg Zero
);
    always @(*) begin
        case(ALUControl)
            4'b0000: Result = A & B;           // AND
            4'b0001: Result = A | B;           // OR
            4'b0010: Result = A + B;           // ADD
            4'b0110: Result = A - B;           // SUB
            4'b0111: Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // SLT
            4'b1000: Result = A ^ B;           // XOR
            4'b1001: Result = ~(A | B);        // NOR
            4'b1010: Result = A << B[4:0];     // SLL
            4'b1011: Result = A >> B[4:0];     // SRL
            4'b1100: Result = $signed(A) >>> B[4:0]; // SRA
            default: Result = A + B;
        endcase
        
        // Set Zero flag
        Zero = (Result == 32'd0) ? 1'b1 : 1'b0;
    end
endmodule