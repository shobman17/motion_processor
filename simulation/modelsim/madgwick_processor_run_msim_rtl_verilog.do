transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/shobh/OneDrive/Desktop/EE705/motion_processor {C:/Users/shobh/OneDrive/Desktop/EE705/motion_processor/quaternion_lib.v}
vlog -vlog01compat -work work +incdir+C:/Users/shobh/OneDrive/Desktop/EE705/motion_processor {C:/Users/shobh/OneDrive/Desktop/EE705/motion_processor/fp_mul.v}
vlog -vlog01compat -work work +incdir+C:/Users/shobh/OneDrive/Desktop/EE705/motion_processor {C:/Users/shobh/OneDrive/Desktop/EE705/motion_processor/fp_as.v}
vlog -vlog01compat -work work +incdir+C:/Users/shobh/OneDrive/Desktop/EE705/motion_processor {C:/Users/shobh/OneDrive/Desktop/EE705/motion_processor/fp_invsqrt.v}

vlog -vlog01compat -work work +incdir+C:/Users/shobh/OneDrive/Desktop/EE705/motion_processor {C:/Users/shobh/OneDrive/Desktop/EE705/motion_processor/normalise_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  normalise_quat_tb

add wave *
view structure
view signals
run -all
