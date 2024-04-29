###############################################################################
# @file build-vitis.tcl
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

# set the workspace location
setws ./

# ========================================================

platform active $PLATFORM
platform generate

# build application project

app build -name $APP

# build system project
sysproj build -name $SYS

# generate BOOT.bin
set VIT_PROJ_DIR [pwd]
set BIF_DIR $VIT_PROJ_DIR/${SYS}/_ide/bootimage
set BIF_FILEPATH $BIF_DIR/${SYS}.bif

exec bootgen -arch zynq -image $BIF_FILEPATH -w -o $BIF_DIR/BOOT.bin
puts "created $BIF_DIR/BOOT.bin"
