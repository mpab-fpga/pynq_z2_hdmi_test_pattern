# PYNQ-Z2 FPGA and firmware project

Built using the Xilinx toolchain/toolsuite.  
Should also be portable to other ZYNQ XC7Z020 compatible boards.

## Purpose

What does it do?  
Demonstrates a simple HDMI application which displays a test pattern over Pynq-Z2 HDMI out

Start by reading the project [documentation](./docs/docs.md)

## Quick Start

Run the following...

```sh
git clone https://github.com/mpab-fpga/pynq_z2_hdmi_test_pattern.git
cd pynq_z2_hdmi_test_pattern
./create
```

- generates the Vivado and Vitis projects.
- generates the bitstream
- generates the BOOT.bin image
