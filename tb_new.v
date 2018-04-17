`timescale 1ns / 1ps
module TestBench;

reg signed [15:0] in;
reg clk;
reg rst_n;
reg  [1:0] idct4;
wire signed [15:0] out;
//single.ID_cycle single.ID(clk);
	 //shift_add shift_add(in, mode, out1, out2);
	 idct_top idct_top(clk,rst_n,idct4,in,out);

//integer [3:0] mem [5:0];
// reg signed [15:0] mem8 [63:0];
reg [1:0] mode;
integer fp_r;
integer i;

initial begin
	clk = 0;
	rst_n= 0;
	idct4 = 2'b00;
    fp_r = $fopen("E:/important/it/digital_design/work/file_input.txt", "r");
    #1 clk = 1; 
    #1 rst_n = 1;clk = 0;
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