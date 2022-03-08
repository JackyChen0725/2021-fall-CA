module EXMEM(clk_i, rst_i, RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALU_result_i, data_to_dcache_i, RDaddr_i, stall_i, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALU_result_o, data_to_dcache_o, RDaddr_o);
    input clk_i, rst_i;
    input RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i;
    input [31:0] ALU_result_i;
    input [31:0] data_to_dcache_i;
    input [4:0] RDaddr_i;
    input stall_i;
    output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;
    output reg [31:0] ALU_result_o;
    output reg [31:0] data_to_dcache_o;
    output reg [4:0] RDaddr_o;

    always@(negedge rst_i)begin
        RegWrite_o <= 1'b0;
        MemtoReg_o <= 1'b0;
        MemRead_o <= 1'b0;
        MemWrite_o <= 1'b0;
        ALU_result_o <= 32'd0;
        data_to_dcache_o <= 32'd0;
        RDaddr_o <= 5'd0;
    end
    always@(posedge clk_i)begin
        if(~stall_i)begin
            RegWrite_o <= RegWrite_i;
            MemtoReg_o <= MemtoReg_i;
            MemRead_o <= MemRead_i;
            MemWrite_o <= MemWrite_i;
            ALU_result_o <= ALU_result_i;
            data_to_dcache_o <= data_to_dcache_i;
            RDaddr_o <= RDaddr_i;
        end  
    end
endmodule