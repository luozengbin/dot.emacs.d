## Process this file with automake to produce Makefile.in

TEXINFO_TEX = ../texinfo.tex
info_TEXINFOS = gdb-ja.texinfo
gdb_ja_TEXINFOS = remote-ja.texi rluser-ja.texinfo inc-hist-ja.texi gdb-cfg.texi GDBvn.texi
EXTRA_DIST = README-ja

MAKEINFO = @MAKEINFO@ --no-split

.texinfo.info:
	$(MAKEINFO) $< -I $(srcdir)
	$(EMACS) -batch -no-site-file -l $(top_srcdir)/tagify.el $@

.texinfo.dvi:
	TEX=$(TEX) TEXINPUTS=.:$$TEXINPUTS \
	MAKEINFO='$(MAKEINFO) -I $(srcdir)' \
	$(TEXI2DVI) $<

