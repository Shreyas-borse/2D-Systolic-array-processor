module corelet 
(
	input clk,
	input reset,
    
    input seq_begin, 
    output reg seq_done,

// SRAM interface for Activations and Weights (ie AW) to FSM
    input [31:0] ACT_q, //from sram to lo
    output [6:0] ACT_addr,
    output ACT_cen,
    output ACT_wen,
    input [31:0] W_q, //from sram to lo
    output [6:0] W_addr,
    output W_cen,
    output W_wen,
// SRAM interface for PMEM and output_final (ie OP) TO FSM
    input [127:0] OP_q,
    output [127:0] OP_d,
    output [8:0] OP_addr,
    output OP_cen,
    output OP_wen
);

parameter row = 8;
parameter col = 8;
parameter bw = 4;
parameter psum_bw = 16;

reg [psum_bw*col -1 :0] sfu_in;
reg [psum_bw*col -1 :0] sfu_out;

reg [31:0] l0_to_array;
reg l0_rd;
reg l0_wr;
reg l0_full;
reg l0_ready;

logic [31:0] AW_q;
logic AW_mode;
assign AW_q = AW_mode ? W_q : ACT_q ;

l0 #( .bw(bw), .row(row)) u_l0_inst1 (
        .clk(clk),
        .in(AW_q),
        .out(l0_to_array),
        .rd(l0_rd),
        .wr(l0_wr),
        .o_full(l0_full),
        .reset(reset),
        .o_ready(l0_ready)
        );

logic [col*bw -1 : 0] ofifo_in;
logic [col -1 : 0] array_valid_out;

logic [1:0] inst_w;

mac_array #(.bw(bw), .psum_bw(psum_bw), .row(row), .col(col)) u_mac_array_inst1 
(
  .clk(clk),
  .reset(reset),
  .out_s(ofifo_in),
  .in_w(l0_to_array), // inst[1]:execute, inst[0]: kernel loading
  .inst_w(inst_w),
  .in_n(0),
  .valid(array_valid_out) //connect to ofifo valid signal
);

wire [psum_bw*col - 1: 0] pmem_in;
wire ofifo_rd;
wire ofifo_wr[col-1 : 0];
wire ofifo_full;
wire ofifo_empty;
wire ofifo_valid;


ofifo #(.col(col), .bw(bw)) u_ofifo_inst1(
        .clk(clk),
        .in(ofifo_in),
        .out(pmem_in),
        .rd(ofifo_rd),
        .wr(ofifo_wr),
        .o_full(ofifo_full),
        .reset(reset),
        .o_ready(ofifo_ready),
        .o_valid(ofifo_valid)
);

assign OP_d = pmem_in;


//wire [] pmem_to_sfu_in; // from pmem to sfu unit
//wire [] sfu_out; // goes to OP_sram output 
//wire [] sfu_valid;


//sfu #(.col(col)) u_sfu_inst1(
//        .clk(clk),
//        .reset(reset),
//        .sfu_in(pmem_to_sfu_in),
//        .sfu_out(sfu_out),
//        .sfu_valid(sfu_valid)
//);

///FSM for controlling data flow//

//typedef enum logic {IDLE, W_TO_L0, W_TO_ARRAY, A_TO_L0, A_TO_ARRAY, SFU_COMPUTE, OUT_SRAM_FILL } state_coding_t;
typedef enum {IDLE, W_SRAM_TO_L0, W_L0_TO_ARRAY, ACT_SRAM_TO_L0, ACT_L0_TO_ARRAY, SFU_COMPUTE, OUT_SRAM_FILL} state_coding_t;
state_coding_t present_state, next_state;

logic [6:0] count, count_next;
logic [3:0] kij_count, kij_count_next;
//logic [5:0] act_count, act_count_next;
logic     l0_wr_next;
logic     l0_rd_next;
logic    inst_w_next; 
logic weight_reset;

// sequence complete from FSM to TB
always @(posedge clk or posedge reset) begin
    if(reset)
        seq_done <=0;
    else 
        seq_done <= (next_state == IDLE && OUT_SRAM_FILL);
    end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        present_state   <= IDLE;
        count           <= 0;
        kij_count       <= 0;
        l0_wr           <= 0;
        l0_rd           <= 0;
        inst_w          <= 0;
    end
    else begin
        present_state   <= next_state        ;
        count           <= count_next        ;
        kij_count       <= kij_count_next    ;
        l0_wr           <= l0_wr_next        ;
        l0_rd           <= l0_rd_next        ;
        inst_w          <= inst_w_next       ;
    end
end

always@ * begin
    next_state      =   present_state  ;
    count_next      =   count          ;
    kij_count_next  =   kij_count      ;
    l0_wr_next      =   l0_wr          ;
    l0_rd_next      =   l0_rd          ;
    inst_w_next     =   inst_w         ;
    weight_reset    =   0;
    case(present_state)
        IDLE:
            if(seq_begin) 
            begin
                next_state  =   W_SRAM_TO_L0;
                count_next  =   0;
                kij_count_next = 0;
            end

        W_SRAM_TO_L0:
            if (count > 7) 
            begin
                next_state = W_L0_TO_ARRAY;
                count_next = 0;
                l0_wr_next = 0;
            end
            else
            begin
                AW_mode    = 1;
                next_state = present_state;
                count_next = count + 1;
                l0_wr_next = 1;
            end

        W_L0_TO_ARRAY:
            if(count > 23)
            begin
                next_state      = ACT_L0_TO_ARRAY;
                count_next      = 0;
                inst_w_next     = 0;
                l0_rd_next      = 0;
            end
            else if(count > 7)
            begin
                next_state      = present_state;
                count_next      = count + 1;
                inst_w_next     = 0;
                l0_rd_next      = 0;
            end
            else
            begin
                next_state      = present_state;
                count_next      = count + 1;
                inst_w_next     = 1;
                l0_rd_next      = 1;
            end

        ACT_SRAM_TO_L0:     
            if(count> 35) 
            begin
                next_state      = ACT_L0_TO_ARRAY;
                count_next      = 0;
                l0_wr_next      = 0;
            end
            else 
            begin
                AW_mode       = 0;
                next_state    = present_state;
                count_next    = count+1;
                l0_wr_next    = 1;
            end

        ACT_L0_TO_ARRAY:
            if(count>57)
            begin   // +2 over computation for reset of the state
				next_state      = kij_count== 8 ? SFU_COMPUTE : W_SRAM_TO_L0;
				count_next 	    =  0;
				weight_reset	= 0;
                kij_count_next        = kij_count== 8 ? 8 : kij_count + 1;
            end
            else if(count>56)
            begin     //Asserting reset to Mac_array for 1 cycle to clear the weights
				next_state 		= present_state;
				count_next 	= count + 1;
				weight_reset 		= 1;
            end
            else if(count>55)
            begin// 36 + 8 + 8 + 1 + 1 + buffer(2)
                next_state    = present_state;
                count_next    = 0;
                inst_w_next   = 0;
                l0_rd_next    = 0;
            end
            else if(count> 35)  
            begin
                next_state    = present_state;
                count_next    = count+1;
                inst_w_next   = 0;
                l0_rd_next    = 0;
            end
            else
            begin
                next_state      = present_state;
                count_next      = count + 1;
                inst_w_next     = 2;
                l0_rd_next      = 1;
            end

        SFU_COMPUTE:
            if(count>143) 
            begin
                next_state      = OUT_SRAM_FILL;
                count_next    = 0;
            end
            else begin
                next_state      = present_state;
                count         = count + 1;
            end

        OUT_SRAM_FILL:
            if(count>15) begin
                next_state      = IDLE;
                count_next      = 0;
            end
            else begin
                next_state = present_state;
                count = count + 1;
            end
    endcase
end
    


endmodule
