module	sobel_top(
		input		wire			sclk	,
		input		wire			rst_n	,
		input		wire			rx		,
		output	wire			h_sync	,
		output	wire			v_sync	,
		output	wire[2:0]	r					,
		output	wire[2:0]	g					,
		output	wire[1:0]	b          

);    

wire				rx_flag	;
wire[7:0]		rx_data	;
wire				area2		;
wire[7:0]		rgb			;
wire[7:0]		value		; 
wire[7:0]		dout		;
wire				vga_clk	;


uart_ctrl	U1(
.sclk			(sclk		) ,
.rst_n		(rst_n	)	, 
.rx     	(rx     ) ,
.po_flag	(rx_flag)	,
.rx_data	(rx_data)		
);

fifo_ctrl	U2(
.sclk			(sclk		),
.rst_n		(rst_n	)	,
.rx_flag	(rx_flag)	,
.rx_data	(rx_data)	,
.area2	(area2)	,
//.wr_area		(wr_area	)	,
.rgb			(rgb		)	
);

ram_ctrl	U3(
.sclk		(sclk		),
.rst_n	(rst_n	)	,
.vga_clk(vga_clk)	,
.pi_flag(rx_flag)	,
.rgb		(rgb		)	,
.area2	(area2	)	,
.area		(area		),
.dout		(dout		)
);

vga_module	U4(
.sclk		(sclk		)	,
.rst_n	(rst_n	)		,
.vga_clk(vga_clk)		,
.dout		(dout		)	,	
.h_sync	(h_sync	)	,
.v_sync	(v_sync	)	,
.area		(area		),
.r			(r			)		,
.g			(g			)		,
.b      (b      )
);

vga_clk_module	U5(
.sclk			(sclk		),
.rst_n		(rst_n	),
.vga_clk	(vga_clk)
);
endmodule