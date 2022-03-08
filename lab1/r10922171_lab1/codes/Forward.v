module Forward(IDEX_RS1addr_i, IDEX_RS2addr_i, EXMEM_RDaddr_i, EXMEM_RegWrite_i, MEMWB_RDaddr_i, MEMWB_RegWrite_i, ForwardA_o, ForwardB_o);
    input [4:0] IDEX_RS1addr_i;
    input [4:0] IDEX_RS2addr_i;
    input [4:0] EXMEM_RDaddr_i;
    input [4:0] MEMWB_RDaddr_i;
    input EXMEM_RegWrite_i, MEMWB_RegWrite_i;
    output reg [1:0] ForwardA_o;
    output reg [1:0] ForwardB_o;

    always@(*)begin
        if(EXMEM_RegWrite_i && IDEX_RS1addr_i == EXMEM_RDaddr_i && EXMEM_RDaddr_i != 5'b0)begin
            ForwardA_o = 2'b10;
        end
        else if(MEMWB_RegWrite_i && IDEX_RS1addr_i == MEMWB_RDaddr_i && MEMWB_RDaddr_i != 5'b0)begin
            ForwardA_o = 2'b01;
        end
        else begin
            ForwardA_o = 2'b00;
        end

        if(EXMEM_RegWrite_i && IDEX_RS2addr_i == EXMEM_RDaddr_i && EXMEM_RDaddr_i != 5'b0)begin
            ForwardB_o = 2'b10;
        end
        else if(MEMWB_RegWrite_i && IDEX_RS2addr_i == MEMWB_RDaddr_i && MEMWB_RDaddr_i != 5'b0)begin
            ForwardB_o = 2'b01;
        end
        else begin
            ForwardB_o = 2'b00;
        end
    end
endmodule