#!/bin/bash
set -e

TCL_VERSION=9.0.1
TK_VERSION=9.0.1
TCL_ARCHIVE=tcl-core${TCL_VERSION}-src.tar.gz
TK_ARCHIVE=tk${TK_VERSION}-src.tar.gz
URL=https://prdownloads.sourceforge.net/tcl

if ! [ -e ${TCL_ARCHIVE} ]; then
    curl -L -O ${URL}/${TCL_ARCHIVE}
fi
if ! [ -e ${TK_ARCHIVE} ]; then
    curl -L -O ${URL}/${TK_ARCHIVE}
fi
rm -rf Tcl Tk
mkdir Tcl Tk
tar xfz ${TCL_ARCHIVE} --directory=Tcl --strip-components=1
tar xfz ${TK_ARCHIVE} --directory=Tk --strip-components=1
