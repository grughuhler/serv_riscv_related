/*
 * servant_kiwi_1p5.v : servant toplevel for Kiwi-1P5 board.
 *
 * SPDX-FileCopyrightText: 2025 Grug Huhler
 * SPDX-License-Identifier: ISC
 * This file is a simple adaptation of other servant top level
 * files.
 */

`default_nettype none
module servant_kiwi_1p5_top
  (input wire  i_clk, // 27 MHz
   input wire  i_rst, // low when pressed on the 1p5
   output wire o_uart_tx,
   output wire q,     // LED1 on board
   output wire led2); // opposite of q

   // serv pre-built software tested:
   //  zephyr_hello.hex: Zephyr RTOS hello world.  Needs 8192 bytes SRAM
   //  blinky.hex: Very slowly blinks LED.  Works with 128 bytes
   //  hello_uart.hex: Hello without RTOS.  Works with 128 bytes
   parameter memfile = "../sw/zephyr_hello.hex";
   parameter memsize = 8192;

   wire wb_clk;
   wire wb_rst;

   // LED2 glows faintly unless driven
   assign led2 = !q;

   // GPIO q drives UART unless we are just blinking the LED
   assign o_uart_tx = (memfile == "../sw/blinky.hex") ? 1'b1 : q;
  
   gowin_pll0_clkgen pll0
     (.i_clk(i_clk),
      .i_rst(!i_rst), // active low to active high
      .o_clk(wb_clk),
      .o_rst(wb_rst));
  
   servant
     #(.memfile (memfile),
       .memsize (memsize))
   servant
     (.wb_clk (wb_clk),
      .wb_rst (wb_rst),
      .q      (q));

endmodule
