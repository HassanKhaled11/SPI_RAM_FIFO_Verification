module monitor(FIFO_if.monitor mon);
always @(posedge mon.clk or negedge mon.rst_n) begin 
	if (mon.data_out!=mon.data_out_expected)
		$display("error @ time = %0t 	expe=%0h   out =%0h",$time(), mon.data_out_expected, mon.data_out);
	else
		$display("RIGHT");
	end
compar: assert property (@(posedge mon.clk or negedge mon.rst_n) mon.data_out==mon.data_out_expected);
endmodule