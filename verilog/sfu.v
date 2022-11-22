module sfu (

input clk,
input reset,
input [psum_bw*col - 1: 0]sfu_in,
output [psum_bw*col - 1: 0]sfu_out,
output [8:0] pmem_addr,

);

parameter row = 8;
parameter col = 8;
parameter psum_bw = 16;
parameter bw = 4;
