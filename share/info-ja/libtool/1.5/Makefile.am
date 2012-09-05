## Process this file with automake to produce Makefile.in

TEXINFO_TEX = ../texinfo.tex
info_TEXINFOS = libtool-ja.texi
libtool_ja_TEXINFOS = libtool-v.texi PLATFORMS-ja fdl.texi

MAKEINFO = @MAKEINFO@ --no-split

.texi.info:
	$(MAKEINFO) $< -I $(srcdir)
	$(EMACS) -batch -no-site-file -l $(top_srcdir)/tagify.el $@

.texi.dvi:
	TEX=$(TEX) TEXINPUTS=.:$$TEXINPUTS \
	MAKEINFO='$(MAKEINFO) -I $(srcdir)' \
	$(TEXI2DVI) $<
