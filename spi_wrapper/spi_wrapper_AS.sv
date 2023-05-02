module spi_wrapper_sva(MISO,MOSI,SS_n,clk,rst_n);

input MOSI,clk,rst_n,SS_n;
input MISO;

sequence seq_read_data;
 $fell(SS_n)##1 MOSI [*3]; 
endsequence

//--------------------------------------------------
property rst_prop;
@(posedge clk) ($fell(rst_n) || $rose(SS_n)) |-> !MISO;
endproperty

assert property(rst_prop);
cover property (rst_prop);

//--------------------------------------------------

property ssn_prop;
@(posedge clk) seq_read_data |=> !SS_n[*15] ##1 $rose(SS_n);
endproperty

assert property(ssn_prop);
cover property(ssn_prop);



endmodule
