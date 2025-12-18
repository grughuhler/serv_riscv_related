# Set SRAM_BYTES to 144 bytes less than the memory size set in
# ../src/serving_kiwi_1p5.v.  This accounts for the register file
# being at the top of SRAM and consisting of 36 (32 + 4) 32-bit
#registers

SRAM_BYTES = 8048

PREFIX=riscv64-unknown-elf
CC = $(PREFIX)-gcc
OBJCOPY = $(PREFIX)-objcopy
OBJDUMP = $(PREFIX)-objdump
AS = $(PREFIX)-as

GCCVERSION = $(shell $(PREFIX)-gcc -dumpversion)

COMMONFLAGS = -march=rv32i -mabi=ilp32
CFLAGS = -mno-save-restore $(COMMONFLAGS) -nostartfiles -nostdlib -static -O1
CPPFLAGS = 
ASFLAGS =  $(COMMONFLAGS)

ifeq ($(GCCVERSION), 10.2.0)
# This is a hack for Ubuntu 22.04 whose riscv gcc appears to have
# problems that are resolved in laer gcc version.
LIBS = /usr/lib/gcc/riscv64-unknown-elf/10.2.0/rv32i/ilp32/libgcc.a
else
LIBS = -lgcc
endif

COMMON_CSRCS = main.c

ALL_CSRCS = $(COMMON_CSRCS)

%.o: %.c
	$(CC) -c $(CFLAGS) -DCLK_FREQ=$(CLK_FREQ) $< -o $@

%.d: %.c
	$(CC) -MM $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

all: prog.hex

startup.o: startup.S
	$(CC) $(CFLAGS) -c -DSRAM_BYTES=$(SRAM_BYTES) startup.S

prog.elf: startup.o $(COMMON_CSRCS:.c=.o)
	$(CC) $(CFLAGS) -Tlink_cmd.ld -o prog.elf startup.o \
              $(COMMON_CSRCS:.c=.o) $(NANO9K_CSRCS:.c=.o) $(LIBS)

prog.bin: prog.elf
	$(OBJCOPY) prog.elf -O binary prog.bin

prog.hex: prog.bin
	python3 makehex1.py $< > $@

clean:
	rm -f prog.elf prog.hex prog.bin  \
	      startup.o $(ALL_CSRCS:.c=.d) $(ALL_CSRCS:.c=.o)
