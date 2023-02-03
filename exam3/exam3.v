module exam3(clk,rst,dataout,key_in,key,en);
input clk,rst;
input[1:0] key_in;

output key=0;
output reg[7:0] dataout; 
output reg[7:0] en;    
   
reg key_1;
reg key_2;

reg[15:0] cnt_scan;

always@(posedge clk or negedge  rst)
begin
	if(!rst) begin cnt_scan<=0;end
	else begin cnt_scan<=cnt_scan+1;end
end

always @(cnt_scan)
begin
   case(cnt_scan[15:13])
       3'b000 :en = 8'b11111110;
       3'b001 :en = 8'b11111101;
       3'b010 :en = 8'b11111011;
       3'b011 :en = 8'b11110111;
       3'b100 :en = 8'b11101111;
       3'b101 :en = 8'b11011111;
       3'b110 :en = 8'b10111111;
       3'b111 :en = 8'b01111111;
    endcase
end

always@(en) 
begin
	if(key_in == 2'b10)begin key_1 = 1;key_2 = 0;end
	if(key_in == 2'b01)begin key_2 = 1;key_1 = 0;end
	
	if(key_1)begin
	case(en)
		8'b11111110:dataout=8'b00000000;
		8'b11111101:dataout=8'b01100110;
		8'b11111011:dataout=8'b01100110;
		8'b11110111:dataout=8'b00000000;
		8'b11101111:dataout=8'b10000001;
		8'b11011111:dataout=8'b10000001;
		8'b10111111:dataout=8'b01000010;
		8'b01111111:dataout=8'b00111100;
	 endcase
	end
	if(key_2)begin
	case(en)
		8'b11111110:dataout=8'b00000000;
		8'b11111101:dataout=8'b01100110;
		8'b11111011:dataout=8'b01100110;
		8'b11110111:dataout=8'b00000000;
		8'b11101111:dataout=8'b00111100;
		8'b11011111:dataout=8'b01000010;
		8'b10111111:dataout=8'b10000001;
		8'b01111111:dataout=8'b10000001;
	 endcase
	end
end
endmodule 