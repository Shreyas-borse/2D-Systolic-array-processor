module core 
(
	input clk,
	input reset,
    
    input seq_begin, 
    output seq_done,

    //output [col - 1 :0] ofifo_valid,
    //input [bw*row -1 : 0] D_xmem,
    //output [col*psum_bw - 1 : 0] sfp_out,

// SRAM interface for Activations and Weights (ie AW) 
    output [31:0] AW_q, // going to LO
    input [31:0]  dut_AW_d,
    input [6:0]   dut_AW_addr,
    input         dut_AW_cen,
    input         dut_AW_wen,

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
    wire [31:0] core_AW_q,
    wire [31:0] core_AW_d,
    wire  [6:0] core_AW_addr,
    wire        core_AW_cen,
    wire        core_AW_wen,

    wire  [127:0] core_OP_q,
    wire  [127:0] core_OP_d,
    wire  [8:0]   core_OP_addr,
    wire          core_OP_cen,
    wire          core_OP_wen,

//  from mux to SRAMs 
    wire [31:0] mux_AW_q,
    wire [31:0] mux_AW_d,
    wire  [6:0] mux_AW_addr,
    wire        mux_AW_cen,
    wire        mux_AW_wen,

    wire  [127:0] mux_OP_q,
    wire  [127:0] mux_OP_d,
    wire  [8:0]   mux_OP_addr,
    wire          mux_OP_cen,
    wire          mux_OP_wen,


assign mux_AW_d    = dut_AW_d;

//assign mux_AW_q = dut_cl_sel ? dut_AW_q : core_AW_q;
assign mux_AW_addr = dut_cl_sel?  dut_AW_add: core_AW_addr;
assign mux_AW_cen  = dut_cl_sel?  dut_AW_cen: core_AW_cen;
assign mux_AW_wen  = dut_cl_sel?  dut_AW_wen: core_AW_wen;

assign mux_OP_d    = dut_cl_sel? dut_OP_d: core_OP_d;                       
assign mux_OP_addr = dut_cl_sel?  dut_OP_add: core_OP_addr;
assign mux_OP_cen  = dut_cl_sel?  dut_OP_cen: core_OP_cen;
assign mux_OP_wen  = dut_cl_sel?  dut_OP_wen: core_OP_wen;


AW_sram_108x32 u_sram_inst1(
    .CLK(clk),
    .D(mux_AW_d),
    .Q(AW_q),
    .CEN(mux_AW_cen),
    .WEN(mux_AW_wen),
    .A(mux_AW_addr)
    );


OP_sram_340x128 u_sram_inst2(
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
            
             .AW_q(AW_q),
             .AW_addr(core_AW_addr),
             .AW_cen(core_AW_cen),
             .AW_wen(core_AW_wen), 
             .OP_q(dut_OP_q),
             .OP_d(core_OP_d),
             .OP_addr(core_OP_addr),
             .OP_cen(core_OP_cen),
             .OP_wen(core_OP_wen),
);

endmodule
