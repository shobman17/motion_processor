`timescale 1ns / 1ps
//`include "flags.vh"

module addsub_quat_tb;

	reg [15:0] w_in1, i_in1, j_in1, k_in1, w_in2, i_in2, j_in2, k_in2;
	reg select; // 0 = add, 1 = subtract
	wire [15:0] w_out, i_out, j_out, k_out;

   addsub_quat dut(w_in1, i_in1, j_in1, k_in1, w_in2, i_in2, j_in2, k_in2, select, w_out, i_out, j_out, k_out);

    initial begin

        w_in1 = 16'b0011001000011001; 
        i_in1 = 16'b0011001000011001; 
        j_in1 = 16'b0011001000011001; 
        k_in1 = 16'b0011001000011001;
		 
		  w_in2 = 16'b0011001000011001; 
        i_in2 = 16'b0011001000011001; 
        j_in2 = 16'b0011001000011001; 
        k_in2 = 16'b0011001000011001;
		  
		  select = 1'b0;

        #1000; 

        
//        if (w_out == 16'h3D00 && i_out == 16'h3D00 && j_out == 16'h3D00 && k_out == 16'h3D00) begin
//            $display("Test Case 1 Passed");
//			end
//        else
//			begin
//            $display("Test Case 1 Failed");
//			end

		  $display("Test Case 1:");
        $display("w_out: %h", w_out);
        $display("i_out: %h", i_out);
        $display("j_out: %h", j_out);
        $display("k_out: %h", k_out);
		  
		  select = 1'b1;
		  
		  #1000;
		  
        $display("Test Case 2:");
        $display("w_out: %h", w_out);
        $display("i_out: %h", i_out);
        $display("j_out: %h", j_out);
        $display("k_out: %h", k_out);

        $stop; 
    end
endmodule