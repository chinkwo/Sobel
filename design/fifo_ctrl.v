module	fifo_ctrl(
		input		wire			sclk			,
		input		wire			rst_n			,
		input		wire			rx_flag		,
		input		wire[7:0]	rx_data		,
		output	reg			area2			,
		output	reg			wr_area			,
		output	reg[7:0]	rgb				
		
);
reg					wr_en1		;
reg					wr_en2		;
reg					rd_en1		;
reg					rd_en2		; 
wire[7:0]		data_in1	;
wire[7:0]		data_in2	;
wire[7:0]		dout2			;
reg[7:0]		cnt				;
reg[7:0]		h_cnt			;
reg[7:0]		v_cnt			;
reg					add_flag	;
wire[7:0]		dout1			;
wire				full1			; 
wire				empty1		;
wire				full2			;
wire				empty2		;
//reg					area2			;
reg[23:0]	a					;
reg[23:0]	b					;
reg[23:0]	c					;
wire[7:0]		c3			;
wire[7:0]		c2			;
wire[7:0]		c1			;
wire[7:0]		b3			; 
wire[7:0]		b2			;
wire[7:0]		b1			;
wire[7:0]		a3			;
wire[7:0]		a2			;
wire[7:0]		a1			;
reg[7:0]		dx			;
reg[7:0]		dy			;
reg[7:0]		abs_dx			;
reg[7:0]		abs_dy			;
reg[7:0]		value				;

parameter		H_CNT_END	=	199;//86*86
parameter		V_CNT_END	=	199;
parameter		VALUE 		=	8;

//area2定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				area2	<=	0;
		else	if(v_cnt>=2&&h_cnt==1&&rx_flag==1)
				area2	<=	1;
		else	if(v_cnt>=2&&h_cnt==199&&rx_flag==1)
				area2	<=	0;
//wr_area定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				wr_area	<=	0;
		else	if(v_cnt>=2&&h_cnt==3&&rx_flag==1)
				wr_area	<=	1;
		else	if(v_cnt>=2&&h_cnt==1&&rx_flag==1)
				wr_area	<=	0;

//cnt定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				cnt	<=	0;
		else	if(cnt==H_CNT_END&&rx_flag==1)
				cnt	<=	0;
		else	if(rx_flag==1)
				cnt	<=	cnt+1;


//h_cnt定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				h_cnt	<=	0;
		else	if(h_cnt==H_CNT_END&&rx_flag==1)
				h_cnt	<=	0;
		else	if(v_cnt==0&&cnt==0&&rx_flag==1)
				h_cnt	<=	0;
		else	if(rx_flag==1)
				h_cnt	<=	h_cnt+1;
				
				
//v_cnt定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				v_cnt	<=	0;
		else	if(v_cnt==V_CNT_END&&h_cnt==H_CNT_END&&rx_flag==1)
				v_cnt	<=	0;
		else	if(h_cnt==H_CNT_END&&rx_flag==1)
				v_cnt	<=	v_cnt+1;
				
								
//wr_en2定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				wr_en2	<=	0;
		else	if(v_cnt==V_CNT_END&&h_cnt==H_CNT_END&&rx_flag==1)
				wr_en2	<=	0;
		else	if(v_cnt>=1)
				wr_en2	<=	rx_flag;

//data_in2定义
assign	data_in2	=	rx_data	;

				
//rd_en2定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				rd_en2	<=	0;
		else	if(v_cnt==V_CNT_END&&h_cnt==H_CNT_END&&rx_flag==1)
				rd_en2	<=	0;
		else	if(v_cnt>=1)
				rd_en2	<=	wr_en2;

//wr_en1定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				wr_en1	<=	0;
		else	if(v_cnt>=2)
				wr_en1	<=	rd_en2;
				
//rd_en1定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				rd_en1	<=	0;
		else	if(v_cnt==V_CNT_END&&h_cnt==H_CNT_END&&rx_flag==1)
				rd_en1	<=	0;
		else	if(v_cnt>=2)
				rd_en1	<=	wr_en1;

//add_flag定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				add_flag	<=	0;
		else	
				add_flag	<=	rd_en1;
				
//data_in1定义
assign	data_in1	=	dout2	;
				

//a、b、c定义
//a
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				a	<=	0;
		else	if(add_flag==1)
				a	<=	{dout1,a[23:8]};
//b
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				b	<=	0;
		else	if(add_flag==1)
				b	<=	{dout1,b[23:8]};		
//c
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				c	<=	0;
		else	if(add_flag==1)
				c	<=	{dout1,c[23:8]};				
				
				
assign  c3 = c[23:16]; 
assign  c2 = c[15:8];
assign  c1 = c[7:0];
assign  b3 = b[23:16]; 
assign  b2 = b[15:8]; 
assign  b1 = b[7:0]; 
assign  a3 = a[23:16]; 
assign  a2 = a[15:8]; 
assign  a1 = a[7:0];
 
//dx定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				dx	<=	0;
		else	if(rx_flag==1)
				dx	<=	a3-a1+((b3-b1)<<1)+c3-c1;
//dy定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				dy	<=	0;
		else	if(rx_flag==1)
				dy	<=	a1-c1+((a2-c2)<<1)+a3-c3;
//abs_dx定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				abs_dx	<=	0;
		else	if(dx[7]==1)
				abs_dx	<=	~dx+1;
		else	
				abs_dx	<=	dx;
//abs_dy定义
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				abs_dy	<=	0;
		else	if(dy[7]==1)
				abs_dy	<=	~dy+1;
		else	
				abs_dy	<=	dy;
//阈值定义												
//assign	value	=	abs_dx+abs_dy;		
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				value	<=	0;
		else	
				value	<=	abs_dx+abs_dy;
//rgb赋值
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				rgb	<=	0;
				else	if(value>=3)
				rgb	<=	8'b1111_1111;
		else	
				rgb	<=	8'b0000_0000;		
				
//fifo1例化
fifo_200x8 U1 (
  .clk(sclk), // input clk
  .din(data_in1), // input [7 : 0] din
  .wr_en(wr_en1), // input wr_en
  .rd_en(rd_en1), // input rd_en
  .dout(dout1), // output [7 : 0] dout
  .full(full1), // output full
  .empty(empty1) // output empty
);


//fifo2例化
fifo_200x8 U2 (
  .clk(sclk), // input clk
  .din(data_in2), // input [7 : 0] din
  .wr_en(wr_en2), // input wr_en
  .rd_en(rd_en2), // input rd_en
  .dout(dout2), // output [7 : 0] dout
  .full(full2), // output full
  .empty(empty2) // output empty
);


endmodule