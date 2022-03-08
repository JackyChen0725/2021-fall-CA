module MUX(data1_i, data2_i, select_i, data_o);

    input [31:0] data1_i;
    input [31:0] data2_i;
    input select_i;
    output reg [31:0] data_o;

    always@(*)begin
        data_o = (select_i == 1'b0)? data1_i : data2_i;
    end
endmodule