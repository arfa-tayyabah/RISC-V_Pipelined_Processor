module branch_target_calculator(
    input [31:0] pc,
    input [31:0] immediate,
    output [31:0] branch_target
);
adder_32bit branch_adder(.A(pc), .B(immediate), .Sum(branch_target));
endmodule
