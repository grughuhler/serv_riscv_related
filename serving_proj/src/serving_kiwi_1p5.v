/* serving_kiwi_1p5.v
 *
 * ISC License
 * Copyright (C) 2025 Grug Huhler
 *
 * Top level for SoC on Kiwi 1P5 board for an example SoC like servant
 * but instead based on serving so that BSRAM is used for both SRAM and
 * RF.
 * 
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

module serving_kiwi_1p5
(
 input wire  i_clk,
 input wire  i_rst,
 input wire  button2,
 output wire uart_tx,
 output wire led1,
 output wire led2
 );

   parameter RESET_STRATEGY = "MINI";
   parameter memfile = "../c_code/prog_prebuilt.hex";
   parameter memsize = 8192;
 
   wire         timer_irq;

   wire [31:0]  o_wb_adr;
   wire [31:0]  o_wb_dat;
   wire [3:0]   o_wb_sel;
   wire         o_wb_we;
   wire         o_wb_stb;
   wire [31:0]  i_wb_rdt;
   wire         i_wb_ack;

   wire         wb_gpio_dat;
   wire         wb_gpio_we;
   wire         wb_gpio_stb;
   wire         wb_gpio_rdt;

   wire [31:0]  wb_timer_dat;
   wire         wb_timer_we;
   wire         wb_timer_stb;
   wire [31:0]  wb_timer_rdt;

   wire         wb_clk;
   wire         wb_rst;

   assign led2 = !button2;
   // GPIO q drives UART unless we are just blinking the LED
   assign uart_tx = (memfile == "blinky8.hex") ? 1'b1 : led1;

   gowin_pll0_clkgen pll0
     (.i_clk(i_clk),
      .i_rst(!i_rst), // active low to active high
      .o_clk(wb_clk),
      .o_rst(wb_rst));

   servant_gpio gpio
     (.i_wb_clk (wb_clk),
      .i_wb_dat (wb_gpio_dat),
      .i_wb_we  (wb_gpio_we),
      .i_wb_cyc (wb_gpio_stb),
      .o_wb_rdt (wb_gpio_rdt),
      .o_gpio   (led1));

   servant_timer
     #(.RESET_STRATEGY (RESET_STRATEGY),
       .WIDTH (32))
   timer
     (.i_clk    (wb_clk),
      .i_rst    (wb_rst),
      .o_irq    (timer_irq),
      .i_wb_cyc (wb_timer_stb),
      .i_wb_we  (wb_timer_we) ,
      .i_wb_dat (wb_timer_dat),
      .o_wb_dat (wb_timer_rdt));

   servant_mux servant_mux
     (
      .i_clk (wb_clk),
      .i_rst (wb_rst & (RESET_STRATEGY != "NONE")),
      .i_wb_cpu_adr (o_wb_adr),
      .i_wb_cpu_dat (o_wb_dat),
      .i_wb_cpu_sel (o_wb_sel),
      .i_wb_cpu_we  (o_wb_we),
      .i_wb_cpu_cyc (o_wb_stb),
      .o_wb_cpu_rdt (i_wb_rdt),
      .o_wb_cpu_ack (i_wb_ack),

      .o_wb_gpio_dat (wb_gpio_dat),
      .o_wb_gpio_we  (wb_gpio_we),
      .o_wb_gpio_cyc (wb_gpio_stb),
      .i_wb_gpio_rdt (wb_gpio_rdt),

      .o_wb_timer_dat (wb_timer_dat),
      .o_wb_timer_we  (wb_timer_we),
      .o_wb_timer_cyc (wb_timer_stb),
      .i_wb_timer_rdt (wb_timer_rdt));

serving
  #(.memfile (memfile),
    .memsize (memsize),
    .RESET_STRATEGY(RESET_STRATEGY))
   cpu
  (
   .i_clk(wb_clk),
   .i_rst(wb_rst),
   .i_timer_irq(timer_irq),
   .o_wb_adr(o_wb_adr),
   .o_wb_dat(o_wb_dat),
   .o_wb_sel(o_wb_sel),
   .o_wb_we(o_wb_we),
   .o_wb_stb(o_wb_stb),
   .i_wb_rdt(i_wb_rdt),
   .i_wb_ack(i_wb_ack));

endmodule
