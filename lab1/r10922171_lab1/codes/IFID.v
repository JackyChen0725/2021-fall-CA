module IFID(clk_i, rst_i, instr_addr_i, instr_i, Write_i, flush_i, instr_addr_o, instr_o);

    input clk_i, rst_i;
    input [31:0] instr_addr_i;
    input [31:0] instr_i;
    input Write_i;
    input flush_i;
    output reg [31:0] instr_addr_o;
    output reg [31:0] instr_o;

    always@(negedge rst_i)begin
        instr_addr_o <= 32'd0;
        instr_o <= 32'd0;
    end
    
    always@(posedge clk_i)begin
        if(flush_i)begin
            instr_addr_o <= 32'd0;
            instr_o <= 32'd0;
        end
        else if(Write_i)begin
            instr_addr_o <= instr_addr_i;
            instr_o <= instr_i;
        end
    end
endmodule