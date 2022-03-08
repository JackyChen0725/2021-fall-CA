module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] instr_addr, instr;

Control Control(
    .Op_i       (instr [6:0]),
    .ALUOp_o    (ALU_Control.ALUOp_i),
    .ALUSrc_o   (MUX_ALUSrc.select_i),
    .RegWrite_o (Registers.RegWrite_i)
);

Adder Add_PC(
    .data1_in   (instr_addr),
    .data2_in   (32'd4),
    .data_o     (PC.pc_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Add_PC.data_o),
    .pc_o       (instr_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (instr_addr), 
    .instr_o    (instr)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (instr [19:15]),
    .RS2addr_i   (instr [24:20]),
    .RDaddr_i   (instr [11:7]), 
    .RDdata_i   (ALU.data_o),
    .RegWrite_i (Control.RegWrite_o), 
    .RS1data_o   (ALU.data1_i), 
    .RS2data_o   (MUX_ALUSrc.data1_i) 
);

MUX32 MUX_ALUSrc(
    .data1_i    (Registers.RS2data_o),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     (ALU.data2_i)
);

Sign_Extend Sign_Extend(
    .data_i     (instr [31:20]),
    .data_o     (MUX_ALUSrc.data2_i)
);
  
ALU ALU(
    .data1_i    (Registers.RS1data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (Registers.RDdata_i),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    ({instr [31:25],instr [14:12]}),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);

endmodule

