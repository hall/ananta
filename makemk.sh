#!/bin/sh

# this file is used only to bootstrap mk onto a platform
# that currently lacks a binary for mk. after that, mk can
# look after itself.

# grab settings from mkconfig
. ./mkconfig

SYSTYPE=posix

# you might need to adjust the CC, LD, AR, and RANLIB definitions after this point
CC="p gcc -m32 -c -I$OBJDIR/include -I$ROOT/utils/include"
LD="p gcc -m32"
AR="p ar crvs"
RANLIB=":"	# some systems still require `ranlib'

error() {
	echo $* >&2
	exit 1
}

ofiles() {
	echo $* | sed 's/\.c/.o/g'
}

p() {
	echo $*
	"$@"
}

# make sure we start off clean
echo removing old libraries and binaries
rm -f $OBJDIR/lib/*.a $OBJDIR/bin/*
rm -f utils/cc/y.tab.?

# ensure the output directories exist
mkdir -p $OBJDIR/lib $OBJDIR/bin

# libregexp
cd $ROOT/utils/libregexp || error cannot find libregexp directory
CFILES="regaux.c regcomp.c regerror.c regexec.c regsub.c rregexec.c rregsub.c"
$CC $CFILES || error libregexp compilation failed
$AR $OBJDIR/lib/libregexp.a `ofiles $CFILES` || error libregexp ar failed
$RANLIB $OBJDIR/lib/libregexp.a || error libregexp ranlib failed

# libbio
cd $OBJDIR/include/libbio || error cannot find libbio directory
$CC *.c || error libbio compilation failed
$AR $OBJDIR/lib/libbio.a *.o || error libbio ar failed
$RANLIB $OBJDIR/lib/libbio.a || error libbio ranlib failed

# lib9
cd $OBJDIR/include/lib9 || error cannot find lib9 directory
CFILES="dirstat-$SYSTYPE.c rerrstr.c errstr-$SYSTYPE.c getuser-$SYSTYPE.c"	# system specific
CFILES="$CFILES charstod.c cleanname.c create.c dirwstat.c *print*.c *fmt*.c exits.c getfields.c  pow10.c print.c qsort.c rune.c runestrlen.c seek.c strdup.c strtoll.c utflen.c utfrrune.c utfrune.c utf*.c *str*cpy*.c"
$CC $CFILES || error lib9 compilation failed
$AR $OBJDIR/lib/lib9.a `ofiles $CFILES` || error lib9 ar failed
$RANLIB $OBJDIR/lib/lib9.a || error lib9 ranlib failed

# mk itself
cd $ROOT/utils/mk
CFILES="Posix.c sh.c"	# system specific
CFILES="$CFILES arc.c archive.c bufblock.c env.c file.c graph.c job.c lex.c main.c match.c mk.c parse.c recipe.c rule.c run.c shprint.c symtab.c var.c varsub.c word.c"
$CC $CFILES || error mk compilation failed
$LD -o mk `ofiles $CFILES` $OBJDIR/libregexp.a $OBJDIR/lib/libbio.a $OBJDIR/lib/lib9.a || error mk link failed
mv mk $OBJDIR/bin || error mk binary install failed

echo mk binary built successfully!

