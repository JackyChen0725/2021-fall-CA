module MUX32(data1_i, data2_i, select_i, data_o);

    input [31:0] data1_i;
    input [31:0] data2_i;
    input select_i;
    input [31:0] data_o;

    reg [31:0] temp;

    assign data_o = temp;

    always@(*)begin
        if(select_i == 0) begin
            temp = data1_i;
        end
        else begin
           temp = data2_i; 
        end 
    end
endmodule