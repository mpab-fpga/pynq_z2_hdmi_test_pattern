###############################################################################
# @file create-vitis.tcl
# Author: mpab
# Copyright (c) 2023-, mpab
# All rights reserved.
###############################################################################

# generates assets in the Vitis workspace (firmware) directory
# must be run in ./firmware/

set PROJECT_NAME hdmi_overlay
set BOARD "pynq_z2"

set PLATFORM ${BOARD}_pfm
set APP ${PROJECT_NAME}_app
set SYS ${APP}_system
set XILFFS_VER @@XILFFS_VERSION@@

# set the workspace location
setws ./

# ========================================================
# create platform project
puts "creating platform $PLATFORM"

set xsa_filepath [file normalize [file join [pwd] ../../hardware/vivado/design_1_wrapper.xsa]]
platform create -name $PLATFORM\
    -hw ${xsa_filepath}\
    -proc {ps7_cortexa9_0} -os {standalone} -out {./}

platform write
#platform generate -domains
::scw::regenerate_psinit $xsa_filepath
#::scw::get_mss_path
#platform active $PLATFORM
bsp reload
bsp setlib -name xilffs -ver $XILFFS_VER
bsp write
bsp reload
catch {bsp regenerate}
platform generate
# ========================================================

# ========================================================
# create application project
puts "creating application $APP, system $SYS, board $BOARD"

# Open the platform
platform read ${PLATFORM}/platform.spr

platform generate

# create C application
# app create -name $APP -platform $PLATFORM -template {Empty Application(C)} -domain standalone_domain -lang c
puts "app create -name $APP -platform $PLATFORM -template {Hello World} -domain standalone_domain -lang c"
app create -name $APP -platform $PLATFORM -template {Hello World} -domain standalone_domain -lang c

# BUG: fails if no sources
# import any sources
#importsources -name $APP -path ../src/

# build application project
app build -name $APP

# build system project
sysproj build -name $SYS

# ========================================================
# ensure all projects are added to the workspace
importprojects ./

# rebuild platform to fix 'out of date' warning
platform active $PLATFORM
platform generate

# ========================================================
# fix $PROJ_app_system.bif -> BOOT.bin issue

# template
# "//arch = zynq; split = false; format = BIN
# the_ROM_image:
# {
#     [bootloader]$VIV_PROJ_DIR/pynq_z2_pfm/export/pynq_z2_pfm/sw/pynq_z2_pfm/boot/fsbl.elf
#     ${PROJECT_ROOT}/hardware/vivado/vivado.runs/impl_1/design_1_wrapper.bit
#     $VIV_PROJ_DIR/hdmi_overlay_app/Debug/$APP.elf
# }"

set VIT_PROJ_DIR [pwd]
set PROJECT_ROOT [file dirname [file dirname $VIT_PROJ_DIR]]

# puts "Vitis project: $VIT_PROJ_DIR"
# puts "Project root: $PROJECT_ROOT"

set BOOTLOADER "    \[bootloader\]${VIT_PROJ_DIR}/pynq_z2_pfm/export/pynq_z2_pfm/sw/pynq_z2_pfm/boot/fsbl.elf"
set BITSTREAM "    ${PROJECT_ROOT}/hardware/vivado/vivado.runs/impl_1/design_1_wrapper.bit"
set ELF "    ${VIT_PROJ_DIR}/hdmi_overlay_app/Debug/${APP}.elf"

set BIF_DIR $VIT_PROJ_DIR/${SYS}/_ide/bootimage
set BIF_FILEPATH $BIF_DIR/${SYS}.bif

file mkdir $BIF_DIR
set FH [open "$BIF_FILEPATH" w]

puts $FH "//arch = zynq; split = false; format = BIN"
puts $FH "the_ROM_image:"
puts $FH "{"
puts $FH $BOOTLOADER
puts $FH $BITSTREAM
puts $FH $ELF
puts $FH "}"
close $FH
puts "created $BIF_FILEPATH"

exec bootgen -arch zynq -image $BIF_FILEPATH -w -o $BIF_DIR/BOOT.bin
puts "created $BIF_DIR/BOOT.bin"
