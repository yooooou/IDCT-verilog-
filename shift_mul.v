module shift_mul
#(
	parameter WIDTH_X = 16,
	parameter WIDTH_Y = 23
)

(   input clk,
	input rst_n,
    input signed [WIDTH_X-1:0] x_in,
	input [2:0] mode,
	input [1:0]idct4_1,
	output reg [1:0]idct4_3,
	output reg signed [WIDTH_Y-1:0] y0,
	output reg signed [WIDTH_Y-1:0] y1,
	output reg signed [WIDTH_Y-1:0] y2,
	output reg signed [WIDTH_Y-1:0] y3
);
// stage 1
wire signed [WIDTH_X-1:0] x0;
wire signed [WIDTH_X:0] x1;
wire signed [WIDTH_X+1:0] x2;
wire signed [WIDTH_X+2:0] x3;
wire signed [WIDTH_X+3:0] x4; 
wire signed [WIDTH_X+4:0] x5; 
wire signed [WIDTH_X+5:0] x6;


reg signed [WIDTH_Y-4:0] add_10;
reg signed [WIDTH_Y-3:0] add_18;
reg signed [WIDTH_Y-3:0] add_24;
reg signed [WIDTH_Y-2:0] add_36;
reg signed [WIDTH_Y-1:0] add_65;
reg signed [WIDTH_X+4:0] x5_d;
reg signed [WIDTH_X+5:0] x6_d;

reg [1:0] idct4_2;

// stage 2
wire signed [WIDTH_Y-2:0] add_50;
wire signed [WIDTH_Y-1:0] add_75;
wire signed [WIDTH_Y-1:0] add_83;
wire signed [WIDTH_Y-1:0] add_89;

// shift 
assign x0 = x_in;
assign x1 = {x_in,1'b0};
assign x2 = {x_in,2'b0};
assign x3 = {x1,2'b0};
assign x4 = {x_in,4'b0};
assign x5 = {x2,3'b0};    
assign x6 = {x_in,6'b0};



always @(posedge clk ) begin
  if (!rst_n) begin
    idct4_2 <= 2'b0;
  end else begin
    idct4_2 <= idct4_1;
  end
end


always @(posedge clk) begin               //stage 1
	if (!rst_n) begin
	  x5_d <= 21'b0;	
	  x6_d <= 22'b0;
	  add_10 <= 20'b0;
	  add_18 <= 21'b0;
	  add_24 <= 21'b0;        
	  add_36 <= 22'b0;
	  add_65 <= 23'b0;          
	end
	else begin
	  x5_d <= x5;		
	  x6_d <= x6;	  
	  add_10 <= x3 + x1;
	  add_18 <= x1 + x4;
	  add_24 <= x4 + x3;        
	  add_36 <= x5 + x2;
	  add_65 <= x6 + x0; 	  
	end
end

// stage 2
assign add_50 = x5_d + add_18;
assign add_75 = add_65 + add_10;
assign add_83 = add_65 + add_18;
assign add_89 = add_65 + add_24;

always @(posedge clk) begin
  if (!rst_n)
	idct4_3 <= 2'b0;
  else 
	idct4_3 <= idct4_2;
end

always @(posedge clk) begin
	if (!rst_n)
		begin
			y0 <= 23'b0;
			y1 <= 23'b0;
			y2 <= 23'b0;
			y3 <= 23'b0;
		end
    else if (idct4_2==2'b01) begin
		case (mode[1:0])
		2'b00: 
			begin
				y0 <= x6_d;
				y1 <= x6_d;
				y2 <= y2;
				y3 <= y3;
			end
		2'b01:
			begin
				y0 <= add_83;
				y1 <= add_36;
				y2 <= y2;
				y3 <= y3;				
			end
		2'b10:
			begin
				y0 <= x6_d;
				y1 <= x6_d;
				y2 <= y2;
				y3 <= y3;
			end	
		2'b11:
			begin
				y0 <= add_36;
				y1 <= add_83;
				y2 <= y2;
				y3 <= y3;
		    end
	   endcase
	 end
	else if (idct4_2==2'b10) begin
		  case(mode)
		3'b000:
			begin
				y0 <= x6_d;
				y1 <= x6_d;
				y2 <= x6_d;
				y3 <= x6_d;
			end
		3'b001:
			begin
				y0 <= add_89;
				y1 <= add_75;
				y2 <= add_50;
				y3 <= add_18;
			end	
		3'b010:
			begin
				y0 <= add_83;
				y1 <= add_36;
				y2 <= add_36;
				y3 <= add_83;
			end	
		3'b011:
			begin
				y0 <= add_75;
				y1 <= add_18;
				y2 <= add_89;
				y3 <= add_50;
			end	
		3'b100:
			begin
				y0 <= x6_d;
				y1 <= x6_d;
				y2 <= x6_d;
				y3 <= x6_d;
			end	
		3'b101:
			begin
				y0 <= add_50;
				y1 <= add_89;
				y2 <= add_18;
				y3 <= add_75;
			end	
		3'b110:
			begin
				y0 <= add_36;
				y1 <= add_83;
				y2 <= add_83;
				y3 <= add_36;
			end				
		3'b111:
			begin
				y0 <= add_18;
				y1 <= add_50;
				y2 <= add_75;
				y3 <= add_89;
			end
		endcase	  
	 end
	else
		begin
			y0 <= 23'b0;
			y1 <= 23'b0;
			y2 <= 23'b0;
			y3 <= 23'b0;
		end
 end
endmodule


