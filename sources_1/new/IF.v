`timescale 1ns / 1ps
//ȡָ�ָ�������Դ��PC+4��branch��j��jr
//�ڷ�ָ֧���תָ����ת�󣬻���Ҫflush�������Ҫ��IF/ID�Ĵ�����Ķ��������
//Ҫ��IF/ID�Ĵ��������ָ���PC��instr
module IF(
input clk,
input reset,
input dojump,
input pc_keep, //flushʱ�� keep PC
input dobranch,// zero&&isbranch,Ӧ����EX�׶β���������
input [31:0]jumpaddress,
input [31:0]branchaddress,
input [1:0]next_condition,// whether to flush

input [31:0]if_id_pc4in,
input [31:0]if_id_instrin,//��ʱIF/ID�Ĵ������ֵ�����flush������ܰ������������

output reg [31:0]if_id_pc4out,
output reg [31:0]if_id_instrout

    );
    
    //IF��������߼�����
    reg [31:0]pcaddress; //��reset�󣬸�ֵΪ0��֮��ÿһ�����ڣ�Pc+4
    wire [31:0]instruction;
    
    InstructionMemory im1(
    .Address(pcaddress),
    .Instruction(instruction)
    );
    wire [31:0]pc4;
    assign pc4=pcaddress+32'd4;
    wire [31:0]pc_next;
    assign pc_next=pc_keep?pcaddress:
                    dobranch?branchaddress:
                    dojump?jumpaddress:pc4;
                    //ȷ������һ��PC������˭
                    
     
     always@(posedge clk or posedge reset)begin
     if(reset)begin
     pcaddress<=32'd0;
     if_id_pc4out<=32'd0;
     if_id_instrout<=32'd0;
     end
     else begin
     pcaddress<=pc_next;
     
     case(next_condition)
     2'b00 :begin // go on
     if_id_pc4out<=pc4;//���Ҫ��go on���˴���PCnextӦ�þ͵���pc+4
        if_id_instrout<=instruction;
     end
     2'b01:begin// flush to zero
     if_id_pc4out<=32'd0;
          if_id_instrout<=32'd0;
     end
     2'b10:begin//keep  for load-use
     if_id_pc4out<=if_id_pc4in;
          if_id_instrout<=if_id_instrin;
     end
     endcase     
     end
     end
endmodule
//ok 7.1