module ram_sva(din,rx_valid,tx_valid,dout,clk,rst_n);
input [9:0] din;
input rx_valid;
input clk,rst_n;
input tx_valid;
input [7:0] dout;


property tx_assertion;
@(posedge clk) disable iff(!rst_n) (din[9:8] == 2'b11) |=> ##[1:2] $rose(tx_valid);
endproperty

assert property (tx_assertion);
cover property  (tx_assertion);


property tx_deassertion;
@(posedge clk) disable iff(!rst_n) $rose(tx_valid) |=> ((!tx_valid) throughout din[9:8] != 2'b11);
endproperty

assert property (tx_deassertion);
cover property  (tx_deassertion);


property write_op;
@(posedge clk)  disable iff(!rst_n) (din[9:8] == 2'b00) |-> ##1  (din[9:8] == 2'b01);
endproperty

assert property(write_op);
cover property(write_op);


property read_op;
@(posedge clk)  disable iff(!rst_n) (din[9:8] == 2'b10) |-> ##1  (din[9:8] == 2'b11);
endproperty

assert property(read_op);
cover property(read_op);



property reset_out;
@(posedge clk)  $fell(rst_n) |-> (dout == 0);
endproperty

rst_out:  assert property (reset_out);
rst_out_cov: cover property (reset_out);



endmodule
