set simulator_name [lindex $argv 0]
set simulator_exec_path [lindex $argv 1]
set output_path [lindex $argv 2]

puts "simulator_name=${simulator_name}"
puts "simulator_exec_path=${simulator_exec_path}"
puts "output_path=${output_path}"

set_param general.maxThreads 4

# If you do not have System Verilog Assert license
config_compile_simlib -reset
config_compile_simlib -cfgopt {riviera.verilog.xpm:-sv2k12 -na sva}
compile_simlib -help
compile_simlib -force \
    -language all \
    -simulator ${simulator_name} \
    -verbose  \
    -library all \
    -family  kintex7 \
    -no_ip_compile \
    -simulator_exec_path ${simulator_exec_path} \
    -directory ${output_path}
    # -32bit  \
    # -library unisim \
    # -library simprim \
    # -library xpm \
