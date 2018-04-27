`timescale 1ns / 1ps
module TestBench;

reg signed [15:0] in;
reg clk;
reg rst_n;
reg start;
reg  [1:0] idct4;
wire signed [15:0] out;
wire [1:0] idct_top_out;

reg signed [15:0] mem_out[63:0];
reg [5:0]addr;

	 idct_top idct_top(clk,rst_n,idct4,start,in,out,idct_top_out);


reg [1:0] mode;
integer fp_r;
integer i,j;

always @(posedge clk ) begin
  if (!rst_n) begin
	addr <= 6'b0;	
  end else if(idct_top_out!=2'b0) begin
	addr <= addr+1;
  end
  else
	addr <= addr;
end

always @(posedge clk ) begin
	if(idct_top_out!=2'b0) begin 
		mem_out[addr] <= out;
		if(addr==6'b0)begin
		  	for(j = 1;j <= 63 ;j = j+1)begin
				mem_out[j] <= 16'bx;
			end
		end
	end
end

initial begin
	clk = 0;
	rst_n= 0;
	idct4 = 2'b00;
    fp_r = $fopen("E:/important/it/digital_design/work/file_input.txt", "r");
    #1 clk = 1; 
    #1 rst_n = 1;clk = 0;start=1;
    while(!$feof(fp_r)) begin
	    $fscanf(fp_r,"%b",mode);
	    if (mode == 2'b00)begin
	        idct4=2'b01;
			 for(i = 0;i <= 15 ;i = i+1)begin
					$fscanf(fp_r,"%d",in); 
					#1 clk = 1;
					#1 clk = 0;
				end
	    end
	    else begin
	        idct4=2'b10;	
			 for(i = 0;i <= 63 ;i = i+1)begin
					$fscanf(fp_r,"%d",in); 
					#1 clk = 1;
					#1 clk = 0;
	    end
	end
	end
	$fclose(fp_r);
end
 
endmodule