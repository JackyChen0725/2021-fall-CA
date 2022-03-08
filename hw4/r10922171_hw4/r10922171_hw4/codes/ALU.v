module ALU(data1_i, data2_i, ALUCtrl_i, data_o, Zero_o);

    input [31:0] data1_i;
    input [31:0] data2_i;
    input [2:0] ALUCtrl_i;
    output [31:0] data_o;
    output Zero_o;

    reg [31:0] temp;
    
    assign data_o = temp;
    assign Zero_o = 1'b0;

    always@(*)begin
        temp = (ALUCtrl_i == 3'b000)? (data1_i & data2_i) :
    (ALUCtrl_i == 3'b001)? (data1_i | data2_i) : 
    (ALUCtrl_i == 3'b010)? (data1_i + data2_i) :
    (ALUCtrl_i == 3'b110)? (data1_i - data2_i) : 
    (ALUCtrl_i == 3'b011)? (data1_i * data2_i) :
    (ALUCtrl_i == 3'b100)? (data1_i ^ data2_i) :
    (ALUCtrl_i == 3'b101)? (data1_i << data2_i) :
    (ALUCtrl_i == 3'b111)? (data1_i >>> data2_i[4:0]) :
    (data1_i + data2_i);
    end
    
endmodule