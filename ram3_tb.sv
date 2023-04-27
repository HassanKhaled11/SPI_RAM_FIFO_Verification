`include "RAM3_C.sv"


module spi_ram_tb;

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

bit   flag;
logic [9:0] din;
logic rx_valid;
bit   clk,rst_n;
logic tx_valid;
logic tx_valid_expected;
logic [7:0] dout;
//logic [7:0] memory [logic [7:0]];
logic [7:0] address;
logic [7:0] data_expected;
reg [7:0] memory [MEM_DEPTH-1 : 0];

C_RAM3 r_obj = new();

 spi_ram  ram_dut(din,rx_valid,tx_valid,dout,clk,rst_n);
 RAM #(.MEM_DEPTH(MEM_DEPTH), .ADDR_SIZE(ADDR_SIZE)) r_dut (.clk(clk),.rst_n(rst_n),.din(din),.rx_valid(rx_valid),.dout(data_expected),.tx_valid(tx_valid_expected));

 bind spi_ram  ram_sva  ram_sva_instance(.din(din),.rx_valid(rx_valid),.tx_valid(tx_valid),.dout(dout),.clk(clk),.rst_n(rst_n)); 
 



initial begin
$readmemb ("mem.dat.txt",memory);
end
 


initial begin
clk = 0 ;
forever #1 clk = ~clk;
end

initial begin

for(int i = 0 ; i < 2000 ; i++)begin
@(negedge clk);
assert(r_obj.randomize());
rst_n = r_obj.rst_n;
din = r_obj.din;
rx_valid = r_obj.rx_valid;
r_obj.tx_valid= tx_valid;
r_obj.dout= dout;


if((r_obj.din[9:8]== 2'b00 || r_obj.din[9:8]== 2'b10 )&& r_obj.rx_valid)begin
address = r_obj.din[7:0];
end



end
$stop;
end


always @(dout) begin
if(data_expected !== dout) //$display("RIGHT !!,address = %h , data_out = %h , data_expected = %h",address,dout,data_expected);
 $display("WRONG !!,address = %d ,data_out = %h , data_expected = %h , time = %t ",address,dout,data_expected,$time);

end

always @(posedge clk) begin
r_obj.r_cg.sample();
end


endmodule