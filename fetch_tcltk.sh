#!/bin/bash
set -e

TCL_VERSION=9.0.1
TK_VERSION=9.0.1
TCL_ARCHIVE=tcl-core${TCL_VERSION}-src.tar.gz
TK_ARCHIVE=tk${TK_VERSION}-src.tar.gz
URL=https://prdownloads.sourceforge.net/tcl

rm -rf build/Tcl build/Tk
mkdir build/Tcl build/Tk
if ! [ -e ${TCL_ARCHIVE} ]; then
    echo NO TCL
    exit
    curl -L -O ${URL}/${TCL_ARCHIVE}
fi
if ! [ -e ${TK_ARCHIVE} ]; then
    echo NO TK
    exit
    curl -L -O ${URL}/${TK_ARCHIVE}
fi
tar xfz ${TCL_ARCHIVE} --directory=build/Tcl --strip-components=1
tar xfz ${TK_ARCHIVE} --directory=build/Tk --strip-components=1
