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
	arch/native\
	arch/native/boot/pc\


DIRS=\
	$EMUDIRS\
#	appl\

foo:QV:
	echo mk all, clean, install

all:V:                  all-$HOSTMODEL
clean:V:                clean-$HOSTMODEL
install:V:              install-$HOSTMODEL
emu:V:                  $ROOT/arch/emu/all-$HOSTMODEL
emuinstall:V:           $ROOT/arch/emu/install-$HOSTMODEL
emuclean:V:             $ROOT/arch/emu/clean-$HOSTMODEL
kernel:V:               kernel/all-$HOSTMODEL
kernelclean:V:          kernel/clean-$HOSTMODEL
kernelinstall:V:        kernel/install-$HOSTMODEL

&-Posix:QV:
	for j in $DIRS utils tools; do
                echo "(cd $j; mk $MKFLAGS $stem)"
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

emptydirs = \
    keydb/countersigned\
    keydb/signed\
    mail\
    mnt\
    mnt/9win\
    mnt/acme\
    mnt/arch\
    mnt/diary\
    mnt/factotum\
    mnt/gossip\
    mnt/icontact\
    mnt/ilog\
    mnt/incall\
    mnt/isubs\
    mnt/itrack\
    mnt/keys\
    mnt/keysrv\
    mnt/quiz\
    mnt/registry\
    mnt/rstyxreg\
    mnt/schedule\
    mnt/vmail\
    mnt/wm\
    mnt/wrap\
    mnt/wsys\
    n\
    n/cd\
    n/client\
    n/client/chan\
    n/client/dev\
    n/disk\
    n/dist\
    n/dump\
    n/ftp\
    n/gridfs\
    n/kfs\
    n/local\
    n/rdbg\
    n/registry\
    n/remote\
    opt\
    services/logs\
    services/ppp\
    src\
    tmp\
    usr/inferno/charon\
    usr/inferno/keyring\
    usr/inferno/tmp\

mkdirs:V:
	mkdir -p $emptydirs $OBJDIR/bin $OBJDIR/lib
	chmod 555 mnt/* n/client/* n/*
