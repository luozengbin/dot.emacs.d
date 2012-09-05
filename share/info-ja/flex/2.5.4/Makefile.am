## Process this file with automake to produce Makefile.in

TEXINFO_TEX = ../texinfo.tex
info_TEXINFOS = flex-ja.texi
flex_ja_TEXINFOS = bufferman_addendum-ja.texi c++_addendum-ja.texi \
          charclassexpr_addendum-ja.texi flexposix_addendum-ja.texi \
          funcvar_addendum-ja.texi funcvar_summary_addendum-ja.texi \
          option_addendum-ja.texi startstate_addendum-ja.texi \
          switch_addendum-ja.texi switch_summary_addendum-ja.texi
EXTRA_DIST = README-ja TODO-ja

MAKEINFO = @MAKEINFO@ --no-split

.texi.info:
	$(MAKEINFO) $< -I $(srcdir)
	$(EMACS) -batch -no-site-file -l $(top_srcdir)/tagify.el $@

.texi.dvi:
	TEX=$(TEX) TEXINPUTS=.:$$TEXINPUTS \
	MAKEINFO='$(MAKEINFO) -I $(srcdir)' \
	$(TEXI2DVI) $<


