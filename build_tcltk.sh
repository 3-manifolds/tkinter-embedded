set -e
mkdir -p build
. fetch_tcltk.sh
pushd build
BASE=`pwd`
export CFLAGS="-arch arm64 -arch x86_64 -mmacosx-version-min=10.13"
mkdir -p ${BASE}/dist
make -j6 -C Tcl/macosx install-embedded SUBFRAMEWORK=1 DESTDIR=${BASE}/dist \
     DYLIB_INSTALL_DIR=@rpath
make -j6 -C Tk/macosx install-embedded SUBFRAMEWORK=1 DESTDIR=${BASE}/dist \
     DYLIB_INSTALL_DIR=@rpath
cp Tcl/libtommath/tommath.h dist/Frameworks/Tcl.framework/Headers
TCL_FRAMEWORK=dist/Frameworks/Tcl.framework
TK_FRAMEWORK=dist/Frameworks/Tk.framework
rm ${TCL_FRAMEWORK}/PrivateHeaders
rm ${TK_FRAMEWORK}/PrivateHeaders
mv ${TCL_FRAMEWORK}/Versions/Current/*.sh ${TCL_FRAMEWORK}/Versions/Current/Resources 
ln -s Resources/tclConfig.sh ${TCL_FRAMEWORK}/Versions/Current/tclConfig.sh
ln -s Resources/tclooConfig.sh ${TCL_FRAMEWORK}/Versions/Current/tclooConfig.sh
mv ${TK_FRAMEWORK}/Versions/Current/*.sh ${TK_FRAMEWORK}/Versions/Current/Resources 
ln -s Resources/tkConfig.sh ${TK_FRAMEWORK}/Versions/Current/tkConfig.sh
popd
python3 -m notabot.sign build/dist/Frameworks/Tcl.framework
python3 -m notabot.sign build/dist/Frameworks/Tk.framework
