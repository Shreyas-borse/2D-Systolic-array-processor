module clock_gater
(
input wire clk, i_clk_en,
output wire g_clk
);

reg clk_en_latch;
wire inv_clk;

assign inv_clk = ~clk;

always @ (*)
begin
	if (inv_clk)
		clk_en_latch = i_clk_en;
end

assign g_clk = clk & clk_en_latch;

endmodule
