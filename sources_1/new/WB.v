`timescale 1ns / 1ps

module WB(
// MEM 写入MEM/WB寄存器里的值
input[1:0] mem_wb_memtoreg_out,
input[31 : 0] mem_wb_pc_plus_4_out,
input[31 : 0] mem_wb_aluout_out,
input[31:0] data_read_from_mem,
// choose 1 from these 3
output [31:0]write_to_reg_data
    );
    
    assign write_to_reg_data=(mem_wb_memtoreg_out==2'b00)?mem_wb_aluout_out:
                                (mem_wb_memtoreg_out==2'b01)?data_read_from_mem:mem_wb_pc_plus_4_out;
    
endmodule
// OK 7.1