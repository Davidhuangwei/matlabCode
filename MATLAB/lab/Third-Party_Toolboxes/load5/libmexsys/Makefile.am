AUTOMAKE_OPTIONS = foreign 1.8 no-dependencies
VPATH = @srcdir@

INCLUDES = -I$(srcdir) -I$(top_srcdir)/libmexio $(MATIO_CFLAGS) $(ZLIB_CFLAGS) $(MATLAB_FLAGS)

lib_LIBRARIES = libmexsys.a
libmexsys_a_SOURCES = mem.c mexstd.c string.c

print:
	@list='$(libmexsys_a_SOURCES)'; \
	rm -f libmexsys.ps; \
	curdir=`pwd`; \
	cd $(srcdir); \
	for f in $$list; do \
	    enscript -2 -G -r -Ec --color -o - $$f >> $$curdir/libmexsys.ps;\
	done; \
	cd $$curdir
