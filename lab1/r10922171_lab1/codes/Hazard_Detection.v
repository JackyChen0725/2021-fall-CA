module Hazard_Detection(IFID_RS1addr_i, IFID_RS2addr_i, IDEX_MemRead_i, IDEX_RDaddr_i, PCWrite_o, IFIDWrite_o, NoOp_o);
    input [4:0] IFID_RS1addr_i;
    input [4:0] IFID_RS2addr_i;
    input [4:0] IDEX_RDaddr_i;
    input IDEX_MemRead_i;
    output reg PCWrite_o, IFIDWrite_o, NoOp_o;

    always@(*)begin
        if(IDEX_MemRead_i && ((IDEX_RDaddr_i == IFID_RS1addr_i) || (IDEX_RDaddr_i == IFID_RS2addr_i)) && IDEX_RDaddr_i != 5'b0)begin
            PCWrite_o <= 1'b0;
            IFIDWrite_o <= 1'b0;
            NoOp_o <= 1'b1;
        end
        else begin
            PCWrite_o <= 1'b1;
            IFIDWrite_o <= 1'b1;
            NoOp_o <= 1'b0;
        end
    end
endmodule