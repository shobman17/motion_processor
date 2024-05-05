`timescale 1ns / 1ps
//`include "flags.vh"

module multquat_tb;

    // port definitions
	reg [15:0] w_in1, i_in1, j_in1, k_in1, w_in2, i_in2, j_in2, k_in2;
	wire [15:0] w_out, i_out, j_out, k_out;

    mult_quat dut(w_in1, i_in1, j_in1, k_in1, w_in2, i_in2, j_in2, k_in2, w_out, i_out, j_out, k_out);

	 
    initial begin

        w_in1 = 16'b0000010100011001; 
        i_in1 = 16'b0000010100011001; 
        j_in1 = 16'b0000010100011001; 
        k_in1 = 16'b0000010100011001;
		 
		  w_in2 = 16'b0000010100011001; 
        i_in2 = 16'b0000010100011001; 
        j_in2 = 16'b0000010100011001; 
        k_in2 = 16'b0000010100011001;

        #10; 

		  $display("Test Case 1:");
        $display("w_out: %h", w_out);
        $display("i_out: %h", i_out);
        $display("j_out: %h", j_out);
        $display("k_out: %h", k_out);
		  
		  #10
        
		  w_in1 = 16'b0000010100011001; 
        i_in1 = 16'b0000010100011001; 
        j_in1 = 16'b0000010100011001; 
        k_in1 = 16'b0000010100011001;
		 
		  w_in2 = 16'b0000001010100000; 
        i_in2 = 16'b0000001010100000; 
        j_in2 = 16'b0000001010100000; 
        k_in2 = 16'b0000001010100000;

        #10; 

		  $display("Test Case 2:");
        $display("w_out: %h", w_out);
        $display("i_out: %h", i_out);
        $display("j_out: %h", j_out);
        $display("k_out: %h", k_out);

        $stop; 
    end
endmodule
