module testbench;
    reg clk;
    reg reset;
    wire [31:0] write_back_data;
    wire [31:0] pc_next;
    wire PCSrc;
    wire [31:0] pc = testbench.cpu.pc;
    wire [31:0] instruction = testbench.cpu.instruction;
    wire [31:0] ifid_instr = testbench.cpu.ifid_instruction;
    wire [31:0] idex_rs1 = testbench.cpu.idex_rs1;
    wire [31:0] idex_rs2 = testbench.cpu.idex_rs2;
    wire [31:0] alu_result = testbench.cpu.alu_result;
    wire stall = testbench.cpu.stall;
    wire [4:0]  memwb_rd = testbench.cpu.memwb_rd;
    wire memwb_we = testbench.cpu.memwb_RegWrite;
    wire [1:0] fwdA = testbench.cpu.forwardA;
    wire [1:0] fwdB = testbench.cpu.forwardB;
    wire [3:0]  alu_control_sig = testbench.cpu.alu_control_sig;
    wire [31:0] alu_input_a     = testbench.cpu.alu_input_a;
    wire [31:0] alu_input_b     = testbench.cpu.alu_input_b;
wire [1:0] idex_aluop = testbench.cpu.idex_ALUOp;


    pipeline_datapath cpu (
        .clk(clk),
        .reset(reset),
        .write_back_data(write_back_data),
        .pc_next(pc_next),
        .PCSrc(PCSrc)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        #15 reset = 0;

        // Print header
        $display("==================================================================================");
        $display("Time | PC       | Instruction | ALU_Result | WB_Data | RD|WE|Stall|Fwd| ALUctrl | ALU_A     ALU_B");
        $display("==================================================================================");

        // Monitor every rising edge
        repeat(60) begin
            @(posedge clk);
            #1;
            // Change display to:
$display("%5t | %08h | %08h | %08h | %08h | x%02d | %d | %d | %d %d | %b",
    $time, pc, ifid_instr, alu_result, write_back_data, 
    memwb_rd, memwb_we, stall, fwdA, fwdB, idex_aluop);
        end
    end
endmodule