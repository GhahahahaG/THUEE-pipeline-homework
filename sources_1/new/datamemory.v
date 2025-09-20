module DataMemory(
	input  reset    , 
	input  clk      ,  
	input  MemRead  ,
	input  MemWrite ,
	input  [32 -1:0] Address    ,
	input  [32 -1:0] Write_data ,
	output [32 -1:0] Read_data,
	output [11 : 0] leds   // 数码管控制信号
);
	
	// RAM size is 256 words, each word is 32 bits, valid address is 8 bits
	parameter RAM_SIZE      = 256;
	parameter RAM_SIZE_BIT  = 8;
	
	// RAM_data is an array of 256 32-bit registers
	reg [31:0] RAM_data [RAM_SIZE - 1: 0];
    reg [11:0]leds_tmp;
    reg flag;
    assign leds=leds_tmp;
	// read data from RAM_data as Read_data
	assign Read_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	// write Write_data to RAM_data at clock posedge
	integer i;
	always @(posedge reset or posedge clk)begin
		if (reset) begin
		  leds_tmp = 12'hf80;
			// -------- Paste Data Memory Configuration Below (Data-q1.txt)
			
			         
			RAM_data[0]<=32'd3; //M   0000_0000
			RAM_data[1]<=32'd4; //N
			RAM_data[2]<=32'd5; //P
			RAM_data[3]<=32'd4; //S
			// value
			RAM_data[4]<=32'd9; 
            RAM_data[5]<=32'd7; 
            RAM_data[6]<=32'd15; 
            RAM_data[7]<=32'd9;
            //col
            RAM_data[8]<=32'd2; 
            RAM_data[9]<=32'd1; 
            RAM_data[10]<=32'd0; 
            RAM_data[11]<=32'd2;
            //rowptr
            RAM_data[12]<=32'd0; 
            RAM_data[13]<=32'd1; 
            RAM_data[14]<=32'd2; 
            RAM_data[15]<=32'd4;        
            /*
            1 4 0 12 11
            9 0 11 8 2
            12 2 11 10 0
            10 12 0 1 9
            */
            RAM_data[16]<=32'd1; 
            RAM_data[17]<=32'd4; 
            RAM_data[18]<=32'd0; 
            RAM_data[19]<=32'd12;  
            RAM_data[20]<=32'd11; 
            
            RAM_data[21]<=32'd9; 
            RAM_data[22]<=32'd0; 
            RAM_data[23]<=32'd11; 
            RAM_data[24]<=32'd8;  
            RAM_data[25]<=32'd2;   
            
            RAM_data[26]<=32'd12; 
            RAM_data[27]<=32'd2; 
            RAM_data[28]<=32'd11; 
            RAM_data[29]<=32'd10;  
            RAM_data[30]<=32'd0; 
            
            RAM_data[31]<=32'd10; 
            RAM_data[32]<=32'd12; 
            RAM_data[33]<=32'd0; 
            RAM_data[34]<=32'd1;  
            RAM_data[35]<=32'd9; 
            //BCD
           RAM_data[36]<=32'h3f; 
           RAM_data[37]<=32'h06; 
           RAM_data[38]<=32'h5b; 
           RAM_data[39]<=32'h4f;  
           RAM_data[40]<=32'h66;   
           
           RAM_data[41]<=32'h6d; 
           RAM_data[42]<=32'h7d; 
           RAM_data[43]<=32'h07; 
           RAM_data[44]<=32'h7f;  
           RAM_data[45]<=32'h6f; 
           
           RAM_data[46]<=32'h77; 
           RAM_data[47]<=32'h7c; 
           RAM_data[48]<=32'h39; 
           RAM_data[49]<=32'h5e;  
           RAM_data[50]<=32'h79;
            RAM_data[51]<=32'h71;
            
            
            
			for (i = 52; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
			// -------- Paste Data Memory Configuration Above
		end
		
		
		else if (MemWrite) begin
		      if (Address == 32'h4000_0010) begin
		      leds_tmp <= Write_data[11 : 0];
		      flag<=1;
		      end
			else begin
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
			flag<=0;
			end
		end
	end
			
endmodule
// OK 7.1