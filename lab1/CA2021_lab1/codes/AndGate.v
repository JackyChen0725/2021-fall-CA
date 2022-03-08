module AndGate(data1_i, data2_i, flush_o);
    input data1_i, data2_i;
    output reg flush_o;

    always@(*)begin
        if(data1_i & data2_i == 1'b1)begin
            flush_o = 1'b1;
        end
        else begin
            flush_o = 1'b0;
        end
    end
endmodule