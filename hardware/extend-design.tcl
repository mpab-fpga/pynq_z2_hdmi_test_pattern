# Create ports
set hdmi_tx_d_p [ create_bd_port -dir O -from 2 -to 0 hdmi_tx_d_p ]
set hdmi_tx_clk_n [ create_bd_port -dir O -type clk hdmi_tx_clk_n ]
set_property -dict [ list \
  CONFIG.FREQ_HZ {100000000} \
  ] $hdmi_tx_clk_n
set hdmi_tx_d_n [ create_bd_port -dir O -from 2 -to 0 hdmi_tx_d_n ]
set hdmi_tx_clk_p [ create_bd_port -dir O -type clk hdmi_tx_clk_p ]
set_property -dict [ list \
  CONFIG.FREQ_HZ {100000000} \
  ] $hdmi_tx_clk_p
set sysclk [ create_bd_port -dir I -type clk -freq_hz 125000000 sysclk ]

# Create instance: top_HDMI_0, and set properties
set block_name top_HDMI_
set block_cell_name top_HDMI_0
if { [catch {set top_HDMI_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
  catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
  return 1
} elseif { $top_HDMI_0 eq "" } {
  catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
  return 1
}

# Create port connections
connect_bd_net -net sysclk_1 [get_bd_ports sysclk] [get_bd_pins top_HDMI_0/sysclk]
connect_bd_net -net top_HDMI_0_hdmi_tx_clk_n [get_bd_pins top_HDMI_0/hdmi_tx_clk_n] [get_bd_ports hdmi_tx_clk_n]
connect_bd_net -net top_HDMI_0_hdmi_tx_clk_p [get_bd_pins top_HDMI_0/hdmi_tx_clk_p] [get_bd_ports hdmi_tx_clk_p]
connect_bd_net -net top_HDMI_0_hdmi_tx_d_n [get_bd_pins top_HDMI_0/hdmi_tx_d_n] [get_bd_ports hdmi_tx_d_n]
connect_bd_net -net top_HDMI_0_hdmi_tx_d_p [get_bd_pins top_HDMI_0/hdmi_tx_d_p] [get_bd_ports hdmi_tx_d_p]
