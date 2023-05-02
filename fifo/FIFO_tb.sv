import pack_FIFO::*;

module FIFO_tb (FIFO_if.TEST tb_if);

parameter n = FIFO_DEPTH;

logic [FIFO_WIDTH-1:0] fif_q [$:n-1];
parameter num_test=n*20;
fiffo fifoo = new();
initial begin

	

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	fifoo.write_read.constraint_mode(0);
	
	tb_if.data_in =0;
	tb_if.wr_en = 0;
	tb_if.rd_en = 0;
	tb_if.rst_n = 0;
	repeat(n)@(negedge tb_if.clk);
	fifoo.rd_en.rand_mode(0);
	fifoo.rd_en=0;
	tb_if.rst_n = 1;
	for (int i = 0; i < num_test; i++) begin
		@(negedge tb_if.clk);
		assert(fifoo.randomize());
		tb_if.data_in = fifoo.data_in;
		tb_if.wr_en = fifoo.wr_en;
		tb_if.rd_en = fifoo.rd_en;
		tb_if.rst_n = fifoo.rst_n;
	end
	@(negedge tb_if.clk);
		tb_if.data_in =0;
	tb_if.wr_en = 0;
	tb_if.rd_en = 0;
	repeat(2*n)@(negedge tb_if.clk);
	
	fifoo.wr_en.rand_mode(0);
	fifoo.wr_en=0;
	for (int i = 0; i < num_test; i++) begin
		@(negedge tb_if.clk);
		assert(fifoo.randomize());
		fifoo.rd_en=$random();
		tb_if.data_in = fifoo.data_in;
		tb_if.wr_en = fifoo.wr_en;
		tb_if.rd_en = fifoo.rd_en;
		tb_if.rst_n = fifoo.rst_n;
	end
	@(negedge tb_if.clk);
		tb_if.data_in =0;
	tb_if.wr_en = 0;
	tb_if.rd_en = 0;
	repeat(2*n)@(negedge tb_if.clk);
	fifoo.wr_en.rand_mode(1);
	for (int i = 0; i < num_test*2; i++) begin
		@(negedge tb_if.clk);
		assert(fifoo.randomize());
		tb_if.data_in = fifoo.data_in;
		tb_if.wr_en = fifoo.wr_en;
		fifoo.rd_en=$random();
		tb_if.rd_en = fifoo.rd_en;
		tb_if.rst_n = fifoo.rst_n;

	end

	@(negedge tb_if.clk);
	tb_if.rst_n = 0;
	repeat(2*n)@(negedge tb_if.clk);

	////////////////////////////////////////////////
	tb_if.rst_n = 1;
	fifoo.write_read.constraint_mode(1);
	fifoo.wr_en.rand_mode(1);
	fifoo.rd_en.rand_mode(1);
	for (int i = 0; i < num_test; i++) begin
		@(negedge tb_if.clk);
		fifoo.size = fif_q.size();
		assert(fifoo.randomize());
		tb_if.data_in = fifoo.data_in;
		tb_if.wr_en = fifoo.wr_en;
		tb_if.rd_en = fifoo.rd_en;
		tb_if.rst_n = fifoo.rst_n;

	end

	@(negedge tb_if.clk);
	tb_if.rst_n = 0;
	repeat(2*n)@(negedge tb_if.clk);
	

	$stop;
end
always @(negedge tb_if.clk)begin

			fifoo.wr_ack = tb_if.wr_ack;
			fifoo.empty = tb_if.empty;
			fifoo.full  = tb_if.full;
			fifoo.almostfull = tb_if.almostfull;
			fifoo.almostempty = tb_if.almostempty;
			fifoo.overflow = tb_if.overflow;
			fifoo.underflow = tb_if.underflow;	
end
bit w_d=0;
always @(posedge tb_if.clk or negedge fifoo.rst_n) begin 
		fifoo.fif.sample();
	if(~fifoo.rst_n) begin
	fif_q.delete();
	tb_if.data_out_expected = 0;
	end else begin
w_d=0;
		 if (tb_if.wr_en) begin
		 	/* code */
		 	w_d=1;
		 	if (fif_q.size()==n)
		 		w_d=0;
		 	fif_q.push_back(tb_if.data_in);
		 	
		 end
		 if (tb_if.rd_en) begin
		 	/* code */
		 	tb_if.data_out_expected=fif_q.pop_front();
		 end
		  if (tb_if.wr_en&&!w_d) begin
		 	/* code */
		 	fif_q.push_back(tb_if.data_in);
		 	
		 end
	end
end


endmodule 