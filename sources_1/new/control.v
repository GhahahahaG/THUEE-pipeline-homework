`timescale 1ns / 1ps


module control(
input [5:0]opcode,
input [5:0]functcode,
output reg[1:0] pcsrc,// ��������PC+4 00  PC+4��ƫ�� 01  $rs��jr�� 10, 11 j/jal
output reg extop,
output reg luop, // for lui
output reg alusrc1, //�ж�ʹ������busB������ 0 or ������ 1
output reg alusrc2, // ���srl,sll,sra,�Ƿ�ʹ��shamet(1)
output reg [1:0]regdst,// ����Ҫд�� $rt 00 $rd 01 $ra 10
output reg memwr,
output reg branch,
output reg [1:0]memtoreg, // ����Ҫ�� �洢���е�ֵ01��ALU�����ֵ00��PC+4��ֵ��jal��д���Ĵ�������10
output reg regwr,
output reg memread, // used in hazard unit
output  [1:0]btz, // 00 for bltz ;01 for bgtz; 10 for blez
output  [3:0]aluop //�ж�alu��ִ�к������㣬�ӡ��ˡ���������
    );
    //��ָ���opcode��functcode�����������ɺ��ֿ���ָ��
    // ��ID�׶�ʹ��controlģ�飬�������ɿ����ź�
    
    always@(*)begin
        if(opcode==6'h0)
        begin //R instruction
            case(functcode)
                6'h20,6'h22,6'h21,6'h23,6'h25,6'h24,6'h26,6'h27 ://add ,addu, sub,subu,and,or,xor,nor
                begin
                pcsrc=2'b00;
                extop=1'b0;
                luop=1'b0;
                alusrc1=1'b0;
                alusrc2=1'b0;
                regdst=2'b01;
                memwr=1'b0;
                branch=1'b0;
                memtoreg=2'b00;
                regwr=1'b1;
                memread=1'b0;
                end
                
               6'h0,6'h2,6'h3: // sll,srl,sra
               begin
               pcsrc=2'b00;
               extop=1'b1;
               luop=1'b0;
               alusrc1=1'b0; 
               alusrc2=1'b1;// use shamt!!!
               regdst=2'b01; // rd
               memwr=1'b0;
               branch=1'b0;
               memtoreg=2'b00;
               regwr=1'b1;
               memread=1'b0;
               
               end
               
                6'h8: // jr
                 begin
                 pcsrc=2'b10;
                 extop=1'b1;
                 luop=1'b0;
                 alusrc1=1'b0; 
                 alusrc2=1'b0;
                 regdst=2'b00; 
                 memwr=1'b0;
                 branch=1'b0;
                 memtoreg=2'b00;
                 regwr=1'b0;
                 memread=1'b0;
                 
                 end
                 
                 6'h9: // jalr
                 //Ҳ�������⣿����
                  begin
                  pcsrc=2'b10;
                  extop=1'b0;
                  luop=1'b0;
                  alusrc1=1'b0; 
                  alusrc2=1'b0;
                  regdst=2'b00; 
                  memwr=1'b0;
                  branch=1'b0;
                  memtoreg=2'b10;// PC+4
                  regwr=1'b1;
                  memread=1'b0;
                  
                  end
                 
                 
                 
                  6'h2a,6'h2b: // slt,sltu
                 begin
                 pcsrc=2'b00;
                 extop=1'b0;
                 luop=1'b0;
                 alusrc1=1'b0; 
                 alusrc2=1'b0;
                 regdst=2'b01; 
                 memwr=1'b0;
                 branch=1'b0;
                 memtoreg=2'b00;
                 regwr=1'b1;
                 memread=1'b0;
                 
                 end
                 endcase
                 
                 
          end
        else begin // NOT R
        if(opcode==6'h23)begin // Lw
          pcsrc=2'b00;
            extop=1'b1;
            luop=1'b0;
            alusrc1=1'b1;  // imm number
            alusrc2=1'b0;
            regdst=2'b00;//rt 
            memwr=1'b0;
            branch=1'b0;
            memtoreg=2'b01; // from mem
            regwr=1'b1;
            memread=1'b1;
        end
        // checked!
        
        if(opcode==6'h2b)begin // sw
          pcsrc=2'b00;
            extop=1'b1;
            luop=1'b0;
            alusrc1=1'b1;  // imm number
            alusrc2=1'b0;
            regdst=2'b00;//rt 
            memwr=1'b1;
            branch=1'b0;
            memtoreg=2'b01; // from mem
            regwr=1'b0;
            memread=1'b0;
        end
        // checked!
        
         if((opcode==6'h8)||(opcode==6'h9))begin // addi ,addiu
         pcsrc=2'b00;
           extop=1'b1;
           luop=1'b0;
           alusrc1=1'b1;  // imm number
           alusrc2=1'b0;
           regdst=2'b00;//rt 
           memwr=1'b0;
           branch=1'b0;
           memtoreg=2'b00; // from alu
           regwr=1'b1;
           memread=1'b0;
       end
        // checked!
         if(opcode==6'hc)begin // andi , in which i is Zero-ext-imm
               pcsrc=2'b00;
                 extop=1'b0;
                 luop=1'b0;
                 alusrc1=1'b1;  // imm number
                 alusrc2=1'b0;
                 regdst=2'b00;//rt 
                 memwr=1'b0;
                 branch=1'b0;
                 memtoreg=2'b00; // from alu
                 regwr=1'b1;
                 memread=1'b0;
             end
        // checked!
        if((opcode==6'hb)||(opcode==6'ha))begin // sltiu and slti
       pcsrc=2'b00;
         extop=1'b1;
         luop=1'b0;
         alusrc1=1'b1;  // imm number
         alusrc2=1'b0;
         regdst=2'b00;//rt 
         memwr=1'b0;
         branch=1'b0;
         memtoreg=2'b00; // from alu
         regwr=1'b1;
         memread=1'b0;
     end
        // checked!!
         if(opcode==6'hf)begin // lui
          pcsrc=2'b00;
            extop=1'b1;
            luop=1'b1;
            alusrc1=1'b1;  // imm number
            alusrc2=1'b0;
            regdst=2'b00;//rt 
            memwr=1'b0;
            branch=1'b0;
            memtoreg=2'b00; // from alu
            regwr=1'b1;
            memread=1'b0;
        end
               // checked!!
        
        if(opcode==6'h2)begin // j
         pcsrc=2'b11;
           extop=1'b0;
           luop=1'b0;
           alusrc1=1'b1;  // imm number
           alusrc2=1'b0;
           regdst=2'b00;//rt 
           memwr=1'b0;
           branch=1'b0;
           memtoreg=2'b00; // from alu
           regwr=1'b0;
           memread=1'b0;
       end
              // checked!!
         if(opcode==6'h3)begin // jal
          pcsrc=2'b11;
            extop=1'b0;
            luop=1'b0;
            alusrc1=1'b1;  // imm number
            alusrc2=1'b0;
            regdst=2'b10;//ra
            memwr=1'b0;
            branch=1'b0;
            memtoreg=2'b10; // from PC+4
            regwr=1'b1;
            memread=1'b0;
        end
               // checked!!
         if(opcode==6'h4)begin // beq
        pcsrc=2'b00; //����Ϊ������������PC+4׼��
        //�������EX�׶Σ�������ʵ��Ҫ��ת������EX�׶θ�PC
          extop=1'b0;
          luop=1'b0;
          alusrc1=1'b0;  // imm number
          alusrc2=1'b0;
          regdst=2'b00;//ra
          memwr=1'b0;
          branch=1'b1;//֤���Ƿ�ָ֧��
          memtoreg=2'b00; // from PC+4
          regwr=1'b0;
          memread=1'b0;
      end
             // checked!!
             
          if(opcode==6'h5)begin // bne
      pcsrc=2'b00; //����Ϊ������������PC+4׼��
     //�������EX�׶Σ�������ʵ��Ҫ��ת������EX�׶θ�PC
       extop=1'b0;
       luop=1'b0;
       alusrc1=1'b0;  // imm number
       alusrc2=1'b0;
       regdst=2'b00;//ra
       memwr=1'b0;
       branch=1'b1;//֤���Ƿ�ָ֧��
       memtoreg=2'b00; // from PC+4
       regwr=1'b0;
       memread=1'b0;
   end
          // checked!!
         if(opcode==6'h1c)begin // mul
           pcsrc=2'b00;
             extop=1'b1;
             luop=1'b0;
             alusrc1=1'b0;  // imm number
             alusrc2=1'b0;
             regdst=2'b01;//rd
             memwr=1'b0;
             branch=1'b0;
             memtoreg=2'b00; // fromalu
             regwr=1'b1;
             memread=1'b0;
         end
         
         if(opcode==6'h1||opcode==6'h7)begin // bgtz bltz
                    pcsrc=2'b00;
                      extop=1'b0;
                      luop=1'b0;
                      alusrc1=1'b0;  // imm number
                      alusrc2=1'b0;
                      regdst=2'b00;//rd
                      memwr=1'b0;
                      branch=1'b1;
                      memtoreg=2'b00; // fromalu
                      regwr=1'b0;
                      memread=1'b0;
                  end
         
         
                // checked!!
        end
    
    end
    
     assign btz =  (opcode==6'h6)?2'b10:
     (opcode==6'h7)?2'b01:
     (opcode==6'h1)?2'b00:2'b00;
    // 00 for bltz ;01 for bgtz; 10 for blez
    //���濪ʼ����aluop���ó�alu�ý���ʲô����
    
    assign aluop[2:0] = 
            (opcode == 6'h0)? 3'b010: 
            ((opcode == 6'h4)||(opcode == 6'h5)||(opcode == 6'h1)||(opcode == 6'h6)||(opcode == 6'h7))? 3'b001:  //��֧��ģ�beq+bne+bltz+bgtz+blez
            (opcode == 6'h0c)? 3'b100: // andi
            (opcode == 6'h0a || opcode == 6'h0b)? 3'b101: //slti��sltiu
            (opcode == 6'h1c && functcode == 6'h02)? 3'b110://ori
            3'b000; //mul others
            
        assign aluop[3] = opcode[0];
    
endmodule
// OK 7.1