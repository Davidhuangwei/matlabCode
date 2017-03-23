AUTOMAKE_OPTIONS = foreign 1.8 no-dependencies
VPATH = @srcdir@

INCLUDES = -I$(top_srcdir)/libmexio $(MATIO_CFLAGS) $(MATLAB_FLAGS)

SUBDIRS = libmexsys libmexio

SUFFIX=
bindir=$(exec_prefix)/mex

if WINNT
MEXVSRC=$(MATLAB_DIR)/sys/lcc/mex/lccstub.c
else
MEXVSRC=$(MATLAB_DIR)/extern/src/mexversion.c
endif

bin_PROGRAMS = load5

load5_SOURCES = load5.c $(MEXVSRC)
load5_CFLAGS  = $(MATLAB_FLAGS) -I$(top_srcdir)/libmexsys $(HDF5_FLAGS)
load5_LDFLAGS = -L$(top_builddir)/libmexsys -L$(top_builddir)/libmexio \
                 $(MATLAB_LINK) $(MEX_WRAPS)
load5_LDADD   = -lmexio $(MATIO_LIBS) -lmexsys $(MATLAB_LIB) -lmexsys

print:
	@list='$(libmexio_a_SOURCES)'; \
	rm -f libmexio.ps; \
	curdir=`pwd`; \
	cd $(srcdir); \
	for f in $$list; do \
	    enscript -2 -G -r -Ec --color -o - $$f >> $$curdir/libmexio.ps;\
	done; \
	cd $$curdir
