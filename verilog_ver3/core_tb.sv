// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
`timescale 1ns/1ns

module core_tb;

logic CLK;
logic RESET;
logic START;

logic   [31:0]  TB_ACT_D;
wire    [31:0]  TB_ACT_Q;  //logic can't be connected to output port for some reason
logic   [6:0]   TB_ACT_ADDR;
logic           TB_ACT_CEN;
logic           TB_ACT_WEN;

logic   [31:0]  TB_W_D;
wire    [31:0]  TB_W_Q;  //logic can't be connected to output port for some reason
logic   [6:0]   TB_W_ADDR;
logic           TB_W_CEN;
logic           TB_W_WEN;

logic   [127:0] TB_O_D;
wire    [127:0] TB_O_Q;
logic   [8:0]   TB_O_ADDR;
logic           TB_O_CEN;
logic           TB_O_WEN;

logic           TB_CL_SELECT;
logic   [31:0]  D_2D [108:0];
logic   [127:0] D_2D_128 [15:0];

integer w_file, w_scan_file ; // file_handler
integer a_file, a_scan_file ; // file_handler
integer p_file, p_scan_file ; // file_handler
integer i;
integer captured_data;
integer error;
logic SEQ_DONE;

core u_core(
    .clk        (CLK),
    .reset      (RESET),
    .seq_begin      (START),
	.seq_done		(SEQ_DONE),

    .dut_ACT_addr  (TB_ACT_ADDR),
    .dut_ACT_cen   (TB_ACT_CEN),
    .dut_ACT_wen   (TB_ACT_WEN),
    .dut_ACT_d     (TB_ACT_D),
    .ACT_q         (TB_ACT_Q),

    .dut_W_addr  (TB_W_ADDR),
    .dut_W_cen   (TB_W_CEN),
    .dut_W_wen   (TB_W_WEN),
    .dut_W_d     (TB_W_D),
    .W_q         (TB_W_Q),

    .dut_OP_addr  (TB_O_ADDR),
    .dut_OP_cen   (TB_O_CEN),
    .dut_OP_wen   (TB_O_WEN),
    .dut_OP_d     (TB_O_D),
    .dut_OP_q     (TB_O_Q),

    .dut_cl_sel(TB_CL_SELECT)
    );


initial 
begin

    $dumpfile("core_tb.vcd");
    $dumpvars(0,core_tb);
 
    CLK = 0;
    RESET = 1;
    START = 0;
  
    w_file = $fopen("weight.txt", "r");

    // Following three lines are to remove the first three comment lines of the file
    w_scan_file = $fscanf(w_file,"%s", captured_data);
    w_scan_file = $fscanf(w_file,"%s", captured_data);
    w_scan_file = $fscanf(w_file,"%s", captured_data);

    #101 RESET = 0;
    #10
    TB_W_CEN = 0;
    TB_W_WEN = 0;
    TB_ACT_CEN = 1;
    TB_ACT_WEN = 1;

    TB_CL_SELECT = 1;
    TB_O_WEN = 1;
    TB_O_CEN = 1;

    for (i=0; i<72 ; i=i+1)
    begin
        #10
        TB_W_ADDR   = i;
        w_scan_file = $fscanf(w_file,"%32b", TB_W_D);
        D_2D[i][31:0] = TB_W_D;
    end
    #10
    TB_W_CEN = 1;
    TB_W_WEN = 1;
    TB_CL_SELECT = 1;
    TB_O_WEN = 1;
    TB_O_CEN = 1;
    for (i=0; i<72 ; i=i+1)
    begin
        #5
        TB_W_CEN = 0;
        TB_W_WEN = 1;
        TB_W_ADDR   = i;
        #5
        if (D_2D[i][31:0] == TB_W_Q)
            $display("%2d-th read data is %h --- Data matched", i, TB_W_Q);
        else begin
            $display("%2d-th read data is %h, expected data is %h --- Data ERROR !!!", i, TB_W_Q, D_2D[i]);
            error = error+1;
        end
    end
    //Weight Load and Check ends

    //Activation Load and check begins

    a_file = $fopen("activation.txt", "r");

    // Following three lines are to remove the first three comment lines of the file
    a_scan_file = $fscanf(a_file,"%s", captured_data);
    a_scan_file = $fscanf(a_file,"%s", captured_data);
    a_scan_file = $fscanf(a_file,"%s", captured_data);

    #101 RESET = 0;
    #10
    TB_ACT_CEN = 0;
    TB_ACT_WEN = 0;
    TB_CL_SELECT = 1;
    TB_O_WEN = 1;
    TB_O_CEN = 1;

    for (i=0; i<36 ; i=i+1)
    begin
        #10
        TB_ACT_ADDR   = i;
        a_scan_file = $fscanf(a_file,"%32b", TB_ACT_D);
        D_2D[72+i][31:0] = TB_ACT_D;
    end
    #10
    TB_ACT_CEN = 1;
    TB_ACT_WEN = 1;
    TB_CL_SELECT = 1;
    TB_O_WEN = 1;
    TB_O_CEN = 1;
    for (i=0; i<36 ; i=i+1)
    begin
        #5
        TB_ACT_CEN = 0;
        TB_ACT_WEN = 1;
        TB_ACT_ADDR   = i;
        #5
        if (D_2D[72+i][31:0] == TB_ACT_Q)
            $display("%2d-th read data is %h --- Data matched", i, TB_ACT_Q);
        else begin
            $display("%2d-th read data is %h, expected data is %h --- Data ERROR !!!", i, TB_ACT_Q, D_2D[72+i]);
            error = error+1;
        end
    end
	
    
    TB_CL_SELECT = 0;
    TB_ACT_WEN = 1;
    TB_ACT_CEN = 1;
    
    #100 START = 1;
    #100 START = 0;

    #12500
    //Activation Load and check begins

    p_file = $fopen("psum.txt", "r");

    // Following three lines are to remove the first three comment lines of the file
    p_scan_file = $fscanf(p_file,"%s", captured_data);
    p_scan_file = $fscanf(p_file,"%s", captured_data);
    p_scan_file = $fscanf(p_file,"%s", captured_data);

    #101 RESET = 0;
    #10
    TB_ACT_CEN = 1;
    TB_ACT_WEN = 1;
    TB_W_CEN = 1;
    TB_W_WEN = 1;
    TB_CL_SELECT = 1;
    TB_O_WEN = 1;
    TB_O_CEN = 1;

    for (i=0; i<16 ; i=i+1)
    begin
        #10
        p_scan_file = $fscanf(p_file,"%128b", TB_O_D);
        D_2D_128[i][127:0] = TB_O_D;
    end
    #10
    TB_ACT_CEN = 1;
    TB_ACT_WEN = 1;
    TB_W_CEN = 1;
    TB_W_WEN = 1;
    TB_CL_SELECT = 1;
    TB_O_WEN = 1;
    TB_O_CEN = 1;
    for (i=0; i<16 ; i=i+1)
    begin
        #5
        TB_O_CEN = 0;
        TB_O_WEN = 1;
        TB_O_ADDR   = i;
        #5
        if (D_2D_128[i][127:0] == TB_O_Q)
            $display("%2d-th read data is %h --- Data matched", i, TB_O_Q);
        else begin
            $display("%2d-th read data is %h, expected data is %h --- Data ERROR !!!", i, TB_O_Q, D_2D_128[i]);
            error = error+1;
        end
    end
    

    #500

     $stop;
end

initial
begin
#5
forever
    #5 CLK = ~CLK;
end

endmodule