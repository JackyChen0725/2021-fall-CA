module ALU(data1_i, data2_i, ALUCtrl_i, ALU_result_o);
    input [31:0] data1_i;
    input [31:0] data2_i;
    input [3:0] ALUCtrl_i;
    output reg [31:0] ALU_result_o;

    always@(*)begin
        case(ALUCtrl_i)
            4'b0000: ALU_result_o = data1_i & data2_i;
            4'b0001: ALU_result_o = data1_i | data2_i;
            4'b0010: ALU_result_o = data1_i + data2_i;
            4'b0011: ALU_result_o = data1_i ^ data2_i;
            4'b0100: ALU_result_o = data1_i << data2_i;
            4'b0101: ALU_result_o = data1_i * data2_i;
            4'b0110: ALU_result_o = data1_i - data2_i;
            4'b0111: ALU_result_o = $signed(data1_i) >>> data2_i[4:0];
            default: ALU_result_o = 32'dx;
        endcase
    end
endmodule
