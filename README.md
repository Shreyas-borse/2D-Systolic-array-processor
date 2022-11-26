# 2D-Systolic-array-processor-ISA

### Implementation of one Conv2D layer of VGG / RESNET on a custom design hardware accelarator

VGG:

	Normally Tested for 1 layer on VGG
	8 Input Channel ---> 8 Output channel
	Nij = 6x6 (Input dim) Kij=3x3(Kernel dim) Oij = 4x4(Output dim)


RESNET : (Extensively tested)

	64 ITERATIONS (as there are 64 Tiles)
	8 Input channels ---> 8 Output channel

	Nij = 34X34  Oij = 32X32 
	64 Tiles (6x6) 
	Each output is 4x4
	total coumputing 64 outputs

#### Compiling 
  
VGG and RESET have different implementation folder but same hardware,
for design compilation and analysis ICARUS and gtkwave is been used.

for running and generating .vcd file we need to go to respective folder:
run following commands on terminal 

iverilog -g2012 -o compiled -c

vvp compiled

#### Design Hierarchy
```bash
|--> CORE_TESTBENCH                                                                                                                       
      |---> core                                                                                                                                           
            |--> corelet                                                                                                          
            |     |----> l0 (fifo 8x64)                                                                                                           
            |     |----> mac_array                                                                                                                  
            |     |          |--> mac_row                                                                                                           
            |     |               |-->mac_tile                                                                                                     
            |     |----> ofifo (8x8)                                                                                                                
            |     |----> SFU   (sfu_reg_banks)                                                                                                          
            |                                                                                                                                              
            |----> SFU Act_ sram (activation storage)                                                                                                     
            |----> SFU W_sram (for weights)                                                                                                               
            |----> SFU OP_sram (Final convoluted output after relu)  
            
