import pack_FIFO::*;


module top();
bit clk;
initial begin
	clk = 0;
	forever #1 clk = ~clk;
end

FIFO_if  fif(clk);
FIFO #(.FIFO_DEPTH(FIFO_DEPTH),.FIFO_WIDTH(FIFO_WIDTH)) f_if(fif.DUT);
FIFO_tb tb_if(fif.TEST);
monitor print(fif.monitor);
bind FIFO  fifo_sva_a asrt(fif.asert);
endmodule