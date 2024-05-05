`timescale 1 ps / 1 ps
module filter_avalon_interface (clk, 
										 resetn, 
										 slave_writedata, 
										 slave_readdata, 
										 write, 
										 read,
										 byteenable,
										 chipselect,
										 slave_address,
										 Q_export); 

// signals for connecting to the Avalon fabric 
input clk, resetn, read, write, chipselect; 
input [3:0] byteenable;
input [31:0] slave_writedata; 
input [15:0] slave_address; 
output [31:0] slave_readdata, Q_export; 

// some translation from 32 bit to 16 bit
//wire [15:0] address;
//wire [1:0] byteenable_t;
//assign byteenable_t[0] = byteenable[1] + byteenable[3];
//assign byteenable_t[1] = byteenable[3] + byteenable[2];
//wire [31:0] address_t = slave_address + {30'b0, byteenable_t};
//assign address = address_t[16:1]; 
wire [15:0] readdata;
wire [15:0] address = slave_address[15:0];
wire [15:0] writedata = slave_writedata[15:0];
assign slave_readdata = {16'b0, readdata}; 
assign Q_export = {16'b0, readdata};

// registers to store input data (accel, gyro, beta, initial quaternion
reg [15:0] accel_x, accel_y, accel_z, gyro_x, gyro_y, gyro_z, beta, samplePeriod, q_w, q_i, q_j, q_k;

// registers to store output data
reg [15:0] out_w, out_i, out_j, out_k;

// internal registers and wires
reg [15:0] status, // status of calculation of quaternion
			  current_input, // current data on writedata
			  current_addr, // current data on address
			  run, // whether to store calculation from filter ALU or not
			  dummy, // dummy register
			  output_reg;
			  
wire [15:0] to_filter_w, 
				to_filter_i, 
				to_filter_j, 
				to_filter_k, 
				to_filter_accelx,
				to_filter_accely,
				to_filter_accelz,
				to_filter_gyrox,
				to_filter_gyroy,
				to_filter_gyroz,
				to_filter_beta,
				to_filter_period,
				from_filter_w,
				from_filter_i,
				from_filter_j,
				from_filter_k,
				output_wire;

// constants
localparam [15:0] one = 16'b0011110000000000;
localparam [15:0] zero = 16'b0;
localparam [15:0] beta_default = 16'b0010011110101110; // around 0.03
localparam [15:0] samplePeriod_default = 16'b0010001110101110; // around 0.015 (15 ms)

// register addresses
localparam [15:0] ADDR_ACCELX = 16'd0,
						ADDR_ACCELY = 16'd4,
						ADDR_ACCELZ = 16'd8,
						ADDR_GYROX = 16'd12,
						ADDR_GYROY = 16'd16,
						ADDR_GYROZ = 16'd20,
						ADDR_BETA = 16'd24,
						ADDR_PERIOD = 16'd28,
						ADDR_INP = 16'd32, // stores latest valid write data
						ADDR_INPADDRESS = 16'd36, // stores latest valid write address
						ADDR_QW = 16'd40,
						ADDR_QI = 16'd44,
						ADDR_QJ = 16'd48,
						ADDR_QK = 16'd52,
						ADDR_OUTW = 16'd56,
						ADDR_OUTI = 16'd60,
						ADDR_OUTJ = 16'd64,
						ADDR_OUTK = 16'd68,
						ADDR_STATUS = 16'd72,
						ADDR_RUN = 16'd76;

// Instance of the madgwick filter ALU
madgwick M0(.in_w(to_filter_w),
				.in_i(to_filter_i),
				.in_j(to_filter_j),
				.in_k(to_filter_k),
				.accel_x(to_filter_accelx),
				.accel_y(to_filter_accely),
				.accel_z(to_filter_accelz),
				.gyro_x(to_filter_gyrox),
				.gyro_y(to_filter_gyroy),
				.gyro_z(to_filter_gyroz),
				.beta(to_filter_beta),
				.samplePeriod(to_filter_period),
				.out_w(from_filter_w),
				.out_i(from_filter_i),
				.out_j(from_filter_j),
				.out_k(from_filter_k));

assign to_filter_w = q_w;
assign to_filter_i = q_i;
assign to_filter_j = q_j;
assign to_filter_k = q_k;
assign to_filter_accelx = accel_x;
assign to_filter_accely = accel_y;
assign to_filter_accelz = accel_z;
assign to_filter_gyrox = gyro_x;
assign to_filter_gyroy = gyro_y;
assign to_filter_gyroz = gyro_z;
assign to_filter_beta = beta;
assign to_filter_period = samplePeriod;
assign readdata = output_reg;

// synchronous reads from output registers 
always @(posedge clk) begin
	if (read & chipselect) begin
		case (address)
			ADDR_OUTW: output_reg <= out_w;
			ADDR_OUTI: output_reg <= out_i;
			ADDR_OUTJ: output_reg <= out_j;
			ADDR_OUTK: output_reg <= out_k;
			ADDR_STATUS: output_reg <= status;
			ADDR_RUN: output_reg <= run;
			ADDR_BETA: output_reg <= beta;
			ADDR_PERIOD: output_reg <= samplePeriod;
			ADDR_INPADDRESS: output_reg <= current_addr;
			ADDR_INP: output_reg <= current_input;
			default: output_reg <= 0;
		endcase
	end
end

// synchronous write to registers and synchronous reset
// Synchronous run for the filter ALU
always @(posedge clk) begin
	if (resetn == 0) begin //active low reset. does not require chipselect
		// reset quaternion to (1,0,0,0)
		q_w <= one;
		q_i <= zero;
		q_j <= zero;
		q_k <= zero;
		beta <= beta_default;
		samplePeriod <= samplePeriod_default;
		status <= zero;
		run <= zero; // stop ALU
	end else begin
		if (chipselect) begin
			if (run == 16'b1) begin
				out_w <= from_filter_w;
				out_i <= from_filter_i;
				out_j <= from_filter_j;
				out_k <= from_filter_k;
				q_w <= from_filter_w;
				q_i <= from_filter_i;
				q_j <= from_filter_j;
				q_k <= from_filter_k;
				run <= zero; //stop ALU
			end else begin
				if (write) begin
					current_input <= writedata;
					current_addr <= address;
					case (address)
						ADDR_ACCELX: accel_x <= writedata;
						ADDR_ACCELY: accel_y <= writedata;
						ADDR_ACCELZ: accel_z <= writedata;
						ADDR_GYROX: gyro_x <= writedata;
						ADDR_GYROY: gyro_y <= writedata;
						ADDR_GYROZ: gyro_z <= writedata;
						ADDR_BETA: beta <= writedata;
						ADDR_PERIOD: samplePeriod <= writedata;
						ADDR_QW: q_w <= writedata;
						ADDR_QI: q_i <= writedata;
						ADDR_QJ: q_j <= writedata;
						ADDR_QK: q_k <= writedata;
						ADDR_RUN: run <= writedata;
						default: dummy <= writedata;
					endcase
				end
			end
		end
	end
end
		

endmodule
