module	ram_ctrl(
		input		wire			sclk		,
		input		wire			rst_n		,
		input		wire			vga_clk	,
		input		wire			pi_flag	,
		input		wire[7:0]	rgb			,
		input		wire			area2		,
		input		wire			area		,
		output	wire[7:0]	dout		
);

reg    [15:0]               wr_addr; //40000个地址
reg    [15:0]               rd_addr; //40000个地址
reg													pi_flag_1;
reg													pi_flag_2;
reg													pi_flag_3;
reg													wr_en		;
parameter	ADDR_END		=		39203;

always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				pi_flag_1	<=	0;
		else	
				pi_flag_1	<=	pi_flag;
				
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				pi_flag_2	<=	0;
		else	
				pi_flag_2	<=	pi_flag_1;
				
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				pi_flag_3	<=	0;
		else	
				pi_flag_3	<=	pi_flag_2;
				
always@(posedge	sclk	or	negedge	rst_n)
		if(rst_n==0)
				wr_en	<=	0;
		else	
				wr_en	<=	pi_flag_3;		

always@(posedge sclk or negedge rst_n) //写地址
begin
       if (!rst_n)
       	wr_addr <= 0;
      	else if (wr_en==1 && wr_addr == ADDR_END)
      		wr_addr <= 0;
      	else if (pi_flag == 1&&area2)
      		wr_addr <= wr_addr + 1;
end       	
       	
always@(posedge vga_clk or negedge rst_n) //读地址
begin
       if (!rst_n)
              rd_addr <= 14'd0;
       else if (rd_addr == ADDR_END)
              rd_addr <= 14'd0;
       else if (area)
              rd_addr <= rd_addr + 1; 
end  


ram_39204x8 U1 (
  .clka(sclk), // input clka
  .wea(wr_en), // input [0 : 0] wea
  .addra(wr_addr), // input [15 : 0] addra
  .dina(rgb), // input [7 : 0] dina
  .clkb(vga_clk), // input clkb
  .addrb(rd_addr), // input [15 : 0] addrb
  .doutb(dout) // output [7 : 0] doutb
);
endmodule