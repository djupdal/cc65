# ---- Display info during parsing phase ----
SILENT:=$(findstring s,$(word 1, $(MAKEFLAGS)))
ifneq ($(SILENT),s)
    $(info Using Makefile: $(realpath $(firstword $(MAKEFILE_LIST))) $(MAKECMDGOALS))
endif


# Run 'make SYS=<target>'; or, set a SYS env.
# var. to build for another target system.
SYS ?= geos-cbm

# Comes with the VICE emulator, see http://vice-emu.sourceforge.net/
C1541 ?= c1541

# If SYS was given on the commandline, redirect "c64" to "geos-cbm" and
# "apple2enh" to "geos-apple"
ifeq ($(origin SYS),command line)
  ifeq ($(SYS),c64)
    override SYS = geos-cbm
    ifneq ($(SILENT),s)
      $(info GEOS: c64 -> geos-cbm)
    endif
  endif
  ifeq ($(SYS),apple2enh)
    override SYS = geos-apple
    ifneq ($(SILENT),s)
      $(info GEOS: apple2enh -> geos-apple)
    endif
  endif
endif

# Just the usual way to find out if we're
# using cmd.exe to execute make rules.
ifneq ($(shell echo),)
  CMD_EXE = 1
endif

ifdef CMD_EXE
  NULLDEV = nul:
  DEL = -del /f
  RMDIR = rmdir /s /q
  CP = copy
else
  NULLDEV = /dev/null
  DEL = $(RM)
  RMDIR = $(RM) -r
  CP = cp
endif

ifdef CC65_HOME
  AS = $(CC65_HOME)/bin/ca65
  CC = $(CC65_HOME)/bin/cc65
  CL = $(CC65_HOME)/bin/cl65
  LD = $(CC65_HOME)/bin/ld65
  SP = $(CC65_HOME)/bin/sp65
else
  AS := $(if $(wildcard ../../bin/ca65*),../../bin/ca65,ca65)
  CC := $(if $(wildcard ../../bin/cc65*),../../bin/cc65,cc65)
  CL := $(if $(wildcard ../../bin/cl65*),../../bin/cl65,cl65)
  LD := $(if $(wildcard ../../bin/ld65*),../../bin/ld65,ld65)
  SP := $(if $(wildcard ../../bin/sp65*),../../bin/sp65,sp65)
endif

ifeq ($(SILENT),s)
    QUIET = 1
endif

ifdef QUIET
    .SILENT:
endif

DIRLIST = grc

define SUBDIR_recipe

@+$(MAKE) SYS=$(SYS) -C $(dir) --no-print-directory $@

endef # SUBDIR_recipe

EXELIST_geos-cbm = \
	bitmap-demo.cvt \
	deskacc-demo.cvt \
	filesel.cvt \
	geosver.cvt \
	getid.cvt \
	hello1.cvt \
	hello2.cvt \
	overlay-demo.cvt \
	vector-demo.cvt \
	yesno.cvt

EXELIST_geos-apple = \
	bitmap-demo.cvt \
	filesel.cvt \
	hello1.cvt \
	hello2.cvt \
	overlay-demo.cvt \
	vector-demo.cvt \
	yesno.cvt

# omitted: dialog.c grphstr.c inittab.c menu.c
# TODO: geosconio.cvt rmvprot.cvt

ifneq ($(EXELIST_$(SYS)),)
samples: $(EXELIST_$(SYS))
	$(foreach dir,$(DIRLIST),$(SUBDIR_recipe))

define samples-geos
$(C1541) -attach $(0).d64 -geoswrite $(1);
endef

samples-geos: $(EXELIST_$(SYS))
ifeq (,$(wildcard ./geos-template.d64))
	$(C1541) -format "$@,01" d64 $@.d64
else
	$(CP) geos-template.d64 $@.d64
endif
	$(foreach tool,$(EXELIST_$(SYS)),$(call samples-geos,$(tool)))
else
samples:
  ifeq ($(MAKELEVEL),0)
	@echo "info: geos samples not available for" $(SYS)
  else
# suppress the "nothing to be done for 'samples' message
	@echo > $(NULLDEV)
  endif
endif

bitmap.c: logo.pcx
	$(SP) -r logo.pcx -c geos-bitmap -w bitmap.c,ident=bitmap

bitmap-demo.cvt: bitmap.c bitmap-demores.grc bitmap-demo.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m bitmap-demo.map bitmap-demores.grc bitmap-demo.c

# A DESK_ACC needs a different linker config to a plain APPLICATION:
#
# - its load address (STARTADDRESS) has to move: the default $0400 is
#   the normal APPLICATION load address, which overlaps memory the
#   resident disk driver lives in. Reusing $0400 works fine for
#   loading/running the accessory itself, but corrupts the driver's own
#   code, which only bites once RstrAppl needs the driver again to read
#   the swap file back. A known-working hand-written geos-cbm DA loads
#   at $1000 instead. Not yet verified what the equivalent is for
#   geos-apple.
#
# - __HIMEM__ (grc65's DESK_ACC header end address, i.e. how much memory
#   GEOS saves to a swap file before loading the accessory over it and
#   restores afterwards) needs to be trimmed to this accessory's own
#   footprint plus stack headroom, instead of the whole application
#   memory space cfg/geos-cbm.cfg's regular __HIMEM__ default uses --
#   see geos-cbm-deskacc.cfg for how that's derived automatically from
#   wherever the linker actually ends up placing this accessory's code,
#   data and bss (__VLIR0_LAST__), in the same link pass, instead of
#   needing a number picked by hand. Only geos-cbm-deskacc.cfg exists so
#   far (see above); geos-apple still uses the regular geos-apple.cfg.
#
# deskacc-crt0.o (see deskacc-crt0.s) is linked explicitly, ahead of the
# target library: it satisfies __STARTUP__/_exit itself, so the linker
# never pulls in the library's own crt0.o. This keeps the zero page save
# a desk accessory needs (see deskacc-crt0.s) out of every other GEOS
# program's build, instead of changing the shared crt0.s/cfg files.
deskacc-crt0.o: deskacc-crt0.s
	$(if $(QUIET),echo $(SYS):$@)
	$(AS) -t $(SYS) -I ../../libsrc/$(SYS) -I ../../libsrc/geos-common -o $@ deskacc-crt0.s

deskacc-demo.cvt: deskacc-crt0.o deskacc-demores.grc deskacc-demo.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m deskacc-demo.map $(if $(filter geos-cbm,$(SYS)),-C geos-cbm-deskacc.cfg) deskacc-crt0.o deskacc-demores.grc deskacc-demo.c

filesel.cvt: fileselres.grc filesel.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m filesel.map fileselres.grc filesel.c

geosconio.cvt: geosconiores.grc geosconio.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m geosconio.map geosconiores.grc geosconio.c

geosver.cvt: geosverres.grc geosver.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m geosver.map geosverres.grc geosver.c

getid.cvt: getidres.grc getid.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m getid.map getidres.grc getid.c

hello1.cvt: hello1res.grc hello1.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m hello1.map hello1res.grc hello1.c

hello2.cvt: hello2res.grc hello2.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m hello2.map hello2res.grc hello2.c

overlay-demo.cvt: overlay-demores.grc overlay-demo.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m overlay-demo.map overlay-demores.grc overlay-demo.c

rmvprot.cvt: rmvprotres.grc rmvprot.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m rmvprot.map rmvprotres.grc rmvprot.c

vector-demo.cvt: vector-demores.grc vector-demo.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m vector-demo.map vector-demores.grc vector-demo.c

yesno.cvt: yesnores.grc yesno.c
	$(if $(QUIET),echo $(SYS):$@)
	$(CL) -t $(SYS) -O -o $@ -m yesno.map yesnores.grc yesno.c


clean:
	@$(DEL) overlay-demores.h 2>$(NULLDEV)
	@$(DEL) bitmap.c 2>$(NULLDEV)
	@$(DEL) deskacc-crt0.o 2>$(NULLDEV)
	@$(DEL) *.cvt 2>$(NULLDEV)
	@$(DEL) *.map 2>$(NULLDEV)
	@$(DEL) samples-geos.d64 2>$(NULLDEV)
	$(foreach dir,$(DIRLIST),$(SUBDIR_recipe))
