.PHONY: usage clean dist testpypi-upload pypi-upload

all: dist

usage:
	@echo Available make targets are: \
	setup, clean, dist, testpypi-upload, and pypi-upload	

setup: notabot.cfg
	bash create_src.sh

dist: setup
# Unset PIP_CONFIG_FILE in case pip.conf sets user = True
	env PIP_CONFIG_FILE=/dev/null python3 -m build --sdist --wheel .

clean:
	rm -rf build */*.egg-info
	rm -rf `find . -name __pycache__`
	rm -rf dynload
	find src/tkinter_embedded -not -name 'version.py' -delete

testpypi-upload:
	python3 -m twine upload --verbose --repository testpypi dist/*

pypi-upload:
	python3 -m twine upload dist/*
