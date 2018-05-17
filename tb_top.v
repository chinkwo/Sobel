`timescale	1ns/1ns
module	tb_top();
reg	clk;
reg	rst_n;
reg	rx;

wire	tx;

reg	[7:0]	a_mem[39999:0];
////////////时钟和复位////////////
initial
	begin
		clk	=	0;
		rst_n	<=	0;
		#30
		rst_n	<=	1;	
	end

always	#10	clk	=	~clk;
////////////rx///////////
initial
	$readmemh("./data.txt",a_mem);
initial
	begin
		rx	<=	1'b1;
		#200
		rx_byte();	
	end
task	rx_byte();
	integer	j;
	for(j=0;j<40000;j=j+1)
	rx_bit(a_mem[j]);
endtask
task	rx_bit(input	[7:0]	data);
	integer	i;
	for(i=0;i<10;i=i+1)
	begin	
		case(i)
		0:	rx	<=	1'b0;
		1:	rx	<=	data[0];
		2:	rx	<=	data[1];
		3:	rx	<=	data[2];
		4:	rx	<=	data[3];
		5:	rx	<=	data[4];
		6:	rx	<=	data[5];
		7:	rx	<=	data[6];
		8:	rx	<=	data[7];
		9:	rx	<=	1'b1;
		endcase
		#8680;//434*20
	end
endtask
//defparam top_inst.rx_inst.BAUD_CNT_END=51;//重定义defparam。用于修改参数
//defparam top_inst.rx_inst.BAUD_CNT_END_HALF=25;
//defparam top_inst.tx_inst.CNT_BAUD_END=51;
	
	sobel_top	top_inst(
                .sclk	(clk	),
                .rst_n(rst_n),
                .rx	(rx	)   
		);
endmodule