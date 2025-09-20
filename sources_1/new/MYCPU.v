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
   
     wire mem_regWrite_out; // WB�����Ŀ����ź�
     wire [4 : 0] mem_regWriteAddr_out; // WB������д���ַ
     wire [31 : 0] mem_regWriteData_out; // WB������д������
     
     
     
        //output reg extop_out,
        //output reg luop_out, // for lui
        wire id_ex_alusrc1; //�ж�ʹ������busB������ 0 or ������ 1
        wire id_ex_alusrc2; // ���srl,sll,sra,�Ƿ�ʹ��shamet
        wire [1:0]id_ex_regdst;// ����Ҫд�� $rt 00 $rd 01 $ra 10
        wire id_ex_memwr;
        wire id_ex_branch;
        wire [1:0]id_ex_memtoreg;// ����Ҫ�� �洢���е�ֵ01��ALU�����ֵ00��PC+4��ֵ��jal��д���Ĵ�������10
        wire id_ex_regwr;
        wire[1:0]id_ex_btz;
     wire[4:0] id_ex_alucon;
    wire id_ex_sign;
    //ָ���а�����������Ϣ
    
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
    .pc_keep(pckeep), //flushʱ�� keep PC
    .dobranch(dobranch),// zero&&isbranch,Ӧ����EX�׶β���������
    .jumpaddress(jumpaddress),
    .branchaddress(branchaddress),
    .if_id_pc4in(if_id_pc_plus_4),
    .if_id_instrin(if_id_instr),//��ʱIF/ID�Ĵ������ֵ�����flush������ܰ������������
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
        //IF/ID����Ĵ�������
        .pc4(if_id_pc_plus_4),
        .instruction(if_id_instr),
        //����Ҫ����ID/EX�Ĵ��������ݣ���ΪID/EXҪ��Ȼ����go on��Ҫ��Ȼflush����
        
        //������������Ҫд�ص��Ĵ�������
        .regWrite(mem_regWrite_out), // WB�����Ŀ����ź�
        .regWriteAddr(mem_regWriteAddr_out), // WB������д���ַ
        .regWriteData(mem_regWriteData_out), // WB������д������
        
        //�Ƿ�jump
        .whetherjump(dojump),
        .jumpaddress(jumpaddress),
        //������ݣ�����һ��ѿ����ź�+ָ���а�����������Ϣ
        //�����ź�
        .pcsrc_out(id_ex_pcsrc_out),// ��������PC+4 00  PC+4��ƫ�� 01  $rs��jr�� 10, 11 j/jal
        //output reg extop_out,
        //output reg luop_out, // for lui
        .alusrc1_out(id_ex_alusrc1), //�ж�ʹ������busB������ 0 or ������ 1
        .alusrc2_out(id_ex_alusrc2), // ���srl,sll,sra,�Ƿ�ʹ��shamet
        .regdst_out(id_ex_regdst),// ����Ҫд�� $rt 00 $rd 01 $ra 10
        . memwr_out(id_ex_memwr),
        .branch_out(id_ex_branch),
        .memtoreg_out(id_ex_memtoreg), // ����Ҫ�� �洢���е�ֵ01��ALU�����ֵ00��PC+4��ֵ��jal��д���Ĵ�������10
        .regwr_out(id_ex_regwr),
        .memread_out(id_ex_memread), // used in hazard unit
        .btz_out(id_ex_btz), // 00 for bltz ;01 for bgtz; 10 for blez
        //output  reg[3:0]aluop_out,
        .alucon(id_ex_alucon),
        .sign(id_ex_sign),
        //ָ���а�����������Ϣ
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
            // ������·
            .forwardA(forwardA),
            .forwardB(forwardB),
            .ex_mem_data(ex_mem_aluout),
            .mem_wb_data(mem_regWriteData_out), 
             
            .opcode(id_ex_opcode),
            
            
            // ID д��ID/EX �Ĵ���������� 
            .pcsrc_out(id_ex_pcsrc_out),// ��������PC+4 00  PC+4��ƫ�� 01  $rs��jr�� 10, 11 j/jal
            .alusrc1_out(id_ex_alusrc1), //�ж�ʹ������busB������ 0 or ������ 1
            .alusrc2_out(id_ex_alusrc2), // ���srl,sll,sra,�Ƿ�ʹ��shamet
            .regdst_out(id_ex_regdst),// ����Ҫд�� $rt 00 $rd 01 $ra 10
            .memwr_out(id_ex_memwr),
            .branch_out(id_ex_branch),
            .memtoreg_out(id_ex_memtoreg), // ����Ҫ�� �洢���е�ֵ01��ALU�����ֵ00��PC+4��ֵ��jal��д���Ĵ�������10
            .regwr_out(id_ex_regwr),
            .memread_out(id_ex_memread), // used in hazard unit
            .btz_out(id_ex_btz), // 00 for bltz ;01 for bgtz; 10 for blez
            .alucon(id_ex_alucon),
           .sign(id_ex_sign),
            //ָ���а�����������Ϣ
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
                .leds(ledmid) //���ָ��ʹ��sw���ض���ַ����LED�Ŀ����źţ�Ȼ������ֱ��ȡ������
                    );
    
    
     WB WBreal(
                    // MEM д��MEM/WB�Ĵ������ֵ
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