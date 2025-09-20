
module MEM(
input reset,
input clk,

input ex_mem_memwr,
input ex_mem_memread,
input [1:0] ex_mem_memtoreg,
input ex_mem_regwrite,

input [31 : 0] ex_mem_pc_plus_4,
input [31 : 0] ex_mem_aluout,
input [31 : 0] ex_mem_busB,
input [4 : 0] ex_mem_regwraddress,

output reg[1:0] mem_wb_memtoreg_out,
output  reg mem_wb_regwrite_out,

output reg[31 : 0] mem_wb_pc_plus_4_out,
output reg[31 : 0] mem_wb_aluout_out,
output reg[4 : 0] mem_wb_regwraddress_out,
output reg[31:0] data_read_from_mem,
output [11:0] leds //汇编指令使用sw向特定地址存入LED的控制信号，然后我们直接取出来用
    );
    
    wire [31:0] readfrommem;
  DataMemory DM(
        .reset(reset)    , 
        .clk(clk)      ,  
        .MemRead(ex_mem_memread)  ,
        .MemWrite(ex_mem_memwr) ,
        .Address(ex_mem_aluout)    ,
        . Write_data(ex_mem_busB) ,
        .Read_data(readfrommem),
        .leds(leds)
    );
    
    always @(posedge clk or posedge reset)begin
    if(reset)begin
    mem_wb_memtoreg_out<=2'b00;
    mem_wb_regwrite_out<=1'b0;
   mem_wb_pc_plus_4_out<=32'd0;
   mem_wb_aluout_out<=32'd0;
   mem_wb_regwraddress_out<=32'd0;
   data_read_from_mem<=32'd0;
    end
    else begin
     mem_wb_memtoreg_out<=ex_mem_memtoreg;
      mem_wb_regwrite_out<=ex_mem_regwrite;
      mem_wb_pc_plus_4_out<=ex_mem_pc_plus_4;
      mem_wb_aluout_out<=ex_mem_aluout;
      mem_wb_regwraddress_out<=ex_mem_regwraddress;
      data_read_from_mem<=readfrommem;
    
    end
    end
    
    
    
    // OK 7.1
    
    
    
    
    
endmodule
