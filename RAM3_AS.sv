module ram_sva(din,rx_valid,tx_valid,dout,clk,rst_n);
input [9:0] din;
input rx_valid;
input clk,rst_n;
input tx_valid;
input [7:0] dout;

tx_assertion: assert property (@(posedge clk)  disable iff(!rst_n) (din[9:8] == 2'b11) |=>  (din[9:8] == 2'b11) throughout $rose(tx_valid));

tx_assertion2: assert property (@(posedge clk) disable iff(!rst_n) (din[9:8] == 2'b11) |=> ##[1:2] $rose(tx_valid));


reset_out   : assert property (@(posedge clk)  $fell(rst_n) |-> (dout == 0));






endmodule
