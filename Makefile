# Makefile for development.
# See INSTALL and docs/dev.txt for details.
SHELL = /bin/bash
ROOT_DIR = $(shell pwd)
BIN_DIR = $(ROOT_DIR)/bin
DATA_DIR = $(ROOT_DIR)/var
WGET = wget
PYTHON = $(shell which python)
PROJECT = $(shell $(PYTHON) -c "import setup; print setup.NAME")
BUILDOUT_CFG = $(ROOT_DIR)/etc/buildout.cfg
BUILDOUT_DIR = $(ROOT_DIR)/lib/buildout
BUILDOUT_VERSION = 1.7.0
BUILDOUT_BOOTSTRAP_URL = https://raw.github.com/buildout/buildout/$(BUILDOUT_VERSION)/bootstrap/bootstrap.py
BUILDOUT_BOOTSTRAP = $(BUILDOUT_DIR)/bootstrap.py
BUILDOUT_BOOTSTRAP_ARGS = -c $(BUILDOUT_CFG) --version=$(BUILDOUT_VERSION) --distribute buildout:directory=$(ROOT_DIR)
BUILDOUT = $(BIN_DIR)/buildout
BUILDOUT_ARGS = -N -c $(BUILDOUT_CFG) buildout:directory=$(ROOT_DIR)
NOSE = $(BIN_DIR)/nosetests


configure:
	# Configuration is stored in etc/ folder. Not generated yet.


develop: buildout


buildout:
	if [ ! -d $(BUILDOUT_DIR) ]; then mkdir -p $(BUILDOUT_DIR); fi
	if [ ! -f $(BUILDOUT_BOOTSTRAP) ]; then wget -O $(BUILDOUT_BOOTSTRAP) $(BUILDOUT_BOOTSTRAP_URL); fi
	if [ ! -x $(BUILDOUT) ]; then $(PYTHON) $(BUILDOUT_BOOTSTRAP) $(BUILDOUT_BOOTSTRAP_ARGS); fi
	$(BUILDOUT) $(BUILDOUT_ARGS)


clean:
	find $(ROOT_DIR)/ -name "*.pyc" -delete
	find $(ROOT_DIR)/ -name ".noseids" -delete


distclean: clean
	rm -rf $(ROOT_DIR)/*.egg-info
	rm -rf $(ROOT_DIR)/demo/*.egg-info


maintainer-clean: distclean
	rm -rf $(BIN_DIR)/
	rm -rf $(ROOT_DIR)/lib/


test: test-app test-demo test-documentation


test-app:
	$(NOSE) -c $(ROOT_DIR)/etc/nose.cfg --with-coverage --cover-package=django_downloadview django_downloadview tests
	mv $(ROOT_DIR)/.coverage $(ROOT_DIR)/var/test/app.coverage


test-demo:
	$(BIN_DIR)/demo test demo
	mv $(ROOT_DIR)/.coverage $(ROOT_DIR)/var/test/demo.coverage


test-documentation:
	$(NOSE) -c $(ROOT_DIR)/etc/nose.cfg sphinxcontrib.testbuild.tests


apidoc:
	cp docs/api/index.txt docs/api-backup.txt
	rm -rf docs/api/*
	mv docs/api-backup.txt docs/api/index.txt
	$(BIN_DIR)/sphinx-apidoc --suffix txt --output-dir $(ROOT_DIR)/docs/api django_downloadview


sphinx:
	make --directory=docs clean html doctest


documentation: apidoc sphinx


demo: develop
	mkdir -p var/media/document
	$(BIN_DIR)/demo syncdb --noinput
	cp $(ROOT_DIR)/demo/demoproject/download/fixtures/hello-world.txt var/media/document/
	$(BIN_DIR)/demo loaddata $(ROOT_DIR)/demo/demoproject/download/fixtures/demo.json
	$(BIN_DIR)/demo runserver


release:
	$(BIN_DIR)/fullrelease
