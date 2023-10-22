open_project vivado

# this is a little janky as it relies on knowing the filepath of the design file
#open_bd_design {design_1.bd}
set bd_filepath "./vivado.srcs/sources_1/bd/design_1/design_1.bd"
open_bd_design $bd_filepath

# Create ports
set hdmi_tx_d_n [ create_bd_port -dir O -from 2 -to 0 hdmi_tx_d_n ]
set hdmi_tx_clk_n [ create_bd_port -dir O -type clk hdmi_tx_clk_n ]
set hdmi_tx_d_p [ create_bd_port -dir O -from 2 -to 0 hdmi_tx_d_p ]
set hdmi_tx_clk_p [ create_bd_port -dir O -type clk hdmi_tx_clk_p ]
set sysclk [ create_bd_port -dir I -type clk sysclk ]

# Create instance: HDMI_generator_0, and set properties
set block_name HDMI_generator
set block_cell_name HDMI_generator_0
if { [catch {set HDMI_generator_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
    catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
    return 1
} elseif { $HDMI_generator_0 eq "" } {
    catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
    return 1
}

# Create instance: HDMI_frame_0, and set properties
set block_name HDMI_frame
set block_cell_name HDMI_frame_0
if { [catch {set HDMI_frame_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
    catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
    return 1
} elseif { $HDMI_frame_0 eq "" } {
    catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
    return 1
}

# Create port connections
connect_bd_net -net HDMI_frame_0_blue [get_bd_pins HDMI_frame_0/blue] [get_bd_pins HDMI_generator_0/blue]
connect_bd_net -net HDMI_frame_0_green [get_bd_pins HDMI_frame_0/green] [get_bd_pins HDMI_generator_0/green]
connect_bd_net -net HDMI_frame_0_red [get_bd_pins HDMI_frame_0/red] [get_bd_pins HDMI_generator_0/red]
connect_bd_net -net HDMI_generator_0_CounterX [get_bd_pins HDMI_generator_0/CounterX] [get_bd_pins HDMI_frame_0/CounterX]
connect_bd_net -net HDMI_generator_0_CounterY [get_bd_pins HDMI_generator_0/CounterY] [get_bd_pins HDMI_frame_0/CounterY]
connect_bd_net -net HDMI_generator_0_TMDSn [get_bd_pins HDMI_generator_0/TMDSn] [get_bd_ports hdmi_tx_d_n]
connect_bd_net -net HDMI_generator_0_TMDSn_clock [get_bd_pins HDMI_generator_0/TMDSn_clock] [get_bd_ports hdmi_tx_clk_n]
connect_bd_net -net HDMI_generator_0_TMDSp [get_bd_pins HDMI_generator_0/TMDSp] [get_bd_ports hdmi_tx_d_p]
connect_bd_net -net HDMI_generator_0_TMDSp_clock [get_bd_pins HDMI_generator_0/TMDSp_clock] [get_bd_ports hdmi_tx_clk_p]
connect_bd_net -net HDMI_generator_0_pixclk [get_bd_pins HDMI_generator_0/pixclk] [get_bd_pins HDMI_frame_0/pixclk]
connect_bd_net -net sysclk_1 [get_bd_ports sysclk] [get_bd_pins HDMI_generator_0/clk]

validate_bd_design
save_bd_design

generate_target all [get_files  $bd_filepath]

#export_simulation -of_objects [get_files D:/Xilinx/projects/template_test/hardware/vivado/vivado.srcs/sources_1/bd/design_1/design_1.bd] -directory D:/Xilinx/projects/template_test/hardware/vivado/vivado.ip_user_files/sim_scripts -ip_user_files_dir D:/Xilinx/projects/template_test/hardware/vivado/vivado.ip_user_files -ipstatic_source_dir D:/Xilinx/projects/template_test/hardware/vivado/vivado.ip_user_files/ipstatic -lib_map_path [list {modelsim=D:/Xilinx/projects/template_test/hardware/vivado/vivado.cache/compile_simlib/modelsim} {questa=D:/Xilinx/projects/template_test/hardware/vivado/vivado.cache/compile_simlib/questa} {riviera=D:/Xilinx/projects/template_test/hardware/vivado/vivado.cache/compile_simlib/riviera} {activehdl=D:/Xilinx/projects/template_test/hardware/vivado/vivado.cache/compile_simlib/activehdl}] -use_ip_compiled_libs -force -quiet
