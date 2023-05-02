`include "spi_wrapper_C.sv"

module spi_wrapper_tb();

bit MOSI,clk,rst_n,SS_n;
bit MISO, MISO_ex;



localparam NO_OF_INPUTS = 'd2000;
bit [10:0] data_to_write [];
bit [7:0]  data_to_read  [bit [7:0]];
bit [7:0]  data_expected;


SW_C sw_obj = new();

spi_wrapper  spi_wr_dut(MISO,MOSI,SS_n,clk,rst_n);


bind spi_wrapper spi_wrapper_sva sw_sva_dut(MISO,MOSI,SS_n,clk,rst_n);


initial begin
clk = 0 ;
forever #1 clk = ~clk;
end

initial begin
data_to_write = new[NO_OF_INPUTS];

for(int i = 0 ; i < NO_OF_INPUTS ; i++) begin

assert(sw_obj.randomize());
data_to_write[i] = sw_obj.joker;
end

repeat(5) @(negedge clk);


foreach(data_to_write[i])begin

if(data_to_write[i][10:8] == 3'b000)begin
data_to_read[data_to_write[i][7:0]] = data_to_write[i+1][7:0];
end

if(data_to_write[i][10:8] == 3'b110)begin
data_expected = data_to_read[data_to_write[i][7:0]];

end

SS_n = 0;

  for(int j = 10 ; j >= 0 ; j--)begin
    @(negedge clk);
    MOSI = data_to_write[i][j];
  end

if(data_to_write[i][10:8] == 3'b111)
foreach(data_expected[x]) begin
@(negedge clk);
  MISO_ex=data_expected[x];
end

SS_n = 1;
#4;
@(negedge clk);
end

$stop;
end

 always @(negedge clk) begin 
 // sw_obj.SS_n = SS_n;
  assert(sw_obj.randomize());
  rst_n= sw_obj.rst_n;

 end

always @(posedge clk)begin
  sw_obj.cg.sample();
end

sequence seq_read_data;
 $fell(SS_n)##1 MOSI [*3]; 
endsequence

//-------------------------------------------
property miso_prop;
@ (posedge clk) seq_read_data |=> ##7 (MISO==MISO_ex)[*8];
endproperty

assert property(miso_prop);
cover property(miso_prop);

//-------------------------------------------

endmodule
