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

logic [7:0] address;
logic [7:0] data_expected;
logic[7:0] mem_data_expected;
reg [7:0] memory [MEM_DEPTH-1 : 0];

C_RAM3 r_obj = new();

spi_ram  ram_dut(din,rx_valid,tx_valid,dout,clk,rst_n);
RAM_  golden_rdut(clk,rst_n,din,rx_valid,data_expected,tx_valid_expected); 

bind spi_ram  ram_sva  ram_sva_instance(.din(din),.rx_valid(rx_valid),.tx_valid(tx_valid),.dout(dout),.clk(clk),.rst_n(rst_n)); 
 

initial begin
$readmemb ("mem.dat.txt",memory);
end
 

initial begin
clk = 0 ;
forever #1 clk = ~clk;
end

initial begin

for(int i = 0 ; i < 3000 ; i++)begin
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

if (r_obj.din[9:8]== 2'b01)begin
memory[address] = r_obj.din[7:0];
end

if(r_obj.din[9:8]== 2'b11)begin
mem_data_expected = memory[address];
end


end
$stop;
end


always @(dout) begin
if(mem_data_expected !== dout) //$display("RIGHT !!,address = %h , data_out = %h , data_expected = %h",address,dout,data_expected);
 $display("WRONG !!,address = %d ,data_out = %h , data_expected = %h , time = %t ",address,dout,mem_data_expected,$time);

end

always @(posedge clk) begin
r_obj.r_cg.sample();
end

//------------------------------------------
property add_in_range;
@(posedge clk) (din[9:8] == 2'b00 || din[9:8] == 2'b10 ) |-> (din[7:0] < 256);
endproperty

assert property(add_in_range);
cover property(add_in_range);
//-----------------------------------------


endmodule