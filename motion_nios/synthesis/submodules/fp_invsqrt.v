

module fp_invsqrt(inp, outp);

// ports
input [15:0] inp;
output [15:0] outp;
reg [15:0] y_inv, y_invsqrt; // for fast inverse square root

//internal signals
wire [15:0] alpha, alpha1, alpha2, alpha3, alpha4, term1, term2, term3, term4, i1, i2, i3, i4;
wire flags1, flags2, flags3, flags4, flags5, flagst1, flagst2, flagst3, flagst4, flagsf;
localparam [15:0] one = 16'b0000000010000000,
						half = 16'b0000000001000000,
						three_by_8 = 16'b0000000000110000,
						fifteen_by_48 = 16'b0000000000101000,
						onehundredfive_by_384 = 16'b0000000000100011;
	
always @(*) begin

	if (inp[14]) begin y_inv = 16'b0000000000000001; y_invsqrt = 16'b0000000000001011; end
	else if (inp[13]) begin y_inv = 16'b0000000000000010; y_invsqrt = 16'b0000000000010000; end
	else if (inp[12]) begin y_inv = 16'b0000000000000100; y_invsqrt = 16'b0000000000010110; end
	else if (inp[11]) begin y_inv = 16'b0000000000001000; y_invsqrt = 16'b0000000000100000; end
	else begin y_inv = 16'b00000000000100000; y_invsqrt = 16'b0000000001000000; end
end

	fp_mul m1(inp, y_inv, alpha1, flags1);
	fp_as a1(one, alpha1, 1'b1, alpha);
	
	fp_mul m2(alpha, alpha, alpha2, flags2);
	fp_mul m3(alpha, alpha2, alpha3, flags3);
	fp_mul m4(alpha2, alpha2, alpha4, flags4);
	
	fp_mul c1(alpha, half, term1, flagst1);
	fp_mul c2(alpha2, three_by_8, term2, flagst2);
	fp_mul c3(alpha3, fifteen_by_48, term3, flagst3);
	fp_mul c4(alpha4, onehundredfive_by_384, term4, flagst4);
	
	fp_as a2(term1, term2, 1'b0, i1);
	fp_as a3(term3, term4, 1'b0, i2);
	fp_as a4(i1, i2, 1'b0, i3);
	fp_as a5(i3, one, 1'b0, i4);
	
	fp_mul final(i4, y_invsqrt, outp, flagsf);

endmodule
