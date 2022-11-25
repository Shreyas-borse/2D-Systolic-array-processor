restart
add wave -position insertpoint  \
sim:/core_tb/u_core/corelet_inst1/present_state \
sim:/core_tb/u_core/corelet_inst1/next_state
add wave -position insertpoint  \
sim:/core_tb/u_core/corelet_inst1/u_ofifo_inst1/clk \
sim:/core_tb/u_core/corelet_inst1/u_ofifo_inst1/wr \
sim:/core_tb/u_core/corelet_inst1/u_ofifo_inst1/rd \
sim:/core_tb/u_core/corelet_inst1/u_ofifo_inst1/reset \
sim:/core_tb/u_core/corelet_inst1/u_ofifo_inst1/in \
sim:/core_tb/u_core/corelet_inst1/u_ofifo_inst1/out \
sim:/core_tb/u_core/corelet_inst1/u_ofifo_inst1/o_full \
sim:/core_tb/u_core/corelet_inst1/u_ofifo_inst1/o_ready \
sim:/core_tb/u_core/corelet_inst1/u_ofifo_inst1/o_valid
add wave -position insertpoint  \
sim:/core_tb/u_core/corelet_inst1/u_SFU/sfu_reg_bank
add wave -position insertpoint  \
sim:/core_tb/u_core/corelet_inst1/u_SFU/OFIFO_out
add wave -position insertpoint  \
sim:/core_tb/u_core/corelet_inst1/present_state \
sim:/core_tb/u_core/corelet_inst1/next_state
add wave -position insertpoint  \
sim:/core_tb/u_core/corelet_inst1/debug_array_weight
run -all
