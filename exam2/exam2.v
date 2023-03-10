module exam2(clk,key_in,sm_bit,sm_seg,key);		
input clk;						
input[1:0] key_in;

output key=0;								
output[0:7]	sm_bit;						
output[7:0] sm_seg;				


reg[7:0] sm_seg_r;				
reg[7:0] sm_bit_r;				
reg[3:0] disp_dat;				
reg[24:0]count;					
reg[23:0]hour;					
reg sec,keyen;					
reg[1:0]dout1,dout2,dout3;		
wire[1:0]key_done;				

assign sm_bit = sm_bit_r;		
assign sm_seg = sm_seg_r;		


always @(posedge clk)   				
begin
	count = count + 1'b1;
	if(count == 25'd25000000)			
	begin
		count = 25'd0;					
		sec = ~sec;						
	end
end


assign key_done = (dout1 | dout2 | dout3);	

always @(posedge count[17])
begin
	dout1 <= key_in;
	dout2 <= dout1;
	dout3 <= dout2;	
end

always @(negedge key_done[0])
begin
	keyen = ~keyen;							
end


always @(posedge clk)   					
begin
	case(count[17:15])						
		3'd0:disp_dat = hour[3:0];			
		3'd1:disp_dat = hour[7:4];		
		3'd2:disp_dat = 4'ha;				
		3'd3:disp_dat = hour[11:8];			
		3'd4:disp_dat = hour[15:12];	
		3'd5:disp_dat = 4'ha;				
		3'd6:disp_dat = hour[19:16];		
		3'd7:disp_dat = hour[23:20];	
	endcase
	case(count[17:15])						
		3'd0:sm_bit_r = 8'b11111110;			
		3'd1:sm_bit_r = 8'b11111101;		
		3'd2:sm_bit_r = 8'b11111011;			
		3'd3:sm_bit_r = 8'b11110111;			
		3'd4:sm_bit_r = 8'b11101111;		
		3'd5:sm_bit_r = 8'b11011111;			
		3'd6:sm_bit_r = 8'b10111111;			
		3'd7:sm_bit_r = 8'b01111111;			
	endcase	
end

always @(posedge clk)
begin
	case(disp_dat)
		4'h0:sm_seg_r = 8'h3f;					
		4'h1:sm_seg_r = 8'h06;				
		4'h2:sm_seg_r = 8'h5b;				
		4'h3:sm_seg_r = 8'h4f;					
		4'h4:sm_seg_r = 8'h66;				
		4'h5:sm_seg_r = 8'h6d;				
		4'h6:sm_seg_r = 8'h7d;				
		4'h7:sm_seg_r = 8'h07;				
		4'h8:sm_seg_r = 8'h7f;				
		4'h9:sm_seg_r = 8'h6f;					
		4'ha:sm_seg_r = 8'h40;					
		default:sm_seg_r = 8'h00;			
	endcase
	if((count[17:15]== 3'd2)&sec)
		sm_seg_r = 8'h00;
end

always @(negedge sec or negedge key_done[1])
begin
	if(!key_done[1])					
	begin
		hour = 24'h0;			
	end
	else if(!keyen)
	begin
		hour[3:0] = hour[3:0] + 1'b1;	
		if(hour[3:0] == 4'ha)
		begin
			hour[3:0] = 4'h0;
			hour[7:4] = hour[7:4] + 1'b1;	
			if(hour[7:4] == 4'h6)
			begin
				hour[7:4] = 4'h0;
				hour[11:8] = hour[11:8] + 1'b1;
				if(hour[11:8] == 4'ha)
				begin
					hour[11:8] = 4'h0;
					hour[15:12] = hour[15:12] + 1'b1;
					if(hour[15:12] == 4'h6)
					begin
						hour[15:12] = 4'h0;
						hour[19:16] = hour[19:16] + 1'b1;
						if(hour[19:16] == 4'ha)
						begin
							hour[19:16] = 4'h0;
							hour[23:20] = hour[23:20] + 1'b1;
						end
						if(hour[23:16] == 8'h24)
							hour[23:16] = 8'h0;
					end
				end
			end
		end
	end
end
endmodule
