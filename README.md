# PYNQ-Z2 FPGA and firmware project

Built using the Xilinx toolchain/toolsuite.  
Should also be portable to other ZYNQ XC7Z020 compatible boards.

## Purpose

What does it do?  
Demonstrates a simple HDMI application which displays a test pattern over Pynq-Z2 HDMI out

<img src="./docs/test_pattern.png" width="1024" />

Start by reading the project [documentation](./docs/docs.md)

## Quick Start

```sh
git clone https://github.com/mpab-fpga/pynq_z2_hdmi_test_pattern.git
cd pynq_z2_hdmi_test_pattern
```

### Post checkout - Run the simulation

```sh
cd $PROJECT
cd verilator
./run
```

### Post checkout - Generate the fpga and firmware project files

- Windows Git Bash: open a shell prompt in the project root
- Linux: open a shell prompt in the project root

```sh
cd $PROJECT
cd hardware
./create
./build
cd ../firmware
./create
./build
```

- generates the Vivado and Vitis projects.
- generates the bitstream
- generates the BOOT.bin image
