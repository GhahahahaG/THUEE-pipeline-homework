module InstructionMemory(
	input      [32 -1:0] Address, 
	output reg [32 -1:0] Instruction
);
	
	always @(*)
		case (Address[9:2])

			// -------- Paste Binary Instruction Below (Inst-q1-1/Inst-q1-2.txt)

         
       
            8'd0: Instruction <= 32'h24020002;
            8'd1: Instruction <= 32'h24080000;
            8'd2: Instruction <= 32'h8d100000;
            8'd3: Instruction <= 32'h8d110004;
            8'd4: Instruction <= 32'h8d120008;
            8'd5: Instruction <= 32'h8d13000c;
            8'd6: Instruction <= 32'h21140010;
            8'd7: Instruction <= 32'h0013a880;
            8'd8: Instruction <= 32'h02b4a820;
            8'd9: Instruction <= 32'h0013b0c0;
            8'd10: Instruction <= 32'h02d4b020;
            8'd11: Instruction <= 32'h22170001;
            8'd12: Instruction <= 32'h0017b880;
            8'd13: Instruction <= 32'h02f6b820;
            8'd14: Instruction <= 32'h00004021;
            8'd15: Instruction <= 32'h72124802;
            8'd16: Instruction <= 32'h22ea0190;
            8'd17: Instruction <= 32'had400000;
            8'd18: Instruction <= 32'h214a0004;
            8'd19: Instruction <= 32'h21080001;
            8'd20: Instruction <= 32'h1509fffc;
            8'd21: Instruction <= 32'h00004021;
            8'd22: Instruction <= 32'h00004821;
            8'd23: Instruction <= 32'h00005021;
            8'd24: Instruction <= 32'h8ecb0000;
            8'd25: Instruction <= 32'h8ecc0004;
            8'd26: Instruction <= 32'h000b4821;
            8'd27: Instruction <= 32'h00156821;
            8'd28: Instruction <= 32'h00147021;
            8'd29: Instruction <= 32'h20010004;
            8'd30: Instruction <= 32'h71217802;
            8'd31: Instruction <= 32'h01af6820;
            8'd32: Instruction <= 32'h01cf7020;
            8'd33: Instruction <= 32'h8dad0000;
            8'd34: Instruction <= 32'h8dce0000;
            8'd35: Instruction <= 32'h00005021;
            8'd36: Instruction <= 32'h22ef0190;
            8'd37: Instruction <= 32'h7112c002;
            8'd38: Instruction <= 32'h030ac020;
            8'd39: Instruction <= 32'h20010004;
            8'd40: Instruction <= 32'h7301c002;
            8'd41: Instruction <= 32'h030f7820;
            8'd42: Instruction <= 32'h8df90000;
            8'd43: Instruction <= 32'h71b2c002;
            8'd44: Instruction <= 32'h030ac020;
            8'd45: Instruction <= 32'h20010004;
            8'd46: Instruction <= 32'h7301c002;
            8'd47: Instruction <= 32'h0317c020;
            8'd48: Instruction <= 32'h8f180000;
            8'd49: Instruction <= 32'h730ec002;
            8'd50: Instruction <= 32'h0338c820;
            8'd51: Instruction <= 32'hadf90000;
            8'd52: Instruction <= 32'h214a0001;
            8'd53: Instruction <= 32'h0152082a;
            8'd54: Instruction <= 32'h1420ffed;
            8'd55: Instruction <= 32'h21290001;
            8'd56: Instruction <= 32'h012c082a;
            8'd57: Instruction <= 32'h1420ffe1;
            8'd58: Instruction <= 32'h21080001;
            8'd59: Instruction <= 32'h22d60004;
            8'd60: Instruction <= 32'h0110082a;
            8'd61: Instruction <= 32'h1420ffda;
            8'd62: Instruction <= 32'h24020001;
            8'd63: Instruction <= 32'h22ef0190;
            8'd64: Instruction <= 32'h20180000;
            8'd65: Instruction <= 32'h7212c802;
            8'd66: Instruction <= 32'h3c0a4000;
            8'd67: Instruction <= 32'h254a0010;
            8'd68: Instruction <= 32'h13190039;
            8'd69: Instruction <= 32'h8dee0000;
            8'd70: Instruction <= 32'h200d07d0;
            8'd71: Instruction <= 32'h0c10004b;
            8'd72: Instruction <= 32'h21ef0004;
            8'd73: Instruction <= 32'h23180001;
            8'd74: Instruction <= 32'h08100044;
            8'd75: Instruction <= 32'h000e6302;
            8'd76: Instruction <= 32'h318c000f;
            8'd77: Instruction <= 32'h200b0010;
            8'd78: Instruction <= 32'h21880024;
            8'd79: Instruction <= 32'h00084080;
            8'd80: Instruction <= 32'h8d090000;
            8'd81: Instruction <= 32'h000b89c0;
            8'd82: Instruction <= 32'h02299020;
            8'd83: Instruction <= 32'had520000;
            8'd84: Instruction <= 32'h24130940;
            8'd85: Instruction <= 32'h2673ffff;
            8'd86: Instruction <= 32'h1660fffe;
            8'd87: Instruction <= 32'h000e6202;
            8'd88: Instruction <= 32'h318c000f;
            8'd89: Instruction <= 32'h200b0008;
            8'd90: Instruction <= 32'h21880024;
            8'd91: Instruction <= 32'h00084080;
            8'd92: Instruction <= 32'h8d090000;
            8'd93: Instruction <= 32'h000b89c0;
            8'd94: Instruction <= 32'h02299020;
            8'd95: Instruction <= 32'had520000;
            8'd96: Instruction <= 32'h24130940;
            8'd97: Instruction <= 32'h2673ffff;
            8'd98: Instruction <= 32'h1660fffe;
            8'd99: Instruction <= 32'h000e6102;
            8'd100: Instruction <= 32'h318c000f;
            8'd101: Instruction <= 32'h200b0004;
            8'd102: Instruction <= 32'h21880024;
            8'd103: Instruction <= 32'h00084080;
            8'd104: Instruction <= 32'h8d090000;
            8'd105: Instruction <= 32'h000b89c0;
            8'd106: Instruction <= 32'h02299020;
            8'd107: Instruction <= 32'had520000;
            8'd108: Instruction <= 32'h24130940;
            8'd109: Instruction <= 32'h2673ffff;
            8'd110: Instruction <= 32'h1660fffe;
            8'd111: Instruction <= 32'h31cc000f;
            8'd112: Instruction <= 32'h200b0002;
            8'd113: Instruction <= 32'h21880024;
            8'd114: Instruction <= 32'h00084080;
            8'd115: Instruction <= 32'h8d090000;
            8'd116: Instruction <= 32'h000b89c0;
            8'd117: Instruction <= 32'h02299020;
            8'd118: Instruction <= 32'had520000;
            8'd119: Instruction <= 32'h24130940;
            8'd120: Instruction <= 32'h2673ffff;
            8'd121: Instruction <= 32'h1660fffe;
            8'd122: Instruction <= 32'h21adffff;
            8'd123: Instruction <= 32'h11a00001;
            8'd124: Instruction <= 32'h0810004b;
            8'd125: Instruction <= 32'h03e00008;
            
         
          
           
            
			// -------- Paste Binary Instruction Above
			
			default: Instruction <= 32'h00000000;
		endcase
		
endmodule
// OK 7.1
// 55MHZ