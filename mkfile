# Directories common to all architectures.
# Build in order:
#	- critical libraries used by the limbo compiler
#	- the limbo compiler (used to build some subsequent libraries)
#	- the remaining libraries
#	- commands
#	- utilities
<mkconfig

EMUDIRS=\
	include/lib9\
	include/libbio\
	include/libmp\
	include/libsec\
	include/libmath\
	utils/iyacc\
	include/limbo\
	include/libinterp\
	include/libkeyring\
	include/libdraw\
	include/libprefab\
	include/libtk\
	include/libfreetype\
	include/libmemdraw\
	include/libmemlayer\
	include/libdynld\
	utils/data2c\
	utils/ndate\
	arch/emu/$SYSTARG\

KERNEL_DIRS=\
	os\
	os/boot/pc\


DIRS=\
	$EMUDIRS\
#	appl\

foo:QV:
	echo mk all, clean, install, installall or nuke

all:V:                  all-$HOSTMODEL
clean:V:                clean-$HOSTMODEL
install:V:              install-$HOSTMODEL
installall:V:           installall-$HOSTMODEL
emu:V:                  $ROOT/arch/all-$HOSTMODEL
emuinstall:V:           $ROOT/arch/install-$HOSTMODEL
emuclean:V:             $ROOT/arch/clean-$HOSTMODEL
kernel:V:               kernel/all-$HOSTMODEL
kernelclean:V:          kernel/clean-$HOSTMODEL
kernelinstall:V:        kernel/install-$HOSTMODEL

&-Posix:V:
	for j in $DIRS utils tools; do
		(cd $j; mk $MKFLAGS $stem) || exit 1
	done
&-Nt:V:
	for (j in $DIRS utils tools) {
		@{builtin cd $j; mk.exe $MKFLAGS $stem }
	}
&-Plan9 &-Inferno:V:
	for (j in $DIRS utils) {
		@{builtin cd $j; mk $MKFLAGS $stem }
	}

emu/&-Posix:V:
	for j in $EMUDIRS; do
		(cd $j; mk $MKFLAGS $stem) || exit 1
	done
emu/&-Nt:V:
	for (j in $EMUDIRS) {
		@{builtin cd $j; mk $MKFLAGS $stem }
	}
emu/&-Plan9:V:
	for (j in $EMUDIRS) {
		@{builtin cd $j; mk $MKFLAGS $stem }
	}

kernel/&-Posix:V:
	for j in $KERNEL_DIRS; do
		(cd $j; mk $MKFLAGS $stem) || exit 1
	done
kernel/&-Nt:V:
	for (j in $KERNEL_DIRS) {
		@{builtin cd $j; mk $MKFLAGS $stem }
	}
kernel/&-Inferno:V:
	for (j in $KERNEL_DIRS) {
		@{builtin cd $j; mk $MKFLAGS $stem }
	}
kernel/&-Plan9:V:
	for (j in $KERNEL_DIRS) {
		@{builtin cd $j; mk $MKFLAGS $stem }
	}

mkdirs:V:	mkdirs-$SHELLTYPE
mkdirs-rc:V:
	mkdir -p `{cat lib/emptydirs}
	chmod 555 mnt/* n/client/* n/*
mkdirs-sh:V:
	mkdir -p `cat lib/emptydirs`
	chmod 555 mnt/* n/client/* n/*
mkdirs-nt:V:
	mkdir -p `{cmd /c type lib\emptydirs}
