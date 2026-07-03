module pipeline_datapath (
    input  clk,
    input reset,
    output [31:0] write_back_data,
    output [31:0] pc_next,
    output        PCSrc
);

    
    wire [31:0] pc, instruction;
    wire [31:0] pc_plus4;
    wire [31:0] pc_next_internal;
    assign pc_next = pc_next_internal;

        wire [31:0] ifid_pc, ifid_instruction;

   
    wire [31:0] rs1_data, rs2_data;
    wire [31:0] immediate_id;
    wire   ALUSrc_id, MemtoReg_id, RegWrite_id;
    wire MemRead_id, MemWrite_id, Branch_id;
    wire [1:0]  ALUOp_id;

        wire stall, id_ex_flush;

    
    wire [31:0] idex_rs1, idex_rs2, idex_imm;
    wire [4:0] idex_rd;
    wire [4:0]  idex_rs1_addr, idex_rs2_addr;
    wire [2:0] idex_funct3;
    wire  idex_funct7;
    wire idex_ALUSrc, idex_MemtoReg, idex_RegWrite;
    wire idex_MemRead, idex_MemWrite, idex_Branch;
    wire [1:0]  idex_ALUOp;

    
    wire [3:0]  alu_control_sig;
    wire [31:0] alu_input_a, alu_input_b_pre, alu_input_b;
    wire [31:0] alu_result;
    wire zero;
    wire [31:0] pc_branch;
    wire [1:0]  forwardA, forwardB;

    
    wire [31:0] exmem_alu, exmem_write_data;
    wire [4:0]  exmem_rd;
    wire exmem_RegWrite, exmem_MemRead, exmem_MemWrite, exmem_MemtoReg;

    
    wire [31:0] mem_read_data;

    
    wire [31:0] memwb_mem_data, memwb_alu;
    wire [4:0]  memwb_rd;
    wire memwb_RegWrite, memwb_MemtoReg;

    
    program_counter pc_reg (
        .clk(clk), .reset(reset),
        .pc_in(pc_next_internal), .pc_out(pc)
    );

    adder_32bit pc_adder (
        .A(pc), .B(32'd4), .Sum(pc_plus4)
    );

    instruction_memory_32 imem (
        .addr(pc[9:2]), .instruction(instruction)
    );

    
    IF_ID_stall ifid (
        .clk(clk), .reset(reset), .stall(stall),
        .pc_in(pc), .instruction_in(instruction),
        .pc_out(ifid_pc), .instruction_out(ifid_instruction)
    );

        register_file rf (
        .clk(clk), .we(memwb_RegWrite),
        .rs1(ifid_instruction[19:15]),
        .rs2(ifid_instruction[24:20]),
        .rd(memwb_rd), .wd(write_back_data),
        .rd1(rs1_data), .rd2(rs2_data)
    );

    immediate_generator ig (
        .instruction(ifid_instruction),
        .immediate(immediate_id)
    );

    riscv_control ctrl (
        .opcode(ifid_instruction[6:0]),
        .ALUSrc(ALUSrc_id), .MemtoReg(MemtoReg_id), .RegWrite(RegWrite_id),
        .MemRead(MemRead_id), .MemWrite(MemWrite_id), .Branch(Branch_id),
        .ALUOp(ALUOp_id)
    );

        hazard_detection_unit hdu (
        .id_ex_MemRead (idex_MemRead),
        .id_ex_rd      (idex_rd),
        .if_id_rs1     (ifid_instruction[19:15]),
        .if_id_rs2     (ifid_instruction[24:20]),
        .stall         (stall),
        .id_ex_flush   (id_ex_flush)
    );

        ID_EX idex (
        .clk(clk), .reset(reset),
        .stall(stall), .flush(id_ex_flush),
        .read_data1_in(rs1_data),
        .read_data2_in(rs2_data),
        .immediate_in (immediate_id),
        .rd_in        (ifid_instruction[11:7]),
        .rs1_addr_in  (ifid_instruction[19:15]),
        .rs2_addr_in  (ifid_instruction[24:20]),
        .funct3_in    (ifid_instruction[14:12]),
        .funct7_in    (ifid_instruction[30]),
        .RegWrite_in  (RegWrite_id),
        .MemRead_in   (MemRead_id),
        .MemWrite_in  (MemWrite_id),
        .ALUSrc_in    (ALUSrc_id),
        .MemtoReg_in  (MemtoReg_id),
        .Branch_in    (Branch_id),
        .ALUOp_in     (ALUOp_id),
        .read_data1_out(idex_rs1),
        .read_data2_out(idex_rs2),
        .immediate_out (idex_imm),
        .rd_out        (idex_rd),
        .rs1_addr_out  (idex_rs1_addr),
        .rs2_addr_out  (idex_rs2_addr),
        .funct3_out    (idex_funct3),
        .funct7_out    (idex_funct7),
        .RegWrite_out  (idex_RegWrite),
        .MemRead_out   (idex_MemRead),
        .MemWrite_out  (idex_MemWrite),
        .ALUSrc_out    (idex_ALUSrc),
        .MemtoReg_out  (idex_MemtoReg),
        .Branch_out    (idex_Branch),
        .ALUOp_out     (idex_ALUOp)
    );

        alu_control ac (
        .ALUOp   (idex_ALUOp),
        .funct3  (idex_funct3),
        .funct7  (idex_funct7),
        .ALUControl(alu_control_sig)
    );

    forwarding_unit fwd (
        .id_ex_rs1  (idex_rs1_addr),
        .id_ex_rs2 (idex_rs2_addr),
        .ex_mem_rd (exmem_rd),
        .ex_mem_RegWrite(exmem_RegWrite),
        .mem_wb_rd  (memwb_rd),
        .mem_wb_RegWrite(memwb_RegWrite),
        .forwardA       (forwardA),
        .forwardB       (forwardB)
    );

    
    assign alu_input_a = (forwardA == 2'b10) ? exmem_alu :
                         (forwardA == 2'b01) ? write_back_data :
                                               idex_rs1;

   
    assign alu_input_b_pre = (forwardB == 2'b10) ? exmem_alu :
                             (forwardB == 2'b01) ? write_back_data :
                                                   idex_rs2;

    
    mux_2to1 src_mux (
        .in0(alu_input_b_pre), .in1(idex_imm),
        .sel(idex_ALUSrc), .out(alu_input_b)
    );

    alu alu_unit (
        .A(alu_input_a), .B(alu_input_b),
        .ALUControl(alu_control_sig),
        .Result(alu_result), .Zero(zero)
    );

always @(posedge clk) begin
    if (idex_ALUOp != 2'b00) begin
        $display("DEBUG: ALUOp=%b, funct3=%b, funct7=%b, ALUctrl=%b, A=%d, B=%d, Result=%d",
                 idex_ALUOp, idex_funct3, idex_funct7, alu_control_sig, 
                 alu_input_a, alu_input_b, alu_result);
    end
end

    branch_target_calculator btc (
        .pc(pc_plus4), .immediate(idex_imm),
        .branch_target(pc_branch)
    );

    assign PCSrc = idex_Branch & zero;

    
    assign pc_next_internal = stall   ? pc        :
                              PCSrc   ? pc_branch :
                                        pc_plus4;

    
    EX_MEM exmem (
        .clk(clk), .reset(reset),
        .alu_result_in (alu_result),
        .write_data_in (alu_input_b_pre),
        .rd_in         (idex_rd),
        .RegWrite_in   (idex_RegWrite),
        .MemRead_in    (idex_MemRead),
        .MemWrite_in   (idex_MemWrite),
        .MemtoReg_in   (idex_MemtoReg),
        .alu_result_out(exmem_alu),
        .write_data_out(exmem_write_data),
        .rd_out        (exmem_rd),
        .RegWrite_out  (exmem_RegWrite),
        .MemRead_out   (exmem_MemRead),
        .MemWrite_out  (exmem_MemWrite),
        .MemtoReg_out  (exmem_MemtoReg)
    );

    
    data_memory dmem (
        .clk        (clk),
        .address    (exmem_alu),
        .write_data (exmem_write_data),
        .MemRead    (exmem_MemRead),
        .MemWrite   (exmem_MemWrite),
        .read_data  (mem_read_data)
    );

        MEM_WB memwb (
        .clk(clk), .reset(reset),
        .mem_data_in   (mem_read_data),
        .alu_result_in (exmem_alu),
        .rd_in         (exmem_rd),
        .RegWrite_in   (exmem_RegWrite),
        .MemtoReg_in   (exmem_MemtoReg),
        .mem_data_out  (memwb_mem_data),
        .alu_result_out(memwb_alu),
        .rd_out        (memwb_rd),
        .RegWrite_out  (memwb_RegWrite),
        .MemtoReg_out  (memwb_MemtoReg)
    );

        mux_2to1 wb_mux (
        .in0(memwb_alu), .in1(memwb_mem_data),
        .sel(memwb_MemtoReg), .out(write_back_data)
    );

endmodule