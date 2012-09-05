## Process this file with automake to produce Makefile.in

TEXINFO_TEX = ../texinfo.tex
info_TEXINFOS = cvs-ja.texinfo
cvs_ja_TEXINFOS = CVSvn.texi

EXTRA_DIST = ChangeLog cvs-ja.dat README README.ja

MAKEINFO = @MAKEINFO@ --no-split

.texinfo.info:
	$(MAKEINFO) $< -I $(srcdir)
	$(EMACS) -batch -no-site-file -l $(top_srcdir)/tagify.el $@

.texinfo.dvi:
	TEX=$(TEX) TEXINPUTS=.:$$TEXINPUTS \
	MAKEINFO='$(MAKEINFO) -I $(srcdir)' \
	$(TEXI2DVI) $<
