/*                =================  author 3laa   =========================
Test Plan :
our cases we need to cover and proceed specific constraints in randomization
to keep towards
	write => almost full (cover bins) => full (cover bins) => overflow (cover bins)
then , read => almost empty(cover bins) => empty (cover bins) => underflow (cover)	
FIFO states :

(1)empty with read enable [underflow]
(2)almost empty
(3)just empty
(4)full with write enable [overflow]
(5)almost full
(6)just full

////////////////////////////    Assertions Plan ////////////////////////////////////////
(1) almost full --> full
(2) full --> almost full
(3) almost empty --> empty
(4) empty --> almost empty
(5) 
*/

class fiffo ;
	rand bit [15:0] data_in ;
	bit [15:0] inc_data_in;
	rand bit wr_en,rd_en,rst_n;
	logic full,almostfull,empty,almostempty,wr_ack; 
	bit overflow,underflow;
	logic old_wr_en , old_rd_en ;//, incoming_wr_en ,incoming_rd_en ;
	covergroup fif;
		ack : coverpoint wr_ack {
			bins acknowledge = {1};
			ignore_bins ack_0 = {0};
		}
		wr:coverpoint wr_en{
		 bins wr_z ={0};
		 bins wr_1 = {1};
		 bins wrz_1 = (0=>1);
		 bins wr1_z = (1 => 0);
		}
		rd:coverpoint rd_en{
		 bins rd_z ={0};
		 bins rd_1 = {1};
		 bins rdz_1 = (0=>1);
		 bins rd1_z = (1 => 0);
		}
		f:coverpoint full{
		 ignore_bins full_z ={0};
		 bins full_1 = {1};
		 bins fullz_1 = (0=>1);
		 bins full1_z = (1 => 0);
		}
		afull : coverpoint almostfull{
				bins a_full1 = {1};
				ignore_bins a_full0 = {0};// don't care when almost full is zero
				bins zero_to_one = (0 => 1);
				bins one_to_zero = (1 => 0);
		}
		full: cross wr,f{
		 bins wr_full = binsof(wr.wr_1) && binsof(f.fullz_1);
		 bins overflow = binsof(wr.wr_1) && binsof(f.full_1);
		 ignore_bins a = binsof(wr.wr1_z) && binsof(f.fullz_1);
		 ignore_bins b = binsof(wr.wr1_z) && binsof(f.full1_z);
		 ignore_bins c = binsof(wr.wrz_1) && binsof(f.fullz_1);
		 ignore_bins d = binsof(wr.wrz_1) && binsof(f.full_1);
		 ignore_bins f = binsof(wr.wr_z) && binsof(f.fullz_1);
		}
		e:coverpoint empty{
		 ignore_bins empty_z ={0};
		 bins empty_1 = {1};
		 bins emptyz_1 = (1=>0);
		 bins empty1_z = (1 => 0);
		}
		aempty : coverpoint almostempty{
				bins a_empty1 = {1};
				ignore_bins a_empty0 = {0};// don't care when almost full is zero
				bins zero_to_one = (0 => 1);
				bins one_to_zero = (1 => 0);
		}
		over: coverpoint overflow{
		 ignore_bins over_z ={0};
		 bins over_1 = {1};
		 bins overz_1 = (1=>0);
		}
		under:coverpoint underflow{
		 ignore_bins under_z ={0};
		 bins under_1 = {1};
		 bins underz_1 = (1=>0);
		} 
		//empty: cross e,rd{
		//bins rd_emp = binsof (rd.rd_1) && binsof(e.emptyz_1);
		//bins underflow = binsof(rd.rd_1) && binsof(e.empty_1);
		//}

 	endgroup
 	constraint rst {
 		rst_n dist {0:=2 , 1:= 98};
 	}
 	constraint write_read {
 			
 			wr_en == old_wr_en;
 			rd_en == old_rd_en;
 			!(rd_en && wr_en);
 			  	
 	}
 	function void post_randomize();
 		if(full) begin
 			old_wr_en = 0;
 			old_rd_en = 1;
 		end
 		rd_en = !old_wr_en;
 	endfunction
 	
 	function void pre_randomize();
 		if(empty) begin // if(empty)fif_q.size()
 			old_rd_en = 0;
 			old_wr_en = 1;
 		end 
 	endfunction

 	function  new();
 		fif = new();
 	endfunction 
endclass 

module FIFO_tb (FIFO_if.TEST tb_if);	
	logic [15:0] fif_q [$:4];//[15:0]
	bit [15:0] data_oout;
	fiffo fifoo = new(); 

	initial begin
		fifoo.empty = tb_if.empty;
		repeat(100)begin 
			//fifoo.size = fif_q.size();
			assert(fifoo.randomize());
			tb_if.data_in = fifoo.data_in;
			tb_if.wr_en = fifoo.wr_en;
			tb_if.rd_en = fifoo.rd_en;
			tb_if.rst_n = fifoo.rst_n;
			if(tb_if.wr_en && tb_if.rst_n) begin 
				fif_q.push_back(tb_if.data_in);
			end
			if(!tb_if.rst_n)
						fif_q.delete();
			if(tb_if.overflow && !tb_if.wr_en)
				  fif_q.pop_back();
			if(tb_if.rd_en && tb_if.rst_n) begin
				tb_if.data_out_expected = fif_q.pop_front();
				//check_2_q(tb_if.data_out , tb_if.data_out_expected);
			end
			@(negedge tb_if.clk);

			fifoo.wr_ack = tb_if.wr_ack;
			fifoo.empty = tb_if.empty;
			fifoo.full  = tb_if.full;
			fifoo.almostfull = tb_if.almostfull;
			fifoo.almostempty = tb_if.almostempty;
			fifoo.overflow = tb_if.overflow;
			fifoo.underflow = tb_if.underflow;			
			
			if(tb_if.rd_en) begin
				check_2_q(tb_if.data_out , tb_if.data_out_expected);
			end
		end

		$stop;
	end

	always@(posedge tb_if.clk)
		fifoo.fif.sample();




task check_2_q(input logic [15:0] data_out,logic [15:0] data_exp);
	if(data_out == data_exp && !tb_if.wr_en)
		$display("Success!!");
	else $display("Error!!, rest=%b , overflow=%b",tb_if.rst_n,tb_if.overflow);
endtask 


endmodule 
