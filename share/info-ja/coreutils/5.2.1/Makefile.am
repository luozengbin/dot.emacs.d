## Process this file with automake to produce Makefile.in

TEXINFO_TEX = $(top_srcdir)/texinfo.tex
info_TEXINFOS = coreutils-ja.texi
coreutils_ja_TEXINFOS = coreutils-v.texi constants.texi getdate-ja.texi \
                       doclicense.texi perm-ja.texi

MAKEINFO = @MAKEINFO@ --no-split

.texi.info:
	$(MAKEINFO) $< -I $(srcdir)
	$(EMACS) -batch -no-site-file -l $(top_srcdir)/tagify.el $@

.texi.dvi:
	TEX=$(TEX) TEXINPUTS=.:$$TEXINPUTS \
	MAKEINFO='$(MAKEINFO) -I $(srcdir)' \
	$(TEXI2DVI) $<
