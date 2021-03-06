module	uart_rx(
	input		wire			sclk				,
	input		wire			rst_n				,
	input		wire			rx					,//串行输入数据
	input		wire[3:0]	rx_bit_cnt	,//用于计算采集到第N个bit的数据
	input		wire			rx_bit_flag	,
	output	reg[7:0]	po_data			,//输出的八位并行数据
	output	reg			rx_flag			,//使能信号，启动波特率计数
	output	reg			po_flag			
	
);
 
 reg[7:0]	rx_data			;//rx_data2为转化后的并行数据 
 
//消除亚稳态设置
reg		rx_1;
reg		rx_2;
//对外部传来的rx数据进行延时两个时钟周期得到rx_2，实际上采集的是rx_2的数据
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				rx_1	<=	1;
		else	
				rx_1	<=	rx;
//对rx_1再进行一个时钟周期的延时，可消除99%以上的亚稳态
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				rx_2	<=	1;
		else	
				rx_2	<=	rx_1;
				
//rx_flag为使能信号，当rx_flag==1时，波特计数器开始计数
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				rx_flag	<=	0;
		else	if(rx_2==0)
				rx_flag	<=	1;
		else	if(rx_bit_flag==1&&rx_bit_cnt==9)		//使能信号在检测到rx起始位的时候拉高电平
				rx_flag	<=	0;									//当八位数据采集完成后拉低电平
				
//rx_data设置，当rx_bit_flag==1时，开始采集rx_2的数据
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				rx_data	<=	0;
		else	if(rx_bit_cnt>=1&&rx_bit_cnt<=8&&rx_bit_flag==1)	//通过位拼接把串行数据转成并行八位数据
				rx_data	<=	{rx_2,rx_data[7:1]};					//采集到的rx_2数据放在rx_data的最高位，所以可以循环后移一位得到串行的八位数据

//po_data定义，当8个bit传送完成后，把rx_data赋给po_data作为输出数据
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				po_data	<=	0;
		else	if(rx_bit_flag==1&&rx_bit_cnt==9)
				po_data	<=	rx_data	;
				
//po_flag定义，当八位数据传送完成后，po_flag拉高一个时钟周期，当po_flag==1的时候，开始输出数据（八位并行）
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				po_flag	<=	0;
		else	if(rx_bit_flag==1&&rx_bit_cnt==9)		
				po_flag	<=	1;	
		else	
				po_flag	<=	0;								

				
endmodule	