//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.12 (64-bit)
//Part Number: GW1N-UV1P5QN48XFC7/I6
//Device: GW1N-1P5
//Device Version: C
//Created Time: Mon Dec 15 13:27:11 2025

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Gowin_PLLO your_instance_name(
        .lock(lock), //output lock
        .clkouta(clkouta), //output clkouta
        .clkin(clkin), //input clkin
        .reset(reset) //input reset
    );

//--------Copy end-------------------
