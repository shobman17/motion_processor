module quatmult_tb;

reg [15:0] w_in1, i_in1, j_in1, k_in1, w_in2, i_in2, j_in2, k_in2;
reg [15:0] w_out, i_out, j_out, k_out;

mult_quat DUT(w_in1, i_in1, j_in1, k_in1, w_in2, i_in2, j_in2, k_in2, w_out, i_out, j_out, k_out);

initial begin
	
	$dumpvars();
	#100 w_in1 = 
	
end 

endmodule
