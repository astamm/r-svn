R_HOME = ../..

## first time through MkRules will not exist.

ifeq ($(wildcard MkRules?local),MkRules.local)
include MkRules.local
endif

include MkRules.rules
include ../../share/make/vars.mk

MK = $(MAKE) --no-print-directory

all:
	@$(MK) MkRules
	@if test -f  ../../SVN-REVISION ; then \
	  cp ../../SVN-REVISION ../../SVN-REVISION.bak ; \
	fi
	@$(MK) rbuild
	@$(MK) -C ../library -f Makefile.win all WIN=$(WIN)
	@$(MK) -C ../library -f Makefile.win docs
	@$(MK) NEWSdocs htmldocs docfiles
	@$(MK)  -C ../../po -f Makefile.win

bytecode: bytecode-base bytecode-recommended

bytecode-base:
	@$(MK) MkRules
	@if test -f  ../../SVN-REVISION ; then \
	  cp ../../SVN-REVISION ../../SVN-REVISION.bak ; \
	fi
	@$(MK) rbuild
	@$(MK) -C ../library -f Makefile.win bytecode WIN=$(WIN)
	@$(MK) -C ../library -f Makefile.win docs
	@$(MK) NEWSdocs htmldocs docfiles
	@$(MK)  -C ../../po -f Makefile.win


rpackages:
	@$(MK) -C ../library -f Makefile.win all WIN=$(WIN) EXT_LIBS="$(EXT_LIBS)"
	@$(MK) -C ../library -f Makefile.win docs

rpackages-cross:
	@$(MK) -C ../library -f Makefile.win cross WIN=$(WIN) EXT_LIBS="$(EXT_LIBS)"


cairodevices:
ifneq "$(USE_CAIRO)" ""
	@$(MK) -C ../library/grDevices/src/cairo -f Makefile.win all \
	  CAIRO_LIBS=$(CAIRO_LIBS) CAIRO_CPPFLAGS=$(CAIRO_CPPFLAGS) \
	  R_ARCH=$(R_ARCH)
endif

ifeq ($(wildcard MkRules?local),MkRules.local)
MkRules: MkRules.local MkRules.rules
	@cat MkRules.local MkRules.rules > MkRules
else
MkRules: MkRules.rules
	@cat MkRules.rules > MkRules
endif

CFLAGS = -O3 -Wall -pedantic $(CSTD) $(EOPTS) $(SANOPTS) $(LTO)
FFLAGS = -O3 $(EOPTS) $(LTO)

ifdef DEBUG
 CFLAGS += $(G_FLAG)
 ifndef USE_LLVM
  FFLAGS += $(G_FLAG)
 endif
else
 DLLFLAGS += -s
endif


R-DLLFLAGS = -mwindows
LIBEXTRAS = -L"$(EXT_LIBS)"/lib$(R_ARCH) -lpcre2-8 -lz -lbz2 -llzma -lzstd
ifdef USE_ICU
LIBEXTRAS += -L"$(ICU_PATH)"/lib$(R_ARCH) $(ICU_LIBS)
endif

dllversion-RESFLAGS = -I../include
CSOURCES = \
  console.c dynload.c editor.c embeddedR.c extra.c \
  opt.c pager.c preferences.c psignal.c rhome.c rt_complete.c \
  rui.c run.c shext.c sys-win32.c system.c dos_wglob.c
OBJS = $(CSOURCES:.c=.o) dllversion.o
MAINLIBS = ../main/libmain.a ../appl/libappl.a ../nmath/libnmath.a
EXTRALIBS = getline/gl.a ../extra/xdr/libxdr.a \
   ../extra/intl/libintl.a ../extra/trio/libtrio.a ../extra/tzone/libtz.a \
   ../extra/tre/libtre.a

R-DLLLIBS = $(OPENMP) -L. $(FLIBS) -lRblas -L../../$(IMPDIR) -lRgraphapp \
  -lRiconv -lcomctl32 -lole32 -luuid -lwinmm -lversion -ldeflate $(LIBEXTRAS)


.PHONY:  clean veryclean rlibs fixfiles front-ends rmodules


CPPFLAGS = -I../include -I. -I../extra -DHAVE_CONFIG_H -DR_DLL_BUILD
extra-CPPFLAGS = -I../library/grDevices/src
system-CPPFLAGS = $(arch_DEFS)

Rpwd.exe: front-ends/Rpwd.exe
	$(CP) $< $@

front-ends/Rpwd.exe:
	$(MK) -C front-ends CSTD='$(CSTD)' Rpwd

## watch out: R.dll and Rblas.dll depend on each other.
rbuild:
	@$(MK) fixfiles
	@$(MK) -C ../include -f Makefile.win
	@$(MK) -C ../scripts -f Makefile.win
ifdef USE_IMPLIBS
	@$(MK) libRiconv.dll.a
endif
	@$(MK) libRblas.dll.a
	@$(MK) ../../$(BINDIR)/R.dll
ifdef USE_IMPLIBS
	@$(MK) implibs
endif
	@$(MK) Rblas
	@$(MK) front-ends COPYRIGHTS rmodules fixed/fixdesc


rlibs:
	$(MK) -C ../extra/intl CFLAGS='$(CFLAGS)' -f Makefile.win
	$(MK) -C ../appl CFLAGS='$(CFLAGS)' FFLAGS='$(FFLAGS)' -f Makefile.win
	$(MK) -C ../nmath CFLAGS='$(CFLAGS)' FFLAGS='${FFLAGS}' -f Makefile.win
	$(MK) -C ../main CFLAGS='$(CFLAGS)' FFLAGS='$(FFLAGS)' malloc-DEFS='$(malloc-DEFS)' -f Makefile.win
	$(MK) -C ./getline CFLAGS='$(CFLAGS)'
	@for ex in graphapp xdr tre trio tzone win_iconv ; do \
	  $(MK) -C ../extra/$${ex} CFLAGS='$(CFLAGS)' -f Makefile.win || exit 1; \
	done

rmodules:
	@$(MKDIR) -p ../../modules$(R_ARCH)
	$(MK) -C ../modules -f Makefile.win \
	  CFLAGS='$(CFLAGS)' FFLAGS='$(FFLAGS)'

COPYRIGHTS: ../../doc/COPYRIGHTS COPYRIGHTS.win
	cat $^ > $@


fixfiles: Rpwd.exe
	@$(MKDIR) -p ../../$(BINDIR)
	@$(MK) -C ./fixed
ifdef USE_LIBCURL
	@if test -f "$(CURL_PATH)/etc/curl-ca-bundle.crt"; then \
	  $(CP) -p "$(CURL_PATH)/etc/curl-ca-bundle.crt" ../../etc; \
	elif test -f "$(CURL_CA_BUNDLE)"; then \
	  $(CP) -p "$(CURL_CA_BUNDLE)" ../../etc/curl-ca-bundle.crt; \
	fi
endif

fixed/fixdesc:
	@sh fixed/GETDESC $(R_PKGS_BASE) translations

dllversion.o: ../include/Rversion.h

## Rdll.hide has decoration which 64-bit builds lack
R.dll: $(OBJS) $(MAINLIBS) $(EXTRALIBS)
	@$(ECHO) EXPORTS > R.def
	@$(NM) $^ | $(SED) -n  $(SYMPAT) | LC_COLLATE=C $(SORT) | \
	  uniq $(NM_FILTER) > R0.def
	@$(SED) -e's/@.*//' Rdll.hide | LC_COLLATE=C $(SORT) > R1.def
	@LC_COLLATE=C comm -23 R0.def R1.def >> R.def
	$(DLL) -shared $(DLLFLAGS) $($*-DLLFLAGS) -o $@ R.def $^ $($*-DLLLIBS) $(DLLLIBS)
	@$(RM) R.def R0.def R1.def

R.exp: $(OBJS) $(MAINLIBS) $(EXTRALIBS)
	@$(ECHO) LIBRARY R.dll > R.exp
	@$(ECHO) EXPORTS >> R.exp
	@$(NM) $^ | $(SED) -n $(SYMPAT) | LC_COLLATE=C $(SORT) | \
	  uniq $(NM_FILTER) > R0.def
	@LC_COLLATE=C comm -23 R0.def Rdll.hide >> R.exp
	@$(RM) R0.def


Rdll: makeMakedeps libRblas.dll.a ../../$(BINDIR)/R.dll

../../$(BINDIR)/R.dll: FORCE
	@$(MK) fixfiles
	@$(MK) -C ../include -f Makefile.win
	@$(MK) rlibs
	@$(MK) makeMakedeps
	@$(MK) R.dll
	@$(MKDIR) -p ../../$(BINDIR)
	$(CP) R.dll ../../$(BINDIR)

FORCE:

implibs: libR.dll.a libRblas.dll.a
	@$(MKDIR) -p ../../lib
	@$(CP) $^ ../../lib

libR.dll.a: R.exp
	$(DLLTOOL) $(DLLTOOLFLAGS) $(R-DLLTOOLFLAGS) --dllname R.dll \
	  --input-def $< --output-lib $@

libRiconv.dll.a: unicode/iconv.def
	$(DLLTOOL) $(DLLTOOLFLAGS) $(R-DLLTOOLFLAGS) --dllname Riconv.dll \
	  --input-def $< --output-lib $@


front-ends:
	$(MK) -C front-ends CSTD='$(CSTD)'

../extra/tre/libtre.a:
	$(MK) -C ../extra/tre -f Makefile.win

../extra/trio/libtrio.a:
	$(MK) -C ../extra/trio -f Makefile.win

NEWSdocs:
	@$(MK) -C ../../doc -f Makefile.win

htmldocs:
	@$(ECHO)
	@$(ECHO) "------ Making HTML documentation ------"
	@$(MK) -C ../../doc/manual -f Makefile.win html


#                          ===== BLAS ======

Rblas:
	@$(MK) -C ../extra/blas -f Makefile.win FFLAGS='-O2 $(EOPTS)'

Rblas-clean:
	@$(MK) -C ../extra/blas -f Makefile.win clean

libRblas.dll.a:  ../extra/blas/Rblas.def
	@$(DLLTOOL) $(DLLTOOLFLAGS) --dllname Rblas.dll \
	  --input-def $< --output-lib $@


#                          ===== cleaning ======

## used in installer/Makefile
PKGDIR = ../library
pkgclean-%:
	@(cd $(PKGDIR)/$*/src; rm -f *.d *.o *.dll *_res.rc Makedeps)

EXTRA_DIRS = blas graphapp intl tre trio tzone xdr win_iconv

cleaninstaller:
	-$(MAKE) -C installer clean

# The installer has to be cleaned first, because cleaning it depends on Rscript
#   clean0 and cleanwin0 exclude the installer
#   clean, distclean and cleanwin clean also the installer 
clean0: cleanwin0
	@$(MAKE) -C ../library -f Makefile.win clean
	$(RM) -f ../*/*.o ../*/*.a *.a ../*/*.d ../*/Makedeps fixed/fixdesc
	@for d in $(EXTRA_DIRS); do \
	  $(MAKE) -C ../extra/$${d} -f Makefile.win clean; \
	done
	-$(MK) -C ../../doc/manual -f Makefile.win distclean
	-$(MK) -C ../nmath/standalone -f Makefile.win distclean
	-$(MK) -C ../modules -f Makefile.win clean
	-$(MK) -C ../../tests -f Makefile.win clean
	-$(MK) -C ../library/Recommended -f Makefile.win clean
	$(RM) -f ../library/methods/all.R ../../etc/curl-ca-bundle.crt

clean: cleaninstaller clean0

distcleaninstaller:
	-$(MAKE) -C installer distclean 

distclean: cleaninstaller distcleaninstaller clean0
	@for d in $(EXTRA_DIRS); do \
	  $(MAKE) -C ../extra/$${d} -f Makefile.win distclean; \
	done
	@$(MAKE) -C ../../tests -f Makefile.win distclean
	$(RM) -R ../../bin ../../include ../../lib ../../library ../../modules
	$(RM) ../include/config.h ../include/iconv.h ../include/psignal.h \
	../include/Rconfig.h ../include/Rversion.h ../include/Rmath.h \
	../include/libintl.h ../include/trioremap.h
	$(RM) ../library/*/src/*.o ../library/*/src/*.a
	$(RM) ../library/*/src/*.d ../library/*/src/Makedeps
	$(RM) ../library/*/src/*.dll
	$(RM) ../library/*/src/windows/*.o ../library/*/src/windows/*.a
	$(RM) ../library/*/src/windows/*.d ../library/*/src/windows/Makedeps
	$(RM) ../library/*/src/windows/*.dll
	$(RM) -R ../library/*/check
	$(RM) ../library/*/tests/*.ps ../library/*/tests/*.pdf
	$(RM) ../library/tcltk/src/tcl$(TCL_VERSION).def \
	../library/tcltk//src/tk$(TCL_VERSION).def
	$(RM) R.exp COPYRIGHTS
	$(RM) ../../doc/html/index.html \
	../../doc/html/packages.html ../../doc/html/rwin.html \
	../../doc/html/rw-FAQ.html ../../doc/html/NEWS.html \
	../../doc/NEWS.rds ../../doc/NEWS.3.rds ../../doc/NEWS.2.rds \
	../../doc/NEWS ../../doc/NEWS.pdf \
	../../doc/CHANGES.rds ../../doc/html/CHANGES.html
	$(RM) ../../etc/Makeconf ../../etc/Rconsole ../../etc/Rdevga \
	../../etc/Rprofile.site ../../etc/rgb.txt ../../etc/Rcmd_environ \
	../../tests/*.Rout ../../tests/*.Rout.fail
	# do both sub-archs
	$(RM) -R ../../etc$(R_ARCH)/Makeconf ../../etc/i386 ../../etc/x64
	$(RM) -R ../../share/zoneinfo
	$(MAKE) -C fixed distclean
	$(MAKE) -C ../include -f Makefile.win distclean
	@for pkg in $(R_PKGS_BASE) translations; do \
	  $(RM) ../library/$${pkg}/DESCRIPTION; \
	done
	$(RM) ../../SVN-REVISION.bak
	$(RM) ../../doc/manual/rw-FAQ
	$(RM) -R ../library/.vignettes # it gets left behind if there is an error
	$(RM) -R ../../share/locale # relic of earlier versions
	$(RM) MkRules Rpwd.exe # do this last of all

veryclean: distclean
	$(RM) ../../doc/FAQ ../../doc/RESOURCES ../../doc/NEWS.rds \
	  ../../doc/html/resources.html ../../doc/html/NEWS.html \
	  ../../SVN-REVISION # not in SVN sources

cleanwin0: MkRules fixfiles
	$(RM) *.o *.dll *.a *~ \#*\# .RData .Rhistory Makedeps *.d
	$(MAKE) -C ../extra/graphapp -f Makefile.win clean
	$(MAKE) -C fixed clean
	$(MAKE) -C getline clean
	$(MAKE) -C front-ends clean
	$(MAKE) -C ../library/grDevices/src/cairo -f Makefile.win clean \
	        R_ARCH=$(R_ARCH)

cleanwin: cleaninstaller cleanwin0


#                          ===== testing ======

check check-devel check-all check-recommended:
	@$(MK) -C ../../tests -f Makefile.win $@

#                          ===== documentation ======

pdfdocs manuals:
	@$(MK) -C ../../doc/manual -f Makefile.win clean
	@$(MK) -C ../../doc/manual -f Makefile.win

## currently only run for 'distribution', not 'all' (unlike on Unix-alikes)
vignettes:
	@$(MK) -C ../library -f Makefile.win vignettes


## ===================== Maintainer targets ========================

RVER-PAT = $(shell version=`cut -d' ' -f1 ../../VERSION | sed -n 1p`; if test "`cut -f2 -d' ' ../../VERSION`" = "Patched"; then version=`echo $${version} | sed 's/\.[0-9]*$$//'`; echo "$${version}-patched"; else echo "$${version}"; fi)

CRANREC = cran.r-project.org::CRAN/src/contrib/$(RVER-PAT)/Recommended

## Use -c here to avoid re-downloading the same versions of files
## A recent rsync seems to need -p
rsync-recommended:
	@(cd ../library; \
	  rsync --timeout=60 -rcvpC --delete \
	    --exclude=Makefile.in --exclude=Makefile.win --exclude=.cvsignore \
	    --include=*.tar.gz --exclude=*.tgz --exclude=*.ts \
	    --exclude=".svn" $(CRANREC) . )
	@$(RM) ../library/Recommended/*.tgz
	@(cd ../library/Recommended; for i in ${R_PKGS_RECOMMENDED}; do cp -p $${i}*.tar.gz $${i}.tgz ; done)

link-recommended:
	@$(RM) ../library/Recommended/*.tgz
	@(cd ../library/Recommended; for i in ${R_PKGS_RECOMMENDED} ; do cp -p $${i}*.tar.gz $${i}.tgz ; done)


recommended:
	@$(ECHO) "--- Making recommended packages"
	@$(MK) -C ../library/Recommended -f Makefile.win

## Note that R_COMPILER_SUPPRESS_ALL is now on by default
bytecode-recommended:
	@$(ECHO) "--- Making and compiling recommended packages"
	@rm ../library/Recommended/*.ts
	@R_COMPILE_PKGS=1 R_COMPILER_SUPPRESS_ALL=1 \
	  $(MK) -C ../library/Recommended -f Makefile.win


docfiles:
	@$(MK) -C ../../doc/manual -f Makefile.win FAQ


EXTRA_PKGS=
rinstaller:
	@$(MAKE) -C installer EXTRA_PKGS='$(EXTRA_PKGS)'
	@$(MAKE) -C installer clean

distribution:
	@$(MK) all
	@$(MK) cairodevices
	@$(MK) recommended
	@$(MK) vignettes
	@$(MK) manuals
	@$(MK) rinstaller
	@$(RM) -f ../../SVN-REVISION.bak


## ============= End of maintainer targets ========================

DEPS = $(CSOURCES:.c=.d)

makeMakedeps: $(DEPS)
	@$(RM) Makedeps
	@cat $(DEPS) >> Makedeps

-include Makedeps
