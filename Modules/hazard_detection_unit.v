
module hazard_detection_unit (
    
    input id_ex_MemRead,   
    input  [4:0] id_ex_rd,     

  
    input  [4:0] if_id_rs1,     
    input  [4:0] if_id_rs2,       


    output reg   stall,           
    output reg   id_ex_flush      
);

always @(*) begin
    
    if (id_ex_MemRead &&
        (id_ex_rd != 5'b0) &&
        ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2)))
    begin
        stall = 1'b1;  
        id_ex_flush = 1'b1;  
    end
    else begin
        stall = 1'b0;
        id_ex_flush = 1'b0;
    end
end

endmodule
