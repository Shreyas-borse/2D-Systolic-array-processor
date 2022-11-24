module sfu (
		input 			clk,
		input			reset,
		input signed	[15:0]  sfu_in [0:7],
		input			valid,
		output signed   [127:0] sfu_out
		//create output interfaces to read from sfu_reg_bank and send to SRAMs
	);
	
	logic [8:0] sfu_counter;
	logic [4:0] LUT_map [0:323];
	logic signed [15:0] sfu_reg_bank [0:7][0:15]; //This is where the final output will be after 324 valid signals
	//This is combination of unpacked and packed arrays.
	//Packed arrays are on the left of the variable. 
	//Unpacked are to the right of the variable. 
	//If there are multiple packed or unpacked, then the order is as below
	//In unpacked (ie to the right), the one closest will be indexed first and we will keep moving towards right for next indexing
	//In packed (ie to the left), the closest will be the last to be indexed (or it will be at bit-level granularity)

	always@(posedge clk or posedge reset) begin
		if(reset) begin
			sfu_counter	<=	0;
			for (int i=0 ; i < 8 ; i= i+1)	begin
				for (int j=0 ; j < 16 ; j= j+1) begin
					sfu_reg_bank[i][j] <= 0;
				end
			end
		end
		else begin
			if(valid) begin
				sfu_counter <= sfu_counter + 1;
				if(LUT_map[sfu_counter][4]!=1) begin
					for(int i=0 ; i<8 ; i = i+1)
						sfu_reg_bank[i][LUT_map[sfu_counter][3:0]] <= $signed(sfu_reg_bank[i][LUT_map[sfu_counter][3:0]]) + $signed(sfu_in[i]);
						//Took indexes [3:0] as bit 4 is not useful towards final output indexing. It only serves as an enable bit used in the "if(LUT_map[sfu_counter][4]!=1)" condition.
				end
			end
		end
	end
	
	// if value is 5'd16, then it should not be added
	assign LUT_map[0  ] =  5'd0  ;
	assign LUT_map[1  ] =  5'd1  ;
	assign LUT_map[2  ] =  5'd2  ;
	assign LUT_map[3  ] =  5'd3  ;
	assign LUT_map[4  ] =  5'd16 ;
	assign LUT_map[5  ] =  5'd16 ;
	assign LUT_map[6  ] =  5'd4  ;
	assign LUT_map[7  ] =  5'd5  ;
	assign LUT_map[8  ] =  5'd6  ;
	assign LUT_map[9  ] =  5'd7  ;
	assign LUT_map[10 ] =  5'd16 ;
	assign LUT_map[11 ] =  5'd16 ;
	assign LUT_map[12 ] =  5'd8  ;
	assign LUT_map[13 ] =  5'd9  ;
	assign LUT_map[14 ] =  5'd10 ;
	assign LUT_map[15 ] =  5'd11 ;
	assign LUT_map[16 ] =  5'd16 ;
	assign LUT_map[17 ] =  5'd16 ;
	assign LUT_map[18 ] =  5'd12 ;
	assign LUT_map[19 ] =  5'd13 ;
	assign LUT_map[20 ] =  5'd14 ;
	assign LUT_map[21 ] =  5'd15 ;
	assign LUT_map[22 ] =  5'd16 ;
	assign LUT_map[23 ] =  5'd16 ;
	assign LUT_map[24 ] =  5'd16 ;
	assign LUT_map[25 ] =  5'd16 ;
	assign LUT_map[26 ] =  5'd16 ;
	assign LUT_map[27 ] =  5'd16 ;
	assign LUT_map[28 ] =  5'd16 ;
	assign LUT_map[29 ] =  5'd16 ;
	assign LUT_map[30 ] =  5'd16 ;
	assign LUT_map[31 ] =  5'd16 ;
	assign LUT_map[32 ] =  5'd16 ;
	assign LUT_map[33 ] =  5'd16 ;
	assign LUT_map[34 ] =  5'd16 ;
	assign LUT_map[35 ] =  5'd16 ;
	assign LUT_map[36 ] =  5'd16 ;
	assign LUT_map[37 ] =  5'd0  ;
	assign LUT_map[38 ] =  5'd1  ;
	assign LUT_map[39 ] =  5'd2  ;
	assign LUT_map[40 ] =  5'd3  ;
	assign LUT_map[41 ] =  5'd16 ;
	assign LUT_map[42 ] =  5'd16 ;
	assign LUT_map[43 ] =  5'd4  ;
	assign LUT_map[44 ] =  5'd5  ;
	assign LUT_map[45 ] =  5'd6  ;
	assign LUT_map[46 ] =  5'd7  ;
	assign LUT_map[47 ] =  5'd16 ;
	assign LUT_map[48 ] =  5'd16 ;
	assign LUT_map[49 ] =  5'd8  ;
	assign LUT_map[50 ] =  5'd9  ;
	assign LUT_map[51 ] =  5'd10 ;
	assign LUT_map[52 ] =  5'd11 ;
	assign LUT_map[53 ] =  5'd16 ;
	assign LUT_map[54 ] =  5'd16 ;
	assign LUT_map[55 ] =  5'd12 ;
	assign LUT_map[56 ] =  5'd13 ;
	assign LUT_map[57 ] =  5'd14 ;
	assign LUT_map[58 ] =  5'd15 ;
	assign LUT_map[59 ] =  5'd16 ;
	assign LUT_map[60 ] =  5'd16 ;
	assign LUT_map[61 ] =  5'd16 ;
	assign LUT_map[62 ] =  5'd16 ;
	assign LUT_map[63 ] =  5'd16 ;
	assign LUT_map[64 ] =  5'd16 ;
	assign LUT_map[65 ] =  5'd16 ;
	assign LUT_map[66 ] =  5'd16 ;
	assign LUT_map[67 ] =  5'd16 ;
	assign LUT_map[68 ] =  5'd16 ;
	assign LUT_map[69 ] =  5'd16 ;
	assign LUT_map[70 ] =  5'd16 ;
	assign LUT_map[71 ] =  5'd16 ;
	assign LUT_map[72 ] =  5'd16 ;
	assign LUT_map[73 ] =  5'd16 ;
	assign LUT_map[74 ] =  5'd0  ;
	assign LUT_map[75 ] =  5'd1  ;
	assign LUT_map[76 ] =  5'd2  ;
	assign LUT_map[77 ] =  5'd3  ;
	assign LUT_map[78 ] =  5'd16 ;
	assign LUT_map[79 ] =  5'd16 ;
	assign LUT_map[80 ] =  5'd4  ;
	assign LUT_map[81 ] =  5'd5  ;
	assign LUT_map[82 ] =  5'd6  ;
	assign LUT_map[83 ] =  5'd7  ;
	assign LUT_map[84 ] =  5'd16 ;
	assign LUT_map[85 ] =  5'd16 ;
	assign LUT_map[86 ] =  5'd8  ;
	assign LUT_map[87 ] =  5'd9  ;
	assign LUT_map[88 ] =  5'd10 ;
	assign LUT_map[89 ] =  5'd11 ;
	assign LUT_map[90 ] =  5'd16 ;
	assign LUT_map[91 ] =  5'd16 ;
	assign LUT_map[92 ] =  5'd12 ;
	assign LUT_map[93 ] =  5'd13 ;
	assign LUT_map[94 ] =  5'd14 ;
	assign LUT_map[95 ] =  5'd15 ;
	assign LUT_map[96 ] =  5'd16 ;
	assign LUT_map[97 ] =  5'd16 ;
	assign LUT_map[98 ] =  5'd16 ;
	assign LUT_map[99 ] =  5'd16 ;
	assign LUT_map[100] =  5'd16 ;
	assign LUT_map[101] =  5'd16 ;
	assign LUT_map[102] =  5'd16 ;
	assign LUT_map[103] =  5'd16 ;
	assign LUT_map[104] =  5'd16 ;
	assign LUT_map[105] =  5'd16 ;
	assign LUT_map[106] =  5'd16 ;
	assign LUT_map[107] =  5'd16 ;
	assign LUT_map[108] =  5'd16 ;
	assign LUT_map[109] =  5'd16 ;
	assign LUT_map[110] =  5'd16 ;
	assign LUT_map[111] =  5'd16 ;
	assign LUT_map[112] =  5'd16 ;
	assign LUT_map[113] =  5'd16 ;
	assign LUT_map[114] =  5'd0  ;
	assign LUT_map[115] =  5'd1  ;
	assign LUT_map[116] =  5'd2  ;
	assign LUT_map[117] =  5'd3  ;
	assign LUT_map[118] =  5'd16 ;
	assign LUT_map[119] =  5'd16 ;
	assign LUT_map[120] =  5'd4  ;
	assign LUT_map[121] =  5'd5  ;
	assign LUT_map[122] =  5'd6  ;
	assign LUT_map[123] =  5'd7  ;
	assign LUT_map[124] =  5'd16 ;
	assign LUT_map[125] =  5'd16 ;
	assign LUT_map[126] =  5'd8  ;
	assign LUT_map[127] =  5'd9  ;
	assign LUT_map[128] =  5'd10 ;
	assign LUT_map[129] =  5'd11 ;
	assign LUT_map[130] =  5'd16 ;
	assign LUT_map[131] =  5'd16 ;
	assign LUT_map[132] =  5'd12 ;
	assign LUT_map[133] =  5'd13 ;
	assign LUT_map[134] =  5'd14 ;
	assign LUT_map[135] =  5'd15 ;
	assign LUT_map[136] =  5'd16 ;
	assign LUT_map[137] =  5'd16 ;
	assign LUT_map[138] =  5'd16 ;
	assign LUT_map[139] =  5'd16 ;
	assign LUT_map[140] =  5'd16 ;
	assign LUT_map[141] =  5'd16 ;
	assign LUT_map[142] =  5'd16 ;
	assign LUT_map[143] =  5'd16 ;
	assign LUT_map[144] =  5'd16 ;
	assign LUT_map[145] =  5'd16 ;
	assign LUT_map[146] =  5'd16 ;
	assign LUT_map[147] =  5'd16 ;
	assign LUT_map[148] =  5'd16 ;
	assign LUT_map[149] =  5'd16 ;
	assign LUT_map[150] =  5'd16 ;
	assign LUT_map[151] =  5'd0  ;
	assign LUT_map[152] =  5'd1  ;
	assign LUT_map[153] =  5'd2  ;
	assign LUT_map[154] =  5'd3  ;
	assign LUT_map[155] =  5'd16 ;
	assign LUT_map[156] =  5'd16 ;
	assign LUT_map[157] =  5'd4  ;
	assign LUT_map[158] =  5'd5  ;
	assign LUT_map[159] =  5'd6  ;
	assign LUT_map[160] =  5'd7  ;
	assign LUT_map[161] =  5'd16 ;
	assign LUT_map[162] =  5'd16 ;
	assign LUT_map[163] =  5'd8  ;
	assign LUT_map[164] =  5'd9  ;
	assign LUT_map[165] =  5'd10 ;
	assign LUT_map[166] =  5'd11 ;
	assign LUT_map[167] =  5'd16 ;
	assign LUT_map[168] =  5'd16 ;
	assign LUT_map[169] =  5'd12 ;
	assign LUT_map[170] =  5'd13 ;
	assign LUT_map[171] =  5'd14 ;
	assign LUT_map[172] =  5'd15 ;
	assign LUT_map[173] =  5'd16 ;
	assign LUT_map[174] =  5'd16 ;
	assign LUT_map[175] =  5'd16 ;
	assign LUT_map[176] =  5'd16 ;
	assign LUT_map[177] =  5'd16 ;
	assign LUT_map[178] =  5'd16 ;
	assign LUT_map[179] =  5'd16 ;
	assign LUT_map[180] =  5'd16 ;
	assign LUT_map[181] =  5'd16 ;
	assign LUT_map[182] =  5'd16 ;
	assign LUT_map[183] =  5'd16 ;
	assign LUT_map[184] =  5'd16 ;
	assign LUT_map[185] =  5'd16 ;
	assign LUT_map[186] =  5'd16 ;
	assign LUT_map[187] =  5'd16 ;
	assign LUT_map[188] =  5'd0  ;
	assign LUT_map[189] =  5'd1  ;
	assign LUT_map[190] =  5'd2  ;
	assign LUT_map[191] =  5'd3  ;
	assign LUT_map[192] =  5'd16 ;
	assign LUT_map[193] =  5'd16 ;
	assign LUT_map[194] =  5'd4  ;
	assign LUT_map[195] =  5'd5  ;
	assign LUT_map[196] =  5'd6  ;
	assign LUT_map[197] =  5'd7  ;
	assign LUT_map[198] =  5'd16 ;
	assign LUT_map[199] =  5'd16 ;
	assign LUT_map[200] =  5'd8  ;
	assign LUT_map[201] =  5'd9  ;
	assign LUT_map[202] =  5'd10 ;
	assign LUT_map[203] =  5'd11 ;
	assign LUT_map[204] =  5'd16 ;
	assign LUT_map[205] =  5'd16 ;
	assign LUT_map[206] =  5'd12 ;
	assign LUT_map[207] =  5'd13 ;
	assign LUT_map[208] =  5'd14 ;
	assign LUT_map[209] =  5'd15 ;
	assign LUT_map[210] =  5'd16 ;
	assign LUT_map[211] =  5'd16 ;
	assign LUT_map[212] =  5'd16 ;
	assign LUT_map[213] =  5'd16 ;
	assign LUT_map[214] =  5'd16 ;
	assign LUT_map[215] =  5'd16 ;
	assign LUT_map[216] =  5'd16 ;
	assign LUT_map[217] =  5'd16 ;
	assign LUT_map[218] =  5'd16 ;
	assign LUT_map[219] =  5'd16 ;
	assign LUT_map[220] =  5'd16 ;
	assign LUT_map[221] =  5'd16 ;
	assign LUT_map[222] =  5'd16 ;
	assign LUT_map[223] =  5'd16 ;
	assign LUT_map[224] =  5'd16 ;
	assign LUT_map[225] =  5'd16 ;
	assign LUT_map[226] =  5'd16 ;
	assign LUT_map[227] =  5'd16 ;
	assign LUT_map[228] =  5'd0  ;
	assign LUT_map[229] =  5'd1  ;
	assign LUT_map[230] =  5'd2  ;
	assign LUT_map[231] =  5'd3  ;
	assign LUT_map[232] =  5'd16 ;
	assign LUT_map[233] =  5'd16 ;
	assign LUT_map[234] =  5'd4  ;
	assign LUT_map[235] =  5'd5  ;
	assign LUT_map[236] =  5'd6  ;
	assign LUT_map[237] =  5'd7  ;
	assign LUT_map[238] =  5'd16 ;
	assign LUT_map[239] =  5'd16 ;
	assign LUT_map[240] =  5'd8  ;
	assign LUT_map[241] =  5'd9  ;
	assign LUT_map[242] =  5'd10 ;
	assign LUT_map[243] =  5'd11 ;
	assign LUT_map[244] =  5'd16 ;
	assign LUT_map[245] =  5'd16 ;
	assign LUT_map[246] =  5'd12 ;
	assign LUT_map[247] =  5'd13 ;
	assign LUT_map[248] =  5'd14 ;
	assign LUT_map[249] =  5'd15 ;
	assign LUT_map[250] =  5'd16 ;
	assign LUT_map[251] =  5'd16 ;
	assign LUT_map[252] =  5'd16 ;
	assign LUT_map[253] =  5'd16 ;
	assign LUT_map[254] =  5'd16 ;
	assign LUT_map[255] =  5'd16 ;
	assign LUT_map[256] =  5'd16 ;
	assign LUT_map[257] =  5'd16 ;
	assign LUT_map[258] =  5'd16 ;
	assign LUT_map[259] =  5'd16 ;
	assign LUT_map[260] =  5'd16 ;
	assign LUT_map[261] =  5'd16 ;
	assign LUT_map[262] =  5'd16 ;
	assign LUT_map[263] =  5'd16 ;
	assign LUT_map[264] =  5'd16 ;
	assign LUT_map[265] =  5'd0  ;
	assign LUT_map[266] =  5'd1  ;
	assign LUT_map[267] =  5'd2  ;
	assign LUT_map[268] =  5'd3  ;
	assign LUT_map[269] =  5'd16 ;
	assign LUT_map[270] =  5'd16 ;
	assign LUT_map[271] =  5'd4  ;
	assign LUT_map[272] =  5'd5  ;
	assign LUT_map[273] =  5'd6  ;
	assign LUT_map[274] =  5'd7  ;
	assign LUT_map[275] =  5'd16 ;
	assign LUT_map[276] =  5'd16 ;
	assign LUT_map[277] =  5'd8  ;
	assign LUT_map[278] =  5'd9  ;
	assign LUT_map[279] =  5'd10 ;
	assign LUT_map[280] =  5'd11 ;
	assign LUT_map[281] =  5'd16 ;
	assign LUT_map[282] =  5'd16 ;
	assign LUT_map[283] =  5'd12 ;
	assign LUT_map[284] =  5'd13 ;
	assign LUT_map[285] =  5'd14 ;
	assign LUT_map[286] =  5'd15 ;
	assign LUT_map[287] =  5'd16 ;
	assign LUT_map[288] =  5'd16 ;
	assign LUT_map[289] =  5'd16 ;
	assign LUT_map[290] =  5'd16 ;
	assign LUT_map[291] =  5'd16 ;
	assign LUT_map[292] =  5'd16 ;
	assign LUT_map[293] =  5'd16 ;
	assign LUT_map[294] =  5'd16 ;
	assign LUT_map[295] =  5'd16 ;
	assign LUT_map[296] =  5'd16 ;
	assign LUT_map[297] =  5'd16 ;
	assign LUT_map[298] =  5'd16 ;
	assign LUT_map[299] =  5'd16 ;
	assign LUT_map[300] =  5'd16 ;
	assign LUT_map[301] =  5'd16 ;
	assign LUT_map[302] =  5'd0  ;
	assign LUT_map[303] =  5'd1  ;
	assign LUT_map[304] =  5'd2  ;
	assign LUT_map[305] =  5'd3  ;
	assign LUT_map[306] =  5'd16 ;
	assign LUT_map[307] =  5'd16 ;
	assign LUT_map[308] =  5'd4  ;
	assign LUT_map[309] =  5'd5  ;
	assign LUT_map[310] =  5'd6  ;
	assign LUT_map[311] =  5'd7  ;
	assign LUT_map[312] =  5'd16 ;
	assign LUT_map[313] =  5'd16 ;
	assign LUT_map[314] =  5'd8  ;
	assign LUT_map[315] =  5'd9  ;
	assign LUT_map[316] =  5'd10 ;
	assign LUT_map[317] =  5'd11 ;
	assign LUT_map[318] =  5'd16 ;
	assign LUT_map[319] =  5'd16 ;
	assign LUT_map[320] =  5'd12 ;
	assign LUT_map[321] =  5'd13 ;
	assign LUT_map[322] =  5'd14 ;
	assign LUT_map[323] =  5'd15 ;

endmodule
