set -e
BASE=`pwd`
mkdir -p Frameworks
mkdir -p tkinter_embedded
rm -rf build
. fetch_tcltk.sh
export CFLAGS="-arch arm64 -arch x86_64 -mmacosx-version-min=10.13"
make -j6 -C Tcl/macosx install-embedded SUBFRAMEWORK=1 DESTDIR=${BASE} \
     DYLIB_INSTALL_DIR=@rpath
make -j6 -C Tk/macosx install-embedded SUBFRAMEWORK=1 DESTDIR=${BASE} \
     DYLIB_INSTALL_DIR=@rpath
cp Tcl/libtommath/tommath.h Frameworks/Tcl.framework/Headers
TCL_FRAMEWORK=Frameworks/Tcl.framework
TK_FRAMEWORK=Frameworks/Tk.framework
rm ${TCL_FRAMEWORK}/PrivateHeaders
rm ${TK_FRAMEWORK}/PrivateHeaders
mv ${TCL_FRAMEWORK}/Versions/Current/*.sh ${TCL_FRAMEWORK}/Versions/Current/Resources 
ln -s Resources/tclConfig.sh ${TCL_FRAMEWORK}/Versions/Current/tclConfig.sh
ln -s Resources/tclooConfig.sh ${TCL_FRAMEWORK}/Versions/Current/tclooConfig.sh
mv ${TK_FRAMEWORK}/Versions/Current/*.sh ${TK_FRAMEWORK}/Versions/Current/Resources 
ln -s Resources/tkConfig.sh ${TK_FRAMEWORK}/Versions/Current/tkConfig.sh
python3 -m notabot.sign ${TCL_FRAMEWORK}
python3 -m notabot.sign ${TK_FRAMEWORK}
rm -rf tkinter_embedded/Tcl.framework
mv ${TCL_FRAMEWORK} tkinter_embedded
rm -rf tkinter_embedded/Tk.framework
mv ${TK_FRAMEWORK} tkinter_embedded
