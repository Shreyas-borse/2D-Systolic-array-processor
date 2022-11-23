module core 
(
	input clk,
	input reset,
    
    input seq_begin, 
    output seq_done,

    //output [col - 1 :0] ofifo_valid,
    //input [bw*row -1 : 0] D_xmem,
    //output [col*psum_bw - 1 : 0] sfp_out,

// SRAM interface for Activations and Weights (ie ACT) 
    output [31:0] ACT_q, // going to LO
    input [31:0]  dut_ACT_d,
    input [6:0]   dut_ACT_addr,
    input         dut_ACT_cen,
    input         dut_ACT_wen,

    output [31:0] W_q, // going to LO
    input [31:0]  dut_W_d,
    input [6:0]   dut_W_addr,
    input         dut_W_cen,
    input         dut_W_wen,
    
    input   dut_cl_sel,
    output  compute_done, 

// SRAM interface for PMEM and output_final (ie OP) 
    output [127:0] dut_OP_q,
    input  [127:0] dut_OP_d,
    input  [8:0] dut_OP_addr,
    input  dut_OP_cen,
    input  dut_OP_wen,
);

parameter row = 8;
parameter col = 8;


// from CORELET to mux for SRAMs 
    wire [31:0] core_ACT_q,
    wire [31:0] core_ACT_d,
    wire  [6:0] core_ACT_addr,
    wire        core_ACT_cen,
    wire        core_ACT_wen,
    
    wire [31:0] core_W_q,
    wire [31:0] core_W_d,
    wire  [6:0] core_W_addr,
    wire        core_W_cen,
    wire        core_W_wen,


    wire  [127:0] core_OP_q,
    wire  [127:0] core_OP_d,
    wire  [8:0]   core_OP_addr,
    wire          core_OP_cen,
    wire          core_OP_wen,

//  from mux to SRAMs 
    wire [31:0] mux_ACT_q,
    wire [31:0] mux_ACT_d,
    wire  [6:0] mux_ACT_addr,
    wire        mux_ACT_cen,
    wire        mux_ACT_wen,

    wire [31:0] mux_W_q,
    wire [31:0] mux_W_d,
    wire  [6:0] mux_W_addr,
    wire        mux_W_cen,
    wire        mux_W_wen,

    wire  [127:0] mux_OP_q,
    wire  [127:0] mux_OP_d,
    wire  [8:0]   mux_OP_addr,
    wire          mux_OP_cen,
    wire          mux_OP_wen,


assign mux_ACT_d    = dut_ACT_d;

//assign mux_ACT_q = dut_cl_sel ? dut_ACT_q : core_ACT_q;
assign mux_ACT_addr = dut_cl_sel?  dut_ACT_add: core_ACT_addr;
assign mux_ACT_cen  = dut_cl_sel?  dut_ACT_cen: core_ACT_cen;
assign mux_ACT_wen  = dut_cl_sel?  dut_ACT_wen: core_ACT_wen;

assign mux_W_d    = dut_W_d;
assign mux_W_addr = dut_cl_sel?  dut_W_add: core_W_addr;
assign mux_W_cen  = dut_cl_sel?  dut_W_cen: core_W_cen;
assign mux_W_wen  = dut_cl_sel?  dut_W_wen: core_W_wen;

assign mux_OP_d    = dut_cl_sel? dut_OP_d: core_OP_d;                       
assign mux_OP_addr = dut_cl_sel?  dut_OP_add: core_OP_addr;
assign mux_OP_cen  = dut_cl_sel?  dut_OP_cen: core_OP_cen;
assign mux_OP_wen  = dut_cl_sel?  dut_OP_wen: core_OP_wen;


ACT_sram_108x32 u_sram_inst1(
    .CLK(clk),
    .D(mux_ACT_d),
    .Q(ACT_q),
    .CEN(mux_ACT_cen),
    .WEN(mux_ACT_wen),
    .A(mux_ACT_addr)
    );

W_sram_108x32 u_sram_inst2(
    .CLK(clk),
    .D(mux_W_d),
    .Q(W_q),
    .CEN(mux_W_cen),
    .WEN(mux_W_wen),
    .A(mux_W_addr)
    );

OP_sram_340x128 u_sram_inst3(
    .CLK(clk),
    .D(mux_OP_d),
    .Q(dut_OP_q),
    .CEN(mux_OP_cen),
    .WEN(mux_OP_wen),
    .A(mux_OP_addr)
    );

);

corelet #(.row(row), .col(col)) corelet_inst1
(
             .clk(clk),
             .reset(reset),
            
             .seq_begin(seq_begin), 
             .seq_done(seq_done),
            
             .ACT_q(ACT_q),
             .ACT_addr(core_ACT_addr),
             .ACT_cen(core_ACT_cen),
             .ACT_wen(core_ACT_wen), 
             .OP_q(dut_OP_q),
             .W_q(W_q),
             .W_addr(core_W_addr),
             .W_cen(core_W_cen),
             .W_wen(core_W_wen), 
             .OP_d(core_OP_d),
             .OP_addr(core_OP_addr),
             .OP_cen(core_OP_cen),
             .OP_wen(core_OP_wen),
);

endmodule
