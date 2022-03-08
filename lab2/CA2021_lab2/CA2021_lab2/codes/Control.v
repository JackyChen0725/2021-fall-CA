module Control(Op_i, NoOp_i, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUOp_o, ALUSrc_o, Branch_o);
    input [6:0] Op_i;
    input NoOp_i;
    output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;
    output reg [1:0] ALUOp_o;

    always@(*)begin
        if(NoOp_i)begin
            RegWrite_o = 1'b0;
            MemtoReg_o = 1'b0;
            MemRead_o = 1'b0;
            MemWrite_o = 1'b0;
            ALUOp_o = 2'b00;
            ALUSrc_o = 1'b0;
            Branch_o = 1'b0;
        end
        else begin
            if(Op_i[6:0] == 7'b0110011)begin
                RegWrite_o = 1'b1;
                MemtoReg_o = 1'b0;
                MemRead_o = 1'b0;
                MemWrite_o = 1'b0;
                ALUSrc_o = 1'b0;
                ALUOp_o = 2'b10;
                Branch_o = 1'b0;
            end
            else if(Op_i[6:0] == 7'b0010011)begin
                RegWrite_o = 1'b1;
                MemtoReg_o = 1'b0;
                MemRead_o = 1'b0;
                MemWrite_o = 1'b0;
                ALUSrc_o = 1'b1;
                ALUOp_o = 2'b00;
                Branch_o = 1'b0;
            end
            else if(Op_i[6:0] == 7'b0000011)begin
                RegWrite_o = 1'b1;
                MemtoReg_o = 1'b1;
                MemRead_o = 1'b1;
                MemWrite_o = 1'b0;
                ALUSrc_o = 1'b1;
                ALUOp_o = 2'b00;
                Branch_o = 1'b0;
            end
            else if(Op_i[6:0] == 7'b0100011)begin
                RegWrite_o = 1'b0;
                MemtoReg_o = 1'bx;
                MemRead_o = 1'b0;
                MemWrite_o = 1'b1;
                ALUSrc_o = 1'b1;
                ALUOp_o = 2'b00;
                Branch_o = 1'b0;
            end
            else if(Op_i[6:0] == 7'b1100011)begin
                RegWrite_o = 1'b0;
                MemtoReg_o = 1'bx;
                MemRead_o = 1'b0;
                MemWrite_o = 1'b0;
                ALUSrc_o = 1'b0;
                ALUOp_o = 2'b01;
                Branch_o = 1'b1;
            end
            else begin
                RegWrite_o = 1'b0;
                MemtoReg_o = 1'b0;
                MemRead_o = 1'b0;
                MemWrite_o = 1'b0;
                ALUSrc_o = 1'b0;
                ALUOp_o = 2'b00;
                Branch_o = 1'b0;
            end
        end
    end
endmodule
