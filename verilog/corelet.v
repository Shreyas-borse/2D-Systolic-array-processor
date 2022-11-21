module corelet (
	input clk,
	input reset,
    
    input seq_begin, 
    output seq_done,

// SRAM interface for Activations and Weights (ie AW) to FSM
    input [31:0] AW_q,
    output [6:0] AW_addr,
    output AW_cen,
    output AW_wen,

// SRAM interface for PMEM and output_final (ie OP) TO FSM
    input [127:0] OP_q,
    output [127:0] OP_d,
    output [8:0] OP_addr,
    output OP_cen,
    output OP_wen,
);

reg [psum_bw*col -1 :0]sfu_in;
reg [psum_bw*col -1 :0]sfu_out;
    


mac_array #(.bw(bw), .psum_bw(psum_bw), .row(row), .col(col)) u_mac_array_inst1 
(
  .clk(clk),
  .reset(reset),
  .out_s(sfu_in),
  .in_w(D_xmem_to_PE), // inst[1]:execute, inst[0]: kernel loading
  .inst_w(inst[1:0]),
  .in_n(64'b0),
  .valid(sfu_valid) //connect to sfu valid signal
);

l0 #( .bw(bw), .row(row)) u_l0_inst1 (
        .clk(clk),
        .in(),
        .out(),
        .rd(),
        .wr(),
        .o_full(),
        .reset(reset),
        .o_ready()
        );

sfu #() u_sfu_inst1(

);


///FSM for controlling data flow//

enum logic {} state;
