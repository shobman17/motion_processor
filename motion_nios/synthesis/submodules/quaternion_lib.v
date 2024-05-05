// Quaternion library for the following operations
// Normalize
// Muliply with a quaternion
// Addition with a quaternion
// Multiply with a scalar

`timescale 1 ps / 1 ps
module normalise_quat(w_in, i_in, j_in, k_in, w_out, i_out, j_out, k_out);

// port definitions
input[15:0] w_in;
input[15:0] i_in;
input[15:0] j_in;
input[15:0] k_in;
output[15:0] w_out;
output[15:0] i_out;
output[15:0] j_out;
output[15:0] k_out;

// internal wires
wire[15:0] w_square, i_square, j_square, k_square, wi, jk, norm;
wire[5:0] flags_w2, flags_i2, flags_j2, flags_k2, flags_wi, flags_jk, flags_norm, flags_divw, flags_divi, flags_divj, flags_divk; 

// logic
// get squares of each element
fp_mul w2(w_in, w_in, w_square, flags_w2);
fp_mul i2(i_in, i_in, i_square, flags_i2);
fp_mul j2(j_in, j_in, j_square, flags_j2);
fp_mul k2(k_in, k_in, k_square, flags_k2);
// add them up
fp_as adder1(w_square, i_square, 1'b0, wi, flags_wi);
fp_as adder2(j_square, k_square, 1'b0, jk, flags_jk);
fp_as adder3(wi, jk, 1'b0, norm, flags_norm);
// divide each element by the norm now
fp_div div_w(w_in, norm, w_out, flags_divw);
fp_div div_i(i_in, norm, i_out, flags_divi);
fp_div div_j(j_in, norm, j_out, flags_divj);
fp_div div_k(k_in, norm, k_out, flags_divk);

endmodule

module mult_quat(w_in1, i_in1, j_in1, k_in1, w_in2, i_in2, j_in2, k_in2, w_out, i_out, j_out, k_out);

// port definitions
input [15:0] w_in1, i_in1, j_in1, k_in1, w_in2, i_in2, j_in2, k_in2;
output [15:0] w_out, i_out, j_out, k_out;

// internal wires
wire[15:0] w1w2, w1i2, w1j2, w1k2, i1w2, i1i2, i1j2, i1k2, j1w2, j1i2, j1j2, j1k2, k1w2, k1i2, k1j2, k1k2, wout1, wout2, iout1, iout2, jout1, jout2, kout1, kout2;
wire[5:0] flags_w1w2, flags_w1i2, flags_w1j2, flags_w1k2, flags_i1w2, flags_i1i2, flags_i1j2, flags_i1k2, flags_j1w2, flags_j1i2, flags_j1j2, flags_j1k2, flags_k1w2, flags_k1i2, flags_k1j2, flags_k1k2;
wire[5:0] flags_wout1, flags_wout2, flags_iout1, flags_iout2, flags_jout1, flags_jout2, flags_kout1, flags_kout2;
wire[5:0] flags_wout, flags_iout, flags_jout, flags_kout;

// logic 
// do all the multiplications
fp_mul mw1w2(w_in1, w_in2, w1w2, flags_w1w2);
fp_mul mw1i2(w_in1, i_in2, w1i2, flags_w1i2);
fp_mul mw1j2(w_in1, j_in2, w1j2, flags_w1j2);
fp_mul mw1k2(w_in1, k_in2, w1k2, flags_w1k2);
fp_mul mi1w2(i_in1, w_in2, i1w2, flags_i1w2);
fp_mul mi1i2(i_in1, i_in2, i1i2, flags_i1i2);
fp_mul mi1j2(i_in1, j_in2, i1j2, flags_i1j2);
fp_mul mi1k2(i_in1, k_in2, i1k2, flags_i1k2);
fp_mul mj1w2(j_in1, w_in2, j1w2, flags_j1w2);
fp_mul mj1i2(j_in1, i_in2, j1i2, flags_j1i2);
fp_mul mj1j2(j_in1, j_in2, j1j2, flags_j1j2);
fp_mul mj1k2(j_in1, k_in2, j1k2, flags_j1k2);
fp_mul mk1w2(k_in1, w_in2, k1w2, flags_k1w2);
fp_mul mk1i2(k_in1, i_in2, k1i2, flags_k1i2);
fp_mul mk1j2(k_in1, j_in2, k1j2, flags_k1j2);
fp_mul mk1k2(k_in1, k_in2, k1k2, flags_k1k2);
// add the relevant parts and output
// for wout
fp_as asw1(w1w2, i1i2, 1'b1, wout1, flags_wout1);
fp_as asw2(j1j2, k1k2, 1'b0, wout2, flags_wout2);
fp_as asw3(wout1, wout2, 1'b1, w_out, flags_wout);
// for iout
fp_as asi1(w1i2, i1w2, 1'b0, iout1, flags_iout1);
fp_as asi2(j1k2, k1j2, 1'b1, iout2, flags_iout2);
fp_as asi3(iout1, iout2, 1'b0, i_out, flags_iout);
// for jout
fp_as asj1(w1j2, i1k2, 1'b1, jout1, flags_jout1);
fp_as asj2(j1w2, k1i2, 1'b0, jout2, flags_jout2);
fp_as asj3(jout1, jout2, 1'b0, j_out, flags_jout);
// for kout
fp_as ask1(w1k2, i1j2, 1'b0, kout1, flags_kout1);
fp_as ask2(j1i2, k1w2, 1'b1, kout2, flags_kout2);
fp_as ask3(kout1, kout2, 1'b1, k_out, flags_kout);

endmodule

module addsub_quat(w_in1, i_in1, j_in1, k_in1, w_in2, i_in2, j_in2, k_in2, select, w_out, i_out, j_out, k_out);

// port definitions
input [15:0] w_in1, i_in1, j_in1, k_in1, w_in2, i_in2, j_in2, k_in2;
input select; // 0 = add, 1 = subtract
output [15:0] w_out, i_out, j_out, k_out;

//internal wires
wire[5:0] flags_w, flags_i, flags_j, flags_k;

// logic
fp_as asw(w_in1, w_in2, select, w_out, flags_w);
fp_as asi(i_in1, i_in2, select, i_out, flags_i);
fp_as asj(j_in1, j_in2, select, j_out, flags_j);
fp_as ask(k_in1, k_in2, select, k_out, flags_k);

endmodule

module multscalar_quat(w_in, i_in, j_in, k_in, scalar, w_out, i_out, j_out, k_out);

// port definitions
input[15:0] w_in;
input[15:0] i_in;
input[15:0] j_in;
input[15:0] k_in;
input[15:0] scalar;
output[15:0] w_out;
output[15:0] i_out;
output[15:0] j_out;
output[15:0] k_out;

//internal wires
wire[5:0] flags_w, flags_i, flags_j, flags_k;

// logic 
fp_mul multw(w_in, scalar, w_out, flags_w);
fp_mul multi(i_in, scalar, i_out, flags_i);
fp_mul multj(j_in, scalar, j_out, flags_j);
fp_mul multk(k_in, scalar, k_out, flags_k);

endmodule

