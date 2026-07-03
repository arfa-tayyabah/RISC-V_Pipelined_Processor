module alu_control(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7,
    output reg [3:0] ALUControl
);
always @(*) begin
    case(ALUOp)
        2'b00: ALUControl = 4'b0010;  // lw/sw: ADD
        2'b01: ALUControl = 4'b0110;  // beq/bne: SUB
        2'b10: begin
            case(funct3)
                3'b000: ALUControl = funct7 ? 4'b0110 : 4'b0010;  // ADD/SUB
                3'b001: ALUControl = 4'b1010;  // SLL
                3'b010: ALUControl = 4'b0111;  // SLT
                3'b011: ALUControl = 4'b0111;  // SLTU (same as SLT for now)
                3'b100: ALUControl = 4'b1000;  // XOR
                3'b101: ALUControl = funct7 ? 4'b1100 : 4'b1011;  // SRL/SRA
                3'b110: ALUControl = 4'b0001;  // OR
                3'b111: ALUControl = 4'b0000;  // AND
                default: ALUControl = 4'b0010;
            endcase
        end
        2'b11: begin
            case(funct3)
                3'b000: ALUControl = 4'b0010;  // ADDI
                3'b010: ALUControl = 4'b0111;  // SLTI
                3'b011: ALUControl = 4'b0111;  // SLTIU
                3'b100: ALUControl = 4'b1000;  // XORI
                3'b110: ALUControl = 4'b0001;  // ORI
                3'b111: ALUControl = 4'b0000;  // ANDI
                3'b001: ALUControl = 4'b1010;  // SLLI
                3'b101: ALUControl = funct7 ? 4'b1100 : 4'b1011;  // SRLI/SRAI
                default: ALUControl = 4'b0010;
            endcase
        end
        default: ALUControl = 4'b0010;
    endcase
end
endmodule