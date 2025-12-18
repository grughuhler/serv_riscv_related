/* Copyright 2025 Grug Huhler.  License SPDX BSD-2-Clause.

   This is a test program for the sering SoC based on the serv core.
   It has veeb tested on the OneKiwi Kiwi 1P5 FPGA development board.
   I expect it to work on other FPGA boards if the Verilog were
   adapted to then.  This would be easy for boards like the Tang Nano
   9K and 20K.

   The test program blinks LED2.  It's just for playing around.  The
   use of the factorial function just makes the serv core work a
   little harder and shows that thew software-based multiplication
   can work.
*/

#include "std_int_types.h"

/* Writing LED sets the LED state */
#define LED *((volatile uint32_t *) 0x40000000)

/* Reading MTIMER reads a 32-bit timer that counts up at the system
 * clock rate.  Writing it sets a timer compare value that controls
 * the assertion of the timer IRQ which only matters if you are using
 * this IRQ which this software is not.
 */
#define MTIMER *((volatile uint32_t *) 0x80000000)

uint32_t fact(uint32_t n)
{
  if (n == 1) {
    return 1;
  } else {
    return n*fact(n - 1);
  }

  return 0;
}

void waste_time(uint32_t n)
{
  volatile uint32_t nn;

  nn = n;
  while (nn-- > 0) {}
}

/* Delay for a specified number of system clock cycles aka
 * MTIMER counts.  Note that calling this function means
 * running quite a few instructions each of which take many
 * 10s of cycles.
 */
void timer_delay(uint32_t delay)
{
  uint32_t start, end;

  start = MTIMER;
  end = start + delay;

  if (start <= end) {
    /* no wrap around */
    while (MTIMER <= end) {};
  } else {
    /* wrapiing */
    while (MTIMER > end) {}
    while (MTIMER <= end) {};
  }
}


int main()
{
  uint32_t v;
  uint32_t i;

  v = 0;
  i = 0;
  LED = v;
  while (1) {
    if (i++ < 8)
      //      waste_time(fact(7));
      timer_delay(fact(10));
    else
      timer_delay(fact(11));
    
    if (i > 14) i = 0;
    v = 1 - v;
    LED = v;
  }
  
  return 0;
}
