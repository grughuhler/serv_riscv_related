/*
 * servant_tang_20k.v: servant toplevel for tang nano 20k board.
 *
 * SPDX-FileCopyrightText: 2025 Grug Huhler
 * SPDX-License-Identifier: ISC
 * This file is a simple adaptation of other servant top level
 * files.
 */

`default_nettype none
module servant_tang_20k_top
  (input wire  i_clk, /* 27 MHz */
   input wire  i_rst, /* high when pressed on the 20k */
   output wire o_uart_tx,
   output wire q);

   // serv pre-built software tested:
   //  zephyr_hello.hex: Zephyr RTOS hello world.  Needs 8192 bytes SRAM
   //  zephyr_phil.hex: Dining philosphers works with 32768 bytes of SRAM
   //  zephyr_hello_mt: works with 16384 bytes of SRAM
   //  zephyr_sync: works with 16384 bytes of SRAM
   //  blinky.hex: Very slowly blinks LED.  Works with 128 bytes
   //  hello_uart.hex: Hello without RTOS.  Works with 128 bytes
   parameter memfile = "../sw/zephyr_hello.hex";
   parameter memsize = 65536;

   wire      wb_clk;
   wire      wb_rst;

   assign o_uart_tx = q;
  
   gowin_rpll_clkgen pll0
     (.i_clk(i_clk),
      .i_rst(i_rst),
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
