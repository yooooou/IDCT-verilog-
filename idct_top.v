module idct_top
(   input clk,
	input rst_n,
	input [1:0] idct,
	input start,
	input  signed [15:0] x_in,
	output signed [15:0] z_out,
	output [1:0] idct_out
);
wire signed [15:0] y_col_out, y_row_in;
wire [1:0] idct_5, idct_row_in;

idct_col idct_col(clk, rst_n, idct, start, x_in, y_col_out, idct_5);
memory_ctr memory_ctr(clk, rst_n, idct_5, y_col_out, idct_row_in, y_row_in);
idct_row idct_row(clk, rst_n, idct_row_in, y_row_in, z_out, idct_out);

endmodule


