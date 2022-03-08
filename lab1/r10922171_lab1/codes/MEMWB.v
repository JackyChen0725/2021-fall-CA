module MEMWB(clk_i, rst_i, RegWrite_i, MemtoReg_i, ALU_result_i, Memory_data_i, RDaddr_i, RegWrite_o, MemtoReg_o, ALU_result_o, Memory_data_o, RDaddr_o);
    input clk_i, rst_i;
    input RegWrite_i, MemtoReg_i;
    input [31:0] ALU_result_i;
    input [31:0] Memory_data_i;
    input [4:0] RDaddr_i;
    output reg RegWrite_o, MemtoReg_o;
    output reg [31:0] ALU_result_o;
    output reg [31:0] Memory_data_o;
    output reg [4:0] RDaddr_o;

    always@(negedge rst_i)begin
        RegWrite_o <= 1'b0;
        MemtoReg_o <= 1'b0;
        ALU_result_o <= 32'd0;
        Memory_data_o <= 32'd0;
        RDaddr_o <= 5'd0;
    end
    
    always@(posedge clk_i)begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        ALU_result_o <= ALU_result_i;
        Memory_data_o <= Memory_data_i;
        RDaddr_o <= RDaddr_i;
    end
endmodule