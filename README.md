![bechamel_logo_Plan de travail 1](https://github.com/user-attachments/assets/a3b16d4a-b1e6-4357-a8fe-4a8e616bc0d5)

# Lo-Fi FPGA Video Art Board

A Lattice iCE40HX1K-based FPGA developement board for lo-fi, live-playable video experiments ranging from the gnarly-glitch-filth to the understated minimalist compositional.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

![image](https://github.com/user-attachments/assets/bf17c343-4a2a-4723-ada7-5bc602cbb8f3) 


|                          |                          |
:-------------------------:|:-------------------------:
![image](https://github.com/user-attachments/assets/ec43d231-f804-41db-ba54-e15a378fc0b0)  | ![IMG_3808-1024x683](https://github.com/user-attachments/assets/49c9bb74-0dcc-44ab-9191-4f8257c90dd5)



# Features :

**WARNING: This video may potentially trigger seizures for people with photosensitive epilepsy. Viewer discretion is advised.**



- 640x480 60Hz HDMI and VGA out, takes raspberry pi video in in DPI mode (https://pinout.xyz/pinout/dpi)
- 9-key mechanical button interface on a hand-solderable, low-cost, single-board design
- 100MHz clock and a 256K x 8 bit external SRAM for screen buffer(s)
- Connections for raspberry pi flash programming


# PCB files

[KiCAD and Eagle PCBs](https://github.com/preparedinstruments/bechamel/tree/main/PCB)

![forgithub](https://github.com/user-attachments/assets/98a38d7d-9e5c-442e-bc27-7d2fbf7a9336)


# BOM :

[Excel BOM Mouser / Digikey ](https://github.com/preparedinstruments/bechamel/tree/main/BOM)

- 9x Mechanical keyboard keys
- 1x FPGA iCE40HX1K-TQ144
- 1x 100MHz clock oscillator
- 1x SRAM 2Mb 256Kx8
- 1x Flash N25Q032A13ESC40F
- 1x USB-C SMD 6 pin connector
- 1x 3.3V reg TLV73333PDBVT 
- 1x 1.2V reg TLV73312PDBVT
- 1x PFET
- 1x Resettable Fuse
- 1x D-SUB 15 connector
- 1x HDMI Connector 
- 50x 0.1µF capacitor 0805
- 50x  10kΩ, 1.8kΩ, 1kΩ, 470Ω, 270Ω, 120Ω resistors 0805
- 5x LEDs 0805
- 2x Dual-row headers

optional extras : (1x Raspberry Pi Zero, 1x Micro SD holder, 1x 10kΩ potentiometers)


# HDL files

[Verilog and Pin constraints files ](https://github.com/preparedinstruments/bechamel/tree/main/verilog)

To synthesize files :

[Yoysis Open-source Toolchain ](https://github.com/YosysHQ/yosys)

![image](https://github.com/user-attachments/assets/e97e0af4-468f-498d-b59e-337a35ea7318)

...or, request an iCEcube2 licence from Lattice :

[iCEcube2 Toolchain](https://www.latticesemi.com/iCEcube2)

To program flash memory you can use raspberry pi using these OLIMEX resources :

- https://www.olimex.com/wiki/ICE40HX1K-EVB#Get_started_under_Linux
- https://github.com/anse1/olimex-ice40-notes

The programming connections :

![image](https://github.com/user-attachments/assets/a652223b-fee8-409c-83ea-dc7b884e64b7)


# Raspberry Pi DPI config file

This config file sets the rpi in DPI mode at 50MHz. It can work with the rpi video pass thru verilog file.

[config.txt](https://github.com/preparedinstruments/bechamel/tree/main/raspberry_pi)

# Acknowledgements


**Verilog** :

Mike Field <hamster@snap.net.nz> for his minimalDVID_encoder.vhd : A quick and dirty DVI-D implementation (https://gist.github.com/uXeBoy/0d46e2f1560f73dd573d83e78309bfa0)

Iñigo Muguruza (imuguruza) for his VGA sync code : https://github.com/imuguruza/alhambra_II_test/blob/master/vga/vga_test/vga_sync.v

NightMachines on Bytebeats : https://llllllll.co/t/bytebeats-a-beginner-s-guide/16491

General verilog learning from HDL Bits : https://hdlbits.01xz.net/wiki/Main_Page

**FPGA Hardware design** :

OLIMEX FPGA dev board : https://github.com/OLIMEX/iCE40HX1K-EVB/tree/master

Alhambra II FPGA dev board : https://github.com/FPGAwars/Alhambra-II-FPGA/tree/master


# TODO

Get SD card reading functional
