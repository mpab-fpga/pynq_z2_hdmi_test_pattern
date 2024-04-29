set bitstream_filepath [file normalize "./vivado.runs/impl_1/design_1_wrapper.bit"]

open_hw_manager
connect_hw_server
current_hw_target
open_hw_target
set_property PROGRAM.FILE "$bitstream_filepath" [current_hw_device]
program_hw_devices [current_hw_device]
