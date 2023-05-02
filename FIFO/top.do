vlib work
vlog pack_FIFO.sv FIFO_tb.sv FIFO.svp top.sv fifo_intrface.sv FIFO_ASER.sv monitor.sv +cover -covercells
vsim -voptargs=+accs work.top -cover
coverage save top.ucdb -onexit
add wave -position insertpoint sim:/top/fif/*

run -all

# to extract report run the following command
# vcover report top.ucdb -details -all -annotate 
