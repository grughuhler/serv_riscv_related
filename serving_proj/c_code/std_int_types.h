/* Copyright 2024 Grug Huhler.  License SPDX BSD-2-Clause.
 *
 * Yes, this is sketchy.  riscv64-unknown-elf-gcc is considered HOSTED
 * I think and thus not best for bare-metal.  So, avoid all standard
 * includes.
 */


#ifndef _STD_INT_TYPES_H
#define _STD_INT_TYPES_H

typedef char int8_t;
typedef short int16_t;
typedef int int32_t;
typedef long int int64_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long uint32_t;
typedef unsigned long long uint64_t;

#endif

