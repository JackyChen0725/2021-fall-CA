module MUX_3to1(Forward_i, data1_i, data2_i, data3_i, data_o);
    input [1:0] Forward_i;
    input [31:0] data1_i;
    input [31:0] data2_i;
    input [31:0] data3_i;
    output reg [31:0] data_o;

    always@(*)begin
        if(Forward_i == 2'b00)begin
            data_o = data1_i;
        end
        else if(Forward_i == 2'b01)begin
            data_o = data2_i;
        end
        else if(Forward_i == 2'b10)begin
            data_o = data3_i;
        end
        else begin
            data_o = data1_i;
        end
    end
endmodule