interface FIFO_if (input bit clk);
	bit [15:0] data_in;
	bit wr_en,rd_en,rst_n;
	bit [15:0] data_out , data_out_expected;
	bit full,almostfull,empty,almostempty,overflow,underflow,wr_ack;
	modport DUT (input data_in, wr_en, rd_en, rst_n,clk,output data_out, full, almostfull, empty, almostempty, overflow, underflow, wr_ack);
	modport TEST (output data_in, wr_en, rd_en, rst_n,clk ,input data_out,data_out_expected, full, almostfull, empty, almostempty, overflow, underflow, wr_ack);
	modport monitor (input data_in, wr_en, rd_en, rst_n, data_out,data_out_expected, full, almostfull, empty, almostempty, overflow, underflow, wr_ack);
	modport asert (input clk, wr_en, rd_en, rst_n, full, almostfull, empty, almostempty, overflow, underflow,wr_ack);
endinterface
