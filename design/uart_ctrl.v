module		uart_ctrl(
		input		wire				sclk		,
		input		wire				rst_n		, 
		input		wire				rx      ,	//tx并行八位数据
		output	wire				po_flag	,
		output	wire[7:0]		rx_data		
);

wire					rx_bit_flag		;//to		U2 
wire[3:0]			rx_bit_cnt		;//to  	U2
wire					tx_bit_flag		;//to		U3 
wire[3:0]			tx_bit_cnt	  ;//to 	U3 
wire					rx_flag				;//to 	U1
		
//bps例化
uart_bps_rx	U1(
.sclk					(sclk				),//from top
.rst_n				(rst_n			),//from top
.rx_flag			(rx_flag		),//from U2   
//.tx_flag			(tx_flag		),
.rx_bit_flag	(rx_bit_flag),//to	U2
.rx_bit_cnt		(rx_bit_cnt	),//to  U2 
.tx_bit_flag	(tx_bit_flag), 
.tx_bit_cnt	  (tx_bit_cnt	) 

);

//rx例化
uart_rx	U2(
.sclk				(sclk				),//from	top
.rst_n			(rst_n			),//from	top
.rx					(rx					),//from	top
.rx_bit_cnt	(rx_bit_cnt	),//from	U1
.rx_bit_flag(rx_bit_flag),//from	U1
.po_data		(rx_data		),//to		top	 
.rx_flag		(rx_flag		),//to 		U1
.po_flag		(po_flag		)	//to 		top
);


endmodule