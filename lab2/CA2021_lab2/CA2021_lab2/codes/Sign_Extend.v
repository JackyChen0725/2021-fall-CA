module Sign_Extend(data_i, constant_o);

    input [31:0] data_i;
    output reg [31:0] constant_o;

    always@(*)begin
        if(data_i[6:0] == 7'b0110011)begin
            constant_o = 32'bx;
        end
        else if(data_i[6:0] == 7'b0010011)begin
            if(data_i[14:12] == 3'b101)begin
                constant_o = {{27{data_i[24]}},data_i[24:20]};
            end
            else begin
                constant_o = {{20{data_i[31]}},data_i[31:20]};
            end 
        end
        else if(data_i[6:0] == 7'b0000011)begin
            constant_o = {{20{data_i[31]}},data_i[31:20]};
        end
        else if(data_i[6:0] == 7'b0100011)begin
            constant_o = {{20{data_i[31]}}, data_i[31:25], data_i[11:7]};
        end
        else if(data_i[6:0] == 7'b1100011)begin
            constant_o = {{20{data_i[31]}}, data_i[31], data_i[7], data_i[30:25], data_i[11:8]};
        end
        else begin
            constant_o = 32'bx;
        end
    end
endmodule