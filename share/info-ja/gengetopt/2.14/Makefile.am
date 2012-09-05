## Process this file with automake to produce Makefile.in

TEXINFO_TEX = $(top_srcdir)/texinfo.tex
info_TEXINFOS = gengetopt-ja.texi
gengetopt_ja_TEXINFOS = gengetopt-v.texi \
	test_conf_parser.c.texinfo \
	help_output.texinfo \
	test_conf_parser_ov2.c.texinfo \
	cmdline1.h.texinfo \
	main1.cc.texinfo \
	multiple_example.c.texinfo

MAKEINFO = @MAKEINFO@ --no-split

.texi.info:
	$(MAKEINFO) $< -I $(srcdir)
	$(EMACS) -batch -no-site-file -l $(top_srcdir)/tagify.el $@

.texi.dvi:
	TEX=$(TEX) TEXINPUTS=.:$$TEXINPUTS \
	MAKEINFO='$(MAKEINFO) -I $(srcdir)' \
	$(TEXI2DVI) $<
