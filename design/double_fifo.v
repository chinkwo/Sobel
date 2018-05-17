module	double_fifo(
		input		wire			sclk	,
		input		wire			rst_n	,
		input		wire			rx		,
		output	wire			tx				

);

wire			rx_flag		;
wire[7:0]	rx_data		;
wire			tx_flag		;
wire[7:0]	tx_data		;

//fifo_ctrl例化
fifo_ctrl	U1(
.sclk			(sclk		),
.rst_n		(rst_n	)	,
.rx_flag	(rx_flag)	,
.rx_data	(rx_data)	,
.tx_flag	(tx_flag)	,
.tx_data	(tx_data)	
);
//uart_rx例化
uart_ctrl	U2(
.sclk			(sclk			),
.rst_n		(rst_n		), 
.rx      	(rx      	),
.tx_flag1	(tx_flag	),
.tx_data	(tx_data	),	//tx并行八位数据
.po_flag	(rx_flag	),
.rx_data	(rx_data	),
.tx				(tx				)
);
endmodule