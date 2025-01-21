set -e
PY_VERSION=3.13
LONG_VERSION=3.13.1
SRC_ARCHIVE=Python-${LONG_VERSION}.tgz
SRC_DIR=Python-${LONG_VERSION}
URL=https://www.python.org/ftp/python/${LONG_VERSION}/${SRC_ARCHIVE}
HASH=6820ac52d77af870f795dabc64583234

if ! [ -e src ] || ! [ -e dynload ]; then
    rm -rf temp
    mkdir temp
    cd temp
    if ! [ -e $SRC_DIR ]; then
	curl -L -O $URL
	ACTUAL_HASH=`md5 -q ${SRC_ARCHIVE}`
	if [[ ${ACTUAL_HASH} != ${HASH} ]]; then
	    echo Invalid hash value for ${SRC_ARCHIVE}
	    exit 1
	fi
	tar xfz $SRC_ARCHIVE
    fi
    cd ..
    mkdir -p src/tkinter_embedded
    cp temp/$SRC_DIR/Lib/tkinter/* src/tkinter_embedded
    mkdir -p dynload/clinic
    cp temp/$SRC_DIR/Modules/_tkinter.c dynload
    cp temp/$SRC_DIR/Modules/tkinter.h dynload
    cp temp/$SRC_DIR/Modules/clinic/_tkinter.c.h dynload/clinic
fi

UNAME="`uname -s`"
case ${UNAME} in
    "Darwin")
	if ! [ -e src/Tcl.framework ] || ! [ -e src/Tk.framework ]; then
	    mkdir -p temp src/tkinter_embedded
	    pushd temp
	    git clone https://github.com/3-manifolds/frameworks
	    cp ../notabot.cfg frameworks
	    cd frameworks
	    make Setup
	    make TclTk
	    popd
	    mv temp/frameworks/Frameworks/Tk.framework src/tkinter_embedded
	    mv temp/frameworks/Frameworks/Tcl.framework src/tkinter_embedded
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

