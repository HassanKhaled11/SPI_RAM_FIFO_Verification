class SW_C;

rand bit [10:0] joker;
bit [10:0] joker2 = 0;  
rand bit rst_n;


constraint c_rst{
   rst_n dist {1:=980,0:=1};
}


constraint joker_c{

            (joker2[10:8] == 3'b000) -> joker[10:8] == 3'b001;
            (joker2[10:8] == 3'b110) -> joker[10:8] == 3'b111;
            (joker2[10:8] == 3'b111) -> joker[10:8] == 3'b000;
             joker[8] != joker2[8];
             joker[10] == joker[9];

}

constraint joker2_c{

             joker[7:0] inside {[0:255]};
}

covergroup cg;
   joker_control: coverpoint joker[10:8]   iff(rst_n){
   bins w_ad = {3'b000};
   bins w_dt = {3'b001};
   bins r_ad = {3'b110};
   bins r_dt = {3'b111};
   }
   joker_data: coverpoint joker[7:0]   iff(rst_n){
   bins f_z = {8'h0};
   bins f_o = {8'hff};
   bins other[] ={[8'h1:8'hfe]};
   }   
   control_data: cross joker_control,joker_data  iff(rst_n){
   ignore_bins data_read =  binsof (joker_control.r_dt);
   ignore_bins wr_def = binsof (joker_control.w_dt ) && binsof (joker_data.other);
   }
   rst:coverpoint rst_n{   bins z_o=(0=>1);   bins o_z=(1=>0);   }
endgroup 



function void post_randomize;
joker2 = joker;
endfunction
 
function  new();
  cg = new();
endfunction


endclass
