
//内含一个registerfile 和control
module ID(
input clk,
input reset,

input whetherflush,
//IF/ID级间寄存器数据
input [31:0]pc4,
input [31:0]instruction,
//不需要传入ID/EX寄存器的数据，因为ID/EX要不然正常go on，要不然flush清零

//可能有数据需要写回到寄存器堆中
input regWrite, // WB带来的控制信号
input [4 : 0] regWriteAddr, // WB带来的写入地址
input [31 : 0] regWriteData, // WB带来的写入数据

//是否jump
output whetherjump,
output [31:0]jumpaddress,
//输出数据，包括一大堆控制信号+指令中包含的数据信息
//控制信号
output reg[1:0] pcsrc_out,// 可能来自PC+4 00  PC+4再偏移 01  $rs（jr） 10, 11 j/jal
//output reg extop_out,
//output reg luop_out, // for lui
output reg alusrc1_out, //判断使用来自busB的数据 0 or 立即数 1
output reg alusrc2_out, // 针对srl,sll,sra,是否使用shamet
output reg [1:0]regdst_out,// 可能要写到 $rt 00 $rd 01 $ra 10
output reg memwr_out,
output reg branch_out,
output reg [1:0]memtoreg_out, // 可能要把 存储器中的值01、ALU计算的值00、PC+4的值（jal）写到寄存器堆中10
output reg regwr_out,
output reg memread_out, // used in hazard unit
output  reg[1:0]btz_out, // 00 for bltz ;01 for bgtz; 10 for blez
//output  reg[3:0]aluop_out,
output reg[4:0] alucon,
output reg sign,
//指令中包含的数据信息
output reg[4:0]rs,
output reg[4:0]rt,
output reg[4:0]rd,
output reg[31:0]ext_imm,
output reg[5:0]fuc,
output reg[31:0]shamt,
output reg[31:0] registerbusA,
output reg[31:0] registerbusB,
output reg[31:0]id_pc4,
output reg[5:0]opcode_out
    );
    
      wire[1:0] pcsrc;// 可能来自PC+4 00  PC+4再偏移 01  $rs（jr） 10, 11 j/jal
      wire extop;
      wire luop;// for lui
      wire alusrc1; //判断使用来自busB的数据 0 or 立即数 1
      wire alusrc2; // 针对srl,sll,sra,是否使用shamet
      wire [1:0]regdst;// 可能要写到 $rt 00 $rd 01 $ra 10
      wire memwr;
      wire branch;
      wire [1:0]memtoreg; // 可能要把 存储器中的值01、ALU计算的值00、PC+4的值（jal）写到寄存器堆中10
     wire  regwr;
     wire  memread; // used in hazard unit
     wire   [1:0]btz; // 00 for bltz ;01 for bgtz; 10 for blez
     wire  [3:0]aluop;
     wire [31:0]EXTIMM;
     wire [31:0]IMMOUT;
    wire [4:0]rsmid;
    wire [4:0]rtmid;
   wire [31:0]busA;
   wire [31:0]busB;
   wire [4:0]aluconcon;
   wire signmid;
      assign rsmid=instruction[25:21];
      assign rtmid=instruction[20:16];
     
    wire[5:0] inopcode;
    assign inopcode=instruction[31:26];
    wire [5:0]funct;
    assign funct=instruction[5:0];
    
    control controlunit(
    .opcode(inopcode),
    .functcode(funct),
     .pcsrc(pcsrc),// 可能来自PC+4 00  PC+4再偏移 01  $rs（jr） 10, 11 j/jal
      .extop(extop),
       .luop(luop), // for lui
        .alusrc1(alusrc1), //判断使用来自busB的数据 0 or 立即数 1
        .alusrc2(alusrc2), // 针对srl,sll,sra,是否使用shamet
        .regdst(regdst),// 可能要写到 $rt 00 $rd 01 $ra 10
        .memwr(memwr),
        .branch(branch),
        .memtoreg(memtoreg), // 可能要把 存储器中的值01、ALU计算的值00、PC+4的值（jal）写到寄存器堆中10
        .regwr(regwr),
        .memread(memread),// used in hazard unit
        .btz(btz),
        .aluop(aluop)
    );
    
    
    RegisterFile RF(
       .reset(reset)  , 
       .clk(clk) ,
        .RegWrite  (regWrite),
        .Read_register1(rsmid) , 
        .Read_register2(rtmid) , 
        .Write_register(regWriteAddr) ,
        .Write_data (regWriteData)    ,
        .Read_data1 (busA), 
        .Read_data2 (busB)   
    );
    
    ALUControl aluccccc(
        .ALUOp(aluop)      ,
        .Funct(instruction[5:0])      ,
       .ALUCtl(aluconcon) ,
        . Sign(signmid)
    );
    
    assign EXTIMM = extop ? {{16{instruction[15]}}, instruction[15 : 0]} : {16'h0000, instruction[15 : 0]};
    assign IMMOUT = luop ? {instruction[15 : 0], 16'h0000} : EXTIMM;
    assign whetherjump=((pcsrc==2'b11)||(pcsrc==2'b10))?1'b1:1'b0; // 11 for j and jal  ; 10 for jr
    assign jumpaddress= (pcsrc==2'b11)?{pc4[31 : 28], instruction[25 : 0], 2'b00}:busA;
    //如果是 j or jal, then 伪直接寻址； jr then 根据rs中的值选址
    
    
    always@(posedge clk or posedge reset)begin
    if(reset)begin
    pcsrc_out<=2'b00;// 可能来自PC+4 00  PC+4再偏移 01  $rs（jr） 10, 11 j/jal
   
    alusrc1_out<=1'b0; //判断使用来自busB的数据 0 or 立即数 1
    alusrc2_out<=1'b0;// 针对srl,sll,sra,是否使用shamet
    regdst_out<=2'd0;// 可能要写到 $rt 00 $rd 01 $ra 10
    memwr_out<=1'b0;
    branch_out<=1'b0;
    memtoreg_out<=2'd0;// 可能要把 存储器中的值01、ALU计算的值00、PC+4的值（jal）写到寄存器堆中10
    regwr_out<=1'b0;
    memread_out<=1'b0; // used in hazard unit
    btz_out<=2'd0; // 00 for bltz ;01 for bgtz; 10 for blez
    alucon<=5'd0;
    sign<=1'b0;
    rs<=5'd0;
    rt<=5'd0;
    rd<=5'd0;
    ext_imm<=32'd0;
    fuc<=6'd0;
    shamt<=32'd0;
    registerbusA<=32'd0;
    registerbusB<=32'd0;
    id_pc4<=32'd0;
    opcode_out<=6'd0;
    end
    else begin
    if(whetherflush)begin
   
     pcsrc_out<=2'b00;// 可能来自PC+4 00  PC+4再偏移 01  $rs（jr） 10, 11 j/jal
     
       alusrc1_out<=1'b0; //判断使用来自busB的数据 0 or 立即数 1
       alusrc2_out<=1'b0;// 针对srl,sll,sra,是否使用shamet
       regdst_out<=2'd0;// 可能要写到 $rt 00 $rd 01 $ra 10
       memwr_out<=1'b0;
       branch_out<=1'b0;
       memtoreg_out<=2'd0;// 可能要把 存储器中的值01、ALU计算的值00、PC+4的值（jal）写到寄存器堆中10
       regwr_out<=1'b0;
       memread_out<=1'b0; // used in hazard unit
       btz_out<=2'd0; // 00 for bltz ;01 for bgtz; 10 for blez
        alucon<=5'd0;
          sign<=1'b0;      
       rs<=5'd0;
       rt<=5'd0;
       rd<=5'd0;
       ext_imm<=32'd0;
       fuc<=6'd0;
       shamt<=32'd0;
       registerbusA<=32'd0;
       registerbusB<=32'd0;
       id_pc4<=32'd0;
       opcode_out<=6'd0;
    end
    else begin
     pcsrc_out<=pcsrc;// 可能来自PC+4 00  PC+4再偏移 01  $rs（jr） 10, 11 j/jal 
      
       alusrc1_out<=alusrc1; //判断使用来自busB的数据 0 or 立即数 1
       alusrc2_out<=alusrc2;// 针对srl,sll,sra,是否使用shamet
       regdst_out<=regdst;// 可能要写到 $rt 00 $rd 01 $ra 10
       memwr_out<=memwr;
       branch_out<=branch;
       memtoreg_out<=memtoreg;// 可能要把 存储器中的值01、ALU计算的值00、PC+4的值（jal）写到寄存器堆中10
       regwr_out<=regwr;
       memread_out<=memread; // used in hazard unit
       btz_out<=btz; // 00 for bltz ;01 for bgtz; 10 for blez
       alucon<=aluconcon;
       sign<=signmid;
       rs<=rsmid;
       rt<=rtmid;
       rd<=instruction[15:11];
       ext_imm<=IMMOUT;
       fuc<=instruction[5:0];
       shamt<= {27'h0, instruction[10 : 6]};
       registerbusA<=busA;
       registerbusB<=busB;
       id_pc4<=pc4;
       opcode_out<=inopcode;
    
    
    end
    
    
    
    
    end
    end
    
    
    
    
    
endmodule
//OK 7.1