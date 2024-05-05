module quatnorm_tb;

// port definitions
reg[15:0] w_in;
reg[15:0] i_in;
reg[15:0] j_in;
reg[15:0] k_in;
reg[15:0] w_out;
reg[15:0] i_out;
reg[15:0] j_out;
reg[15:0] k_out;

normalise_quat DUT (w_in, i_in, j_in, k_in, w_out, i_out, j_out, k_out);

initial begin
	
	$dumpvars();
	#100 w_in = 
	#200 
	#300
	#400
	
	
end 

endmodule
