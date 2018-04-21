module idct_chip(clk,rstn,mode,start,din,dout,dout_mode);

input clk,rstn;
input [1:0] mode;
input start;
input [15:0] din;

output [15:0] dout;
output [1:0] dout_mode;

wire net_clk,net_rstn;
wire [1:0] net_mode,net_dout_mode;
wire net_start;
wire [15:0] net_din,net_dout;

PIW
	PIW_clk(.PAD(clk),.C(net_clk)),
	PIW_rstn(.PAD(rstn),.C(net_rstn)),
	PIW_start(.PAD(start),.C(net_start)),
	PIW_mode0(.PAD(mode[0]),.C(net_mode[0])),
	PIW_mode1(.PAD(mode[1]),.C(net_mode[1])),
	PIW_din0(.PAD(din[0]),.C(net_din[0])),
	PIW_din1(.PAD(din[1]),.C(net_din[1])),
	PIW_din2(.PAD(din[2]),.C(net_din[2])),
	PIW_din3(.PAD(din[3]),.C(net_din[3])),
	PIW_din4(.PAD(din[4]),.C(net_din[4])),
	PIW_din5(.PAD(din[5]),.C(net_din[5])),
	PIW_din6(.PAD(din[6]),.C(net_din[6])),
	PIW_din7(.PAD(din[7]),.C(net_din[7])),
	PIW_din8(.PAD(din[8]),.C(net_din[8])),
	PIW_din9(.PAD(din[9]),.C(net_din[9])),
	PIW_din10(.PAD(din[10]),.C(net_din[10])),
	PIW_din11(.PAD(din[11]),.C(net_din[11])),
	PIW_din12(.PAD(din[12]),.C(net_din[12])),
	PIW_din13(.PAD(din[13]),.C(net_din[13])),
	PIW_din14(.PAD(din[14]),.C(net_din[14])),
	PIW_din15(.PAD(din[15]),.C(net_din[15]));
	
PO8W
	PO8W_dout0(.I(net_dout[0]),.PAD(dout[0])),
	PO8W_dout1(.I(net_dout[1]),.PAD(dout[1])),
	PO8W_dout2(.I(net_dout[2]),.PAD(dout[2])),
	PO8W_dout3(.I(net_dout[3]),.PAD(dout[3])),
	PO8W_dout4(.I(net_dout[4]),.PAD(dout[4])),
	PO8W_dout5(.I(net_dout[5]),.PAD(dout[5])),
	PO8W_dout6(.I(net_dout[6]),.PAD(dout[6])),
	PO8W_dout7(.I(net_dout[7]),.PAD(dout[7])),
	PO8W_dout8(.I(net_dout[8]),.PAD(dout[8])),
	PO8W_dout9(.I(net_dout[9]),.PAD(dout[9])),
	PO8W_dout10(.I(net_dout[10]),.PAD(dout[10])),
	PO8W_dout11(.I(net_dout[11]),.PAD(dout[11])),
	PO8W_dout12(.I(net_dout[12]),.PAD(dout[12])),
	PO8W_dout13(.I(net_dout[13]),.PAD(dout[13])),
	PO8W_dout14(.I(net_dout[14]),.PAD(dout[14])),
	PO8W_dout15(.I(net_dout[15]),.PAD(dout[15])),
	PO8W_dout_mode0(.I(net_dout_mode[0]),.PAD(dout_mode[0])),
	PO8W_dout_mode1(.I(net_dout_mode[1]),.PAD(dout_mode[1]));
	
idct_top idct_top_inst(.clk(net_clk),.rst_n(net_rstn),.idct(net_mode),.start(net_start),.x_in(net_din),.z_out(net_dout),.idct_out(net_dout_mode));

endmodule
	
