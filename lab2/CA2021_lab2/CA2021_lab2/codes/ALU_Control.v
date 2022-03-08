module ALU_Control(funct_i, ALUOp_i, ALUCtrl_o);
    input [9:0] funct_i;
    input [1:0] ALUOp_i;
    output reg [3:0] ALUCtrl_o;

    always@(*)begin
        if(ALUOp_i == 2'b00)begin
            ALUCtrl_o = (funct_i[2:0] == 3'b101)? 4'b0111 : ((funct_i[2:0] == 3'b010 || funct_i[2:0] == 3'b000)? 4'b0010 : 4'dx);
        end
        else if(ALUOp_i == 2'b01)begin
            ALUCtrl_o = 4'dx;
        end
        else if(ALUOp_i == 2'b10)begin
            if(funct_i[2:0] == 3'b000)begin
                case(funct_i[9:3])
                    7'b0000000: ALUCtrl_o = 4'b0010;
                    7'b0100000: ALUCtrl_o = 4'b0110;
                    7'b0000001: ALUCtrl_o = 4'b0101;
                    default: ALUCtrl_o = 4'dx;
                endcase
            end
            else if(funct_i[2:0] == 3'b001)begin
                ALUCtrl_o = (funct_i[9:3] == 7'b0000000)? 4'b0100 : 4'dx;
            end
            else if(funct_i[2:0] == 3'b100)begin
                ALUCtrl_o = (funct_i[9:3] == 7'b0000000)? 4'b0011 : 4'dx;
            end
            else if(funct_i[2:0] == 3'b111)begin
                ALUCtrl_o = (funct_i[9:3] == 7'b0000000)? 4'b0000 : 4'dx;
            end
            else begin
                ALUCtrl_o = 4'dx;
            end   
        end
    end
endmodule