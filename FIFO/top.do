vlib work
#vlog FIFO_tb.sv fif_as.sv FIFO.svp top.sv fifo_intrface.sv +cover -covercell
vsim -voptargs=+accs work.top -cover

add wave -position insertpoint  \
sim:/top/fif/clk \
sim:/top/fif/data_in \
sim:/top/fif/wr_en \
sim:/top/fif/rd_en \
sim:/top/fif/rst_n \
sim:/top/fif/data_out \
sim:/top/fif/data_out_expected \
sim:/top/fif/full \
sim:/top/fif/almostfull \
sim:/top/fif/empty \
sim:/top/fif/almostempty \
sim:/top/fif/overflow \
sim:/top/fif/underflow \
sim:/top/fif/wr_ack

add wave /top/f_if/asrt/full_chk /top/f_if/asrt/over_chk /top/f_if/asrt/empty_chk /top/f_if/asrt/uner_chk /top/f_if/asrt/overLong /top/f_if/asrt/amostEmpty /top/f_if/asrt/amostFull /top/f_if/asrt/wrAck_chk1 /top/f_if/asrt/wrAck_chk

coverage save top.ucdb -onexit
run -all

# to extract report run the following command
# vcover report top.ucdb -details -all -annotate 
