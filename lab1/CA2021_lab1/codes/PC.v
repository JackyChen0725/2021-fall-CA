module PC
(
    clk_i,
    rst_i,
    start_i,
    PCWrite_i,
    pc_i,
    pc_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input               PCWrite_i;
input   [31:0]      pc_i;
output  [31:0]      pc_o;

// Wires & Registers
reg     [31:0]      pc_o;

always@(negedge rst_i)begin
    pc_o <= 32'd0;
end

always@(posedge clk_i) begin
    if (PCWrite_i) begin
        if(start_i)
            pc_o <= pc_i;
        else
            pc_o <= pc_o;
    end
end

endmodule
