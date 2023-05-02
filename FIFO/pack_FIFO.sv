package pack_FIFO;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 5;

class fiffo ;
	bit [FIFO_WIDTH-1:0] data_out , data_out_expected;
	rand bit [FIFO_WIDTH-1:0] data_in ;
	rand bit wr_en,rd_en,rst_n;
	
	bit full,almostfull,empty,almostempty,wr_ack,overflow,underflow; 
	logic old_wr_en , old_rd_en ;//, incoming_wr_en ,incoming_rd_en ;
	int size;
constraint rst {
 		rst_n dist {0:=5 , 1:= 90};
 		
 	}
 
constraint write_read {
 			
 			wr_en == old_wr_en;
 			rd_en == old_rd_en;
 			!(rd_en && wr_en);
 							
 	}
 	function void post_randomize();
 		if(size == FIFO_DEPTH) begin
 			old_wr_en = 0;
 			old_rd_en = 1;
 		end
 		 rd_en = !old_wr_en; // overlapping between read and write	
 		
 	endfunction
 	
 	function void pre_randomize();
 		if(size == 0) begin
 			old_rd_en = 0;
 			old_wr_en = 1;
 		end 
 	
 	endfunction
 	//////////////////////////////
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


 	endgroup
 	

 	function  new();
 		fif = new();
 	endfunction 
endclass 

endpackage