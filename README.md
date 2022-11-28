# 2D-Systolic-array-processor-ISA

### Implementation of a Conv2D layer of VGG / RESNET on a custom designed hardware accelarator

VGG:

	Normally Tested for 1 layer on VGG
	8 Input Channel ---> 8 Output channel
	Nij = 6x6 (Input dim) Kij=3x3(Kernel dim) Oij = 4x4(Output dim)


RESNET : (Extensively tested)

	64 ITERATIONS (as there are 64 groups of 6*6 -> 4*4)
	8 Input channels ---> 8 Output channel

	Nij = 34X34  Oij = 32X32 
	64 Tiles (6x6) 
	Each output is 4x4
	total verifying 1024 outputs



##### Compiling #####  
VGG and RESET have different implementation folder but same hardware,
for design compilation and analysis ICARUS and gtkwave is been used.

for running and generating .vcd file we need to go to respective folder:
run following commands on terminal 

iverilog -g2012 -o compiled -c

vvp compiled

### Special notes about testing the design
VGG: Python .ipynb will dump the below .txt files
     - activation_project.txt (contains activations)
     - output_project.txt (conatins final output after accumulation + relu)
     - psum_project.txt (contains final accumulation values)
     - weight_project.txt (conatins weights)
Copy these files from the python folder into the VGG folder and do the testing

RESNET: Python .ipynb will dump the below .txt files
      - Resnet_activation_project.txt (contains activations)
      - Resnet_output_project.txt (contains final output after accumulation + residual addition + relu)
      - Resnet_psum_project.txt (contains final accumulation values before residual addition)
      - Resnet_residual_project.txt (contains residual values to be added to the psum in the testbench)
      - Resnet_weight_project.txt (contains final weight values)
  
  Copy these files from the python folder into the RESNET folder and do the testing.

![image(1)](https://user-images.githubusercontent.com/49656689/204258508-30438d3a-9441-471a-8f2c-4bea0822a05a.png)


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
            


