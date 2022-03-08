module Sign_Extend(data_i, data_o);

    input [11:0]data_i;
    output [31:0]data_o;

    reg [31:0] temp;

    assign data_o = temp;

    always@(*)begin
        temp[11:0] = data_i[11:0];
        if(data_i[11] == 1'b1)begin
            temp = {{20{data_i[11]}}, data_i[11:0]};
        end
        else begin
            temp = {{20{data_i[11]}}, data_i[11:0]};
        end
    end
endmodule