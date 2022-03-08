module Equal(data1_i, data2_i, result_o);

    input [31:0] data1_i;
    input [31:0] data2_i;
    output reg result_o;
    
    always@(*)begin
        result_o = (data1_i == data2_i)? 1'b1 : 1'b0;
    end
endmodule
