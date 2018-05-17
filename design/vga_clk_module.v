module	vga_clk_module(
		input		wire	sclk		,
		input		wire	rst_n		,
		output	reg		vga_clk	
);

//reg[1:0]	cnt;
//
//always@(posedge	sclk	or	negedge	rst_n)
//		if(rst_n==0)
//			cnt	<=	0;
//		else	if(cnt==3)
//			cnt	<=	0;
//		else	
//			cnt	<=	cnt+1;
			
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
			vga_clk	<=	0;
		else	
			vga_clk	<=	~vga_clk;
			
endmodule