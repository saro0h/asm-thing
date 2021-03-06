# PATH := $(DEVKITARM)/bin:$(PATH)

# --- Project details -------------------------------------------------

PROJ    := projet
TITLE   := $(PROJ)
TARGET  := $(PROJ).mb

OBJS    := main.o armgba.o panorama.o ufo.o start.o over.o victoire.o
ASMOBJS := asm.o asmarmgba.o

# --- Build defines ---------------------------------------------------

CROSS   := arm-eabi-
CC      := $(CROSS)gcc
LD      := $(CROSS)gcc
OBJCOPY := $(CROSS)objcopy

ARCH    := -mthumb-interwork -mthumb
SPECS   := -specs=gba_mb.specs

CFLAGS  := $(ARCH) -g -O2 -Wall -fno-strict-aliasing
LDFLAGS := $(ARCH) -g $(SPECS)


.PHONY : build clean

# --- Build -----------------------------------------------------------
# Build process starts here!
build: $(TARGET).gba

$(TARGET).gba : $(TARGET).elf
	$(OBJCOPY) -v -O binary $< $@
	-@gbafix $@ -t$(TITLE)

$(TARGET).elf : $(OBJS) $(ASMOBJS)
	$(LD) $^ $(LDFLAGS) -o $@

$(OBJS) : %.o : %.c
	$(CC) -c $< $(CFLAGS) -o $@
	
$(ASMOBJS) : %.o : %.s
	$(CC) -c $< $(CFLAGS) -o $@
		
# --- Clean -----------------------------------------------------------

clean : 
	@rm -fv *.gba
	@rm -fv *.elf
	@rm -fv *.o
