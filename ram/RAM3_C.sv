class C_RAM3;

rand logic [9:0] din;
rand bit rx_valid,rst_n;
bit [1:0] old_val_ctrl;
bit tx_valid;
logic [7:0] dout;

constraint c_rst{
      rst_n dist {1:=98,0:=1};
}

constraint c_rx{
      rx_valid dist {1:/9,0:/1};
}

constraint c_din {

      (old_val_ctrl == 2'b00) ->  din[9:8] == 2'b01;

      (old_val_ctrl == 2'b10) ->  din[9:8] == 2'b11;

      (old_val_ctrl == 2'b01 || old_val_ctrl == 2'b01  ) ->  din[9:8] dist {2'b00:/ 50 , 2'b10:/50 };
    
}


constraint c_din7_0{
      
       if(old_val_ctrl == 2'b00)   
       din[7:0] dist {8'hFF:/15 , 8'h00:/15 , [1:254]:/70}; 
}




function void post_randomize;
       old_val_ctrl = din[9:8];
endfunction


covergroup r_cg;

di_9_8: coverpoint din[9:8] iff(rst_n)
{
  bins zero_zero =  {2'b00};
  bins one_zero  =  {2'b10};
  bins zz_zo     =  (2'b00 => 2'b01);
  bins oz_oo     =  (2'b10 => 2'b11);
}

di_7_0: coverpoint din[7:0] iff(rst_n)
{

 bins full_dataones   =   {8'hFF};
 bins full_datazeros  =   {8'h00};
 bins random_values[] =   {[1:254]};

}

rx: coverpoint rx_valid
{
 bins zero = {0};
 bins one  = {1};
}

tx: coverpoint tx_valid{
bins tx_trans0_1 = (0=>1);
bins tx_trans1_0 = (1=>0);
}


dot: coverpoint dout[7:0]{
bins dout_1 = {8'hFF};
bins dout_2 = {8'h00};
}


data_address: cross di_9_8 , di_7_0
{
  ignore_bins transition_0 = binsof(di_9_8.zz_zo);
  ignore_bins transition_1 = binsof(di_9_8.oz_oo);
}

endgroup


function new();
r_cg = new();
endfunction


endclass
