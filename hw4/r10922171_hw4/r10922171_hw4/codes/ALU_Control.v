module ALU_Control(funct_i, ALUOp_i, ALUCtrl_o);

    input [9:0] funct_i;
    input [1:0] ALUOp_i;
    output [2:0] ALUCtrl_o;

    reg [2:0] temp;

    assign ALUCtrl_o = temp;
    
    always@(*)begin
        if(ALUOp_i == 2'b10) begin
            temp = (funct_i[2:0] == 3'b111)? 3'b000 : (funct_i[2:0] == 3'b000)? ((funct_i[9:3] == 7'b0100000)? 3'b110 : 3'b011) :
            (funct_i[2:0] == 3'b100)? 3'b100 : 3'b101;
        end
            
        else begin
            temp = (funct_i[2:0] == 3'b101)? 3'b111 : 3'b010;
        end 
    end
endmodule