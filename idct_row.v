module idct_row
#(  parameter WIDTH_X = 16,
	parameter WIDTH_Y = 25,
	parameter SHIFT_ROW = 12,
	parameter ADD_ROW = 2048
)
(   
	input wire clk, rst_n,
	input wire [1:0]idct4,
	input wire  signed [WIDTH_X-1:0] x_in_origin,
	output reg  signed [WIDTH_X-1:0] y_out,
	output reg   [1:0] idct_out
);  

	reg  signed [WIDTH_X-1:0] y0;
	reg  signed [WIDTH_X-1:0] y1;
	reg  signed [WIDTH_X-1:0] y2;
	reg  signed [WIDTH_X-1:0] y3;
	reg  signed [WIDTH_X-1:0] y4;
	reg  signed [WIDTH_X-1:0] y5;
	reg  signed [WIDTH_X-1:0] y6;
	reg  signed [WIDTH_X-1:0] y7;

	reg [2:0] mode;
    reg [2:0] mode_d;
	wire [1:0] mode_d_4;
	// reg flag;	
	reg [1:0]idct4_1;
	wire [1:0] idct4_3;
	reg [1:0] idct4_4;
	reg [1:0] idct4_5;

	reg   signed [WIDTH_X-1:0] x_in;

	wire  signed [WIDTH_Y-3:0] x_reg1;
	wire  signed [WIDTH_Y-3:0] x_reg2;   
	wire  signed [WIDTH_Y-3:0] x_reg1_comp;   
	wire  signed [WIDTH_Y-3:0] x_reg2_comp;	   
 
	wire  signed [WIDTH_Y-3:0] x_reg3;   
	wire  signed [WIDTH_Y-3:0] x_reg4;   
	wire  signed [WIDTH_Y-3:0] x_reg3_comp;   
	wire  signed [WIDTH_Y-3:0] x_reg4_comp;   	
	
	
	//add results 
	reg  signed [WIDTH_Y-1:0] x_add0;
	reg  signed [WIDTH_Y-1:0] x_add1;
	reg  signed [WIDTH_Y-1:0] x_add2;
	reg  signed [WIDTH_Y-1:0] x_add3;
 
	reg  signed [WIDTH_Y-1:0] x_add4;
	reg  signed [WIDTH_Y-1:0] x_add5;
	reg  signed [WIDTH_Y-1:0] x_add6;
	reg  signed [WIDTH_Y-1:0] x_add7;	

	wire signed [WIDTH_Y-1:0] x_add0_op1;
	wire signed [WIDTH_Y-1:0] x_add0_op2;
	wire signed [WIDTH_Y-1:0] x_add1_op1;
	wire signed [WIDTH_Y-1:0] x_add1_op2;
	wire signed [WIDTH_Y-1:0] x_add2_op1;
	wire signed [WIDTH_Y-1:0] x_add2_op2;
	wire signed [WIDTH_Y-1:0] x_add3_op1;
	wire signed [WIDTH_Y-1:0] x_add3_op2;

	wire signed [WIDTH_Y-3:0] x_add0_op1_4;
	wire signed [WIDTH_Y-1:0] x_add0_op2_4;
	wire signed [WIDTH_Y-3:0] x_add1_op1_4;
	wire signed [WIDTH_Y-1:0] x_add1_op2_4;
	wire signed [WIDTH_Y-3:0] x_add2_op1_4;
	wire signed [WIDTH_Y-1:0] x_add2_op2_4;
	wire signed [WIDTH_Y-3:0] x_add3_op1_4;
	wire signed [WIDTH_Y-1:0] x_add3_op2_4;

	wire  signed [WIDTH_Y-3:0] x_add0_op1_8;
	wire  signed [WIDTH_Y-1:0] x_add0_op2_8;
	wire  signed [WIDTH_Y-3:0] x_add1_op1_8;
	wire  signed [WIDTH_Y-1:0] x_add1_op2_8;
	wire  signed [WIDTH_Y-3:0] x_add2_op1_8;
	wire  signed [WIDTH_Y-1:0] x_add2_op2_8;
	wire  signed [WIDTH_Y-3:0] x_add3_op1_8;
	wire  signed [WIDTH_Y-1:0] x_add3_op2_8;
 
	wire  signed [WIDTH_Y-1:0] x_add4_op1;
	wire  signed [WIDTH_Y-1:0] x_add4_op2;
	wire  signed [WIDTH_Y-1:0] x_add5_op1;
	wire  signed [WIDTH_Y-1:0] x_add5_op2;
	wire  signed [WIDTH_Y-1:0] x_add6_op1;
	wire  signed [WIDTH_Y-1:0] x_add6_op2;
	wire  signed [WIDTH_Y-1:0] x_add7_op1;
	wire  signed [WIDTH_Y-1:0] x_add7_op2;
     

	assign mode_d_4 = mode_d[1:0];

    assign x_reg1_comp = ~x_reg1+1;
    assign x_reg2_comp = ~x_reg2+1;

	assign x_add0_op1_4 = x_reg1;
	assign x_add0_op2_4 = (mode_d_4==2'b01)?ADD_ROW:x_add0;
	
	assign x_add1_op1_4 = ((mode_d_4[0]^mode_d_4[1])==1)?x_reg2:x_reg2_comp;
	assign x_add1_op2_4 = (mode_d_4==2'b01)?ADD_ROW:x_add1;
	
	assign x_add2_op1_4 = (mode_d_4[1]==0)?x_reg2:x_reg2_comp;
	assign x_add2_op2_4 = (mode_d_4==2'b01)?ADD_ROW:x_add2;
	
	assign x_add3_op1_4 = (mode_d_4[0]==1)?x_reg1:x_reg1_comp;
	assign x_add3_op2_4 = (mode_d_4==2'b01)?ADD_ROW:x_add3;


	assign x_reg3_comp = ~x_reg3+1;
    assign x_reg4_comp = ~x_reg4+1;
	
    assign x_add0_op1_8 = x_reg1;
	assign x_add0_op2_8 = (mode_d==3'b001)?ADD_ROW:x_add0;
	
	assign x_add1_op1_8 = ((mode_d[2]==1)||(mode_d==3'b0))?x_reg2_comp:x_reg2;
	assign x_add1_op2_8 = (mode_d==3'b001)?ADD_ROW:x_add1;
	
	assign x_add2_op1_8 = ((mode_d[2:1]==2'b10)||(mode_d==3'b011))?x_reg3_comp:x_reg3;
	assign x_add2_op2_8 = (mode_d==3'b001)?ADD_ROW:x_add2;
	
	assign x_add3_op1_8 = ((mode_d[0]^mode_d[1])==0)?x_reg4_comp:x_reg4;
	assign x_add3_op2_8 = (mode_d==3'b001)?ADD_ROW:x_add3;	

	
	assign x_add4_op1 = (mode_d[1]==1)?x_reg4_comp:x_reg4;
	assign x_add4_op2 = (mode_d==3'b001)?ADD_ROW:x_add4;
	
	assign x_add5_op1 = ((mode_d[2:1]==2'b01)||(mode_d==3'b0)||(mode_d==3'b110)||(mode_d==3'b101))?x_reg3_comp:x_reg3;
	assign x_add5_op2 = (mode_d==3'b001)?ADD_ROW:x_add5;
	
	assign x_add6_op1 = ((mode_d==3'b010)||((mode_d[2]&mode_d[0])==1))?x_reg2_comp:x_reg2;
	assign x_add6_op2 = (mode_d==3'b001)?ADD_ROW:x_add6;
	
	assign x_add7_op1 = (mode_d[0]==0)?x_reg1_comp:x_reg1;
	assign x_add7_op2 = (mode_d==3'b001)?ADD_ROW:x_add7;	

	assign x_add0_op1 = (idct4_3[0]==1)? x_add0_op1_4: x_add0_op1_8;
	assign x_add1_op1 = (idct4_3[0]==1)? x_add1_op1_4: x_add1_op1_8;
	assign x_add2_op1 = (idct4_3[0]==1)? x_add2_op1_4: x_add2_op1_8;
	assign x_add3_op1 = (idct4_3[0]==1)? x_add3_op1_4: x_add3_op1_8;

	assign x_add0_op2 = (idct4_3[0]==1)? x_add0_op2_4: x_add0_op2_8;
	assign x_add1_op2 = (idct4_3[0]==1)? x_add1_op2_4: x_add1_op2_8;
	assign x_add2_op2 = (idct4_3[0]==1)? x_add2_op2_4: x_add2_op2_8;
	assign x_add3_op2 = (idct4_3[0]==1)? x_add3_op2_4: x_add3_op2_8;		

	always @ (posedge clk)
	begin
		 if(!rst_n)
			x_in <= 16'b0;
	     else 
			x_in <= x_in_origin;
	end	
	
	always @(posedge clk) begin
		if (!rst_n) begin
	  		idct4_1 <= 2'b0;
			idct4_4 <= 2'b0;		  
		end else begin
	  		idct4_1 <= idct4;
			idct4_4 <= idct4_3;			  
		end			
	end

	always @ (posedge clk)
	begin
		 if(!rst_n)
			mode <= 3'b0;
	     else if ((mode==3'b111)||(idct4_1==2'b00))
			mode <= 3'b0;
		 else
		    mode <= mode+1;
	end	
	
	always @ (posedge clk)
	begin
		 if(!rst_n)
			mode_d <= 3'b0;
		 else
		    mode_d <= mode;
	end

	shift_mul shift_mul_row(clk,rst_n,x_in,mode_d,idct4_1,idct4_3,x_reg1,x_reg2,x_reg3,x_reg4);  

	always @ (posedge clk)                     //add 
	begin
	    if (!rst_n)
		begin
		   x_add0 <= 25'b0;
		   x_add1 <= 25'b0;
		   x_add2 <= 25'b0;
		   x_add3 <= 25'b0;
		   x_add4 <= 25'b0;
		   x_add5 <= 25'b0;
		   x_add6 <= 25'b0;
		   x_add7 <= 25'b0;
		end
	    else begin
		   x_add0 <= x_add0_op1 + x_add0_op2;
		   x_add1 <= x_add1_op1 + x_add1_op2;
		   x_add2 <= x_add2_op1 + x_add2_op2;
		   x_add3 <= x_add3_op1 + x_add3_op2;
		   x_add4 <= x_add4_op1 + x_add4_op2;
		   x_add5 <= x_add5_op1 + x_add5_op2;
		   x_add6 <= x_add6_op1 + x_add6_op2;
		   x_add7 <= x_add7_op1 + x_add7_op2;
		end  
	end	
	
	always @ (posedge clk)
	begin
		if(!rst_n) begin
				y0 <= 16'b0;
				y1 <= 16'b0;
				y2 <= 16'b0;
				y3 <= 16'b0;
				y4 <= 16'b0;
				y5 <= 16'b0;
				y6 <= 16'b0;
				y7 <= 16'b0;
				idct4_5 <= 2'b0;
		end
		else if ({idct4_4[0],mode_d}==4'b1101) begin
				y0 <= x_add0>>>SHIFT_ROW;
				y1 <= x_add1>>>SHIFT_ROW;
				y2 <= x_add2>>>SHIFT_ROW;
				y3 <= x_add3>>>SHIFT_ROW;
				y4 <= y4; 
				y5 <= y5;
				y6 <= y6;
				y7 <= y7;
				idct4_5 <= idct4_5;			
		end
		else if ({idct4_4[0],mode_d}==4'b1001) begin
				y0 <= y0;
				y1 <= y1;
				y2 <= y2;
				y3 <= y3;
				y4 <= x_add0>>>SHIFT_ROW; 
				y5 <= x_add1>>>SHIFT_ROW;
				y6 <= x_add2>>>SHIFT_ROW;
				y7 <= x_add3>>>SHIFT_ROW;
				idct4_5 <= 2'b01;						
		end		
		else if ({idct4_4[1],mode_d}==4'b1001) begin
				y0 <= x_add0>>>SHIFT_ROW;
				y1 <= x_add1>>>SHIFT_ROW;
				y2 <= x_add2>>>SHIFT_ROW;
				y3 <= x_add3>>>SHIFT_ROW;
				y4 <= x_add4>>>SHIFT_ROW;
				y5 <= x_add5>>>SHIFT_ROW;
				y6 <= x_add6>>>SHIFT_ROW;
				y7 <= x_add7>>>SHIFT_ROW;
				idct4_5 <= 2'b10;		  
		end
		else   begin
				y0 <= y0;
				y1 <= y1;
				y2 <= y2;
				y3 <= y3;
				y4 <= y4;
				y5 <= y5;
				y6 <= y6;
				y7 <= y7;
				idct4_5 <= idct4_5;	        
		end
	end 

	always @(posedge clk) begin
		if (!rst_n)
			idct_out <= 2'b0;
		else begin
			idct_out <= idct4_5;
		end
	end


	always @(posedge clk) begin
		if (!rst_n||(idct4_5==2'b0))
			y_out <= 16'b0;
		else begin
			case (mode_d)
			  3'b010: y_out <= y0;
			  3'b011: y_out <= y1;
			  3'b100: y_out <= y2;
			  3'b101: y_out <= y3; 
			  3'b110: y_out <= y4;
			  3'b111: y_out <= y5;
			  3'b000: y_out <= y6;
			  3'b001: y_out <= y7;
			endcase
		end
	end
endmodule
	
