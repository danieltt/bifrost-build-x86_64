#!/bin/bash

SRCVER=zlib-1.2.5
PKG=$SRCVER-1 # with build version

PKGDIR=${PKGDIR:-/var/lib/build/all/$PKG}
SRC=/var/spool/src/$SRCVER.tar.bz2
CDIR=/var/tmp/src
DST="/var/tmp/install/$PKG"

#########
# Install dependencies:
# pkg_install dependency-1.1 || exit 1

#########
# Unpack sources into dir under /var/tmp/src
./Fetch-source.sh || exit 1
cd $CDIR; tar xf $SRC

#########
# Patch
cd $CDIR/$SRCVER
libtool_fix-1
# patch -p1 < $PKGDIR/mypatch.pat

#########
# Configure
B-configure-1 --prefix=/usr --static --64 || exit 1
sed -i 's/-DPIC//g' Makefile
sed -i 's/-fPIC//g' Makefile

#########
# Post configure patch
# patch -p0 < $PKGDIR/Makefile.pat

#########
# Compile
make -j 3 libz.a || exit 1

#########
# Install into dir under /var/tmp/install
rm -rf "$DST"

mkdir -p $DST/usr/lib
mkdir -p $DST/usr/include
mkdir -p $DST/usr/lib/pkgconfig

cp libz.a $DST/usr/lib
cp zlib.h $DST/usr/include
cp zconf.h $DST/usr/include
cp zlib.pc $DST/usr/lib/pkgconfig

#########
# Check result
cd $DST || exit 1
# [ -f usr/bin/myprog ] || exit 1
# (file usr/bin/myprog | grep -qs "statically linked") || exit 1

#########
# Clean up
cd $DST
rm -rf usr/share usr/lib/libz.so*
#[ -d bin ] && strip bin/*
#[ -d usr/bin ] && strip usr/bin/*

#########
# Make package
cd $DST
tar czf /var/spool/pkg/$PKG.tar.gz .

#########
# Cleanup after a success
cd /var/lib/build
[ "$DEVEL" ] || rm -rf "$DST"
[ "$DEVEL" ] || rm -rf "$CDIR/$SRCVER"
pkg_uninstall
exit 0
