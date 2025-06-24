PKG = src/tkinter
DEV = dev/3.13

PY_FILES = ${PKG}/__init__.py ${PKG}/commondialog.py ${PKG}/dnd.py \
${PKG}/messagebox.py ${PKG} ttk.py${PKG} ${PKG}/__main__.py \
${PKG}/constants.py ${PKG}/filedialog.py ${PKG}/scrolledtext.py \
${PKG}/colorchooser.py ${PKG}\dialog.py ${PKG}/font.py ${PKG}/simpledialog.py
DYLIB_SRC = dynload/_tkinter.c dynload/clinic dynload/tkinter.h 
FRAMEWORKS = ${PKG}/Tcl.framework ${PKG}/Tk.framework
EXTRA = ${DEV}/notabot.cfg ${DEV}/entitlements.txt

.PHONY: setup usage clean dist testpypi-upload pypi-upload

all: dist

usage:
	@echo Available make targets are: \
clean, dist, testpypi-upload, and pypi-upload \
	@echo Run make dist to create a wheel.


setup:
	mkdir -p dist
	bash ${DEV}/create_src.sh

dist: setup
# Unset PIP_CONFIG_FILE in case pip.conf sets user = True
	env PIP_CONFIG_FILE=/dev/null python3 -m build --sdist --wheel .

clean:
	rm -rf build dist */*.egg-info
	rm -rf `find . -name __pycache__`
	rm -rf dynload
	find src/tkinter_embedded -not -name 'version.py' -delete
	rm -rf src/tkinter_embedded/*.framework
	rm -f *_Headers

testpypi-upload:
	python3 -m twine upload --verbose --repository testpypi dist/*

pypi-upload:
	python3 -m twine upload dist/*
