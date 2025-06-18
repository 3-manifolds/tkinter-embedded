set -e
PY_VERSION=3.13
LONG_VERSION=3.13.3
SRC_ARCHIVE=Python-${LONG_VERSION}.tgz
SRC_DIR=Python-${LONG_VERSION}
URL=https://www.python.org/ftp/python/${LONG_VERSION}/${SRC_ARCHIVE}
HASH=b3d8c043dcdd52d55d48769a95c8e7d1

if ! [ -e src ] || ! [ -e dynload ]; then
    rm -rf build
    mkdir build
    if ! [ -e ${SRC_ARCHIVE} ]; then
	curl -L -O $URL
	ACTUAL_HASH=`md5 -q ${SRC_ARCHIVE}`
	if [[ ${ACTUAL_HASH} != ${HASH} ]]; then
	    echo Invalid hash value for ${SRC_ARCHIVE}
	    exit 1
	fi    fi
    pushd  build
    if ! [ -e $SRC_DIR ]; then
	tar xfz ../$SRC_ARCHIVE
	ln -s ${SRC_DIR} Python
    fi
    popd
    mkdir -p src/tkinter_embedded
    cp build/$SRC_DIR/Lib/tkinter/* src/tkinter_embedded
    mkdir -p dynload/clinic
    cp build/$SRC_DIR/Modules/_tkinter.c dynload
    cp build/$SRC_DIR/Modules/tkinter.h dynload
    cp build/$SRC_DIR/Modules/clinic/_tkinter.c.h dynload/clinic
fi

UNAME="`uname -s`"
case ${UNAME} in
    "Darwin")
	if ! [ -e src/Tcl.framework ] || ! [ -e src/Tk.framework ]; then
	    bash build_TclTk.sh
	    rm -rf src/Tcl.framework src/Tk.framework
	    mv build/dist/Frameworks/Tk.framework src/tkinter_embedded
	    mv build/dist/Frameworks/Tcl.framework src/tkinter_embedded
	    ln -s src/tkinter_embedded/Tcl.framework/Versions/Current/Headers Tcl_Headers
	    ln -s src/tkinter_embedded/Tk.framework/Versions/Current/Headers Tk_Headers
	fi
	;;
    "Linux")
	echo "Linux is not implemented yet."
	;;
    *)
	echo "Unknown system."
	;;
esac

