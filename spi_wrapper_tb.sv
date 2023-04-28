`include "spi_wrapper_C.sv"

module spi_wrapper_tb();

bit MOSI,clk,rst_n,SS_n;
bit  MISO;

localparam NO_OF_INPUTS = 'd2000;
bit [10:0] data_to_write [];


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
//@(negedge clk);
assert(sw_obj.randomize());
data_to_write[i] = sw_obj.joker;
end

repeat(5) @(negedge clk);

rst_n = 0;
#5;
rst_n = 1;
#2; 


foreach(data_to_write[i])begin
SS_n = 0;
  for(int j = 10 ; j >= 0 ; j--)begin
    @(negedge clk);
    MOSI = data_to_write[i][j];
  end

if(data_to_write[i][10:8] == 3'b111)
repeat(10)@(negedge clk);
SS_n = 1;

@(negedge clk);
end
$stop;
end


endmodule
