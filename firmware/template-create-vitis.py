#!/usr/bin/env python3

###############################################################################
# @file create-vitis.py
# Author: mpab
# Copyright (c) 2024-, mpab
# All rights reserved.
###############################################################################

# generates assets in the Vitis workspace (firmware) directory
# expects to be run in ./firmware/vitis

import vitis
import os
import shutil
import platform as os_platform

def main():
    PROJECT_NAME="hdmi_overlay"
    BOARD="pynq_z2"
    CPU="ps7_cortexa9_0"
    
    PLATFORM=f'{BOARD}_pfm'
    APP=f'{PROJECT_NAME}_app'
    SYS=f'{APP}_system'
    XILFFS_VER=@@XILFFS_VERSION@@

    print (f'Project: {PROJECT_NAME}, Board: {BOARD}, Platform: {PLATFORM}, CPU: {CPU}')

    client = vitis.create_client()
    client.info()

    client.set_workspace(path='./')

    # Create platform
    script_dir = os.path.dirname(os.path.abspath(__file__))
    xsa_path = os.path.join(script_dir, '../../app/hardware/vivado/design_1_wrapper.xsa')
    platform = client.create_platform_component(
        name = PLATFORM,
        hw = xsa_path,
        cpu = CPU,
        os = "standalone",
        domain_name = "standalone_domain")
    platform.report()
    platform.build()

    print ('exiting...')


if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print("main() exception: ", e)

    #Close the client and terminate the server
    try:
        vitis.dispose()
    except Exception as e:
        print("vitis.dispose() exception: ", e)
