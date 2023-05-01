module fifo_sva(FIFO_if.asert asrt);

	property full;
		@(posedge asrt.clk) ($fell(asrt.almostfull) && asrt.wr_en) |-> (asrt.full) ;
	endproperty
	full_chk: assert property(full);
	cfull : cover property (full);

	property full2;
		@(posedge asrt.clk) $fell(asrt.empty) && asrt.wr_en |-> asrt.full[->1];
	endproperty
	full_chk2: assert property(full2);
	cfull2 : cover property (full2);
	///////////////////////////////////////////////////////////////////////////
	property over;
		@(posedge asrt.clk) ($rose(asrt.full) && asrt.wr_en) |=> (asrt.overflow) ;
	endproperty
	over_chk: assert property(over);	
	c_over : cover property(over); 
	property empty;
		@(posedge asrt.clk) ($rose(asrt.almostempty) && asrt.rd_en) |=> (asrt.empty) ;
		// after one clock cycle from amostempty is high with reading enable active
		//empty is high so we need atleast 1 clk cycle delay to assert it 
		// we can use non overlapping implication operator
		// or support one delay as ##1 
	endproperty

	empty_chk: assert property(empty);
	cempty : cover property(empty);

	property emp;
		@(posedge asrt.clk) $fell(asrt.rst_n)|-> $rose(asrt.empty);
	endproperty
	emp2: assert property(emp);
	cemp2 : cover property (emp);

	/////////////////////////////////////////////////////////
	property under;
		 @(posedge asrt.clk) ($rose(asrt.empty) && asrt.rd_en) |-> (asrt.underflow) ;
		//@(posedge asrt.clk) !(asrt.rd_en) and !asrt.empty |-> !(asrt.underflow);
	endproperty
	uner_chk: assert property(under);
	cunder : cover property(under);
	//////////////////// new assertions ////////////////////////
	// property over_long;
	// 	@(posedge asrt.clk) ($rose(asrt.full) && asrt.wr_en) |-> (asrt.overflow);
	// endproperty
	// overLong : assert property(over_long);
	// c_over_long : cover property(over_long);
	/////////////////////// almost property ////////////////////////////////
	/*
		(1) empty then write --> almost empty
		(2) full then read 	 --> almost full
	*/
	property aempty;
		@(posedge asrt.clk) ($rose(asrt.empty) && asrt.wr_en)|=> $rose(asrt.almostempty);
	endproperty
	amostEmpty : assert property(aempty);
	c_amostempty : cover property(aempty);
	property afull;
		@(posedge asrt.clk) ($fell(asrt.full))|-> $rose(asrt.almostfull);
	endproperty
	amostFull : assert property(afull);
	c_amostfull : cover property(afull);

	/////////////////// write acknowledge ////////////////////
	property wack_1 ;
		@(posedge asrt.clk) if(asrt.rst_n) $rose(asrt.wr_en) |=> $rose(asrt.wr_ack);
	endproperty
	wrAck_chk1 : assert property(wack_1);
	c_wrAck : cover property(wack_1);
	property wack ;
		@(posedge asrt.clk) $rose(asrt.wr_en) |->##[1:2] (asrt.wr_ack);
	endproperty
	wrAck_chk : assert property(wack);
	c2_wack : cover property(wack);


	
endmodule 
