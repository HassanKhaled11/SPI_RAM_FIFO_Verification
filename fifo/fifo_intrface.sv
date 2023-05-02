import pack_FIFO::*;
interface FIFO_if (input bit clk);

	bit [FIFO_WIDTH-1:0] data_in;
	bit wr_en,rd_en,rst_n;
	bit [FIFO_WIDTH-1:0] data_out , data_out_expected;
	bit full,almostfull,empty,almostempty,overflow,underflow,wr_ack;
	
	modport DUT (input data_in, wr_en, rd_en, rst_n,clk,output data_out, full, almostfull, empty, almostempty, overflow, underflow, wr_ack);
	modport TEST (output data_in, wr_en, rd_en, rst_n,clk,data_out_expected,input full, almostfull, empty, almostempty, overflow, underflow, wr_ack);
	modport monitor (input	clk,rst_n,rd_en,data_out , data_out_expected );
	modport asert (input data_out,data_in,clk, wr_en, rd_en, rst_n, full, almostfull, empty, almostempty, overflow, underflow,wr_ack);
endinterface
