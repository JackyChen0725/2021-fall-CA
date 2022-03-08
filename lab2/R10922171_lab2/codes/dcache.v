module dcache
(
    // System clock, reset and stall
    clk_i, 
    rst_i,
    
    // to Data Memory interface        
    mem_data_i, 
    mem_ack_i,     
    mem_data_o, 
    mem_addr_o,     
    mem_enable_o, 
    mem_write_o, 
    
    // to CPU interface    
    cpu_data_i, 
    cpu_addr_i,     
    cpu_MemRead_i, 
    cpu_MemWrite_i, 
    cpu_data_o, 
    cpu_stall_o
);
//
// System clock, start
//
input                 clk_i; 
input                 rst_i;

//
// to Data_Memory interface        
//
input    [255:0]      mem_data_i; //從memory搬上來的data
input                 mem_ack_i; //指出memory是否完成
    
output   [255:0]      mem_data_o; //要寫回memory的data
output   [31:0]       mem_addr_o; //要寫回的block no.    
output                mem_enable_o; //是否使用memory
output                mem_write_o; //是否寫入memory
    
//    
// to CPU interface            
//    
input    [31:0]       cpu_data_i; //要寫入cache的data
input    [31:0]       cpu_addr_i; //要寫入cache的block no.    
input                 cpu_MemRead_i; 
input                 cpu_MemWrite_i; 

output   [31:0]       cpu_data_o; //從cache讀出來的data
output                cpu_stall_o; //當miss時從cache傳出的stall

//
// to SRAM interface
//
wire    [3:0]         cache_sram_index; //傳給cache的cpu address
wire                  cache_sram_enable; //是否使用cache
wire    [24:0]        cache_sram_tag; //傳給cache的cpu address
wire    [255:0]       cache_sram_data; //傳給cache的data
wire                  cache_sram_write; //是否寫入cache
wire    [24:0]        sram_cache_tag; //cache line中的valid + dirty + tag bit
wire    [255:0]       sram_cache_data; //cache line中的data
wire                  sram_cache_hit; //cache傳出的hit


// cache
wire                  sram_valid;
wire                  sram_dirty;

// controller
parameter             STATE_IDLE         = 3'h0, //controller閒置
                      STATE_READMISS     = 3'h1, //readmiss但不用write back，等memory把block搬上來
                      STATE_READMISSOK   = 3'h2, //置換完成
                      STATE_WRITEBACK    = 3'h3, //readmiss且須做write back
                      STATE_MISS         = 3'h4; //readmiss
reg     [2:0]         state; //儲存狀態
reg                   mem_enable; //是否使用memory
reg                   mem_write; //是否寫入memory
reg                   cache_write; //是否寫入cache
wire                  cache_dirty; //cache block是否為髒
reg                   write_back; //是否需寫回memory

// regs & wires
wire    [4:0]         cpu_offset; //cpu address
wire    [3:0]         cpu_index; //cpu address
wire    [22:0]        cpu_tag; //cpu address
wire    [255:0]       r_hit_data;
wire    [21:0]        sram_tag; //cache中的tag bit
wire                  hit; //read hit or write hit
reg     [255:0]       w_hit_data;
wire                  write_hit;
wire                  cpu_req; //cpu要求存取cache
reg     [31:0]        cpu_data; //讀出來給cpu的data

// to CPU interface
assign    cpu_req     = cpu_MemRead_i | cpu_MemWrite_i; //cpu要求存取cache
assign    cpu_tag     = cpu_addr_i[31:9]; //cpu address
assign    cpu_index   = cpu_addr_i[8:5]; //cpu address
assign    cpu_offset  = cpu_addr_i[4:0]; //cpu address
assign    cpu_stall_o = ~hit & cpu_req; //有cpu request且沒有hit就暫停
assign    cpu_data_o  = cpu_data; //讀出來給cpu的data

// to SRAM interface
assign    sram_valid = sram_cache_tag[24]; //cache line中的valid bit
assign    sram_dirty = sram_cache_tag[23]; //cache line中的dirty bit
assign    sram_tag   = sram_cache_tag[22:0]; //cache line中的tag bit
assign    cache_sram_index  = cpu_index; //cache controller用來比對cache index
assign    cache_sram_enable = cpu_req; //表示是否使用cache
assign    cache_sram_write  = cache_write | write_hit; //表示是否寫入cache，cache write為從memory寫入cache;write hit為從cpu寫入cache
assign    cache_sram_tag    = {1'b1, cache_dirty, cpu_tag}; //valid + dirty + tag bit
assign    cache_sram_data   = (hit) ? w_hit_data : mem_data_i; //看是從memory寫入或從cpu寫入

// to Data_Memory interface
assign    mem_enable_o = mem_enable; //是否使用memory
assign    mem_addr_o   = (write_back) ? {sram_tag, cpu_index, 5'b0} : {cpu_tag, cpu_index, 5'b0}; //若有write back，address用來將原本cache中的block搬回memory;否則，address用來告訴memory要搬哪個block到cache
assign    mem_data_o   = sram_cache_data; //要write back回memory的block
assign    mem_write_o  = mem_write; //若有write back mem_write就為1

assign    write_hit    = hit & cpu_MemWrite_i; //要被write的block存在cache中
assign    cache_dirty  = write_hit; //只要有寫入block，dirty bit設1

// TODO: add your code here!  (r_hit_data=...?)
assign r_hit_data = (hit)? sram_cache_data : mem_data_i;

// read data :  256-bit to 32-bit
integer  i;
always@(cpu_offset or r_hit_data) begin
    // TODO: add your code here! (cpu_data=...?)
    for(i = 0; i < 32; i++)begin
        cpu_data[i] = r_hit_data[(cpu_offset >> 2) * 32 + i];
    end
end

// write data :  32-bit to 256-bit
always@(cpu_offset or r_hit_data or cpu_data_i) begin
    // TODO: add your code here! (w_hit_data=...?)
    w_hit_data = r_hit_data;
    for(i = 0; i < 32; i++)begin
        w_hit_data[(cpu_offset >> 2) * 32 + i] = cpu_data[i];
    end
end


// controller 
always@(negedge rst_i)begin
    state       <= STATE_IDLE;
    mem_enable  <= 1'b0;
    mem_write   <= 1'b0;
    cache_write <= 1'b0; 
    write_back  <= 1'b0;
end

always@(posedge clk_i) begin
    case(state)        
        STATE_IDLE: begin
            if(cpu_req && !hit) begin      // wait for request
                mem_enable <= 1'b1;
                if(sram_dirty)begin
                    mem_write <= 1'b1;
                    write_back <= 1'b1;
                end
                state <= STATE_MISS;
            end
            else begin
                state <= STATE_IDLE;
            end
        end
        STATE_MISS: begin
            if(sram_dirty) begin          // write back if dirty
                // TODO: add your code here! 
                mem_enable <= 1'b1;
                mem_write <= 1'b1;
                write_back <= 1'b1;
                state <= STATE_WRITEBACK;
            end
            else begin                    // write allocate: write miss = read miss + write hit; read miss = read miss + read hit
                // TODO: add your code here!
                mem_enable <= 1'b1;
                mem_write <= 1'b0;
                write_back <= 1'b0; 
                state <= STATE_READMISS;
            end
        end
        STATE_READMISS: begin
            if(mem_ack_i) begin            // wait for data memory acknowledge
                // TODO: add your code here!
                mem_enable <= 1'b0;
                cache_write <= 1'b1;
                state <= STATE_READMISSOK;
            end
            else begin
                state <= STATE_READMISS;
            end
        end
        STATE_READMISSOK: begin            // wait for data memory acknowledge
            // TODO: add your code here!
            cache_write <= 1'b0;
            state <= STATE_IDLE;
        end
        STATE_WRITEBACK: begin
            if(mem_ack_i) begin            // wait for data memory acknowledge
                // TODO: add your code here!
                mem_write <= 1'b0;
                write_back <= 1'b0;
                state <= STATE_READMISS;
            end
            else begin
                state <= STATE_WRITEBACK;
            end
        end
    endcase
end

//
// SRAM (cache memory part)
//
dcache_sram dcache_sram
(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .addr_i     (cache_sram_index),
    .tag_i      (cache_sram_tag),
    .data_i     (cache_sram_data),
    .enable_i   (cache_sram_enable),
    .write_i    (cache_sram_write),
    .tag_o      (sram_cache_tag),
    .data_o     (sram_cache_data),
    .hit_o      (hit)
);

endmodule
