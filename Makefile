.PHONY: usage clean dist testpypi-upload pypi-upload

all: setup dist

usage:
	@echo Available make targets are: \
	setup, clean, dist, testpypi-upload, and pypi-upload	

setup: notabot.cfg
	bash create_src.sh

dist:
# Unset PIP_CONFIG_FILE in case pip.conf sets user = True
	env PIP_CONFIG_FILE=/dev/null python3 -m build --sdist --wheel .

# Clean up src too?  Need to leave version.py
clean:
	rm -rf build dist */*.egg-info
	rm -rf `find . -name __pycache__`
	rm -rf temp dynload
	find src/tkinter_embedded -not -name 'version.py' -delete

testpypi-upload:
	python3 -m twine upload --verbose --repository testpypi dist/*

pypi-upload:
	python3 -m twine upload dist/*
