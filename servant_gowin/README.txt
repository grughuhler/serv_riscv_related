      SERV RISC-V core on three Gowin FPGA development boards

SERV is an open source 32-bit RISC-V soft core that is created with
the goal of being very small, trading small size for performance in
the sense of instructions per clock.  The SERV project includes a very
simple example SoC called servant that adds a single signal GPIO
controller and a timer to the SERV core.  Supplied software examples
can blink an LED or print "hello world" using a software bit-banged
UART (settings 115200, 8-1-none).

This folder contains top level Verilog files that adapt servant to
three boards that contain Gowin FPGAs:

1. OneKiwi Kiwi-1P5
2. Tang Nano 9K
3. Tang Nano 20K

There is a separate project file for each of these boards.

The intent is to build and load the projects using the Gowin IDE
rather than FuseSoC (SERV's normal build system).  Just open the
project for your FPGA board and use the Gowin IDE normally.

You must use a recent version of the Gowin tools to have support for
the kiwi 1P5.  Tested versions:

  V1.9.12 Pro (Windows)
  V1.9.11.03 Educational (Ubuntu 24.04.3)

Directory src/serv contains many (but not all) files from commit
61ef8eaef9f795e2e5425f620e96c6f732a5609b of Olaf Kindren's serv git
repo (https://github.com/olofk/serv.git).  None of these files are
modified.  See this git repo for lots of information on the serv core
and example SoCs.  SERV is a very interesting project.

The default example runs the Zephyr RTOS and prints hello using the
software bit-banged UART.  Just connect the board's USB serial to the
terminal emulator of your choice and select speed 115200.  Button 1
(of 2) on each board is a reset.

See also YouTube videos:

Getting started with Kiwi 1P5 FPGA Board: https://youtu.be/d1sUu9FITxE

Video about SERV on Gowin:

Using Linux

The Gowin tools work with less trouble on Windows.  Here are some notes
on Ubuntu 24.04.5.  Your experience many vary.

Copy system libfontconfig to ./lib or was that libfreetype...

Use this script to run the IDE.

   #!/bin/bash
   # Copy system libfontconfig to ./lib
   export LD_LIBRARY_PATH=$PWD/lib
   export QT_XCB_GL_INTEGRATION=none
   ./bin/gw_ide

It might be necessary to
  sudo apt install linux-image-generic
but try without.

sudo apt install openfpgaloader

But might be best to build the lastest from source.

Create /etc/udev/rules.d/98-ftdi_9k.rules containing the line:
ACTION=="add", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", RUN+="/sbin/modprobe ftdi_sio"

