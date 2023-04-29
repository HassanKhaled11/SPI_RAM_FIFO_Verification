module top ();
bit clk;
initial begin
	clk = 0;
	forever #1 clk = ~clk;
end

FIFO_if fif(clk);
FIFO #(.FIFO_DEPTH(4)) f_if(fif.DUT);
FIFO_tb tb_if(fif.TEST);
monitor_ print(fif.monitor);
bind FIFO fifo_sva asrt(fif.asert);
endmodule