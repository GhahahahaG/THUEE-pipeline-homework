//stall可能来自于 load-use   j/jr/jal  beq/bne
module hazard(
input reset,
input id_ex_memread,
input [4:0]id_ex_rt,
input [4:0]if_id_rs,
input [4:0]if_id_rt,   // for load-use
input dojump, // for j/jal/jr
input dobranch,// for beq bne

output reg pckeep,
output reg [1:0]control_if_id, // 00 go on   ; 01 flush  ;10 keep
output reg flush_id_ex 
    );
    
   // assign pckeep= (id_ex_memread && (id_ex_rt==if_id_rs)&&(id_ex_rt==if_id_rt))?1'b1:1'b0; // only when load-use ,keep pc
  //  assign flush_id_ex=
    
    
    always@(*)begin
    if(reset)begin
     pckeep=1'b0;
           control_if_id=2'b00;
           flush_id_ex=1'b0;
    end
    
    
    else begin
    
    if (id_ex_memread && ((id_ex_rt==if_id_rs)||(id_ex_rt==if_id_rt)) ) // load-use
    begin
    pckeep=1'b1;
    control_if_id=2'b10;
    flush_id_ex=1;
    end
    
    else if(dobranch)begin // branch flush IF/ID and ID/EX
    pckeep=1'b0;
    control_if_id=2'b01;
    flush_id_ex=1'b1;   
    end
    else if(dojump) // for j/jal/jr
    begin
    pckeep=1'b0;
    control_if_id=2'b01;
    flush_id_ex=1'b0;
    end
    else begin // normal
    pckeep=1'b0;
        control_if_id=2'b00;
        flush_id_ex=1'b0;
    end
    
    end
    
    end
    
 
endmodule
// OK 7.1