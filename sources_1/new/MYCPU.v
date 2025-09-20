`timescale 1ns / 1ps

module MYCPU(
input clk,
input reset,
output [11:0]leds
    );
    
    wire dojump;
    wire dobranch;
    wire [31:0]jumpaddress;
    wire [31:0]branchaddress;
    wire [31:0]if_id_pc_plus_4;
    wire [31:0]if_id_instr;
    wire [1:0]control_if_id;
    wire flush_id_ex;
    wire pckeep;
    wire [5:0]id_ex_opcode;
    wire id_ex_memread;
    wire [4:0]id_ex_rt;
   
     wire mem_regWrite_out; // WB带来的控制信号
     wire [4 : 0] mem_regWriteAddr_out; // WB带来的写入地址
     wire [31 : 0] mem_regWriteData_out; // WB带来的写入数据
     
     
     
        //output reg extop_out,
        //output reg luop_out, // for lui
        wire id_ex_alusrc1; //判断使用来自busB的数据 0 or 立即数 1
        wire id_ex_alusrc2; // 针对srl,sll,sra,是否使用shamet
        wire [1:0]id_ex_regdst;// 可能要写到 $rt 00 $rd 01 $ra 10
        wire id_ex_memwr;
        wire id_ex_branch;
        wire [1:0]id_ex_memtoreg;// 可能要把 存储器中的值01、ALU计算的值00、PC+4的值（jal）写到寄存器堆中10
        wire id_ex_regwr;
        wire[1:0]id_ex_btz;
     wire[4:0] id_ex_alucon;
    wire id_ex_sign;
    //指令中包含的数据信息
    
    wire [4:0]id_ex_rd;
    wire[31:0]id_ex_ext_imm;
    wire[5:0]id_ex_fuc;
    wire[31:0]id_ex_shamt;
    wire[31:0] id_ex_registerbusA;
    wire[31:0] id_ex_registerbusB;
    wire[31:0] id_ex_id_pc4;
    wire [4:0]id_ex_rs;
  
     wire [1:0] id_ex_pcsrc_out; //?????????????????????????
     
      wire ex_mem_memwr;
        wire ex_mem_memread;
        wire [1:0] ex_mem_memtoreg;
        wire ex_mem_regwrite_out;
        
        wire [31 : 0] ex_mem_pc_plus_4_out;
        wire [31 : 0] ex_mem_aluout;
        wire [31 : 0] ex_mem_busB;
        wire [4 : 0] ex_mem_regwraddress;
     wire [1:0]forwardA;
     wire[1:0]forwardB;
     wire[1:0] mem_wb_memtoreg_out;
     wire[31 : 0] mem_wb_pc_plus_4_out;
     wire[31 : 0] mem_wb_aluout_out;
     wire[31:0] mem_wb_data_read_from_mem;
     wire[11:0]ledmid;
     
     
     
    IF IFreal(
    .clk(clk),
   .reset(reset),
    .dojump(dojump),
    .pc_keep(pckeep), //flush时候 keep PC
    .dobranch(dobranch),// zero&&isbranch,应该在EX阶段产生并送入
    .jumpaddress(jumpaddress),
    .branchaddress(branchaddress),
    .if_id_pc4in(if_id_pc_plus_4),
    .if_id_instrin(if_id_instr),//此时IF/ID寄存器存的值，如果flush，则可能把这两个再输出
    .next_condition(control_if_id),// whether to flush
    .if_id_pc4out(if_id_pc_plus_4),
    .if_id_instrout(if_id_instr)
        );
    
    
    hazard hazardreal(
        .reset(reset),
        .id_ex_memread(id_ex_memread),
        .id_ex_rt(id_ex_rt),
        .if_id_rs(if_id_instr[25:21]),
        .if_id_rt(if_id_instr[20:16]),   // for load-use
        .dojump(dojump), // for j/jal/jr
        .dobranch(dobranch),// for beq bne
        .pckeep(pckeep),
        .control_if_id(control_if_id), // 00 go on   ; 01 flush  ;10 keep
        .flush_id_ex(flush_id_ex)
            );
    
    
    
    
 
     ID IDreal(
        .clk(clk),
        .reset(reset),
        .whetherflush(flush_id_ex),
        //IF/ID级间寄存器数据
        .pc4(if_id_pc_plus_4),
        .instruction(if_id_instr),
        //不需要传入ID/EX寄存器的数据，因为ID/EX要不然正常go on，要不然flush清零
        
        //可能有数据需要写回到寄存器堆中
        .regWrite(mem_regWrite_out), // WB带来的控制信号
        .regWriteAddr(mem_regWriteAddr_out), // WB带来的写入地址
        .regWriteData(mem_regWriteData_out), // WB带来的写入数据
        
        //是否jump
        .whetherjump(dojump),
        .jumpaddress(jumpaddress),
        //输出数据，包括一大堆控制信号+指令中包含的数据信息
        //控制信号
        .pcsrc_out(id_ex_pcsrc_out),// 可能来自PC+4 00  PC+4再偏移 01  $rs（jr） 10, 11 j/jal
        //output reg extop_out,
        //output reg luop_out, // for lui
        .alusrc1_out(id_ex_alusrc1), //判断使用来自busB的数据 0 or 立即数 1
        .alusrc2_out(id_ex_alusrc2), // 针对srl,sll,sra,是否使用shamet
        .regdst_out(id_ex_regdst),// 可能要写到 $rt 00 $rd 01 $ra 10
        . memwr_out(id_ex_memwr),
        .branch_out(id_ex_branch),
        .memtoreg_out(id_ex_memtoreg), // 可能要把 存储器中的值01、ALU计算的值00、PC+4的值（jal）写到寄存器堆中10
        .regwr_out(id_ex_regwr),
        .memread_out(id_ex_memread), // used in hazard unit
        .btz_out(id_ex_btz), // 00 for bltz ;01 for bgtz; 10 for blez
        //output  reg[3:0]aluop_out,
        .alucon(id_ex_alucon),
        .sign(id_ex_sign),
        //指令中包含的数据信息
        .rs(id_ex_rs),
        .rt(id_ex_rt),
         .rd(id_ex_rd),
       .ext_imm(id_ex_ext_imm),
       .fuc(id_ex_fuc),
       .shamt(id_ex_shamt),
       .registerbusA(id_ex_registerbusA),
       .registerbusB(id_ex_registerbusB),
       .id_pc4(id_ex_id_pc4),
       .opcode_out(id_ex_opcode)
            );
    
    
    
    forward_unit forward_unitreal(
            .ex_mem_regwrite(ex_mem_regwrite_out),
            .ex_mem_regwraddr(ex_mem_regwraddress),
           .mem_wb_regwrite(mem_regWrite_out),
            .mem_wb_regwraddr(mem_regWriteAddr_out),
            .id_ex_rs(id_ex_rs),
            .id_ex_rt(id_ex_rt),
            .forwardA(forwardA),
            .forwardB(forwardB)
                );
    
    
    
    EX EXreal(
            .clk(clk),
            .reset(reset),
            // 数据旁路
            .forwardA(forwardA),
            .forwardB(forwardB),
            .ex_mem_data(ex_mem_aluout),
            .mem_wb_data(mem_regWriteData_out), 
             
            .opcode(id_ex_opcode),
            
            
            // ID 写到ID/EX 寄存器里的数据 
            .pcsrc_out(id_ex_pcsrc_out),// 可能来自PC+4 00  PC+4再偏移 01  $rs（jr） 10, 11 j/jal
            .alusrc1_out(id_ex_alusrc1), //判断使用来自busB的数据 0 or 立即数 1
            .alusrc2_out(id_ex_alusrc2), // 针对srl,sll,sra,是否使用shamet
            .regdst_out(id_ex_regdst),// 可能要写到 $rt 00 $rd 01 $ra 10
            .memwr_out(id_ex_memwr),
            .branch_out(id_ex_branch),
            .memtoreg_out(id_ex_memtoreg), // 可能要把 存储器中的值01、ALU计算的值00、PC+4的值（jal）写到寄存器堆中10
            .regwr_out(id_ex_regwr),
            .memread_out(id_ex_memread), // used in hazard unit
            .btz_out(id_ex_btz), // 00 for bltz ;01 for bgtz; 10 for blez
            .alucon(id_ex_alucon),
           .sign(id_ex_sign),
            //指令中包含的数据信息
            .rs(id_ex_rs),
            .rt(id_ex_rt),
            .rd(id_ex_rd),
            .ext_imm(id_ex_ext_imm),
            .fuc(id_ex_fuc),
            .shamt(id_ex_shamt),
            .registerbusA(id_ex_registerbusA),
            .registerbusB(id_ex_registerbusB),
            .id_pc4(id_ex_id_pc4),
            
            // for branch
            .whether_branch(dobranch),
            .branch_address(branchaddress),
            
            .ex_mem_memwr(ex_mem_memwr),
            . ex_mem_memread(ex_mem_memread),
            .ex_mem_memtoreg(ex_mem_memtoreg),
           .ex_mem_regwrite_out(ex_mem_regwrite_out),
            
            . ex_mem_pc_plus_4_out(ex_mem_pc_plus_4_out),
            .ex_mem_aluout(ex_mem_aluout),
            .ex_mem_busB(ex_mem_busB),
            .ex_mem_regwraddress(ex_mem_regwraddress)
            
                );
                
            
        MEM MEMreal(
                .reset(reset),
                .clk(clk),
                
                .ex_mem_memwr(ex_mem_memwr),
               . ex_mem_memread(ex_mem_memread),
               .ex_mem_memtoreg(ex_mem_memtoreg),
              .ex_mem_regwrite(ex_mem_regwrite_out),
               
               . ex_mem_pc_plus_4(ex_mem_pc_plus_4_out),
               .ex_mem_aluout(ex_mem_aluout),
               .ex_mem_busB(ex_mem_busB),
               .ex_mem_regwraddress(ex_mem_regwraddress),
                
                .mem_wb_memtoreg_out(mem_wb_memtoreg_out),
                .mem_wb_regwrite_out(mem_regWrite_out),
               .mem_wb_pc_plus_4_out(mem_wb_pc_plus_4_out),
                .mem_wb_aluout_out(mem_wb_aluout_out),
                .mem_wb_regwraddress_out(mem_regWriteAddr_out),
                .data_read_from_mem(mem_wb_data_read_from_mem),
                .leds(ledmid) //汇编指令使用sw向特定地址存入LED的控制信号，然后我们直接取出来用
                    );
    
    
     WB WBreal(
                    // MEM 写入MEM/WB寄存器里的值
                   .mem_wb_memtoreg_out(mem_wb_memtoreg_out),
                    .mem_wb_pc_plus_4_out(mem_wb_pc_plus_4_out),
                    .mem_wb_aluout_out(mem_wb_aluout_out),
                    .data_read_from_mem(mem_wb_data_read_from_mem),
                    // choose 1 from these 3
                    .write_to_reg_data(mem_regWriteData_out)
                        );
                        
                        
          assign leds=ledmid;
    
endmodule
//ok 7.1