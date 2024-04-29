set fpga_part "xc7z020clg400-1"
set bitstream_filepath [file normalize "./vivado.runs/impl_1/design_1_wrapper.bit"]

# set reference directories for source files
set src_dir [file normalize "../src"]
set lib_dir [file normalize "../lib"]

# read design sources
read_verilog -sv [file normalize "${src_dir}/./HDMI_encoder.sv"]
read_verilog -sv [file normalize "${src_dir}/./TMDS_encoder.sv"]
read_verilog -sv [file normalize "${src_dir}/./top_HDMI.sv"]
read_verilog -sv [file normalize "${src_dir}/./top_HDMI_.v"]
read_verilog -sv [file normalize "${src_dir}/./VIDEO_frame_gen.sv"]
read_verilog -sv [file normalize "${src_dir}/./VIDEO_sig_gen.sv"]
read_verilog -sv [file normalize "${src_dir}/./VIDEO_source.sv"]
read_verilog -sv [file normalize "${src_dir}/./VIDEO_sync.sv"]

# read memory files

# read constraints
read_xdc [file normalize "../constraints/constraints.xdc"]

# synth
synth_design -top "top_HDMI" -part ${fpga_part}

# place and route
opt_design
place_design
route_design

# write bitstream, using vivado-style path
write_bitstream -force $bitstream_filepath
