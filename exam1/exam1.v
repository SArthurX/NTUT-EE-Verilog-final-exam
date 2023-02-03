module exam1(rst,key_in,clk,rw,rs,en,data,intr_n,cs_n,rd_n,wr_n,data_reg,adata,key);
 
 input clk,rst;
 input[7:0] adata;
 input intr_n;
 output cs_n,rd_n,wr_n;
 output rs,en,rw;
 output reg[7:0] data;
 output reg[7:0] data_reg;
 
 input [1:0]key_in;
 output key=0;
 
 reg rs,en_sel;
 reg [7:0] shi,fen,miao;
 reg [31:0]count,count1; 
 reg lcd_clk;
 reg [7:0] one_1,one_2,one_3,one_4,one_5,one_6,one_7,one_8,one_9,one_10,one_11,one_12,one_13,one_14,one_15,one_16;
 reg [7:0] two_1,two_2,two_3,two_4,two_5,two_6,two_7,two_8,two_9,two_10,two_11,two_12,two_13,two_14,two_15,two_16;
 reg [7:0] next,xianshi,two;
 reg[1:0] idle,start,start_wait,convert,acurrent_state,anext_state;
 reg[15:0] delay;
 reg cs_n,rd_n,wr_n;
 reg read_flag;
 integer xval; 
 
 reg flag=1;
 
 parameter state0  =8'h00,
    state1  =8'h01, 
    state2  =8'h02,
    state3  =8'h03,  
    state4  =8'h04,  
    state5  =8'h05, 
    
    scan =8'h06,  
    nul  =8'h07; 
 
 parameter data0  =8'h10, 
    data1  =8'h11,
    data2  =8'h12,
    data3  =8'h13,
    data4  =8'h14,
    data5  =8'h15,
    data6  =8'h16,
    data7  =8'h17,
    data8  =8'h18,
    data9  =8'h19,
    data10  =8'h20,
    data11  =8'h21,
    data12  =8'h22,
    data13  =8'h23,
    data14  =8'h24,
    data15  =8'h25,
    data16  =8'h26,
    data17 =8'h27,
    data18 =8'h28,
    data19 =8'h29,
    data20 =8'h30,
    data21  =8'h31,
    data22  =8'h32,
    data23  =8'h33,
    data24  =8'h34,
    data25  =8'h35,
    data26  =8'h36,
    data27  =8'h37,
    data28  =8'h38,
    data29  =8'h39,
    data30  =8'h40,
    data31  =8'h41;
 initial       
 begin

 
   one_1<="H"; one_2<="E"; one_3<="L"; one_4<="L"; one_5<="O"; one_6<=" "; one_7<="A"; one_8<="D";
   one_9<="C";one_10<=":";one_11<=" ";one_12<=".";one_13<=" ";one_14<=" ";one_15<="V";one_16<=" ";

   two_1<="C"; two_2<="l"; two_3<="o"; two_4<="c"; two_5<="k"; two_6<=":"; two_7<=" "; two_8<=" ";
   two_9<="-";two_10<=" ";two_11<=" ";two_12<="-";two_13<=" ";two_14<=" ";two_15<=" ";two_16<=" "; 
   
   shi<=0;fen<=0;miao<=0;
 end
    
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
                               delay <= delay+1; end                                  
                              else begin
                                  acurrent_state <= anext_state;                                    
                                  delay <= 0; end
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
  
       always @(posedge clk) begin
		
        xval = data_reg*2;
        case (xval%10) 
0 : one_14 = 8'h30;
1 : one_14 = 8'h31;
2 : one_14 = 8'h32;
3 : one_14 = 8'h33;
4 : one_14 = 8'h34;
5 : one_14 = 8'h35;
6 : one_14 = 8'h36;
7 : one_14 = 8'h37;
8 : one_14 = 8'h38;
9 : one_14 = 8'h39;
endcase;

xval = xval/10;

case (xval%10) 
0 : one_13 = 8'h30;
1 : one_13 = 8'h31;
2 : one_13 = 8'h32;
3 : one_13 = 8'h33;
4 : one_13 = 8'h34;
5 : one_13 = 8'h35;
6 : one_13 = 8'h36;
7 : one_13 = 8'h37;
8 : one_13 = 8'h38;
9 : one_13 = 8'h39;
endcase;

xval = xval/10;

case (xval%10) 
0 : one_11 = 8'h30;
1 : one_11 = 8'h31;
2 : one_11 = 8'h32;
3 : one_11 = 8'h33;
4 : one_11 = 8'h34;
5 : one_11 = 8'h35;
6 : one_11 = 8'h36;
7 : one_11 = 8'h37;
8 : one_11 = 8'h38;
9 : one_11 = 8'h39;
endcase;
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
   
   if(key_in == 2'b10)flag=1; 
   if(key_in == 2'b01)flag=0;
   
   if(flag)count1<=count1+1'b1;
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

 
 always @(posedge lcd_clk  )
 begin
   case(next)
    state0 :
     begin rs<=0; data<=8'h38; next<=state1; end   
    state1 :
     begin rs<=0; data<=8'h0e; next<=state2; end
    state2 :
     begin rs<=0; data<=8'h06; next<=state3; end
    state3 :
     begin rs<=0; data<=8'h01; next<=state5; end 
         
    state4 :
     begin rs<=0; data<=8'h80; next<=data0; end 
    data0 :
     begin rs<=1; data<=one_1; next<=data1 ; end
    data1 :
     begin rs<=1; data<=one_2; next<=data2 ; end
    data2 :
     begin rs<=1; data<=one_3; next<=data3 ; end
    data3 :
     begin rs<=1; data<=one_4; next<=data4 ; end
    data4 :
     begin rs<=1; data<=one_5; next<=data5 ; end
    data5 :
     begin rs<=1; data<=one_6; next<=data6 ; end
    data6 :
     begin rs<=1; data<=one_7; next<=data7 ; end
    data7 :
     begin rs<=1; data<=one_8; next<=data8 ; end
    data8 :
     begin rs<=1; data<=one_9; next<=data9 ; end
    data9 :
     begin rs<=1; data<=one_10; next<=data10 ; end
    data10 :
     begin rs<=1; data<=one_11; next<=data11 ; end
    data11 :
     begin rs<=1; data<=one_12; next<=data12 ; end
    data12 :
     begin rs<=1; data<=one_13; next<=data13 ; end
    data13 :
     begin rs<=1; data<=one_14; next<=data14 ; end
    data14 :
     begin rs<=1; data<=one_15; next<=data15 ; end
    data15 :
     begin rs<=1; data<=one_16; next<=state5 ; end
      
    state5:  
     begin rs<=0;data<=8'hC0; next<=data16; end 
    data16 :
     begin rs<=1; data<=two_1; next<=data17 ; end
    data17 :
     begin rs<=1; data<=two_2; next<=data18 ; end
    data18 :
     begin rs<=1; data<=two_3; next<=data19 ; end
    data19 :
     begin rs<=1; data<=two_4; next<=data20 ; end
    data20 :
     begin rs<=1; data<=two_5; next<=data21 ; end
    data21 :
     begin rs<=1; data<=two_6; next<=data22 ; end
    data22 :
     begin rs<=1; data<=two_7; next<=data23 ; end
    data23 :
     begin rs<=1; data<=two_8; next<=data24 ; end
    data24 :
     begin rs<=1; data<=two_9; next<=data25 ; end
    data25 :
     begin rs<=1; data<=two_10; next<=data26 ; end
    data26 :
     begin rs<=1; data<=two_11; next<=data27 ; end
    data27 :
     begin rs<=1; data<=two_12; next<=data28 ; end
    data28 :
     begin rs<=1; data<=two_13; next<=data29 ; end
    data29 :
     begin rs<=1; data<=two_14; next<=data30 ; end
    data30 :
     begin rs<=1; data<=two_15; next<=data31 ; end
    data31 :
     begin rs<=1; data<=two_16; next<=scan ; end
     
    scan :  
    begin
     next<=state5;
    end
    default:   next<=state0;
   endcase
 end
 assign en=lcd_clk && en_sel;
 assign rw=0;
endmodule
