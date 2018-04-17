module idct_top
#(
	parameter WIDTH_X = 16
)
(   input clk,
	input rst_n,
	input [1:0] idct,
	input signed [15:0] x_in,
	output signed [WIDTH_X-1:0] z_out
);
wire [WIDTH_X-1:0] y_col_out, y_row_in;
wire [1:0] idct_5, idct_row_in;

idct_col idct_col(clk, rst_n, idct, x_in, y_col_out, idct_5);
memory_ctr memory_ctr(clk, rst_n, idct_5, y_col_out, idct_row_in, y_row_in);
idct_row idct_row(clk, rst_n, idct_row_in, y_row_in, z_out);

endmodule


