# Directories common to all architectures.
# Build in order:
#	- critical libraries used by the limbo compiler
#	- the limbo compiler (used to build some subsequent libraries)
#	- the remaining libraries
#	- commands
#	- utilities

EMUDIRS=\
	$INCDIR/lib9\
	$INCDIR/libbio\
	$INCDIR/libmp\
	$INCDIR/libsec\
	$INCDIR/libmath\
	utils/iyacc\
	$INCDIR/limbo\
	$INCDIR/libinterp\
	$INCDIR/libkeyring\
	$INCDIR/libdraw\
	$INCDIR/libprefab\
	$INCDIR/libtk\
	$INCDIR/libfreetype\
	$INCDIR/libmemdraw\
	$INCDIR/libmemlayer\
	$INCDIR/libdynld\
	utils/data2c\
	utils/ndate\
	emu\

KERNEL_DIRS=\
	os\
	os/boot/pc\

# mkconfig is included at this point to allow it to override
#the preceding declarations (particularly KERNEL_DIRS) if need be

<mkconfig

DIRS=\
	$EMUDIRS\
#	appl\

foo:QV:
	echo mk all, clean, install, installall or nuke

all:V:		all-$HOSTMODEL
clean:V:	clean-$HOSTMODEL
install:V:	install-$HOSTMODEL
installall:V:	installall-$HOSTMODEL
emu:V:	        emu/all-$HOSTMODEL
emuinstall:V:	emu/install-$HOSTMODEL
emuclean:V:	emu/clean-$HOSTMODEL
emunuke:V:	emu/nuke-$HOSTMODEL
kernel:V:	kernel/all-$HOSTMODEL
kernelall:V:	kernel/all-$HOSTMODEL
kernelclean:V:	kernel/clean-$HOSTMODEL
kernelinstall:V:        kernel/install-$HOSTMODEL
kernelinstallall:V:     kernel/installall-$HOSTMODEL
kernelnuke:V:   kernel/nuke-$HOSTMODEL
nuke:V:
	rm -f $BINDIR/*
	rm -f $LIBDIR/*.a

&-Posix:QV:
	for j in $DIRS utils tools
	do
		echo "(cd $j; mk $MKFLAGS $stem)"
		(cd $j; mk $MKFLAGS $stem) || exit 1
	done

&-Nt:QV:
	for (j in $DIRS utils tools)
	{
		echo '@{builtin cd' $j '; mk $MKFLAGS $stem}'
		@{builtin cd $j; mk.exe $MKFLAGS $stem }
	}

&-Inferno:QV:
	for (j in $DIRS utils)
	{
		echo '@{builtin cd' $j '; mk $MKFLAGS $stem}'
		@{builtin cd $j; mk $MKFLAGS $stem }
	}

&-Plan9:QV:
	for (j in $DIRS utils)
	{
		echo '@{builtin cd' $j '; mk $MKFLAGS $stem}'
		@{builtin cd $j; mk $MKFLAGS $stem }
	}

emu/&-Posix:QV:
	for j in $EMUDIRS
	do
		echo "(cd $j; mk $MKFLAGS $stem)"
		(cd $j; mk $MKFLAGS $stem) || exit 1
	done

emu/&-Nt:QV:
	for (j in $EMUDIRS)
	{
		echo '@{builtin cd' $j '; mk $MKFLAGS $stem}'
		@{builtin cd $j; mk $MKFLAGS $stem }
	}

emu/&-Plan9:QV:
	for (j in $EMUDIRS)
	{
		echo '@{builtin cd' $j '; mk $MKFLAGS $stem}'
		@{builtin cd $j; mk $MKFLAGS $stem }
	}

kernel/&-Posix:QV:
	for j in $KERNEL_DIRS
	do
		echo "(cd $j; mk $MKFLAGS $stem)"
		(cd $j; mk $MKFLAGS $stem) || exit 1
	done

kernel/&-Nt:QV:
	for (j in $KERNEL_DIRS)
	{
		echo '@{builtin cd' $j '; mk $MKFLAGS $stem}'
		@{builtin cd $j; mk $MKFLAGS $stem }
	}

kernel/&-Inferno:QV:
	for (j in $KERNEL_DIRS)
	{
		echo '@{builtin cd' $j '; mk $MKFLAGS $stem}'
		@{builtin cd $j; mk $MKFLAGS $stem }
	}

kernel/&-Plan9:QV:
	for (j in $KERNEL_DIRS)
	{
		echo '@{builtin cd' $j '; mk $MKFLAGS $stem}'
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
