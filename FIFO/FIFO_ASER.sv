import pack_FIFO::*;
module fifo_sva_a(FIFO_if.asert asrt);
int count =0;
parameter n = FIFO_DEPTH;
always @(posedge  asrt.clk or negedge asrt.rst_n)begin
		if(~asrt.rst_n) begin
		 count <= 0;
	end else begin
		if (asrt.wr_en&&!asrt.rd_en)
			if(count!=n)
				count++;
		if (asrt.rd_en&&!asrt.wr_en)
			if(count!=0)
				count--;
	end
end


property over_r;
		@(posedge asrt.clk) (count==n && asrt.wr_en&& !asrt.rd_en && asrt.rst_n) |=> asrt.overflow ;
	endproperty
	over_chk_r: assert property(over_r);	
	c_over_r : cover property(over_r);

property over_f;
		@(posedge asrt.clk) ($past(asrt.overflow) && (count < n||$past(!asrt.wr_en)||!asrt.rst_n ) ) |-> !(asrt.overflow) ;
	endproperty
	over_chk_f: assert property(over_f);	
	c_over_f : cover property(over_f);

property full_r;
		@(posedge asrt.clk) (count==n) |-> (asrt.full) ;
	endproperty
	full_chk_r: assert property(full_r);
	cfull_r : cover property (full_r);

property full_f;
		@(posedge asrt.clk) ($past(asrt.full) && count < n) |-> !(asrt.full) ;
	endproperty
	full_chk_f: assert property(full_f);
	cfull_f : cover property (full_f);


property afull_r;
		@(posedge asrt.clk) (count==n-1)|-> (asrt.almostfull);
	endproperty
	amostFull_r : assert property(afull_r);
	c_amostfull_r : cover property(afull_r);
property afull_f;
		@(posedge asrt.clk) ($past(asrt.almostfull)&&(count!=n-1))|-> !(asrt.almostfull);
	endproperty
	amostFull_f : assert property(afull_f);
	c_amostfull_f : cover property(afull_f);



property aempty_r;
		@(posedge asrt.clk) (count==1)|->(asrt.almostempty);
	endproperty
	amostEmpty_r : assert property(aempty_r);
	c_amostempty_r : cover property(aempty_r);

property aempty_f;
		@(posedge asrt.clk) ($past(asrt.almostempty)&&count!=1)|->!(asrt.almostempty);
	endproperty
	amostEmpty_f : assert property(aempty_f);
	c_amostempty_f : cover property(aempty_f);



property empty_r;
		@(posedge asrt.clk) (count==0) |-> (asrt.empty) ;
	endproperty
	empty_chk_r: assert property(empty_r);
	cempty_r : cover property(empty_r);
property empty_f;
		@(posedge asrt.clk) ($past(asrt.empty)&&count!=0) |-> !(asrt.empty) ;
	endproperty
	empty_chk_f: assert property(empty_f);
	cempty_f : cover property(empty_f);


property under_r;
		 @(posedge asrt.clk) (count==0 && asrt.rd_en && asrt.rst_n)|=> (asrt.underflow) ;
	endproperty
	uner_chk_r: assert property(under_r);
	cunder_r : cover property(under_r);

property under_f;
		 @(posedge asrt.clk) ($past(asrt.underflow)&&(count!=0 || !asrt.rd_en||$fell(asrt.rst_n)))|-> !(asrt.underflow) ;
	endproperty
	uner_chk_f: assert property(under_f);
	cunder_f : cover property(under_f);



property wack_1_r ;
		@(posedge asrt.clk) (asrt.wr_en &&count!=n && asrt.rst_n)  |=> (asrt.wr_ack);
	endproperty
	wrAck_chk1_r : assert property(wack_1_r);
	c_wrAck_r : cover property(wack_1_r);

property wack_1_f ;
		@(posedge asrt.clk) ($past(asrt.wr_ack) &&(count==n ||$past(!asrt.wr_en)||!asrt.rst_n))  |-> !(asrt.wr_ack);
	endproperty
	wrAck_chk1_f : assert property(wack_1_f);
	c_wrAck_f : cover property(wack_1_f);


property rst_behave;
@(negedge asrt.rst_n)  (!asrt.full&&!asrt.wr_ack&&!asrt.overflow&&!asrt.almostfull&&!asrt.underflow&&!asrt.almostempty&&asrt.data_out==0&&asrt.empty) ;
endproperty
	rst_behave_chk : assert property(rst_behave);
	C_rst_behave : cover property(rst_behave);


endmodule 