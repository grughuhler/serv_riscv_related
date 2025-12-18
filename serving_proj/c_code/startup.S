/* Copyright 2024 Grug Huhler.  License SPDX BSD-2-Clause.
   This is a VERY incomplete startup sequence for C.  It fails to
   do many things such as clear bss.
*/

.text
.global _start

_start:
	/* no more than 16 bytes here */
	j cont_start

cont_start:
        /* stack pointer aka x2 */
	li sp, SRAM_BYTES /* SRAM_BYTES set in Makefile */
	call main
stuck:	j stuck

