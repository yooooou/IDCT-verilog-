module mem8
#(
	parameter WIDTH_X = 16
)
(   
	input wire clk, rst_n, 
	input wire w_en, r_en,
	input wire [5:0] w_addr, 
    input wire [5:0] r_addr,
    input reg [WIDTH_X-1:0] d_in, 
    output reg [WIDTH_X-1:0] d_out
);  

reg [WIDTH_X-1:0] memory8[63:0];

always @(posedge clk) begin
  if (w_en==1)
     memory8[w_addr] <= d_in;  
end

always @(posedge clk ) begin
    if (!rst_n) begin
       d_out <= 22'b0;
    end else if(r_en) begin
       d_out <= memory8[r_addr];
    end else begin
      d_out <= d_out;
    end 
end

endmodule