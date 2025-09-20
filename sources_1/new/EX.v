
// 包含alu  forward  hazard
module EX(
input clk,
input reset,
// 数据旁路
input [1:0]forwardA,
input [1:0]forwardB,
input [31:0]ex_mem_data,
input [31:0]mem_wb_data,  

input [5:0]opcode,


// ID 写到ID/EX 寄存器里的数据 
input [1:0] pcsrc_out,// 可能来自PC+4 00  PC+4再偏移 01  $rs（jr） 10, 11 j/jal
input  alusrc1_out, //判断使用来自busB的数据 0 or 立即数 1
input  alusrc2_out, // 针对srl,sll,sra,是否使用shamet
input  [1:0]regdst_out,// 可能要写到 $rt 00 $rd 01 $ra 10
input  memwr_out,
input  branch_out,
input [1:0]memtoreg_out, // 可能要把 存储器中的值01、ALU计算的值00、PC+4的值（jal）写到寄存器堆中10
input  regwr_out,
input  memread_out, // used in hazard unit
input  [1:0]btz_out, // 00 for bltz ;01 for bgtz; 10 for blez
input [4:0] alucon,
input  sign,
//指令中包含的数据信息
input [4:0]rs,
input [4:0]rt,
input [4:0]rd,
input [31:0]ext_imm,
input [5:0]fuc,
input [31:0]shamt,
input [31:0] registerbusA,
input [31:0] registerbusB,
input [31:0]id_pc4,

// for branch
output whether_branch,
output [31:0]branch_address,

output reg ex_mem_memwr,
output reg ex_mem_memread,
output reg [1:0] ex_mem_memtoreg,
output reg ex_mem_regwrite_out,

output reg [31 : 0] ex_mem_pc_plus_4_out,
output reg [31 : 0] ex_mem_aluout,
output reg [31 : 0] ex_mem_busB,
output reg [4 : 0] ex_mem_regwraddress

    );
    /*wire ex_mem_memwr_tmp;
    wire ex_mem_memread_tmp;
    wire [1:0] ex_mem_memtoreg_tmp;
    wire ex_mem_regwrite_out_tmp;
    wire [31 : 0] ex_mem_pc_plus_4_out_tmp;*/
    wire [31 : 0] ex_mem_aluout_tmp;
    /*wire [31 : 0] ex_mem_busB_tmp;
    wire [4 : 0] ex_mem_regwraddress_tmp;*/
    
    wire [31:0]forwardAdata;
    wire [31:0]forwardBdata;
    wire [31:0]in11;
    wire [31:0]in22;   
    wire zero_tmp;
    wire [4:0]towhichreg;
    assign forwardAdata=(forwardA==2'b10)?ex_mem_data:
                 (forwardA==2'b01)?mem_wb_data:registerbusA;
    assign forwardBdata=(forwardB==2'b10)?ex_mem_data:
                  (forwardB==2'b01)?mem_wb_data:registerbusB;
    assign in11 = alusrc2_out ? shamt :forwardAdata;
    assign in22 = alusrc1_out ? ext_imm : forwardBdata;
    // regdst_out,// 可能要写到 $rt 00 $rd 01 $ra 10
    assign towhichreg=(regdst_out==2'b00)?rt:
                        (regdst_out==2'b01)?rd:5'd31;
              wire g;
              wire L;
     ALU aluhhh(
       .in1( in11)      , 
        .in2( in22)      ,
        . ALUCtl(alucon)    ,
        .Sign(sign)               ,
        .out(ex_mem_aluout_tmp) ,
        .zero(zero_tmp),
        .greaterthanzero(g),
            .lower(L)
    );
    
    //assign whether_branch=((opcode==6'h4) && zero_tmp)||((opcode==6'h5) && !zero_tmp)||((btz_out==2'b01)&&g)||((btz_out==2'b00)&&L); 
        assign whether_branch=((opcode==6'h4) && zero_tmp)||((opcode==6'h5) && !zero_tmp);
   // 00 for bltz ;01 for bgtz; 10 for blez
    // beq and bne
    assign branch_address= id_pc4 + {ext_imm[29 : 0], 2'b00};
    
    
    always @(posedge clk or posedge reset)begin
    if(reset)begin
    ex_mem_memwr<=1'b0;
    ex_mem_memread<=1'b0;
    ex_mem_memtoreg<=2'd0;
    ex_mem_regwrite_out<=1'b0;
    ex_mem_pc_plus_4_out<=32'd0;
    ex_mem_aluout<=32'd0;
    ex_mem_busB<=32'd0;
    ex_mem_regwraddress<=32'd0;
    end
    else begin
    ex_mem_memwr<=memwr_out;
    ex_mem_memread<=memread_out;
    ex_mem_memtoreg<=memtoreg_out;
    ex_mem_regwrite_out<=regwr_out;
    
    ex_mem_pc_plus_4_out<=id_pc4;
    ex_mem_aluout<=ex_mem_aluout_tmp;
    ex_mem_busB<=forwardBdata;
    ex_mem_regwraddress<=towhichreg;
    
    end
    
    
    
    end
    
    
    
    
endmodule
// OK 7.1