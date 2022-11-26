// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module core_tb;

logic CLK;
logic RESET;


logic   [31:0]  dut_ACT_D;
wire    [31:0]  dut_ACT_Q;  //logic can't be connected to output port for some reason
logic   [6:0]   dut_ACT_ADDR;
logic           dut_ACT_CEN;
logic           dut_ACT_WEN;

logic   [31:0]  dut_W_D;
wire    [31:0]  dut_W_Q;  //logic can't be connected to output port for some reason
logic   [6:0]   dut_W_ADDR;
logic           dut_W_CEN;
logic           dut_W_WEN;

logic   [127:0] dut_O_D;
wire    [127:0] dut_O_Q;
logic   [3:0]   dut_O_ADDR;
logic           dut_O_CEN;
logic           dut_O_WEN;

logic           dut_CL_SELECT;
logic   [31:0]  D_2D [108:0];
logic   [127:0] D_2D_128 [15:0];
logic   START;
integer w_file, w_scan_file ; // file_handler
integer a_file, a_scan_file ; // file_handler
integer p_file, p_scan_file ; // file_handler
integer i;
integer captured_data;
integer error;
logic SEQ_DONE;


//logic [127:0]  sfu_out_tot [15:0]; 
logic SFU_DONE;

//******SFU OUT TEST PURPOSE********//


//logic [127:0]	sfu_out_0;
//logic [127:0]	sfu_out_1;
//logic [127:0]	sfu_out_2;
//logic [127:0]	sfu_out_3;
//logic [127:0]	sfu_out_4;
//logic [127:0]	sfu_out_5;
//logic [127:0]	sfu_out_6;
//logic [127:0]	sfu_out_7;
//logic [127:0]	sfu_out_8;
//logic [127:0]	sfu_out_9;
//logic [127:0]	sfu_out_10;
//logic [127:0]	sfu_out_11;
//logic [127:0]	sfu_out_12;
//logic [127:0]	sfu_out_13;
//logic [127:0]	sfu_out_14;
//logic [127:0]	sfu_out_15;
//
//assign sfu_out_tot [0] =  sfu_out_0;  
//assign sfu_out_tot [1] =  sfu_out_1;  
//assign sfu_out_tot [2] =  sfu_out_2;  
//assign sfu_out_tot [3] =  sfu_out_3;  
//assign sfu_out_tot [4] =  sfu_out_4;  
//assign sfu_out_tot [5] =  sfu_out_5;  
//assign sfu_out_tot [6] =  sfu_out_6;  
//assign sfu_out_tot [7] =  sfu_out_7;  
//assign sfu_out_tot [8] =  sfu_out_8;  
//assign sfu_out_tot [9] =  sfu_out_9;  
//assign sfu_out_tot [10] =  sfu_out_10;  
//assign sfu_out_tot [11] =  sfu_out_11;  
//assign sfu_out_tot [12] =  sfu_out_12;  
//assign sfu_out_tot [13] =  sfu_out_13;  
//assign sfu_out_tot [14] =  sfu_out_14;  
//assign sfu_out_tot [15] =  sfu_out_15;  

core u_core(
    .clk        (CLK),
    .reset      (RESET),
    .seq_begin  (START),
    .seq_done	(SEQ_DONE),

    .dut_ACT_addr  (dut_ACT_ADDR),
    .dut_ACT_cen   (dut_ACT_CEN),
    .dut_ACT_wen   (dut_ACT_WEN),
    .dut_ACT_d     (dut_ACT_D),
    .ACT_q         (dut_ACT_Q),

    .dut_W_addr  (dut_W_ADDR),
    .dut_W_cen   (dut_W_CEN),
    .dut_W_wen   (dut_W_WEN),
    .dut_W_d     (dut_W_D),
    .W_q         (dut_W_Q),

    .dut_OP_addr  (dut_O_ADDR),
    .dut_OP_cen   (dut_O_CEN),
    .dut_OP_wen   (dut_O_WEN),
    .dut_OP_d     (dut_O_D),
    .dut_OP_q     (dut_O_Q),

    .dut_cl_sel(dut_CL_SELECT),
    .sfu_done (SFU_DONE)
    //.sfu_out_0(sfu_out_0),
    //.sfu_out_1(sfu_out_1),
    //.sfu_out_2(sfu_out_2),
    //.sfu_out_3(sfu_out_3),
    //.sfu_out_4(sfu_out_4),
    //.sfu_out_5(sfu_out_5),
    //.sfu_out_6(sfu_out_6),
    //.sfu_out_7(sfu_out_7),
    //.sfu_out_8(sfu_out_8),
    //.sfu_out_9(sfu_out_9),
    //.sfu_out_10(sfu_out_10),
    //.sfu_out_11(sfu_out_11),
    //.sfu_out_12(sfu_out_12),
    //.sfu_out_13(sfu_out_13),
    //.sfu_out_14(sfu_out_14),
    //.sfu_out_15(sfu_out_15)
    );


initial 
begin

    $dumpfile("core_tb.vcd");
    $dumpvars(0,core_tb);
 
    CLK = 0;
    RESET = 1;
    START = 0;
  
    w_file = $fopen("weight_project.txt", "r");
    // Following three lines are to remove the first three comment lines of the file
    w_scan_file = $fscanf(w_file,"%s", captured_data);
    w_scan_file = $fscanf(w_file,"%s", captured_data);
    w_scan_file = $fscanf(w_file,"%s", captured_data);

    #101 RESET = 0;
    #10
    dut_W_CEN = 0;
    dut_W_WEN = 0;
    dut_ACT_CEN = 1;
    dut_ACT_WEN = 1;

    dut_CL_SELECT = 1;
    dut_O_WEN = 1;
    dut_O_CEN = 1;

    for (i=0; i<72 ; i=i+1)
    begin
        #10
        dut_W_ADDR   = i;
        w_scan_file = $fscanf(w_file,"%32b", dut_W_D);
        D_2D[i][31:0] = dut_W_D;
    end
    #10
    dut_W_CEN = 1;
    dut_W_WEN = 1;
    dut_CL_SELECT = 1;
    dut_O_WEN = 1;
    dut_O_CEN = 1;
    for (i=0; i<72 ; i=i+1)
    begin
        #5
        dut_W_CEN = 0;
        dut_W_WEN = 1;
        dut_W_ADDR   = i;
        #5
        if (D_2D[i][31:0] == dut_W_Q)
            $display("%2d-th read data is %h --- Data matched", i, dut_W_Q);
        else begin
            $display("%2d-th read data is %h, expected data is %h --- Data ERROR !!!", i, dut_W_Q, D_2D[i]);
            error = error+1;
        end
    end
    //Weight Load and Check ends

    //Activation Load and check begins

    a_file = $fopen("activation_project.txt", "r");
    // Following three lines are to remove the first three comment lines of the file
    a_scan_file = $fscanf(a_file,"%s", captured_data);
    a_scan_file = $fscanf(a_file,"%s", captured_data);
    a_scan_file = $fscanf(a_file,"%s", captured_data);

    #101 RESET = 0;
    #10
    dut_ACT_CEN = 0;
    dut_ACT_WEN = 0;
    dut_CL_SELECT = 1;
    dut_O_WEN = 1;
    dut_O_CEN = 1;

    for (i=0; i<36 ; i=i+1)
    begin
        #10
        dut_ACT_ADDR   = i;
        a_scan_file = $fscanf(a_file,"%32b", dut_ACT_D);
        D_2D[72+i][31:0] = dut_ACT_D;
    end
    #10
    dut_ACT_CEN = 1;
    dut_ACT_WEN = 1;
    dut_CL_SELECT = 1;
    dut_O_WEN = 1;
    dut_O_CEN = 1;
    for (i=0; i<36 ; i=i+1)
    begin
        #5
        dut_ACT_CEN = 0;
        dut_ACT_WEN = 1;
        dut_ACT_ADDR   = i;
        #5
        if (D_2D[72+i][31:0] == dut_ACT_Q)
            $display("%2d-th read data is %h --- Data matched", i, dut_ACT_Q);
        else begin
            $display("%2d-th read data is %h, expected data is %h --- Data ERROR !!!", i, dut_ACT_Q, D_2D[72+i]);
            error = error+1;
        end
    end
	
    
    dut_CL_SELECT = 0;
    dut_ACT_WEN = 1;
    dut_ACT_CEN = 1;
    
    #100 START = 1;
    #100 START = 0;

    #12500
    //Activation Load and check begins


    ///SRAM WRITE SIGNAL

    p_file = $fopen("output_project.txt", "r");
    // Following three lines are to remove the first three comment lines of the file
    p_scan_file = $fscanf(p_file,"%s", captured_data);
    p_scan_file = $fscanf(p_file,"%s", captured_data);
    p_scan_file = $fscanf(p_file,"%s", captured_data);

    #101 RESET = 0;
    #10
    dut_ACT_CEN = 1;
    dut_ACT_WEN = 1;
    dut_W_CEN = 1;
    dut_W_WEN = 1;
    dut_CL_SELECT = 1;
    dut_O_WEN = 1;
    dut_O_CEN = 1;
                                                                                                             
    for (i=0; i<16 ; i=i+1)
    begin
        #10
        p_scan_file = $fscanf(p_file,"%128b", dut_O_D);
        //$display("%2d- pscan is %b --- Data matched", i,dut_O_D);
        D_2D_128[i][127:0] = dut_O_D;
    end
    ///****for SFU OUT CHECK *****//
    //for (i=0; i<16 ; i=i+1)
    //begin
    //	if (D_2D_128[i][127:0] == sfu_out_tot[i])                                                                       
    //     $display("%2d-th SFU_OUT is %h --- Data matched", i, sfu_out_tot[i]);                                     
    //	else begin                                                                                                      
    //     	$display("%2d-th SFU_OUT is %h, expected data is %h --- Data ERROR !!!", i, sfu_out_tot[i], D_2D_128[i]); 
    //     	error = error+1;                                                                                            
    //	end
    //end 
    #10
    dut_ACT_CEN = 1;
    dut_ACT_WEN = 1;
    dut_W_CEN = 1;
    dut_W_WEN = 1;
    dut_CL_SELECT = 1;
    dut_O_WEN = 1;
    dut_O_CEN = 1;
    for (i=0; i<16 ; i=i+1)
    begin
        #5
        dut_O_CEN = 0;
        dut_O_WEN = 1;
        dut_O_ADDR   = i;
        #5
        if (D_2D_128[i][127:0] == dut_O_Q)
            $display("%2d-th read data from OP_SRAM is %h --- Data matched", i, dut_O_Q);
        else begin
            $display("%2d-th read data from 0P_SRAM is %h, expected data is %h --- Data ERROR !!!", i, dut_O_Q, D_2D_128[i]);
            error = error+1;
        end
    
    end

    #100
 
    $stop;
    $finish;
  
end

initial
begin
#5
forever
    #5 CLK = ~CLK;
end

endmodule
