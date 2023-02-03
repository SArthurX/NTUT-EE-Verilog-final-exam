module exam5(rst,clk,rw,rs,en,intr_n,cs_n,rd_n,wr_n,adata,dataout,en_s);
 output cs_n,rd_n,wr_n;
 input clk,rst;
 input[7:0] adata;
 output rs,en,rw;
 input intr_n;
 reg rs,en_sel;
 reg [7:0] data;
 reg [7:0] shi,fen,miao;
 reg [31:0]count,count1; 
 reg lcd_clk;
 reg [7:0] one_1,one_2,one_3,one_4,one_5,one_6,one_7,one_8,one_9,one_10,one_11,one_12,one_13,one_14,one_15,one_16;
 reg [7:0] two_1,two_2,two_3,two_4,two_5,two_6,two_7,two_8,two_9,two_10,two_11,two_12,two_13,two_14,two_15,two_16;
 reg [7:0] next,xianshi,two;
 reg[1:0] idle,start,start_wait,convert,acurrent_state,anext_state;
 reg[15:0] delay;
 reg cs_n,rd_n,wr_n;
 reg[7:0] data_reg;
 reg read_flag;
 integer xval; 
 
output reg[7:0] dataout; 
output reg[7:0] en_s; 
 
reg key_1;
reg key_2;
reg[15:0] cnt_scan;

 always @ (posedge lcd_clk or negedge rst) begin
              if(!rst) begin
                     acurrent_state <= 0;     
                     delay <= 0;
                     data_reg  <= 0;
                     end
              else begin
                     case(acurrent_state)
                            idle: begin
                             if(delay<10) begin
                               delay <= delay+1; end                                  else begin
                                  acurrent_state <= anext_state;                                    delay <= 0; end
                                          end
                            start:  begin
                                acurrent_state <= anext_state;
                                end
                            start_wait: begin
                               acurrent_state <= anext_state;
                               end
                           convert:  begin
                               if(delay<2) begin
                                 delay <= delay+1; end
                                  else begin
                                    data_reg <= adata;
                                    acurrent_state <= anext_state;
                                    delay <= 0; end
                                    end
                            default: ;
                            endcase
                     end
       end 
   
       always @ (acurrent_state or intr_n or rst) begin
              if(!rst) begin
                     idle <= 0;
                     start <= 1;
                     start_wait <= 2;
                     convert <= 3;      
                     read_flag <= 0;
                    end
              else begin
                     case (acurrent_state)
                            idle: begin
                                   cs_n <= 1;
                                   wr_n <= 1;
                                   rd_n <= 1;
                                   read_flag <= 0;
                                   anext_state <= start; end
                            start: begin
                                   cs_n <= 0;
                                   wr_n <= 0;
                                   rd_n <= 1;
                                   read_flag <= 0;
                                   anext_state <= start_wait; end
                            start_wait: begin
                                   wr_n <= 1;
                                   cs_n <= 1;
                                   rd_n <= 1;
                                   read_flag <= 0;
                         if(!intr_n)       anext_state <= convert;
                           else anext_state <= start_wait;
                                   end
                            convert: begin
                                   cs_n <= 0;
                                   rd_n <= 0;
                                   wr_n <= 1;
                                   read_flag <= 1;
                                  anext_state <= idle; end
                            default: anext_state <= idle;
                            endcase
                     end
       end    
always @(posedge clk) 
begin
if(!rst)cnt_scan<=0;
else begin cnt_scan<=cnt_scan+1;end

case(cnt_scan[15:13])
       3'b000 :en_s = 8'b11111110;
       3'b001 :en_s = 8'b11111101;
       3'b010 :en_s = 8'b11111011;
       3'b011 :en_s = 8'b11110111;
       3'b100 :en_s = 8'b11101111;
       3'b101 :en_s = 8'b11011111;
       3'b110 :en_s = 8'b10111111;
       3'b111 :en_s = 8'b01111111;
    endcase

xval = data_reg*2;
xval = xval/100;

if(xval%10>3)begin key_1 = 1;key_2 = 0;end else begin key_2 = 1;key_1 = 0;end
if(key_1)begin
	case(en_s)
		8'b1111_1110:dataout=8'b00000000;
		8'b1111_1101:dataout=8'b01100110;
		8'b1111_1011:dataout=8'b01100110;
		8'b1111_0111:dataout=8'b00000000;
		8'b1110_1111:dataout=8'b10000001;
		8'b1101_1111:dataout=8'b10000001;
		8'b1011_1111:dataout=8'b01000010;
		8'b0111_1111:dataout=8'b00111100;
	 endcase
	end
	if(key_2)begin
	case(en_s)
		8'b1111_1110:dataout=8'b00000000;
		8'b1111_1101:dataout=8'b01100110;
		8'b1111_1011:dataout=8'b01100110;
		8'b1111_0111:dataout=8'b00000000;
		8'b1110_1111:dataout=8'b00111100;
		8'b1101_1111:dataout=8'b01000010;
		8'b1011_1111:dataout=8'b10000001;
		8'b0111_1111:dataout=8'b10000001;
	 endcase
	end
end

 always @(posedge clk )     
 begin
  count<=count+1;
  if(count==250000)
  begin
   count<=0;
   lcd_clk<=~lcd_clk;
  end
 end

 always @(posedge clk or negedge rst ) 
 begin
  if(!rst)
  begin
   shi<=0;fen<=0;miao<=0;
   count1<=0;
  end
  else
  begin
   en_sel<=1;
   
   two_7<= (shi/10)+8'b00110000;
   two_8<= (shi%10)+8'b00110000;
   two_10<=(fen/10)+8'b00110000;
   two_11<=(fen%10)+8'b00110000;
   two_13<=(miao/10)+8'b00110000;
   two_14<=(miao%10)+8'b00110000;
   
   count1<=count1+1'b1;
   if(count1==49999999)   
   begin
    count1<=0;
    miao<=miao+1;
    if(miao==59)
    begin
     miao<=0;
     fen<=fen+1;
     if(fen==59)
     begin
      fen<=0;
      shi<=shi+1;
      if(shi==23)
      begin
       shi<=0;
      end
     end
    end
   end
  end   
 end

endmodule
