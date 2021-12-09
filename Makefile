# SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
#
# SPDX-License-Identifier: MIT
#

GPRBUILD_FLAGS = -p -j0
PREFIX                 ?= /usr
GPRDIR                 ?= $(PREFIX)/share/gpr
LIBDIR                 ?= $(PREFIX)/lib
BINDIR                 ?= $(PREFIX)/bin
INSTALL_PROJECT_DIR    ?= $(DESTDIR)$(GPRDIR)
INSTALL_INCLUDE_DIR    ?= $(DESTDIR)$(PREFIX)/include/declarative_regions
INSTALL_EXEC_DIR       ?= $(DESTDIR)$(BINDIR)
INSTALL_LIBRARY_DIR    ?= $(DESTDIR)$(LIBDIR)
INSTALL_ALI_DIR        ?= ${INSTALL_LIBRARY_DIR}/declarative_regions

GPRINSTALL_FLAGS = --prefix=$(PREFIX) --sources-subdir=$(INSTALL_INCLUDE_DIR)\
 --lib-subdir=$(INSTALL_ALI_DIR) --project-subdir=$(INSTALL_PROJECT_DIR)\
 --link-lib-subdir=$(INSTALL_LIBRARY_DIR) --exec-subdir=$(INSTALL_EXEC_DIR)

all:
	gprbuild $(GPRBUILD_FLAGS) -P gnat/declarative_regions.gpr
	gprbuild $(GPRBUILD_FLAGS) -P gnat/declarative_regions_run.gpr

install:
	gprinstall $(GPRINSTALL_FLAGS) -p -P gnat/declarative_regions.gpr
	gprinstall $(GPRINSTALL_FLAGS) -p -P gnat/declarative_regions_run.gpr --mode=usage
clean:
	gprclean -q -P gnat/declarative_regions_run.gpr
	gprclean -q -P gnat/declarative_regions.gpr

check: all
	@set -e; \
	echo No tests yet
