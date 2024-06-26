`timescale 1ns / 1ps
//`include "flags.vh"

module normalise_quat_tb;

    reg [15:0] w_in, i_in, j_in, k_in;

    wire [15:0] w_out, i_out, j_out, k_out;

    normalise_quat uut (
        .w_in(w_in),
        .i_in(i_in),
        .j_in(j_in),
        .k_in(k_in),
        .w_out(w_out),
        .i_out(i_out),
        .j_out(j_out),
        .k_out(k_out)
    );

    initial begin

        w_in = 16'b0000000010011001; 
        i_in = 16'b0000000100110011; 
        j_in = 16'b0000000111001100; 
        k_in = 16'b0000001001100110; 

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
        

        $stop; 
    end
endmodule
