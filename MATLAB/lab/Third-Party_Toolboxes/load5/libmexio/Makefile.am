AUTOMAKE_OPTIONS = foreign 1.8 no-dependencies
VPATH = @srcdir@

INCLUDES = -I$(srcdir) $(MATIO_CFLAGS) $(ZLIB_CFLAGS) $(MATLAB_FLAGS)

lib_LIBRARIES = libmexio.a
include_HEADERS = mexio.h
libmexio_a_SOURCES = mexio.c mex.c

print:
	@list='$(libmexio_a_SOURCES)'; \
	rm -f libmexio.ps; \
	curdir=`pwd`; \
	cd $(srcdir); \
	for f in $$list; do \
	    enscript -2 -G -r -Ec --color -o - $$f >> $$curdir/libmexio.ps;\
	done; \
	cd $$curdir
