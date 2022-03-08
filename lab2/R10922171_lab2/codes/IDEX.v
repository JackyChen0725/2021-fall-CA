module IDEX(clk_i, rst_i, RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUOp_i, ALUSrc_i, RS1data_i, RS2data_i, constant_i, funct_i, RS1addr_i, RS2addr_i, RDaddr_i, stall_i,
RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUOp_o, ALUSrc_o, RS1data_o, RS2data_o, constant_o, funct_o, RS1addr_o, RS2addr_o, RDaddr_o);
    input clk_i, rst_i;
    input RegWrite_i, 
          MemtoReg_i, 
          MemRead_i, 
          MemWrite_i, 
          ALUSrc_i;
    input [1:0] ALUOp_i;
    input [31:0] RS1data_i;
    input [31:0] RS2data_i;
    input [31:0] constant_i;
    input [9:0] funct_i;
    input [4:0] RS1addr_i;
    input [4:0] RS2addr_i;
    input [4:0] RDaddr_i;
    input stall_i;
    output reg  RegWrite_o, 
                MemtoReg_o,
                MemRead_o,
                MemWrite_o,
                ALUSrc_o;
    output reg [1:0] ALUOp_o;
    output reg [31:0] RS1data_o;
    output reg [31:0] RS2data_o;
    output reg [31:0] constant_o;
    output reg [9:0] funct_o;
    output reg [4:0] RS1addr_o;
    output reg [4:0] RS2addr_o;
    output reg [4:0] RDaddr_o;

    
    always@(negedge rst_i)begin
        RegWrite_o <= 1'b0;
        MemtoReg_o <= 1'b0;
        MemRead_o <= 1'b0;
        MemWrite_o <= 1'b0;
        ALUSrc_o <= 1'b0;
        ALUOp_o <= 2'b00;
        RS1data_o <= 32'd0;
        RS2data_o <= 32'd0;
        constant_o <= 32'd0;
        funct_o <= 10'd0;
        RS1addr_o <= 5'd0;
        RS2addr_o <= 5'd0;
        RDaddr_o <= 5'd0;
    end
    always@(posedge clk_i)begin
        if(~stall_i)begin
            RegWrite_o <= RegWrite_i;
            MemtoReg_o <= MemtoReg_i;
            MemRead_o <= MemRead_i;
            MemWrite_o <= MemWrite_i;
            ALUSrc_o <= ALUSrc_i;
            ALUOp_o <= ALUOp_i;
            RS1data_o <= RS1data_i;
            RS2data_o <= RS2data_i;
            constant_o <= constant_i;
            funct_o <= funct_i;
            RS1addr_o <= RS1addr_i;
            RS2addr_o <= RS2addr_i;
            RDaddr_o <= RDaddr_i;
        end
    end
endmodule

