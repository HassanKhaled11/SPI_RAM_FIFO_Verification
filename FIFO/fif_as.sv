module fifo_sva(FIFO_if.asert asrt);

	property full;
		@(posedge asrt.clk) ($fell(asrt.almostfull) && asrt.wr_en) |=> (asrt.full) ;
	endproperty
	full_chk: assert property(full);

	property over;
		@(posedge asrt.clk) ($rose(asrt.full) && asrt.wr_en) |=> (asrt.overflow) ;
	endproperty
	over_chk: assert property(over);	

	property empty;
		@(posedge asrt.clk) ($rose(asrt.almostempty) && asrt.rd_en) |=> (asrt.empty) ;
		// after one clock cycle from amostempty is high with reading enable active
		//empty is high so we need atleast 1 clk cycle delay to assert it 
		// we can use non overlapping implication operator
		// or support one delay as ##1 
	endproperty

	empty_chk: assert property(empty);
	
	property under;
		// @(posedge asrt.clk) ($rose(asrt.empty) && asrt.rd_en) |=> (asrt.underflow) ;
		@(posedge asrt.clk) !(asrt.rd_en) and !asrt.empty |-> !(asrt.underflow);
	endproperty
	uner_chk: assert property(under);

	//////////////////// new assertions ////////////////////////
	property over_long;
		@(posedge asrt.clk) (asrt.full && asrt.wr_en) |=> (asrt.overflow throughout $rose(asrt.rd_en));
	endproperty
	overLong : assert property(over_long);

	/////////////////////// almost property ////////////////////////////////
	/*
		(1) empty then write --> almost empty
		(2) full then read 	 --> almost full
	*/
	property aempty;
		@(posedge asrt.clk) ($rose(asrt.empty) && asrt.wr_en)|=> asrt.almostempty[->1];
	endproperty
	amostEmpty : assert property(aempty);

	property afull;
		@(posedge asrt.clk) ($fell(asrt.full) && asrt.rd_en)|=> asrt.almostfull[->2];
	endproperty
	amostFull : assert property(afull);
endmodule 