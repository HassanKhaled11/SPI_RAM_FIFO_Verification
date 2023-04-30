module fifo_sva(FIFO_if.asert asrt);

	property full;
		@(posedge asrt.clk) ($fell(asrt.almostfull) && asrt.wr_en) |=> (asrt.full) ;
	endproperty
	full_chk: assert property(full) else $display("full assert error");
	cfull : cover property (full);
	property over;
		@(posedge asrt.clk) ($rose(asrt.full) && asrt.wr_en) |=> (asrt.overflow) ;
	endproperty
	over_chk: assert property(over) else $display("overflow assert error");	
	c_over : cover property(over); 
	property empty;
		@(posedge asrt.clk) ($rose(asrt.almostempty) && asrt.rd_en) |=> (asrt.empty) ;
		// after one clock cycle from amostempty is high with reading enable active
		//empty is high so we need atleast 1 clk cycle delay to assert it 
		// we can use non overlapping implication operator
		// or support one delay as ##1 
	endproperty

	empty_chk: assert property(empty) else $display("empty assert error");
	cempty : cover property(empty);
	property under;
		// @(posedge asrt.clk) ($rose(asrt.empty) && asrt.rd_en) |=> (asrt.underflow) ;
		@(posedge asrt.clk) !(asrt.rd_en) and !asrt.empty |-> !(asrt.underflow);
	endproperty
	uner_chk: assert property(under) else $display("underflow assert error");
	cunder : cover property(under);
	//////////////////// new assertions ////////////////////////
	property over_long;
		@(posedge asrt.clk) (asrt.full && asrt.wr_en) |=> (asrt.overflow throughout $rose(asrt.rd_en));
	endproperty
	overLong : assert property(over_long);
	c_over_long : cover property(over_long);
	/////////////////////// almost property ////////////////////////////////
	/*
		(1) empty then write --> almost empty
		(2) full then read 	 --> almost full
	*/
	property aempty;
		@(posedge asrt.clk) ($rose(asrt.empty) && asrt.wr_en)|=> asrt.almostempty[->1];
	endproperty
	amostEmpty : assert property(aempty) else $display("almostempty assert error");
	c_amostempty : cover property(aempty);
	property afull;
		@(posedge asrt.clk) ($fell(asrt.full) && asrt.rd_en)|=> asrt.almostfull[->2];
	endproperty
	amostFull : assert property(afull) else $display("almostfull assert error");
	c_amostfull : cover property(afull);

	/////////////////// write acknowledge ////////////////////
	property wack_1 ;
		@(posedge asrt.clk) if(asrt.rst_n) $rose(asrt.wr_en) |=> $rose(asrt.wr_ack);
	endproperty
	wrAck_chk1 : assert property(wack_1) else $display("wr_Ack assert error");
	c_wrAck : cover property(wack_1);
	property reset ;
		@(posedge asrt.clk)  !(asrt.rst_n) |=> (asrt.empty);
	endproperty
	reset_chk1 : assert property(reset) else $display("resert assert error");
	reset_in : cover property(reset);
	property wack ;
		@(posedge asrt.clk) $rose(asrt.wr_en) |->##[1:2] (asrt.wr_ack);
	endproperty
	wrAck_chk : assert property(wack) else $display("wr_ack assert error");
	c2_wack : cover property(wack);
endmodule 