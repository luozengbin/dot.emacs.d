## Process this file with automake to produce Makefile.in

TEXINFO_TEX = $(top_srcdir)/texinfo.tex
info_TEXINFOS = autoconf-ja.texi
autoconf_ja_TEXINFOS = install-ja.texi autoconf-v.texi fdl.texi

MAKEINFO = @MAKEINFO@ --no-split

.texi.info:
	$(MAKEINFO) $< -I $(srcdir)
	$(EMACS) -batch -no-site-file -l $(top_srcdir)/tagify.el $@

.texi.dvi:
	TEX=$(TEX) TEXINPUTS=.:$$TEXINPUTS \
	MAKEINFO='$(MAKEINFO) -I $(srcdir)' \
	$(TEXI2DVI) $<
