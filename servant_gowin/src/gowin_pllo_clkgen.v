/*
 * gowin_rpll_clkgen.V: clock gen using gowin pll0
 *
 * SPDX-FileCopyrightText: 2025 Grug Huhler
 * SPDX-License-Identifier: ISC
 * This file is a simple adaptation of other servant clk gen
 * files.
 */

module gowin_pll0_clkgen
  (input wire  i_clk,
   input wire  i_rst,  // active high
   output wire o_clk,
   output reg  o_rst); // active high
   
   wire locked;
   reg  locked_r;

   // 27 MHz in to 32.4 MHz out
   Gowin_PLLO pll0
     (.lock(locked), // active high
      .clkouta(o_clk),
      .clkin(i_clk),
      .reset(i_rst));

   always @(posedge o_clk) begin
      locked_r <= locked;
      o_rst  <= !locked_r;
   end

endmodule
