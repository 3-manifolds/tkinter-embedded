cd dev/3.13
set -e
PY_VERSION=3.13
LONG_VERSION=3.13.5
SRC_ARCHIVE=Python-${LONG_VERSION}.tgz
SRC_DIR=Python-${LONG_VERSION}
URL=https://www.python.org/ftp/python/${LONG_VERSION}/${SRC_ARCHIVE}
HASH=88dc0b8317cab6e46e8336995bcc577f

if ! [ -e ${SRC_ARCHIVE} ]; then
    curl -L -O $URL
    ACTUAL_HASH=`md5 -q ${SRC_ARCHIVE}`
    if [[ ${ACTUAL_HASH} != ${HASH} ]]; then
	echo Invalid hash value for ${SRC_ARCHIVE}
	exit 1
    fi    fi
if ! [ -e $SRC_DIR ]; then
    tar xfz $SRC_ARCHIVE
fi
mkdir -p tkinter_embedded
cp $SRC_DIR/Lib/tkinter/* tkinter_embedded
patch -p1 < source.patch
mkdir -p dynload/clinic
cp $SRC_DIR/Modules/_tkinter.c dynload
cp $SRC_DIR/Modules/tkinter.h dynload
cp $SRC_DIR/Modules/clinic/_tkinter.c.h dynload/clinic
. build_tcltk.sh
rm -rf ../../dynload
mv dynload ../..
rm -rf ../../src/tkinter_embedded/*.framework
mv tkinter_embedded/*.framework ../../src/tkinter_embedded
cp tkinter_embedded/*.py ../../src/tkinter_embedded
rm -f ../../*_Headers
ln -s src/tkinter_embedded/Tcl.framework/Versions/Current/Headers ../../Tcl_Headers
ln -s src/tkinter_embedded/Tk.framework/Versions/Current/Headers ../../Tk_Headers
