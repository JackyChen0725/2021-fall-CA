module CPU(clk_i, start_i, rst_i);

    input clk_i;
    input start_i;
    input rst_i;

    /*各state的宣告*/
    //IF state
    wire [31:0] instr_addr;
    wire [31:0] instr;
    wire [31:0] next_pc;

    //ID state
    wire [31:0] IFID_RS1data;
    wire [31:0] IFID_RS2data;
    wire [31:0] imm;
    wire [31:0] IFID_instr;
    wire [31:0] IFID_instr_addr;
    wire Branch, RegWrite, MemtoReg, MemRead, MemWrite, ALUSrc;
    wire [1:0] ALUOp;
    wire Equal_result;
    wire Flush, PCWrite, IFIDWrite, NoOp;

    reg Flush_reg = 1'b0;
    reg PCWrite_reg = 1'b1;
    reg IFIDWrite_reg = 1'b1;
    reg NoOp_reg = 1'b0;

    always@(Flush)begin
        Flush_reg <= Flush;
    end

    always@(PCWrite)begin
        PCWrite_reg <= PCWrite;
    end

    always@(IFIDWrite)begin
        IFIDWrite_reg <= IFIDWrite;
    end

    always@(NoOp)begin
        NoOp_reg <= NoOp;
    end
        
    //EX state
    wire IDEX_RegWrite, IDEX_MemtoReg, IDEX_MemRead, IDEX_MemWrite, IDEX_ALUSrc;
    wire [1:0] IDEX_ALUOp;
    wire [31:0] IDEX_RS1data; 
    wire [31:0] IDEX_RS2data;
    wire [31:0] IDEX_imm;
    wire [9:0] IDEX_funct;
    wire [4:0] IDEX_RS1addr;
    wire [4:0] IDEX_RS2addr;
    wire [4:0] IDEX_RDaddr;
    wire [31:0] RS2_MUX_data;
    wire [1:0] ForwardA, ForwardB;
    wire [3:0] ALUCtrl;
    wire [31:0] ALU_data1, ALU_data2, ALU_result;
    
    //MEM state
    wire EXMEM_RegWrite, EXMEM_MemtoReg, EXMEM_MemRead, EXMEM_MemWrite;
    wire [31:0] Memory_data;
    wire [31:0] EXMEM_ALU_result;
    wire [4:0] EXMEM_RDaddr;
    wire [31:0] DatatoMemory;
    
    //WB state
    wire MEMWB_RegWrite, MEMWB_MemtoReg;
    wire [31:0] MEMWB_ALU_result;
    wire [31:0] MEMWB_Memory_data;
    wire [31:0] MEMWB_RDdata;
    wire [4:0] MEMWB_RDaddr;

    /*各state使用的模組*/
    //IF
    PC PC
    (
        .clk_i (clk_i),
        .rst_i (rst_i),
        .start_i (start_i),
        .PCWrite_i (PCWrite_reg),
        .pc_i (PC_MUX.data_o),
        .pc_o (instr_addr)
    );

    Adder PC_Adder
    (
        .data1_i (instr_addr),
        .data2_i (32'd4),
        .data_o (next_pc)
    );

    MUX PC_MUX
    (
        .data1_i (next_pc),
        .data2_i (branch_Adder.data_o),
        .select_i (Flush_reg),
        .data_o (PC.pc_i)
    );

    Instruction_Memory Instruction_Memory
    (
        .addr_i (instr_addr),
        .instr_o (instr)
    );

    //ID
    Registers Registers
    (
        .clk_i (clk_i),
        .RS1addr_i (IFID_instr[19:15]),
        .RS2addr_i (IFID_instr[24:20]),
        .RDaddr_i (MEMWB_RDaddr),
        .RDdata_i (MEMWB_RDdata),
        .RegWrite_i (MEMWB_RegWrite),
        .RS1data_o (IFID_RS1data),
        .RS2data_o (IFID_RS2data)
    );

    Adder branch_Adder
    (
        .data1_i (Shift.data_o),
        .data2_i (IFID_instr_addr),
        .data_o (PC_MUX.data2_i)
    );

    Sign_Extend Sign_Extend
    (
        .data_i (IFID_instr[31:0]),
        .constant_o (imm)
    );

    Shift Shift
    (
        .data_i (imm),
        .data_o (branch_Adder.data1_i)
    );

    Equal Equal
    (
        .data1_i (IFID_RS1data),
        .data2_i (IFID_RS2data),
        .result_o (Equal_result)
    );

    AndGate AndGate
    (
        .data1_i (Branch),
        .data2_i (Equal_result),
        .flush_o (Flush)
    );

    Control Control
    (
        .Op_i (IFID_instr[6:0]),
        .NoOp_i (NoOp_reg),
        .RegWrite_o (RegWrite),
        .MemtoReg_o (MemtoReg),
        .MemRead_o (MemRead),
        .MemWrite_o (MemWrite),
        .ALUOp_o (ALUOp),
        .ALUSrc_o (ALUSrc),
        .Branch_o (Branch)
    );

    Hazard_Detection Hazard_Detection
    (
        .IFID_RS1addr_i (IFID_instr[19:15]),
        .IFID_RS2addr_i (IFID_instr[24:20]),
        .IDEX_MemRead_i (IDEX_MemRead),
        .IDEX_RDaddr_i (IDEX_RDaddr),
        .PCWrite_o (PCWrite),
        .IFIDWrite_o (IFIDWrite),
        .NoOp_o (NoOp)
    );

    //EX
    Forward Forward
    (
        .IDEX_RS1addr_i (IDEX_RS1addr),
        .IDEX_RS2addr_i (IDEX_RS2addr),
        .EXMEM_RDaddr_i (EXMEM_RDaddr),
        .EXMEM_RegWrite_i (EXMEM_RegWrite),
        .MEMWB_RDaddr_i (MEMWB_RDaddr),
        .MEMWB_RegWrite_i (MEMWB_RegWrite),
        .ForwardA_o (ForwardA),
        .ForwardB_o (ForwardB)
    );

    MUX_3to1 RS1_MUX
    (
        .Forward_i (ForwardA),
        .data1_i (IDEX_RS1data),
        .data2_i (MEMWB_RDdata),
        .data3_i (EXMEM_ALU_result),
        .data_o (ALU_data1)
    );

    MUX_3to1 RS2_MUX
    (
        .Forward_i (ForwardB),
        .data1_i (IDEX_RS2data),
        .data2_i (MEMWB_RDdata),
        .data3_i (EXMEM_ALU_result),
        .data_o (RS2_MUX_data)
    );

    MUX ALUSrc_MUX
    (
        .data1_i (RS2_MUX_data),
        .data2_i (IDEX_imm),
        .select_i (IDEX_ALUSrc),
        .data_o (ALU_data2)
    );

    ALU_Control ALU_Control
    (
        .funct_i (IDEX_funct),
        .ALUOp_i (IDEX_ALUOp),
        .ALUCtrl_o (ALUCtrl)
    );

    ALU ALU
    (
        .data1_i (ALU_data1),
        .data2_i (ALU_data2),
        .ALUCtrl_i (ALUCtrl),
        .ALU_result_o (ALU_result)
    );

    //MEM
    Data_Memory Data_Memory
    (
        .clk_i (clk_i),
        .addr_i (EXMEM_ALU_result),
        .MemRead_i (EXMEM_MemRead),
        .MemWrite_i (EXMEM_MemWrite),
        .data_i (DatatoMemory),
        .data_o (Memory_data)
    );

    //WB
    MUX MemtoReg_MUX
    (
        .data1_i (MEMWB_ALU_result),
        .data2_i (MEMWB_Memory_data),
        .select_i (MEMWB_MemtoReg),
        .data_o (MEMWB_RDdata)
    );

    //pipeline registers
    IFID IFID
    (
        .clk_i (clk_i),
        .rst_i (rst_i),
        .instr_addr_i (instr_addr),
        .instr_i (instr),
        .Write_i (IFIDWrite_reg),
        .flush_i (Flush_reg),
        .instr_addr_o (IFID_instr_addr),
        .instr_o (IFID_instr)
    );
    
    IDEX IDEX
    (
        .clk_i (clk_i),
        .rst_i (rst_i),
        .RegWrite_i (RegWrite),
        .MemtoReg_i (MemtoReg),
        .MemRead_i (MemRead),
        .MemWrite_i (MemWrite),
        .ALUOp_i (ALUOp),
        .ALUSrc_i (ALUSrc),
        .RS1data_i (IFID_RS1data),
        .RS2data_i (IFID_RS2data),
        .constant_i (imm),
        .funct_i ({IFID_instr[31:25],IFID_instr[14:12]}),
        .RS1addr_i (IFID_instr[19:15]),
        .RS2addr_i (IFID_instr[24:20]),
        .RDaddr_i (IFID_instr[11:7]),
        .RegWrite_o (IDEX_RegWrite),
        .MemtoReg_o (IDEX_MemtoReg),
        .MemRead_o (IDEX_MemRead),
        .MemWrite_o (IDEX_MemWrite),
        .ALUOp_o (IDEX_ALUOp),
        .ALUSrc_o (IDEX_ALUSrc),
        .RS1data_o (IDEX_RS1data),
        .RS2data_o (IDEX_RS2data),
        .constant_o (IDEX_imm),
        .funct_o (IDEX_funct),
        .RS1addr_o (IDEX_RS1addr),
        .RS2addr_o (IDEX_RS2addr),
        .RDaddr_o (IDEX_RDaddr)
    );

    EXMEM EXMEM
    (
        .clk_i (clk_i),
        .rst_i (rst_i),
        .RegWrite_i (IDEX_RegWrite),
        .MemtoReg_i (IDEX_MemtoReg),
        .MemRead_i (IDEX_MemRead),
        .MemWrite_i (IDEX_MemWrite),
        .ALU_result_i (ALU_result),
        .DatatoMem_i (RS2_MUX_data),
        .RDaddr_i (IDEX_RDaddr),
        .RegWrite_o (EXMEM_RegWrite),
        .MemtoReg_o (EXMEM_MemtoReg),
        .MemRead_o (EXMEM_MemRead),
        .MemWrite_o (EXMEM_MemWrite),
        .ALU_result_o (EXMEM_ALU_result),
        .DatatoMem_o (DatatoMemory),
        .RDaddr_o (EXMEM_RDaddr)
    );

    MEMWB MEMWB
    (
        .clk_i (clk_i),
        .rst_i (rst_i),
        .RegWrite_i (EXMEM_RegWrite),
        .MemtoReg_i (EXMEM_MemtoReg),
        .ALU_result_i (EXMEM_ALU_result),
        .Memory_data_i (Memory_data),
        .RDaddr_i (EXMEM_RDaddr),
        .RegWrite_o (MEMWB_RegWrite),
        .MemtoReg_o (MEMWB_MemtoReg),
        .ALU_result_o (MEMWB_ALU_result),
        .Memory_data_o (MEMWB_Memory_data),
        .RDaddr_o (MEMWB_RDaddr)
    );
endmodule