module Control(Op_i, ALUOp_o, ALUSrc_o, RegWrite_o);

    input [6:0] Op_i;
    output [1:0] ALUOp_o;
    output ALUSrc_o;
    output RegWrite_o;

    reg tmpALUSrc;
    reg [1:0] tmpALUOp;

    assign ALUOp_o = tmpALUOp;
    assign ALUSrc_o = tmpALUSrc;
    assign RegWrite_o = 1'b1;

    always@(*)begin
        begin
            tmpALUSrc = (Op_i == 7'b0110011)? 1'b0 : 1'b1;
        end
        begin
            tmpALUOp = (Op_i == 7'b0110011)? 2'b10 : 2'b00;
        end
        
    end
    
endmodule