# =====================================================
# Vivado Tcl Script for Simulation
# =====================================================

# --- Paths (adjust if needed)
set design_dir "C:/Users/akshi/Add_Jmp_up/Add_Jmp_up.srcs/sources_1/imports/hello"
set tb_dir     "C:/Users/akshi/Add_Jmp_up/Add_Jmp_up.srcs/sim_1/imports/hello"

# --- Collect Verilog files
set design_files [glob -nocomplain -directory $design_dir *.v]
set tb_files     [glob -nocomplain -directory $tb_dir *.v]

puts "Design files: $design_files"
puts "Testbench files: $tb_files"

# --- Compile all Verilog files
xvlog -sv $design_files $tb_files

# --- Elaborate top-level testbench
# Change 'tb_fpga_top' if your testbench module has another name
xelab tb_fpga_top -debug typical -s tb_sim

# --- Run simulation
xsim tb_sim -tclbatch {
    log_wave -recursive *
    run 2000ns
    write_vcd tb_fpga_top.vcd
}

puts "Simulation finished. Waveform written to tb_fpga_top.vcd"
