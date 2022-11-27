##### DELIVERABLES ######

./verilog has common hardware for VGG16 and ResNet

Both folders have DATA_MATCH_OP.log which we verified

For running Simulation for VGG 
-> Go to ./VGG
-> run on terminal
-> iverilog -g2012 -o compiled -c
-> vvp compiled

For running Simulation for Resnet 
-> Go to ./RESNET
-> run on terminal
-> iverilog -g2012 -o compiled -c
-> vvp compiled

Respective folders have their own activation.txt
weight.txt and output.txt 
and will generate resepective VCDs

