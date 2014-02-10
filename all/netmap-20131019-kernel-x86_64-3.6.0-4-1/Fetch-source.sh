#!/bin/bash

SRC=20131019-netmap.tgz
DST=/var/spool/src/netmap-20131019.tgz

[ -s "$DST" ] || wget -O $DST http://info.iet.unipi.it/~luigi/doc/$SRC
