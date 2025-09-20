

module forward_unit(
input ex_mem_regwrite,
input [4:0]ex_mem_regwraddr,
input mem_wb_regwrite,
input [4:0]mem_wb_regwraddr,
input [4:0]id_ex_rs,
input [4:0]id_ex_rt,
output [1:0]forwardA,
output [1:0]forwardB
    );
    
    assign forwardA=(ex_mem_regwrite && (ex_mem_regwraddr!=5'd0) && (ex_mem_regwraddr==id_ex_rs))?2'b10:
                    (mem_wb_regwrite && (mem_wb_regwraddr!=5'd0)&&(mem_wb_regwraddr==id_ex_rs))?2'b01:2'b00;
    assign forwardB=(ex_mem_regwrite && (ex_mem_regwraddr!=5'd0) && (ex_mem_regwraddr==id_ex_rt))?2'b10:
                    (mem_wb_regwrite && (mem_wb_regwraddr!=5'd0)&&(mem_wb_regwraddr==id_ex_rt))?2'b01:2'b00;
   
   
endmodule

// OK 7.1