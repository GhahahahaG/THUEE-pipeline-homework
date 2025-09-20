`timescale 1ns / 1ps
//取指令，指令可以来源于PC+4、branch、j、jr
//在分支指令、跳转指令跳转后，还需要flush，因此需要把IF/ID寄存器里的东西存回来
//要给IF/ID寄存器传这个指令的PC、instr
module IF(
input clk,
input reset,
input dojump,
input pc_keep, //flush时候 keep PC
input dobranch,// zero&&isbranch,应该在EX阶段产生并送入
input [31:0]jumpaddress,
input [31:0]branchaddress,
input [1:0]next_condition,// whether to flush

input [31:0]if_id_pc4in,
input [31:0]if_id_instrin,//此时IF/ID寄存器存的值，如果flush，则可能把这两个再输出

output reg [31:0]if_id_pc4out,
output reg [31:0]if_id_instrout

    );
    
    //IF区的组合逻辑部分
    reg [31:0]pcaddress; //按reset后，赋值为0，之后每一个周期，Pc+4
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
                    //确定好下一个PC到底是谁
                    
     
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
     if_id_pc4out<=pc4;//如果要是go on，此处的PCnext应该就等于pc+4
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