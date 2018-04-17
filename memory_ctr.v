module memory_ctr
#(
	parameter WIDTH_X = 16
)
(   
	input wire clk, rst_n, 
  input wire [1:0] idct4_5,
	input wire [WIDTH_X-1:0] d_in,
    output reg [1:0] idct4_out,
    output reg [WIDTH_X-1:0] d_out
);  

reg [5:0] w_addr, r_addr, w_addr_op;
reg [7:0] cnt;
reg mem1_w_en, mem1_r_en, mem2_w_en, mem2_r_en, mem1_r_en_d, mem2_r_en_d;
wire [WIDTH_X-1:0] d_out_mem1, d_out_mem2;
reg [1:0] t_rd_sign, idct4_6, idct4_out_t;
wire t_rd_sign_xor;
reg read_start;


mem8 mem1(clk, rst_n, mem1_w_en, mem1_r_en, w_addr, r_addr, d_in, d_out_mem1);

mem8 mem2(clk, rst_n, mem2_w_en, mem2_r_en, w_addr, r_addr, d_in, d_out_mem2);

always @(posedge clk ) begin
    if (!rst_n)
        idct4_6 <= 2'b0;
    else 
        idct4_6 <= idct4_5;
end

always @(posedge clk ) begin
    if (!rst_n) begin
      cnt <= 0;
    end else if ((cnt==7'b1111111)||(idct4_5==2'b0)) begin
      cnt <= 0;
    end
    else begin
      cnt <= cnt + 1;
    end
end


always @(posedge clk ) begin
    if (!rst_n) begin
      mem1_w_en <= 0;
    end else if ((cnt[6]==1)||(idct4_5==2'b0)) begin
      mem1_w_en <= 0;
    end
    else begin
      mem1_w_en <= 1;
    end
end

always @(posedge clk ) begin
    if (!rst_n) begin
      mem2_w_en <= 0;
    end else if ((cnt[6]==0)||(idct4_5==2'b0)) begin
      mem2_w_en <= 0;
    end
    else begin
      mem2_w_en <= 1;
    end
end

always @(*) begin
  if (idct4_6[0]==1) begin
    if (w_addr[3:2]!=2'b11) begin
        w_addr_op = 4;
      end else if (w_addr[1:0]!=2'b11) begin
          w_addr_op = -11;
        end else if (w_addr[5:4]!=2'b11) begin
            w_addr_op = 1;
          end else begin
            w_addr_op = -63;
          end
  end else if (idct4_6[1]==1) begin
    if (w_addr[5:3]!=3'b111) begin
        w_addr_op = 8;
      end else if (w_addr[2:0]!=3'b111) begin
          w_addr_op = -55;
          end else begin
            w_addr_op = -63;
          end    
  end
  else  w_addr_op = 6'b0;
end

always @(posedge clk) begin
  if (!rst_n||(idct4_5==2'b0)) begin
    w_addr <= 6'b0;
  end else begin
    w_addr <= w_addr_op + w_addr;
  end
end

assign t_rd_sign_xor = t_rd_sign[0]^t_rd_sign[1];

always @(posedge clk ) begin
  if (!rst_n) begin
    t_rd_sign <= 2'b0;
  end else if ((read_start==0)&&(t_rd_sign_xor==1)) begin
    t_rd_sign <= t_rd_sign;
  end else begin
    t_rd_sign <= idct4_5 ^ idct4_6;
  end
end

always @(posedge clk ) begin
  if (!rst_n) begin
    read_start <= 0;
  end else if ((t_rd_sign_xor==1)&&(cnt[6:0]==6'b110001)) begin
    read_start <= 1;
  end else begin
    read_start <= 0;
  end    
end


always @(posedge clk ) begin
  if (!rst_n) begin
    mem1_r_en <= 0;
  end else if(read_start==1) begin
    mem1_r_en <= 1;
  end else if(r_addr==6'b111111) begin
    mem1_r_en <= ~mem1_r_en;
  end else begin
    mem1_r_en <= mem1_r_en;
  end
end

always @(posedge clk ) begin
  if (!rst_n) begin
    mem2_r_en <= 0;
  end else if(r_addr==6'b111111) begin
    mem2_r_en <= ~mem2_r_en;
  end else begin
    mem2_r_en <= mem2_r_en;
  end
end

always @(posedge clk ) begin
  if (!rst_n) begin
    r_addr <= 6'b0;
  end else if(r_addr == 6'b111111) begin
    r_addr <= 6'b0;
  end else if((mem1_r_en==1)||(mem2_r_en==1)) begin
    r_addr <= r_addr + 1;
  end else begin
    r_addr <= r_addr;
  end
end

always @(posedge clk ) begin
  if (!rst_n) begin
    mem1_r_en_d <= 0;
    mem2_r_en_d <= 0;    
  end else begin
    mem1_r_en_d <= mem1_r_en;
    mem2_r_en_d <= mem2_r_en; 
  end
end

always @(posedge clk ) begin
  if (!rst_n) begin
    idct4_out_t <=2'b0;
  end else if((mem1_r_en_d ^ mem1_r_en)==1) begin
    idct4_out_t <= idct4_6;
  end else begin
    idct4_out_t <= idct4_out_t;
  end
end

always @(posedge clk ) begin
  if (!rst_n) begin
    idct4_out <=2'b0;
  end else begin
    idct4_out <= idct4_out_t;
  end
end

always @(posedge clk ) begin
  if (!rst_n) begin
    d_out <=22'b0;
  end else if(mem1_r_en_d==1) begin
    d_out <= d_out_mem1;
  end else if(mem2_r_en_d==1) begin
    d_out <= d_out_mem2;
  end else begin
    d_out <= d_out;
  end
end

endmodule
