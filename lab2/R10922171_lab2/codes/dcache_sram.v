module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i; //cpu index
input    [24:0]    tag_i; //cpu tag
input    [255:0]   data_i; //cpu data
input              enable_i; //是否使用cache
input              write_i; //是否寫入cache

output   [24:0]    tag_o; //cache tag
output   [255:0]   data_o; //cache data
output             hit_o; //cache hit


// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];

integer            i, j;


// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
reg count[0:15][0:1];
wire hit0, hit1;

always@(negedge rst_i)begin
    for (i=0;i<16;i = i + 1) begin
        for (j=0;j<2;j=j+1) begin
            tag[i][j] <= 25'b0;
            data[i][j] <= 256'b0;
            count[i][j] <= 1'b0;
        end
    end
end

always@(posedge clk_i) begin
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        if(hit0)begin
            tag[addr_i][0] <= tag_i;
            data[addr_i][0] <= data_i;
            count[addr_i][0] <= 1'b1;
            count[addr_i][1] <= 1'b0;
        end
        else if(hit1)begin
            tag[addr_i][1] <= tag_i;
            data[addr_i][1] <= data_i;
            count[addr_i][1] <= 1'b1;
            count[addr_i][0] <= 1'b0;
        end
        else begin
            if(count[addr_i][1] == 1'b1)begin
                tag[addr_i][0] <= tag_i;
                data[addr_i][0] <= data_i;
                count[addr_i][0] <= 1'b1;
                count[addr_i][1] <= 1'b0;
            end
            else begin
                tag[addr_i][1] <= tag_i;
                data[addr_i][1] <= data_i;
                count[addr_i][1] <= 1'b1;
                count[addr_i][0] <= 1'b0;
            end
        end
    end
end

always@(posedge clk_i)begin
    if(enable_i && ~write_i)begin
        if(hit0)begin
            count[addr_i][0] <= 1'b1;
            count[addr_i][1] <= 1'b0;
        end
        else if(hit1)begin
            count[addr_i][1] <= 1'b1;
            count[addr_i][0] <= 1'b0;
        end
        else begin
            if(count[addr_i][1] == 1'b1)begin
                count[addr_i][0] <= 1'b1;
                count[addr_i][1] <= 1'b0;
            end
            else begin
                count[addr_i][1] <= 1'b1;
                count[addr_i][0] <= 1'b0;
            end
        end
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?
assign hit0 = (tag[addr_i][0][22:0] == tag_i[22:0] && tag[addr_i][0][24])? 1'b1 : 1'b0;
assign hit1 = (tag[addr_i][1][22:0] == tag_i[22:0] && tag[addr_i][1][24])? 1'b1 : 1'b0;
assign hit_o = hit1 | hit0;
assign tag_o = enable_i? (hit0? tag[addr_i][0] : (hit1? tag[addr_i][1] : ((count[addr_i][1] == 1'b1)? tag[addr_i][0] : tag[addr_i][1]))) : 25'b0;
assign data_o = enable_i? (hit0? data[addr_i][0] : (hit1? data[addr_i][1] : ((count[addr_i][1] == 1'b1)? data[addr_i][0] : data[addr_i][1]))) : 256'b0;

endmodule
