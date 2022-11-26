# 2D-Systolic-array-processor-ISA

### Implementation of one Conv2D layer of VGG / RESNET on a custom design hardware accelarator

#### Compiling 
  
VGG and RESET have different implementation folder but same hardware,
for design compilation and analysis ICARUS and gtkwave is been used.

for running and generating .vcd file we need to go to respective folder:
run following commands on terminal 

iverilog -g2012 -o compiled -c 
vvp compiled

### Design Hierarchy

-- CORE_TESTBENCH
 |---> core
       |--> corelet
       |	|----> l0 (fifo 8x64)
       |	|----> mac_array
       |	|       |--> mac_row
       |   	|	 	|-->mac_tile
       |	|----> ofifo (8x8)
       |	|----> SFU   (sfu_reg_banks)
       |      
       |----> SFU Act_ sram (activation storage)
       |----> SFU W_sram (for weights)
       |----> SFU OP_sram (Final convoluted output after relu)
      
