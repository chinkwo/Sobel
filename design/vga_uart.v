module	vga_uart(
		input		wire			sclk		,
		input		wire			rst_n		,
		input		wire			rx      ,
		output	wire			tx			,
		output	wire			h_sync	,
		output	wire			v_sync	,
		output	wire[2:0]	r				,
		output	wire[2:0]	g				,
		output	wire[1:0]	b  
	);
		wire	vga_clk	;
		wire[7:0]		rx_data;	
		wire	po_flag;
		wire	area;
		//wire[15:0]		rd_addr;
		wire[7:0]	dout;
//vga_clk部分例化
vga_clk_module	U1(
.sclk		(sclk		),
.rst_n	(rst_n	),
.vga_clk(vga_clk)	 
);

//vga_module部分例化
vga_module	U2(
.sclk		(sclk		),
.rst_n	(rst_n	),
.vga_clk(vga_clk),
.h_sync	(h_sync	),
.v_sync	(v_sync	),
.dout		(dout		),
.r			(r			),
.g			(g			),
.area		(area),
//.rd_addr(rd_addr		),
.b      (b      )  
);

uart_top	U3(
.sclk		(sclk		),
.rst_n	(rst_n	), 
.rx     (rx     ),
.tx			(tx			),
.po_flag(po_flag),
.po_data(rx_data)		//tx并行八位数据
);

ram_ctrl	U4(
.sclk			(sclk		),
.rst_n		(rst_n	),
.vga_clk	(vga_clk),
.pi_flag	(po_flag),
.rx_data	(rx_data),
.area			(area		),
//.rd_addr	(rd_addr),
.dout		  (dout		)
);


endmodule