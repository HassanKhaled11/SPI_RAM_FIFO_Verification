class SW_C;

rand bit [10:0] joker;
bit [10:0] joker2 = 0;  
//rand bit rst_n;

//constraint c_rst{
   //   rst_n dist {1:=98,0:=1};
//}


constraint joker_c{

            (joker2[10:8] == 3'b000) -> joker[10:8] == 3'b001;
            (joker2[10:8] == 3'b110) -> joker[10:8] == 3'b111;
            joker[8] != joker2[8];
            joker[10] == joker[9];
}

constraint joker2_c{

             joker[7:0] inside {[0:255]};
}


function void post_randomize;
joker2 = joker;
endfunction


endclass
