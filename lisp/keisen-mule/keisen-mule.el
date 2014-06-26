;;; -*- Mode: Emacs-Lisp ; Coding: iso-2022-jp -*-
;;
;; keisen mode commands for Emacs
;; Copyright (C) 1986,1992,1993,1994 Free Software Foundation, Inc.
;;
;;;
;; $BK\%W%m%0%i%`$O%U%j!<!&%=%U%H%&%'%"$G$9!#$"$J$?$O!"(BFree Software
;; Foundation $B$,8xI=$7$?(B GNU $B0lHL8xM-;HMQ5vBz$N!V%P!<%8%g%s(B 1$B!W$"$k$$$O$=$l(B
;; $B0J9_$N3F%P!<%8%g%s$NCf$+$i$$$:$l$+$rA*Br$7!"$=$N%P!<%8%g%s$,Dj$a$k>r9`$K(B
;; $B=>$C$FK\%W%m%0%i%`$r:FHRI[$^$?$OJQ99$9$k$3$H$,$G$-$^$9!#(B
;;
;; $BK\%W%m%0%i%`$OM-MQ$H$O;W$$$^$9$,!"HRI[$K$"$?$C$F$O!";T>l@-5Z$SFCDjL\E*E,(B
;; $B9g@-$K$D$$$F$N0EL[$NJ]>Z$r4^$a$F!"$$$+$J$kJ]>Z$b9T$J$$$^$;$s!#>\:Y$K$D$$(B
;; $B$F$O(B GNU $B0lHL8xM-;HMQ5vBz=q$r$*FI$_2<$5$$!#(B
;;
;; $B$"$J$?$O!"K\%W%m%0%i%`$H0l=o$K(B GNU $B0lHL8xM-;HMQ5vBz=q$N<L$7$r<u$1<h$C$F$$(B
;; $B$k$O$:$G$9!#$=$&$G$J$$>l9g$O!"(BFree Software Foundation, Inc., 675 Mass
;; Ave, Cambridge, MA 02139, USA $B$X<j;f$r=q$$$F2<$5$$!#(B
;;
;;;
;; $B$3$N%W%m%0%i%`$O!";0=EBg3X9)3XItEE5$EE;R9)3X2J$NJ?@.#2G/EYB46H@8(B
;; $BD;5o(B $B7r$5$s$H?yK\(B $BE/Li$5$s$,:n@.$7!"3yIt(B $B9@$5$s$,G[I[$7$?$b$N$r(B
;; $B%Y!<%9$H$7$F!"(BMULE$BBP1~$X$N=$@55Z$S5!G=DI2C$r9T$C$?$b$N$G$9!#(B
;;
;; keisen.el   ver 1.2  (non-tabs version)
;;      by KEN.TORII
;;
;;;
;; keisen-mule.el
;;   Author   : Ken Torii & Tetsuya Sugimoto
;;   Modifier : Masahiko Iwamoto
;;		<iwamoto@mtc.telcom.oki.co.jp, KFR03243@niftyserve.or.jp>
;;   Created  : Dec 13, 1994
;;   Version  : 2.02$B&C(B
;;
;;;
;; History
;;   1993.05.17 08:30 ver 1.90.00    M.Iwamoto
;;      [[ MULE$BBP1~HG7S@~%b!<%I(B $B&A%j%j!<%9(B ]]
;;   1993.05.17 11:10 ver 1.90.01    M.Iwamoto
;;      -- keisen-extend-left$B4X?t$N%P%02~=$(B
;;   1993.05.17 13:09 ver 1.90.02    M.Iwamoto
;;      -- keisen-center-line$B4X?t$NDI2C(B
;;      -- keisen-right-line$B4X?t$NDI2C(B
;;      -- keisen-left-line$B4X?t$NDI2C(B
;;   1993.05.25 09:15 ver 1.90.03    M.Iwamoto
;;      -- $B<+F02~9T5!G=$NDI2C(B
;;      -- $B<+F03HD%5!G=$NDI2C(B
;;   1993.06.08 08:44 ver 1.90.04    M.Iwamoto
;;      -- keisen-clear-backward-char$B4X?t$N%P%02~=$(B
;;      -- keisen-overwrite-string$B4X?t$N%P%02~=$(B
;;      -- keisen-kill-rectangle$B4X?t$NDI2C(B
;;      -- keisen-yank-rectangle$B4X?t$NDI2C(B
;;      -- keisen-open-rectangle$B4X?t$NDI2C(B
;;      -- keisen-clear-rectangle$B4X?t$NDI2C(B
;;   1993.06.14 16:20 ver 1.90.05    M.Iwamoto		<$BHs8x3+(B>
;;      -- keisen-clear-char$B4X?t$N%P%02~=$(B
;;      -- keisen-enlarge-vertically$B4X?t$N%P%02~=$(B
;;      -- keisen-shrink-horizontally$B4X?t$N%P%02~=$(B
;;      -- keisen-extend-right$B4X?t$N0lIt;EMMJQ99(B
;;	-- keisen-extend-left$B4X?t$N0lIt;EMMJQ99(B
;;	-- keisen-extend-up$B4X?t$N0lIt;EMMJQ99(B
;;	-- keisen-extend-down$B4X?t$N0lIt;EMMJQ99(B
;;   1993.10.20 12:53 ver 1.95.00    M.Iwamoto
;;      [[ MULE$BBP1~HG7S@~%b!<%I(B $B&B%j%j!<%9(B ]]
;;      -- keisen-movement-right$B4X?t$NDI2C(B
;;      -- keisen-movement-left$B4X?t$NDI2C(B
;;      -- keisen-movement-up$B4X?t$NDI2C(B
;;      -- keisen-movement-down$B4X?t$NDI2C(B
;;      -- keisen-movement-wnw$B4X?t$NDI2C(B
;;      -- keisen-movement-ene$B4X?t$NDI2C(B
;;      -- keisen-movement-wsw$B4X?t$NDI2C(B
;;      -- keisen-movement-ese$B4X?t$NDI2C(B
;;      -- keisen-movement-nw$B4X?t$NDI2C(B
;;      -- keisen-movement-ne$B4X?t$NDI2C(B
;;      -- keisen-movement-sw$B4X?t$NDI2C(B
;;      -- keisen-movement-se$B4X?t$NDI2C(B
;;      -- keisen-picture-set-tab-stops$B4X?t$NDI2C(B
;;      -- keisen-picture-tab-search$B4X?t$NDI2C(B
;;      -- keisen-picture-tab$B4X?t$NDI2C(B
;;      -- keisen-set-mark$B4X?t$N;EMMJQ99(B
;;      -- keisen-center-line$B4X?t$N%P%02~=$(B
;;      -- keisen-right-line$B4X?t$N%P%02~=$(B
;;      -- keisen-left-line$B4X?t$N%P%02~=$(B
;;      -- keisen-arrow$B4X?t$NDI2C(B
;;      -- keisen-line$B4X?t$NDI2C(B
;;      -- keisen-square-line2$B4X?t$NDI2C(B
;;      -- keisen-rectangle$B4X?t$NDI2C(B
;;      -- keisen-save-rectangle$B4X?t$NDI2C(B
;;      -- keisen-delete-rectangle$B4X?t$NDI2C(B
;;      -- keisen-status$B4X?t$NDI2C(B
;;      -- keisen-previous-line$B4X?t$N;EMMJQ99(B
;;      -- keisen-next-line$B4X?t$N;EMMJQ99(B
;;      -- keisen-forward-jump-frame$B4X?t$NDI2C(B
;;      -- keisen-backward-jump-frame$B4X?t$NDI2C(B
;;      -- keisen-previous-jump-frame$B4X?t$NDI2C(B
;;      -- keisen-next-jump-frame$B4X?t$NDI2C(B
;;      -- keisen-kill-rectangle-to-register$B4X?t$NDI2C(B
;;      -- keisen-delete-rectangle-to-register$B4X?t$NDI2C(B
;;      -- keisen-save-rectangle-to-register$B4X?t$NDI2C(B
;;      -- keisen-yank-rectangle-from-register$B4X?t$NDI2C(B
;;      -- keisen-view-rectangle-register$B4X?t$NDI2C(B
;;   1993.11.04 12:00 ver 1.95.01    M.Iwamoto
;;      -- keisen-mode$B4X?t$N%P%0=$@5(B
;;      -- keisen-key-mode$B4X?t$N=$@5(B
;;      -- keisen-save-rectangle-to-register$B4X?t$N%P%0=$@5(B   
;;;
;; Unofficial History
;;   1994.11.04 14:00 ver ?.??.??   Sakai Kiyotaka <ksakai@mtl.t.u-tokyo.ac.jp>
;;	-- modified for Mule Ver.2.1
;;   1994.12.13 18:40 ver ?.??.??   Tatsuo Furukawa <tatsuo@kobe.hp.com>
;;	-- Mule 2.x $B$K$F%+!<%=%k0\F0$,$*$+$7$$$H$$$&IT6q9g$r=$@5(B
;;;
;;   1993.11.25 11:50 ver 1.95.02    M.Iwamoto		<$BHs8x3+(B>
;;      -- km:new-keisen-string$B4X?t$N%P%0=$@5(B
;;   1994.02.16 17:27 ver 1.95.03    M.Ozawa		<$BHs8x3+(B>
;;      -- km:beginning-of-line$B4X?t$N%P%0=$@5(B
;;      -- km:end-of-line$B4X?t$N%P%0=$@5(B
;;   1994.02.16 18:18 ver 1.95.04    M.Iwamoto
;;      -- km:eoblp$B4X?t$N%P%0=$@5(B
;;   1994.03.18 12:56 ver 1.96.00    M.Ozawa		<$BHs8x3+(B>
;;      -- $BF14|%9%/%m!<%k%b!<%I$NDI2C(B
;;          keisen-sync-mode
;;          keisen-sync-mode-exit
;;          keisen-sync-change-region
;;   1994.03.30 10:33 ver 1.96.01    M.Ozawa		<$BHs8x3+(B>
;;      -- km:beginning-of-line$B4X?t$N%P%0=$@5(B
;;   1994.03.30 12:41 ver 1.97.00    M.Iwamoto		<$BHs8x3+(B>
;;      -- keisen-clear-keisen$B4X?t$NDI2C(B
;;      -- keisen-clear-frame$B4X?t$NDI2C(B
;;      -- keisen-line-horizontally$B4X?t$NDI2C(B
;;      -- keisen-line-vertically$B4X?t$NDI2C(B
;;      -- keisen-arrow-down$B4X?t$NDI2C(B
;;      -- keisen-arrow-up$B4X?t$NDI2C(B
;;      -- keisen-arrow-right$B4X?t$NDI2C(B
;;      -- keisen-arrow-left$B4X?t$NDI2C(B
;;      -- keisen-insert-register$B4X?t$NDI2C(B
;;      -- keisen-locked-forward-line-ext$B4X?t$NDI2C(B
;;      -- keisen-change-locked-forward-after$B4X?t$NDI2C(B
;;   1994.03.30 14:22 ver 1.97.01    M.Ozawa		<$BHs8x3+(B>
;;      -- km:beginning-of-line$B4X?t$N%P%0=$@5(B
;;      -- km:top-of-frame$B4X?t$N%P%0=$@5(B
;;      -- km:bottom-of-frame$B4X?t$N%P%0=$@5(B
;;   1994.03.30 17:53 ver 1.97.02    M.Iwamoto
;;      -- km:beginning-of-line$B4X?t$N%P%0=$@5(B
;;   1994.04.04 11:40 ver 1.97.03    M.Ozawa
;;      -- keisen-arrow-left$B4X?t$N%P%0=$@5(B
;;      -- keisen-arrow-right$B4X?t$N%P%0=$@5(B
;;   1994.04.05 08:28 ver 1.97.04    M.Iwamoto		<$BHs8x3+(B>
;;      -- provide$B$NL>>N%_%9$r=$@5(B
;;   1994.04.18 15:00 ver 1.97.05    M.Iwamoto		<$BHs8x3+(B>
;;      -- keisen-next-line$B4X?t$N;EMMJQ99(B
;;      -- $B>e5-;EMMJQ99$KH<$$(Bkeisen-move-stop$BJQ?tDI2C(B
;;   1994.04.19 17:21 ver 1.97.06    M.Iwamoto		<$BHs8x3+(B>
;;	-- keisen-draw-right$B4X?t$N;EMMJQ99(B
;;	-- keisen-draw-left$B4X?t$N;EMMJQ99(B
;;	-- keisen-extend-right$B4X?t$N;EMMJQ99(B
;;	-- keisen-extend-left$B4X?t$N;EMMJQ99(B
;;   1994.04.22 16:20 ver 1.97.07    M.Ozawa		<$BHs8x3+(B>
;;      -- km:beginning-of-line$B4X?t$N%P%0=$@5(B
;;	-- km:end-of-line$B4X?t$N%P%0=$@5(B
;;   1994.04.22 16:30 ver 1.97.08    M.Iwamoto		<$BHs8x3+(B>
;;	-- keisen-beginning-of-line$B4X?t$N%P%0=$@5(B
;;	-- keisen-end-of-line$B4X?t$N%P%0=$@5(B
;;   1994.04.26 13:05 ver 1.97.09    M.Iwamoto		<$BHs8x3+(B>
;;	-- keisen-forward-word-hscroll$B4X?t$NDI2C(B
;;	-- keisen-backward-word-hscroll$B4X?t$NDI2C(B
;;   1994.06.02 16:05 ver 1.97.10    M.Iwamoto		<$BHs8x3+(B>
;;	-- keisen-clear-frame$B4X?t$N%P%0=$@5(B
;;	-- keisen-kill-line$B4X?t$NDI2C(B
;;   1994.11.04 17:30 ver 2.00	     M.Iwamoto(Based by S.Kiyotaka)
;;							<$BHs8x3+(B>
;;      [[ Mule-2.x$BBP1~HG7S@~%b!<%I(B $B&C%j%j!<%9(B ]]
;;   1994.11.09 22:42 ver 2.01       M.Iwamoto		<$BHs8x3+(B>
;;      -- keisen-sync-mode$B4X?t$N%P%0=$@5(B
;;	-- km:sync-reverse-region$B4X?t$N%P%0=$@5(B
;;   1994.12.13 20:35 ver 2.02       M.Iwamoto(Based by T.Furukawa)
;;      -- keisen-half-locked-forward-line$B4X?t$N%P%0=$@5(B
;;
;;
;; Emacs-20 version:
;;   1998.05.08 16:05 Emacs20 version, ver 0.01   A.Anazawa   <$BHs8x3+(B>
;;      -- km:*em20-p* $BJQ?t$rF3F~$7!"(BEmacs20(Meadow)$B$KBP1~(B
;;	-- delete-text-in-column $B$NBeBX4X?t(B km:delete-text-in-column $B$r:n@.(B
;;
;; $B:FG[I[>r7o$O!$>e5-$N$H$*$j!$(BGPL $B$K=>$$$^$9$,!$K\%P!<%8%g%s$OHs>o$K(B
;; $BIT40A4$J$b$N$G$9!%K|$,0l:FG[I[$5$l$k:]$O!$$=$NE@$r==J,$K$*EA$($/$@(B
;; $B$5$k$h$&!$$*4j$$$$$?$7$^$9!%(B-- $B7j_7(B <anazawa@lares.dti.ne.jp>
;;

(setq debug-on-error t)

(defvar running-xemacs (featurep 'xemacs))
(defvar emacs-major-version (string-to-int emacs-version))

(if (>= emacs-major-version 19)
    (progn
      (defvar keisen-inverse-face)
      (copy-face 'modeline 'keisen-inverse-face)
      (defun km:inverse-on-region (sta end)
	(put-text-property sta end 'face 'keisen-inverse-face))
      (defun km:inverse-off-region (sta end)
	(put-text-property sta end 'face 'default))
      (defun km:read-char ()
	(read-char-exclusive)))
  (require 'attribute)
  (defun km:inverse-on-region (sta end)
    (attribute-on-region 'inverse sta end))
  (defun km:inverse-off-region (sta end)
    (attribute-off-region 'inverse sta end))
  (defun km:read-char ()
    (read-char)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $BJQ?t(B
;;
;;(defconst keisen-version "MULE$BHG7S@~%b!<%I(B ver 2.02 \"$B&C%j%j!<%9(B\""
(defconst keisen-version "Emacs20$BHG7S@~%b!<%I(B ver 2.02 \"$B&C%j%j!<%9(B\""
  "$B7S@~%b!<%I%P!<%8%g%sHV9f(B")

(defvar keisen-mode-view-status-flag nil
  "$B7S@~%b!<%I5/F0;~$K%b!<%I>uBV$NI=<(%U%i%0(B
t$B$J$iI=<(!"(Bnil$B$J$iI=<($7$J$$!#(B")

(defvar keisen-text-mode-flag nil
  "$B7S@~%b!<%IMQ$N%F%-%9%H%b!<%I%U%i%0(B($B8=>u(Bnil$B8GDj(B)")

(defvar keisen-auto-line-feed-flag nil
  "$B7S@~OHFb$GJ8;zNs$r<+F02~9T$9$k%U%i%0(B")

(defvar keisen-auto-enlarge-vertically-flag nil
  "$B7S@~OHFb$GJ8;zNs$,F~$j$-$i$J$+$C$?>l9g!"=DJ}8~$X<+F03HD%$9$k%U%i%0(B
keisen-auto-line-feed-flag$B$,(Bnil$B$N$H$-$OL58z(B")

(defvar keisen-auto-enlarge-horizontally-flag nil
  "$B7S@~OHFb$GJ8;zNs$,F~$j$-$i$J$+$C$?>l9g!"2#J}8~$X<+F03HD%$9$k%U%i%0(B
keisen-auto-line-feed-flag$B$,(Bt$B$N$H$-$OL58z(B")

(defvar keisen-move-mode nil ; Based by S.Kobayashi
  "$B%+!<%=%k0\F0%b!<%I(B
t$B$J$i7S@~$rHt$SD6$($F%+!<%=%k$r0\F0!"(Bnil$B$J$iL5>r7o$K%+!<%=%k$r0\F0$9$k(B")

(defvar keisen-move-stop nil ; 94.04.18 by M.I
  "$B%+!<%=%k0\F0%9%H%C%W%b!<%I(B
t$B$J$i:G=*%i%$%s$G%+!<%=%k$,Dd;_!"(Bnil$B$J$iL5>r7o$K%+!<%=%k$r0\F0$9$k(B")

(defvar keisen-move-level 0
  "$B%+!<%=%k0\F0%l%Y%k(B
0$B$J$i2hLL$NC<$X!"(B1$B$J$i3FOH$NC<$X!"(B2$B$J$iJ8;zNs$NC<$X0\F0$9$k(B" )

(defvar keisen-status-display-interval-time 2
  "$B7S@~%b!<%I>uBVI=$NI=<(;~4V(B")

(defvar keisen-mode-hook nil
  "$B7S@~%b!<%I$N%U%C%/(B")

(defvar keisen-mode-map nil
  "$B7S@~%b!<%I$N%-!<%^%C%W(B")

(defvar keisen-extend-regexp-flag nil
  "extend$B%3%^%s%I$N@55,I=8=$r7hDj$9$k(Bflag
nil$B$N$H$-$9$Y$F$N7S@~!"#1$N$H$-:Y$$7S@~!"#2$N$H$-B@$$7S@~(B")

(defvar keisen-vertical-move-count 0
  "$B?bD>J}8~$N0\F0NL(B")

(defvar keisen-horizontal-move-count 1
  "$B?eJ?J}8~$N0\F0NL(B")

(defconst keisen-draw-force nil
  "nil$B$N$H$-:Y$$7S@~$OB@$$7S@~$K4^$^$l$k(B
non-nil$B$N$H$-B@$$7S@~$N>e$K:Y$$7S@~$r0z$/$H:Y$$7S@~$,=q$+$l$k(B")

(defconst keisen-adjust-column-force t
  "nil$B$N$H$-$O7S@~%3%^%s%I$r;H$C$?$H$-%+%i%`%A%'%C%/$r$7$J$$(B
non-nil$B$N$H$-6/@)E*$K%]%$%s%H$N%+%i%`?t$,6v?t$K%]%$%s%H$r0\F0$5$;$k(B")

(defvar keisen-lock nil
  "non-nil$B$N$H$-A^F~!">C5n!":o=|$H$b$K7S@~$r1[$($k$3$H$O$G$-$J$$(B")

(defvar keisen-width 1
  "$B7S@~$NB@$5(B 0$B$N$H$->C5n!"(B1$B$N$H$-:Y@~!"(B2$B$N$H$-B@@~(B")

(defvar keisen-overwrite-mode nil
  "$B7S@~%b!<%I$NCf$G$N%*!<%P!<%i%$%H%b!<%I$+$I$&$+$N%U%i%C%0(B
nil$B$J$i%$%s%5!<%H%b!<%I!"(Bnon-nil$B$J$i%*!<%P!<%i%$%H%b!<%I(B")

(defvar keisen-key-flag nil ; Based by T.Sakano
  "$B7S@~$NIA2h%-!<%U%i%0(B
nil$B$J$i%+!<%=%k%-!<!"(Bnon-nil$B$J$i(BM-[pnbf]$B%-!<$rIA2h$K;HMQ$9$k!#(B")

(defvar keisen-old-local-map)
(defvar keisen-old-mode-name)
(defvar keisen-old-major-mode)
(defvar keisen-old-overwrite-mode)
(defvar keisen-old-keyboard-coding-system nil)
(if (>= emacs-major-version 19)
    (defvar keisen-old-auto-fill-function)
  (defvar keisen-old-auto-fill-hook))
(defvar keisen-old-self-insert-after-hook)
(defvar keisen-old-indent-tabs-mode)

(defconst keisen-right 1)
(defconst keisen-up    2)
(defconst keisen-left  4)
(defconst keisen-down  8)

(defconst keisen-table "\
$B!!!!!!(&!!(!(%(*!!(#("('($((()(+(B\
$B!!!!(&(&(!(!(*(*(#(#(<(<(((((+(+(B\
$B!!(&!!(&(%(?(%(?("('("('()(+()(+(B\
$B(1(1(1(1(?(?(?(?(<(<(<(<(+(+(+(+(B\
$B!!(!(%(*!!(!(%(*($(((>(+($(((>(+(B\
$B(,(,(:(:(,(,(:(:(8(8(;(;(8(8(;(;(B\
$B(0(?(0(?(0(?(0(?(?(>(>(+(>(+(>(+(B\
$B(5(5(5(5(5(5(5(5(;(;(;(;(;(;(;(;(B\
$B!!(#("('($(=()(+!!(#("('($(=()(+(B\
$B(.(.(<(<(=(=(+(+(.(.(<(<(=(=(+(+(B\
$B(-(7(-(7(9(@(9(@(-(7(-(7(9(@(9(@(B\
$B(2(2(2(2(@(@(@(@(2(2(2(2(@(@(@(@(B\
$B(/(=(>(+(/(=(>(+(/(=(>(+(/(=(>(+(B\
$B(3(3(;(;(3(3(;(;(3(3(;(;(3(3(;(;(B\
$B(4(@(4(@(4(@(@(@(4(@(4(@(4(@(@(@(B\
$B(6(6(6(6(6(6(6(6(6(6(6(6(6(6(6(6(B"
  "$B7S@~%-%c%i%/%?$N3FJ}8~$N;^$NM-L5$r(B8$B%S%C%H$GI=8=$9$k(B.
$B%$%s%G%C%/%9$N>e0L(B4$B%S%C%H$OB@$$@~$NM-L5$r<($7!"2<0L(B4$B%S%C%H$,:Y$$@~$NM-L5$r<($9(B.
($B2<:8>e1&(B)")

(defconst keisen-unit-length (length (char-to-string (sref keisen-table 0)))
  "$B7S@~AGJR$N%P%$%H?t(B")

(defconst keisen-regexp
  "[$B(!("(#($(%(&('((()(*(+(,(-(.(/(0(1(2(3(4(5(6(7(8(9(:(;(<(=(>(?(@(B]"
  "$B7S@~H=JL$N@55,I=8=(B")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B%-!<%P%$%s%G%#%s%0(B
;;
(if keisen-mode-map
    nil
  (setq keisen-mode-map (make-keymap))
  (define-key keisen-mode-map "\C-f"     'keisen-forward-char-hscroll)
  (define-key keisen-mode-map "\C-b"     'keisen-backward-char-hscroll)
  (define-key keisen-mode-map "\C-p"     'keisen-previous-line)
  (define-key keisen-mode-map "\C-n"     'keisen-next-line)
  (define-key keisen-mode-map "\C-a"     'keisen-beginning-of-line)
  (define-key keisen-mode-map "\C-e"     'keisen-end-of-line)
  (define-key keisen-mode-map "\C-m"     'keisen-newline)
; (define-key keisen-mode-map "\C-j"     'keisen-locked-forward-line)
  (define-key keisen-mode-map "\C-j"     'keisen-locked-forward-line-ext)
  (define-key keisen-mode-map "\177"     'keisen-clear-backward-char)
  (define-key keisen-mode-map "\C-d"     'keisen-clear-char)
  (define-key keisen-mode-map "\C-k"     'keisen-clear-line)
; (define-key keisen-mode-map "\C-o"     'undefined)
  (define-key keisen-mode-map "\C-w"     'undefined)
  (define-key keisen-mode-map "\C-y"     'keisen-yank)
; (define-key keisen-mode-map "\ef"      'keisen-draw-right)
; (define-key keisen-mode-map "\eb"      'keisen-draw-left)
; (define-key keisen-mode-map "\ep"      'keisen-draw-up)
; (define-key keisen-mode-map "\en"      'keisen-draw-down)
  (define-key keisen-mode-map "\er"      'keisen-square-line)
  (define-key keisen-mode-map "\es"      'keisen-square-line2)
  (define-key keisen-mode-map "\eh"      'keisen-rectangle)
  (define-key keisen-mode-map "\ew"      'keisen-toggle-width)
  (define-key keisen-mode-map "\e\040"   'keisen-insert-blank)
  (define-key keisen-mode-map "\C-c\040" 'keisen-insert-blank)
  (define-key keisen-mode-map "\C-ck"    'zenkaku-space-region)
  (define-key keisen-mode-map "\C-cv"    'keisen-enlarge-vertically)
  (define-key keisen-mode-map "\C-ch"    'keisen-enlarge-horizontally)
  (define-key keisen-mode-map "\C-c\C-v" 'keisen-shrink-vertically)
  (define-key keisen-mode-map "\C-c\C-h" 'keisen-shrink-horizontally)
  (define-key keisen-mode-map "\C-cf"    'keisen-extend-right)
  (define-key keisen-mode-map "\C-cb"    'keisen-extend-left)
  (define-key keisen-mode-map "\C-cp"    'keisen-extend-up)
  (define-key keisen-mode-map "\C-cn"    'keisen-extend-down)
  (define-key keisen-mode-map "\C-co"    'keisen-overwrite-mode)
  (define-key keisen-mode-map "\C-cc"    'keisen-clean)
  (define-key keisen-mode-map "\C-c\C-c" 'keisen-mode-exit)
  (define-key keisen-mode-map "\e\\"     'keisen-key-mode)
  (define-key keisen-mode-map "\C-ce"    'keisen-toggle-auto-enlarge)
  (define-key keisen-mode-map "\C-cj"    'keisen-toggle-auto-line-feed)
  (define-key keisen-mode-map "\C-cl"    'keisen-toggle-line)
  (define-key keisen-mode-map "\C-cm"    'keisen-toggle-move)
  (define-key keisen-mode-map "\C-@"     'keisen-set-mark)
  (if (>= emacs-major-version 19)
      (define-key keisen-mode-map [?\C-\ ]   'keisen-set-mark))
  (define-key keisen-mode-map "\t"       'keisen-picture-tab)
  (define-key keisen-mode-map "\C-c<"    'keisen-movement-left)
  (define-key keisen-mode-map "\C-c>"    'keisen-movement-right)
  (define-key keisen-mode-map "\C-c^"    'keisen-movement-up)
  (define-key keisen-mode-map "\C-c."    'keisen-movement-down)
  (define-key keisen-mode-map "\C-c`"    'keisen-movement-nw)
  (define-key keisen-mode-map "\C-c'"    'keisen-movement-ne)
  (define-key keisen-mode-map "\C-c/"    'keisen-movement-sw)
  (define-key keisen-mode-map "\C-c\\"   'keisen-movement-se)
  (define-key keisen-mode-map "\C-c["    'keisen-sync-mode)
  (define-key keisen-mode-map "\C-c]"    'keisen-sync-mode-exit)
  (define-key keisen-mode-map "\C-c-"    'keisen-sync-change-region)
  ;CTRL-O$B%^%C%W(B
  (setq keisen-ctlo-map (make-keymap))
  (fset 'ctl-o-prefix keisen-ctlo-map)
  (define-key keisen-mode-map "\C-o"     'ctl-o-prefix)
  (define-key keisen-mode-map "\C-om"    'keisen-status)
  (define-key keisen-mode-map "\C-or"    'keisen-right-line)
  (define-key keisen-mode-map "\C-ol"    'keisen-left-line)
  (define-key keisen-mode-map "\C-oc"    'keisen-center-line)
  (define-key keisen-mode-map "\C-oj"    'keisen-change-locked-forward-after)
  (define-key keisen-mode-map "\C-o\C-k" 'keisen-kill-rectangle)
  (define-key keisen-mode-map "\C-o\C-y" 'keisen-yank-rectangle)
  (define-key keisen-mode-map "\C-o\C-f" 'keisen-forward-jump-frame)
  (define-key keisen-mode-map "\C-o\C-b" 'keisen-backward-jump-frame)
  (define-key keisen-mode-map "\C-o\C-p" 'keisen-previous-jump-frame)
  (define-key keisen-mode-map "\C-o\C-n" 'keisen-next-jump-frame)
  (define-key keisen-mode-map "\C-of"    'keisen-clear-frame)
  (define-key keisen-mode-map "\C-od"    'keisen-clear-keisen)
  (define-key keisen-mode-map "\C-ok"    'keisen-kill-line)
  (define-key keisen-mode-map "\C-o\C-h" 'keisen-line-horizontally)
  (define-key keisen-mode-map "\C-o\C-v" 'keisen-line-vertically)
  (define-key keisen-mode-map "\C-o\C-d" 'keisen-arrow-down)
  (define-key keisen-mode-map "\C-o\C-u" 'keisen-arrow-up)
  (define-key keisen-mode-map "\C-o\C-r" 'keisen-arrow-right)
  (define-key keisen-mode-map "\C-o\C-l" 'keisen-arrow-left)
  )

(defun keisen-key-mode () ;-- Based by T.Sakano -------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$rIA$/%-!<$rJQ99$9$k!#(B
 keisen-key-flag$B$,(Bnil$B$J$i$P!"%+!<%=%k%-!<(B
                    t$B$J$i$P!"(BM-[pnbf]$B%-!<$rIA2h$K;HMQ$9$k!#(B"
  (interactive)
  (setq keisen-key-flag (not keisen-key-flag))
  (if keisen-key-flag
      (progn
        ;$B%+!<%=%k0\F0(B
	(if (>= emacs-major-version 19)
	    (progn
	      (define-key keisen-mode-map [right] 'keisen-forward-char-hscroll)
	      (define-key keisen-mode-map [left] 'keisen-backward-char-hscroll)
	      (define-key keisen-mode-map [up] 'keisen-previous-line)
	      (define-key keisen-mode-map [down] 'keisen-next-line))
	  (define-key keisen-mode-map "\eOC" 'keisen-forward-char-hscroll)
	  (define-key keisen-mode-map "\eOD" 'keisen-backward-char-hscroll)
	  (define-key keisen-mode-map "\eOA" 'keisen-previous-line)
	  (define-key keisen-mode-map "\eOB" 'keisen-next-line)
	  (define-key keisen-mode-map "\e[C" 'keisen-forward-char-hscroll)
	  (define-key keisen-mode-map "\e[D" 'keisen-backward-char-hscroll)
	  (define-key keisen-mode-map "\e[A" 'keisen-previous-line)
	  (define-key keisen-mode-map "\e[B" 'keisen-next-line))
        ;$B7S@~IA2h(B
        (define-key keisen-mode-map "\ef"  'keisen-draw-right)
        (define-key keisen-mode-map "\eb"  'keisen-draw-left)
        (define-key keisen-mode-map "\ep"  'keisen-draw-up)
        (define-key keisen-mode-map "\en"  'keisen-draw-down)
        (message  "$BIA2h$K(BM-[pnbf]$B%-!<$r;HMQ$7$^$9(B"))
    ;$B7S@~IA2h(B
    (if (>= emacs-major-version 19)
	(progn
	  (define-key keisen-mode-map [right] 'keisen-draw-right)
	  (define-key keisen-mode-map [left] 'keisen-draw-left)
	  (define-key keisen-mode-map [up] 'keisen-draw-up)
	  (define-key keisen-mode-map [down] 'keisen-draw-down))
      (define-key keisen-mode-map "\eOC" 'keisen-draw-right)
      (define-key keisen-mode-map "\eOD" 'keisen-draw-left)
      (define-key keisen-mode-map "\eOA" 'keisen-draw-up)
      (define-key keisen-mode-map "\eOB" 'keisen-draw-down)
      (define-key keisen-mode-map "\e[C" 'keisen-draw-right)
      (define-key keisen-mode-map "\e[D" 'keisen-draw-left)
      (define-key keisen-mode-map "\e[A" 'keisen-draw-up)
      (define-key keisen-mode-map "\e[B" 'keisen-draw-down))
    ;$B%+!<%=%k0\F0(B
    (define-key keisen-mode-map "\ef"  'keisen-forward-char-hscroll)
    (define-key keisen-mode-map "\eb"  'keisen-backward-char-hscroll)
    (define-key keisen-mode-map "\ep"  'keisen-previous-line)
    (define-key keisen-mode-map "\en"  'keisen-next-line)
    (message "$BIA2h$K%+!<%=%k%-!<$r;HMQ$7$^$9(B")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B0\F05!G=(B
;;
(defun keisen-locked-forward-line () ;-----------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$rHt$S1[$($J$$HO0O$G2~9T$9$k(B.
 $B$^$:2<$K$$$C$F$+$i7S@~$K$V$D$+$k$^$G:8$K$$$/(B.
 $B2~9T$G$-$?$i(Bt$B!"$G$-$J$+$C$?$i(Bnil$B$rJV$9(B."
  (interactive)
  (while (and (looking-at keisen-regexp) (not (bolp))) ;$B7S@~>e$+$i$NC&=P(B
    (backward-char))
  (let ((col (current-column))
        (pos (point)))
    (forward-line 1)
    (or (= col (move-to-column col)) (forward-char -1))
    (if (looking-at keisen-regexp)
        (goto-char pos))
    (if (re-search-backward keisen-regexp (km:bol) t)
        (goto-char (match-end 0))
      (beginning-of-line))
    (= (count-lines pos (point)) 2)))                  ;$BJV$9CM(B(t,nil)

(defun keisen-half-locked-forward-line () ;------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B=DJ}8~$N7S@~$rHt$S1[$($J$$HO0O$G2~9T$9$k(B.
 $B7S@~$G$J$$$H$3$m$^$G2<$K$$$-7S@~$K$V$D$+$k$^$G:8$K$$$/(B."
  (interactive)
  (while (and (looking-at keisen-regexp) (not (bolp))) ;$B7S@~>e$+$i$NC&=P1&$X(B
    (backward-char))
  (let ((col (current-column))
        flag)
    (while (and (setq flag (= (forward-line 1) 0))     ;$B7S@~>e$+$i$NC&=P2<$X(B
                (progn (move-to-column col) (looking-at keisen-regexp))))
    (cond ((not flag)
;           (end-of-buffer)
           (goto-char (point-max))	; Patched by T.Furukawa
           (newline))
          ((re-search-backward keisen-regexp (km:bol) t)
           (goto-char (match-end 0)))
          (t
           (beginning-of-line)))))

(defvar km:locked-forward-after 'nomal) ;-- Based by M.Ozawa ------------------

(defun keisen-locked-forward-line-ext () ;-- Based by M.Ozawa -----------------
  "[$B7S@~%b!<%I5!G=(B]
 "
  (interactive)
  (if (keisen-locked-forward-line)
      (keisen-previous-line) nil)
  (if (km:point-check)
      (progn (cond ((eq km:locked-forward-after 'nomal)
		    nil)
		   ((eq km:locked-forward-after 'left)
		    (keisen-left-line))
		   ((eq km:locked-forward-after 'right)
		    (keisen-right-line))
		   ((eq km:locked-forward-after 'center)
		    (keisen-center-line)))
	     (keisen-locked-forward-line))
    (keisen-locked-forward-line)))

(defun km:point-check () ;-- Based by M.Ozawa ---------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 "
  (save-excursion
    (skip-chars-forward " ")
    (if (looking-at km:vertically-regexp) nil t)))

(defun keisen-change-locked-forward-after () ;-- Based by M.Ozawa -------------
  "[$B7S@~%b!<%I5!G=(B]
 "
  (interactive)
  (setq km:locked-forward-after
	(intern (completing-read
		 "locked forward after: "
		 '(("nomal") ("left") ("right") ("center")) nil t))))

; DELETE 1992.10.01
;(defun keisen-end-of-line (&optional arg) ;-----------------------------------
;  "Position point after last non-blank character on current line.
;With ARG not nil, move forward ARG - 1 lines first.
;If scan reaches end of buffer, stop there without error.
;$B%]%$%s%H$r%+%l%s%H%i%$%s$G6uGr$G$J$$0lHV:G8e$N%-%c%i%/%?!<$K0\F0$5$;$k(B"
;  (interactive "P")
;  (if arg (forward-line (1- (prefix-numeric-value arg))))
;  (beginning-of-line)
;  (skip-chars-backward "$B!!(B \t" (km:eol)))

(defun keisen-forward-word-hscroll (&optional arg) ;---------------------------
  (interactive "*p")
  (forward-word arg)
  (if (and truncate-lines
	   (>= (- (current-column) (window-hscroll))
	       (- (window-width) 4)))
      (scroll-left (+ (- (current-column)
			 (+ (window-hscroll) (window-width))) 4)))
  (if (and truncate-lines
	   (< (- (current-column) (window-hscroll)) 0))
      (scroll-right (+ (- (window-hscroll) (current-column)) 4))))


(defun keisen-backward-word-hscroll (&optional arg) ;--------------------------
  (interactive "*p")
  (backward-word arg)
  (if (and truncate-lines
	   (< (- (current-column) (window-hscroll)) 0))
      (scroll-right (+ (- (window-hscroll) (current-column)) 4)))
  (if (and truncate-lines
	   (>= (- (current-column) (window-hscroll))
	       (- (window-width) 4)))
      (scroll-left (+ (- (current-column)
			 (+ (window-hscroll) (window-width))) 4))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B0\F05!G=(B [picture.el$B$h$jH4?h(B]
;;
(defun km:move-to-column-force (column &optional force) ;-- Based by K.Handa --
  "[$B7S@~%b!<%I4X?t(B]
 $B%]%$%s%H$r(Bcolumn$B$K0\F0$5$;$k(B.$B0\F0$G$-$J$$$H$-$O%?%V$r%9%Z!<%9$KCV$-49$($?$j(B
$B9TKv$K%9%Z!<%9$rA^F~$7$?$j$7$F0\F0$5$;$k(B.$B$b$7(Bforce$B$,(Bnon-nil$B$G(Bcolumn$B$,4A;z%3(B
$B!<%I$N#2%P%$%HL\$J$i4A;z$rH>3Q%9%Z!<%9#2$D$KCV$-49$($k(B"
  (if (and (/= (move-to-column column t) column) force)
      (let ((w (char-width (char-before (point)))))
	(delete-char -1)
	(insert (make-string w ? ))
	(move-to-column column))))

(defun km:picture-move-down (arg &optional force) ;-- Based by K.Handa --------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+!<%=%k$r2<$X0\F0$5$k!#$b$7!"0\F0@h$,$J$1$l$P6uGr$rA^F~$7$F0\F0$9$k(B.
 $B0z?t(Barg $B$,$"$?$($i$l$?$J$i$P!"$=$N;XDj%i%$%s?tJ,2<$X0\F0$9$k(B."
  (let ((col (current-column)))
    (km:picture-newline arg)
    (km:move-to-column-force col force)))

(defun km:picture-move-up (arg) ;----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+!<%=%k$r>e$X0\F0$5$k!#$b$7!"0\F0@h$,$J$1$l$P6uGr$rA^F~$7$F0\F0$9$k(B.
 $B0z?t(Barg $B$,$"$?$($i$l$?$J$i$P!"$=$N;XDj%i%$%s?tJ,>e$X0\F0$9$k(B."
  (km:picture-move-down (- arg)))

(defun km:picture-forward-column (arg &optional force) ;-- Based by K.Handa ---
  "[$B7S@~%b!<%I4X?t(B]
 $B%+!<%=%k$r1&$X0\F0$5$k!#$b$7!"%+%l%s%H0LCV$,(B (eolp) $B$J$i$P6uGr$rA^F~$7$F0\F0(B
$B$9$k(B.$B0z?t(Barg $B$,$"$?$($i$l$?$J$i$P!"$=$N;XDj%+%i%`?tJ,1&$X0\F0$9$k(B."
  (let ((prev-clm (current-column)))
    (km:move-to-column-force (+ prev-clm arg) force)
    (if (and (/= arg 0) (= prev-clm (current-column)))
        (km:move-to-column-force (+ prev-clm (1+ arg))))))

(defun km:picture-backward-column (arg) ;--------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+!<%=%k$r:8$X0\F0$5$k!#(B
 $B0z?t(Barg $B$,$"$?$($i$l$?$J$i$P!"$=$N;XDj%+%i%`?tJ,:8$X0\F0$9$k(B."
  (km:move-to-column-force (- (current-column) arg)))

(defun km:picture-newline (arg) ;----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B2~9T$9$k(B.$B0z?t(Barg $B$,$"$?$($i$l$?$J$i$P!"$=$N;XDj?tJ,2~9T$9$k(B."
  (if (< arg 0)
      (forward-line arg)
    (while (> arg 0)
      (end-of-line)
      (if (eobp)
          (newline)
        (forward-char 1))
      (setq arg (1- arg)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B0\F0(B($B%?%V(B)$B5!G=(B [picture.el$B$h$jH4?h(B]
;;
(defvar keisen-picture-tab-chars "!-~"
  "*A character set which controls behavior of commands
\\[keisen-picture-set-tab-stops] and \\[keisen-picture-tab-search].  It is NOT a
regular expression, any regexp special characters will be quoted.
It defines a set of \"interesting characters\" to look for when setting
\(or searching for) tab stops, initially \"!-~\" (all printing characters).
For example, suppose that you are editing a table which is formatted thus:
| foo           | bar + baz | 23  *
| bubbles       | and + etc | 97  *
and that keisen-picture-tab-chars is \"|+*\".  Then invoking
\\[keisen-picture-set-tab-stops] on either of the previous lines would result
in the following tab stops
                :     :     :     :
Another example - \"A-Za-z0-9\" would produce the tab stops
  :               :     :     :

Note that if you want the character `-' to be in the set, it must be
included in a range or else appear in a context where it cannot be
taken for indicating a range (e.g. \"-A-Z\" declares the set to be the
letters `A' through `Z' and the character `-').  If you want the
character `\\' in the set it must be preceded by itself: \"\\\\\".

The command \\[keisen-picture-tab-search] is defined to move beneath (or to) a
character belonging to this set independent of the tab stops list.")

(defun keisen-picture-set-tab-stops (&optional arg) ;--------------------------
  "[$B7S@~%b!<%I5!G=(B]
 Set value of  tab-stop-list  according to context of this line.
This controls the behavior of \\[keisen-picture-tab].  A tab stop
is set at every column occupied by an \"interesting character\" that is
preceded by whitespace.  Interesting characters are defined by the
variable  keisen-picture-tab-chars,  see its documentation for an example
of usage.  With ARG, just (re)set  tab-stop-list  to its default value.
The tab stops computed are displayed in the minibuffer with `:' at
each stop."
  (interactive "P")
  (save-excursion
    (let (tabs)
      (if arg
          (setq tabs (default-value 'tab-stop-list))
        (let ((regexp
               (concat "[ \t]+[" (regexp-quote keisen-picture-tab-chars) "]")))
          (beginning-of-line)
          (let ((bol (point)))
            (end-of-line)
            (while (re-search-backward regexp bol t)
              (skip-chars-forward " \t")
              (setq tabs (cons (current-column) tabs)))
            (if (null tabs)
                (error "No characters in set %s on this line."
                       (regexp-quote keisen-picture-tab-chars))))))
      (setq tab-stop-list tabs)
      (let ((blurb (make-string (1+ (nth (1- (length tabs)) tabs)) ?\ )))
        (while tabs
          (aset blurb (car tabs) ?:)
          (setq tabs (cdr tabs)))
        (message blurb)))))

(defun keisen-picture-tab-search (&optional arg) ;-----------------------------
  "[$B7S@~%b!<%I5!G=(B]
 Move to column beneath next interesting char in previous line.
With ARG move to column occupied by next interesting character in this
line.  The character must be preceded by whitespace.
\"interesting characters\" are defined by variable  keisen-picture-tab-chars.
If no such character is found, move to beginning of line."
  (interactive "P")
  (let ((target (current-column)))
    (save-excursion
      (if (and (not arg)
               (progn
                 (beginning-of-line)
                 (skip-chars-backward
                  (concat "^" (regexp-quote keisen-picture-tab-chars))
                  (point-min))
                 (not (bobp))))
          (move-to-column target))
      (if (re-search-forward
           (concat "[ \t]+[" (regexp-quote keisen-picture-tab-chars) "]")
           (save-excursion (end-of-line) (point))
           'move)
          (setq target (1- (current-column)))
        (setq target nil)))
    (if target
        (km:move-to-column-force target)
      (beginning-of-line))))

(defun keisen-picture-tab (&optional arg) ;------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 Tab transparently (move) to next tab stop.
With ARG overwrite the traversed text with spaces.  The tab stop
list can be changed by \\[keisen-picture-set-tab-stops] and \\[edit-tab-stops].
See also documentation for variable  keisen-picture-tab-chars."
  (interactive "P")
  (let* ((opoint (point))
         (target (prog2 (tab-to-tab-stop)
                        (current-column)
                        (delete-region opoint (point)))))
    (km:move-to-column-force target)
    (if arg
        (let (indent-tabs-mode)
          (delete-region opoint (point))
          (indent-to target)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B0\F05!G=DI2C(B $B!](B 1992.10.01
;;
(defun keisen-next-line () ;-- Based by S.Kobayashi ---------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%+!<%=%k$r2<$X0\F0$9$k(B.
 keisen-move-mode$B$,(B  t$B$N;~!"7S@~$rHt$SD6$($F0\F0$9$k(B.
                   nil$B$N;~!"L5>r7o$K<!$N9T$X0\F0$9$k(B."
  (interactive)
  (if (and keisen-move-stop (km:eoblp)) ; 94.04.18 by M.I
      nil
    (if truncate-lines           ;
	(km:picture-move-down 1) ; 1993.10.15 by M.Iwamoto
      (km:next-window-line 1)))  ;
  (if keisen-move-mode
      (while (and (looking-at "[$B(!(,(B]") (not (bolp)))
        (if truncate-lines                  ;
            (km:picture-move-down 1)    ; 1993.10.15 by M.Iwamoto
          (km:next-window-line 1)))))       ;

(defun keisen-previous-line () ;-- Based by S.Kobayashi -----------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%+!<%=%k$r>e$X0\F0$9$k(B.
 keisen-move-mode$B$,(B  t$B$N;~!"7S@~$rHt$SD6$($F0\F0$9$k(B.
                   nil$B$N;~!"L5>r7o$KA0$N9T$X0\F0$9$k(B."
  (interactive)
  (if truncate-lines                ;
      (km:picture-move-up 1)    ; 1993.10.15 by M.Iwamoto
    (km:previous-window-line 1))    ;
  (if keisen-move-mode
      (let ((end t))
        (while (and (looking-at "[$B(!(,(B]") (not (bolp)) end)
          (if truncate-lines                ;
              (km:picture-move-up 1)    ; 1993.10.15 by M.Iwamoto
            (km:previous-window-line 1))    ;
          (if (= (km:what-current-line) 1)
              (setq end nil))))))

(defun km:next-window-line (n) ;-----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+!<%=%k$r2<$K0\F0$9$k(B.
 truncate-lines$B$,(Bnil$B$N;~!"(B(window-width)$B0J>e$NJ8;zNs$,$"$k$H<!$N9T$X$D$E$1$F(B
$BI=<($5$l$k(B.$BDL>o!"%+!<%=%k$r0\F0$9$k$H$3$N9T$OHt$S$3$5$l$F$7$^$&(B.
 $B$=$l$r!"%S%8%e%"%kE*$K<!$N9T$H$J$k0LCV$X%+!<%=%k$r0\F0$9$k(B."
  (let ((cur_col (- (current-column)
                    (save-excursion (vertical-motion 0) (current-column)))))
    (if (not (km:eoblp))
        (vertical-motion n)
      (vertical-motion 0)
      (km:picture-newline n))
    (km:move-to-column-force (+ (current-column) cur_col))))

(defun km:previous-window-line (n) ;-------------------------------------------
   "[$B7S@~%b!<%I4X?t(B]
 $B%+!<%=%k$r>e$K0\F0$9$k(B.
 truncate-lines$B$,(Bnil$B$N;~!"(B(window-width)$B0J>e$NJ8;zNs$,$"$k$H<!$N9T$X$D$E$1$F(B
$BI=<($5$l$k(B.$BDL>o!"%+!<%=%k$r0\F0$9$k$H$3$N9T$OHt$S$3$5$l$F$7$^$&(B.
 $B$=$l$r!"%S%8%e%"%kE*$K<!$N9T$H$J$k0LCV$X%+!<%=%k$r0\F0$9$k(B."
   (let ((cur_col (- (current-column)
                     (save-excursion (vertical-motion 0) (current-column)))))
     (vertical-motion (- n))
     (km:move-to-column-force (+ (current-column) cur_col))))

(defun keisen-beginning-of-line () ;-- Based by S.Kobayashi -------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%+%l%s%H9T$N$=$l$>$l$N@hF,$X%+!<%=%k$r0\F0$9$k(B.
 keisen-move-level$B$,(B0$B$N;~$O!"%+%l%s%H9T$N@hF,$X0\F0$9$k(B.
                    1$B$N;~$O!"%+%l%s%H%]%$%s%H$K6a$$7S@~$X0\F0$9$k(B.$B$?$@$7!"4{$K(B
                             $B%+%l%s%H%]%$%s%H$N$9$0:8NY$K7S@~$,$"$C$?>l9g$O$=(B
                             $B$l$rHt$S1[$($k(B.
                    2$B$N;~$O!"J8;zNs$N@hF,$X0\F0$9$k(B.$B3:Ev$9$kJ8;zNs$,L5$$>l9g$O(B
                             keisen-move-level$B$,(B1$B$N;~$HF1MM(B.
 $B%+%l%s%H%]%$%s%H$,4{$K9T$N@hF,$N>l9g$O!"$J$K$b$7$J$$(B."
  (interactive)
  (if (= keisen-move-level 0)
      (km:beginning-of-line-hscroll)
    (let ((sta-pos (point)) cur-pos)
      (if (bolp)
          nil
        (km:beginning-of-line)
        (if (= sta-pos (point))
            (progn (keisen-backward-char-hscroll 1)
                   (km:beginning-of-line)))
        (if (= keisen-move-level 2)
            (progn (setq cur-pos (point))
                   (while (and (looking-at "[ $B!!(B]") (not (bolp)))
                     (keisen-forward-char-hscroll 1))
                   (if (and (> sta-pos (point))
                            (looking-at "[^$B("('(-(2(7(<()(4(9(>(B]"))
                       nil
                     (goto-char cur-pos))))))))

(defun keisen-end-of-line () ;-- Based by S.Kobayashi -------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%+%l%s%H9T$N$=$l$>$l$N:G8e$X%+!<%=%k$r0\F0$9$k(B.
 keisen-move-level$B$,(B0$B$N;~$O!"%+%l%s%H9T$N:G8e$X0\F0$9$k(B.
                    1$B$N;~$O!"%+%l%s%H%]%$%s%H$K6a$$7S@~$X0\F0$9$k(B.$B$?$@$7!"4{$K(B
                             $B%+%l%s%H%]%$%s%H$N$9$01&NY$K7S@~$,$"$C$?>l9g$O$=(B
                             $B$l$rHt$S1[$($k(B.
                    2$B$N;~$O!"J8;zNs$N:G8e$X0\F0$9$k(B.$B3:Ev$9$kJ8;zNs$,L5$$>l9g$O(B
                             keisen-move-level$B$,(B1$B$N;~$HF1MM(B.
 $B%+%l%s%H%]%$%s%H$,4{$K9T$N:G8e$N>l9g$O!"$J$K$b$7$J$$(B."
  (interactive)
  (if (= keisen-move-level 0)
      (km:end-of-line-hscroll)
    (let ((sta-pos (point)) cur-pos)
      (if (eolp)
          nil
        (km:end-of-line)
        (if (= sta-pos (point))
            (progn (keisen-forward-char-hscroll 1)
                   (km:end-of-line)))
        (if (= keisen-move-level 2)
            (progn (setq cur-pos (point))
                   (while (and (looking-at "[ $B!!(B]") (not (eolp)))
                     (keisen-backward-char-hscroll 1))
                   (if (and (< sta-pos (point))
                            (looking-at "[^$B("('(-(2(7(<()(4(9(>(B]"))
                       nil
                     (goto-char cur-pos))))))))

(defun km:beginning-of-line () ;-- Changed by M.Ozawa -------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%HOHFb$N@hF,$X%+!<%=%k$r0\F0$9$k(B."
  (let* (pos (point))
    (if (bolp)
	nil
      (if (looking-at "[$B("()(-(4(9(>('(2(7(<(B]")
	  (keisen-backward-char-hscroll 1))
      (while (and (or (looking-at "[^$B("()(-(4(9(>('(2(7(<(B]") (eobp))
		  (not (bolp)))
	(keisen-backward-char-hscroll 1))
      (if (looking-at "[$B("()(-(4(9(>('(2(7(<(B]")
	  (keisen-forward-char-hscroll 1))
      (if (eq pos (point))
	  (keisen-backward-char-hscroll 1))
      )))

(defun km:end-of-line () ;-- Chenged by M.Ozawa -------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%HOHFb$N:G8e$X%+!<%=%k$r0\F0$9$k(B."
  (if (looking-at "[$B("()(-(4(9(>('(2(7(<(B]")
      (keisen-forward-char-hscroll 1))
  (while (and (looking-at "[^$B("()(-(4(9('(-(2(7(<(B]") (not (eolp)))
    (keisen-forward-char-hscroll 1))
  (if (not (eolp))
      (keisen-backward-char-hscroll 1)))

(defun keisen-forward-char-hscroll (arg) ;-------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~%b!<%I$G%+!<%=%k$r1&$X0\F0$7$?;~$K%&%#%s%I%&$r%*!<%P!<$7$?$i!"1&$X<+F0E*(B
$B$K?eJ?%9%/%m!<%k$9$k(B.
 $B$?$@$7!"(Btruncate-lines$B$,(Bt$B$N;~$N$_$G$"$k(B."
  (interactive "p")
  (if (eq truncate-lines nil)
      (km:picture-forward-column arg nil)
    (progn
      (if (>= (- (+ (current-column) arg) (window-hscroll))
              (- (window-width) 4)) ; patch 92.09.25 "2 -> 4"
          (scroll-left (+ arg 10))) ; patch 92.09.25 "arg -> (+ arg 10)"
      (km:picture-forward-column arg nil)
      ;$B"-"-"-"-"-(B
      (km:sync-hscroll))))

(defun keisen-backward-char-hscroll (arg) ;------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~%b!<%I$G%+!<%=%k$r:8$X0\F0$7$?;~$K%&%#%s%I%&$r%*!<%P!<$7$?$i!":8$X<+F0E*(B
$B$K?eJ?%9%/%m!<%k$9$k(B.
 $B$?$@$7!"(Btruncate-lines$B$,(Bt$B$N;~$N$_$G$"$k(B."
  (interactive "p")
  (if (eq truncate-lines nil)
      (backward-char arg)
    (progn
      (if (< (- (- (current-column) arg) (window-hscroll)) 0)
          (scroll-right (+ arg 10))) ; patch 92.09.25 "arg -> (+ arg 10)"
      (backward-char arg)
      ;$B"-"-"-"-"-(B
      (km:sync-hscroll))))

(defun km:end-of-line-hscroll () ;---------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B7S@~%b!<%I$G%+%l%s%H9T$N=*$j$,%&%#%s%I%&30$G$"$l$P!"1&$X<+F0E*$K?eJ?%9%/%m!<%k(B
$B$9$k!#$?$@$7!"(Btruncate-lines$B$,(Bt$B$N;~$N$_$G$"$k!#(B"
  (if (eq truncate-lines nil)
      (end-of-line)
    (end-of-line)
    (if (> (current-column) (+ (window-width) (window-hscroll)))
        (scroll-left (+ 2 (- (current-column) (window-width))))))
  ;$B"-"-"-"-"-(B
  (km:sync-hscroll))

(defun km:beginning-of-line-hscroll () ;---------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B7S@~%b!<%I$G%+%l%s%H9T$N@hF,$,%&%#%s%I%&30$G$"$l$P!":8$X<+F0E*$K?eJ?%9%/%m!<%k(B
$B$9$k!#$?$@$7!"(Btruncate-lines$B$,(Bt$B$N;~$N$_$G$"$k!#(B"
  (if (window-hscroll)
      (scroll-right 5000))
  (beginning-of-line)
  ;$B"-"-"-"-"-(B
  (km:sync-hscroll))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B0\F05!G=DI2C(B Part2 [picture.el$B$h$jH4?h(B] $B!](B 1993.09.14
;;
(defconst km:vertical-step   0 "$B=DJ}8~$X$N%+!<%=%k0\F0%9%F%C%W?t(B")
(defconst km:horizontal-step 1 "$B2#J}8~$X$N%+!<%=%k0\F0%9%F%C%W?t(B")

(defun keisen-movement-right () ;----------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B1&J}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion 0 1))

(defun keisen-movement-left () ;-----------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B:8J}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion 0 -1))

(defun keisen-movement-up () ;-------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B>eJ}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion -1 0))

(defun keisen-movement-down () ;-----------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B2<J}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion 1 0))

(defun keisen-movement-nw () ;-------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B:8>eJ}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion -1 -1))

(defun keisen-movement-ne () ;-------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B1&>eJ}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion -1 1))

(defun keisen-movement-sw () ;-------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B:82<J}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion 1 -1))

(defun keisen-movement-se () ;-------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B1&2<J}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion 1 1))

(defun keisen-movement-wnw () ;------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B:8>e(B($B:8$X$O(B2$B%+%i%`(B)$BJ}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion -1 -2))

(defun keisen-movement-ene () ;------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B1&>e(B($B1&$X$O(B2$B%+%i%`(B)$BJ}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion -1 2))

(defun keisen-movement-wsw () ;------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B:82<(B($B:8$X$O(B2$B%+%i%`(B)$BJ}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion 1 -2))

(defun keisen-movement-ese () ;------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B1&2<(B($B1&$X$O(B2$B%+%i%`(B)$BJ}8~$X$NJ8;zF~NO$r;XDj(B"
  (interactive)
  (km:set-motion 1 2))

(defun km:set-motion (vert horiz) ;--------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B3F%9%F%C%W?t$N@_Dj$r9T$J$&(B($B%*!<%P%i%$%H%b!<%I;~$N$_M-8z(B)"
  (if (not keisen-overwrite-mode) ; $B%*!<%P%i%$%H%b!<%I!)(B
      (ding)
    (setq km:vertical-step   vert
          km:horizontal-step horiz)
    (km:update-mode-line)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B0\F05!G=DI2C(B Part3 $B!](B 1993.10.18
;;
(defconst km:vertically-regexp
  "[$B("(#($(%(&('((()(*(+(-(.(/(0(1(2(3(4(5(6(7(8(9(:(;(<(=(>(?(@(B]")
(defconst km:horizontally-regexp
  "[$B(!(#($(%(&('((()(*(+(,(.(/(0(1(2(3(4(5(6(7(8(9(:(;(<(=(>(?(@(B]")

(defun keisen-forward-jump-frame () ;-- Changed by M.Ozawa --------------------
  "[$B7S@~%b!<%I5!G=(B]
"
   (interactive)
   (if (eolp) ;$B:G=*%+%i%`$+!)(B
       nil
     (if (looking-at km:vertically-regexp)
         (keisen-forward-char-hscroll 1)
       (while (if (and (not (looking-at km:vertically-regexp)) (not (eolp)))
                  (progn (keisen-forward-char-hscroll 1) t)
                (if (not (eolp)) (keisen-forward-char-hscroll 1)) nil))))
   (if (or (km:boblp) (eolp)) ;$B@hF,%i%$%s$^$?$O:G=*%+%i%`$+!)(B
       nil
     (if (looking-at km:horizontally-regexp)
         (km:picture-move-up 1))
     (while (if (and (not (looking-at km:horizontally-regexp))
                     (not (km:boblp)))
                (progn (km:picture-move-up 1) t)
              (km:picture-move-down 1) nil))))

(defun keisen-backward-jump-frame () ;-- Changed by M.Ozawa -------------------
  "[$B7S@~%b!<%I5!G=(B]
"
  (interactive)
  (if (bolp) ;$B@hF,%+%i%`$+!)(B
      nil
    (if (looking-at km:vertically-regexp)
        (progn (keisen-backward-char-hscroll 1)
               (if (looking-at km:vertically-regexp)
                   (keisen-backward-char-hscroll 1)))
      (while (if (and (not (looking-at km:vertically-regexp)) (not (bolp)))
                 (progn (keisen-backward-char-hscroll 1) t)
               (if (not (bolp)) (keisen-backward-char-hscroll 1)) nil)))
    (while (if (and (not (looking-at km:vertically-regexp)) (not (bolp)))
               (progn (keisen-backward-char-hscroll 1) t)
             (keisen-forward-char-hscroll 1) nil)))
  (if (or (km:boblp) (bolp)) ;$B@hF,%i%$%s$^$?$O@hF,%+%i%`$+!)(B
      nil
    (if (looking-at km:horizontally-regexp)
        (km:picture-move-up 1)
      (while (if (and (not (looking-at km:horizontally-regexp))
                      (not (km:boblp)))
                 (progn (km:picture-move-up 1) t)
               (km:picture-move-down 1) nil)))))

(defun keisen-previous-jump-frame () ;-----------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
"
  (interactive)
  (if (km:boblp) ;$B@hF,%i%$%s$+!)(B
      nil
    (if (looking-at km:horizontally-regexp)
        (km:picture-move-up 1)
      (while (if (and (not (looking-at km:horizontally-regexp))
                      (not (km:boblp)))
                 (progn (km:picture-move-up 1) t)
               (km:picture-move-up 1) nil)))
    (while (if (and (not (looking-at km:horizontally-regexp))
                    (not (km:boblp)))
               (progn (km:picture-move-up 1) t)
             (km:picture-move-down 1) nil)))
  (if (bolp) ;$B@hF,%+%i%`$+!)(B
      nil
    (while (if (and (not (looking-at km:vertically-regexp)) (not (bolp)))
               (progn (keisen-backward-char-hscroll 1) t)
             (keisen-forward-char-hscroll 1) nil))))

(defun keisen-next-jump-frame () ;---------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
"
  (interactive)
  (if (km:eoblp) ;$B:G=*%i%$%s$+!)(B
      nil
    (if (looking-at km:horizontally-regexp)
        (km:picture-move-up 1)
      (while (if (and (not (looking-at km:horizontally-regexp))
                      (not (km:eoblp)))
                 (progn (km:picture-move-down 1) t)
               (km:picture-move-down 1) nil))))
  (if (bolp) ;$B@hF,%+%i%`$+!)(B
      nil
    (while (if (and (not (looking-at km:vertically-regexp)) (not (bolp)))
               (progn (keisen-backward-char-hscroll 1) t)
             (keisen-forward-char-hscroll 1) nil))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $BF14|%9%/%m!<%k5!G=DI2C(B $B!](B 1994.02.23 Based by M.Ozawa
;;
(make-variable-buffer-local 'km:sync-buffer)
(make-variable-buffer-local 'km:sync-height)

(defun km:sync-set-region () ;-------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%7%s%/%m%V%C%U%!$KI=<($9$kHO0O$N@_Dj$9$k(B"
  (let ((loop     t)
        (b_line nil)
        (e_line nil)
        (chr    nil)
        (flag   nil)
	begin end)
    (point-to-register 'pos)
    (vertical-motion 0)
    (message "$BI=<(HO0O$r@_Dj$7$F2<$5$$(B")
    (sit-for 1)
    (while loop
      (if b_line
	  (message "[C-p:$B>e(B C-n:$B2<(B RET:$B@hF,@_Dj(B C-c:$BD{@5(B C-g:$B<h>C(B]")
	(message "[C-p:$B>e(B C-n:$B2<(B RET:$B7hDj(B C-c:$BD{@5(B C-g:$B<h>C(B]"))
      (setq chr (read-quoted-char))
      (cond ((= chr ?\C-p)
             (vertical-motion -1)
             (if (not b_line) nil
               (setq e_line (km:what-current-line))
               (km:sync-reverse-region b_line e_line)))
            ((= chr ?\C-n)
             (vertical-motion 1)
             (if (not b_line) nil
               (setq e_line (km:what-current-line))
               (km:sync-reverse-region b_line e_line)))
            ((= chr ?\C-m)
             (if (not b_line)
		 (progn (setq b_line (km:what-current-line))
			(setq e_line b_line)
			(km:sync-reverse-region b_line e_line))
	       (if (>= e_line b_line)
		   (progn (setq begin (km:sync-point-bol b_line))
			  (setq end   (km:sync-point-eol e_line)))
		 (progn (setq begin (km:sync-point-eol b_line))
			(setq end   (km:sync-point-bol e_line))))
               (if (>= (count-lines begin end) (- (screen-height) 2))
                   (progn (message "$B;XDjHO0O$,Bg$-2a$.$^$9(B")
                          (sit-for 2))
		 (km:sync-reverse-off-region)
                 (copy-to-register 'sync begin end)
		 (setq km:sync-height (1+ (count-lines begin end)))
                 (setq flag t)
                 (setq loop nil))))
            ((= chr ?\C-g)
             (setq loop nil)
             (ding))
            ((= chr ?<)
             (goto-char (point-min))
             (if (not b_line) nil
               (setq e_line (km:what-current-line))
               (km:sync-reverse-region b_line e_line)))
            ((= chr ?>)
             (goto-char (point-max))
             (if (not b_line) nil
               (setq e_line (km:what-current-line))
               (km:sync-reverse-region b_line e_line)))
            ((= chr ?\C-c)
             (km:sync-reverse-off-region)
             (setq b_line nil)
             (setq e_line nil))
            (t
             (ding))))
    ;(km:sync-reverse-off-region)
    (register-to-point 'pos)
    (if flag t nil)))

(defun km:sync-point-bol (line) ;----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj$5$l$?9T$N@hF,$N%]%$%s%H$rJV$9(B"
  (save-excursion
    (goto-line line)
    (beginning-of-line)
    (point)))

(defun km:sync-point-eol (line) ;----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj$5$l$?9T$N:G=*$N%]%$%s%H$rJV$9(B"
  (save-excursion
    (goto-line line)
    (end-of-line)
    (point)))

(defun km:sync-reverse-region (b_line e_line) ;--------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDjHO0O$r$^$G$rH?E>$5$;$k(B"
  (let ((buffer-read-only nil)
	begin end)
    (km:inverse-off-region (point-min) (point-max))
    (if (>= e_line b_line)
        (progn (setq begin (km:sync-point-bol b_line))
               (setq end   (km:sync-point-eol e_line)))
      (progn (setq begin (km:sync-point-eol b_line))
             (setq end   (km:sync-point-bol e_line))))
    (km:inverse-on-region begin end)
    ))

(defun km:sync-reverse-off-region () ;-----------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $BI=<($,H?E>$7$F$$$k$N$r$b$H$KLa$9(B"
  (let ((old-buffer-read-only buffer-read-only))
    (if old-buffer-read-only
        (toggle-read-only))
    (km:inverse-off-region (point-min) (point-max))
    (if old-buffer-read-only
        (toggle-read-only))))

(defun km:pop-up-sync-window () ;----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 "
  (let* ((old-window-min-height window-min-height)
	 (current-start (window-start (selected-window)))
	 (current-hscroll (window-hscroll (selected-window)))
	 (current-height (window-height  (selected-window)))
	 (sync-height km:sync-height))
    (setq window-min-height 1)
    (split-window-vertically)
    (set-window-hscroll (next-window) current-hscroll)
    (set-window-start (next-window) current-start)
    (switch-to-buffer km:sync-buffer)
    (set-window-hscroll (selected-window) current-hscroll)
    (enlarge-window (- sync-height (window-height)))
    (setq window-min-height old-window-min-height)
    (select-window (next-window))))

(defun keisen-sync-mode () ;---------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%7%s%/%m%b!<%I$K$9$k(B"
  (interactive)
  (if km:sync-buffer
      (if (not (get-buffer-window km:sync-buffer))
	  (km:pop-up-sync-window))
    (if (not (km:sync-set-region))
	(message "Quit")
      (setq km:sync-buffer (format "*SYNCHRONOUS* [%s]" (buffer-name)))
      (save-excursion
	(set-buffer (get-buffer-create km:sync-buffer))
	(setq km:sync-buffer (current-buffer))
	(setq mode-line-format (format "            %s" (buffer-name)))
	(erase-buffer)
	(insert-register 'sync nil)
	(setq truncate-lines t)
	(goto-char (point-min)))
      (km:pop-up-sync-window)
      (setq km:sync-buffer (window-buffer (previous-window)))
      (if (fboundp 'km:old-other-window)
	  nil
	(fset 'km:old-other-window (symbol-function 'other-window))
	(fset 'other-window (symbol-function 'keisen-sync-other-window))
	(fset 'km:old-delete-window (symbol-function 'delete-window))
	(fset 'delete-window (symbol-function 'keisen-sync-delete-window))
	(fset 'km:old-delete-other-windows (symbol-function 'delete-other-windows))
	(fset 'delete-other-windows (symbol-function 'keisen-sync-delete-other-windows)))
      )))

(defun keisen-sync-mode-exit () ;----------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%7%s%/%m%b!<%I$rH4$1$k(B"
  (interactive)
  (if (not km:sync-buffer)
      (ding)
    (delete-windows-on km:sync-buffer)
    (kill-buffer km:sync-buffer)
    (setq km:sync-buffer nil)
    (setq km:sync-height nil)
    (if (not (fboundp 'km:old-other-window))
	nil
      (fset 'other-window (symbol-function 'km:old-other-window))
      (fset 'delete-window (symbol-function 'km:old-delete-window))
      (fset 'delete-other-windows (symbol-function 'km:old-delete-other-windows)))
    ))

(defun keisen-sync-change-region () ;------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $BI=<(HO0O$NJQ99(B"
  (interactive)
  (if (or (not km:sync-buffer) (not (km:sync-set-region)))
      (ding)
    (save-excursion
      (set-buffer km:sync-buffer)
      (erase-buffer)
      (insert-register 'sync nil)
      (goto-char (point-min)))
    (delete-windows-on km:sync-buffer)
    (km:pop-up-sync-window)))

(defun km:sync-hscroll () ;----------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%9%/%m!<%k%+%i%`?t$r9g$o$;$k(B"
  (if km:sync-buffer
      (let ((km:root-window (get-buffer-window (current-buffer)))
            (km:sync-window (get-buffer-window km:sync-buffer)))
        (if (and km:sync-window (eq km:root-window (selected-window)))
	    (set-window-hscroll km:sync-window
				(window-hscroll km:root-window))))))

(defun keisen-sync-other-window (arg) ;----------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 "
  (interactive "p")
  (while (> arg 0)
    (select-window (next-window))
    (setq arg (1- arg)))
  (if (eq (current-buffer) km:sync-buffer)
      (select-window (next-window))))

(defun km:count-window () ;----------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 "
  (let* ((current (selected-window))
	 (next (next-window current 'no-minibuf))
	 (done (eq current next))
	 (count 1))
    (while (not done)
      (setq count (1+ count)
	    next  (next-window next 'no-minibuf)
	    done  (eq current next)))
    count))

(defun keisen-sync-delete-window () ;------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 "
  (interactive)
  (if km:sync-buffer
      (let ((km:root-window (get-buffer-window (current-buffer)))
            (km:sync-window (get-buffer-window km:sync-buffer)))
	(if (eq km:root-window (selected-window))
	    (if (<= (km:count-window) 2) (ding)
	      (km:old-delete-window km:root-window)
	      (km:old-delete-window km:sync-window))
	  (km:old-delete-window (selected-window))
	  (delete-windows-on km:sync-buffer)
	  (km:pop-up-sync-window)))
    (km:old-delete-window (selected-window))))

(defun keisen-sync-delete-other-windows () ;-----------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 "
  (interactive)
  (if km:sync-buffer
      (let* ((km:root-window (get-buffer-window (current-buffer)))
	     (winchk (eq km:root-window (selected-window))))
	(km:old-delete-other-windows)
	(if winchk
	    (km:pop-up-sync-window)))
    (km:old-delete-other-windows)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $BJ8;zNsJT=85!G=(B
;;
(defun keisen-center-line () ;-------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%+%l%s%H%]%$%s%H$NA08e$N7S@~$H7S@~$N4V$K$"$kJ8;zNs$r$=$NCf1{$X0\F0$9$k(B"
  (interactive)
  (km:control-line 'km:control-center-line))

(defun keisen-right-line () ;--------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%+%l%s%H%]%$%s%H$NA08e$N7S@~$H7S@~$N4V$K$"$kJ8;zNs$r$=$N1&B&$N7S@~$X5M$k(B"
  (interactive)
  (km:control-line 'km:control-right-line))

(defun keisen-left-line () ;---------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%+%l%s%H%]%$%s%H$NA08e$N7S@~$H7S@~$N4V$K$"$kJ8;zNs$r$=$N:8B&$N7S@~$X5M$k(B"
  (interactive)
  (km:control-line 'km:control-left-line))

(defun km:control-line (function) ;--------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $BOHFb$NJ8;zNsJT=8$r@)8f$9$k(B"
  (save-excursion
    (let (begin end fil len)
      (km:end-of-line)
      (forward-char 1)
      (setq end (point))
      (km:beginning-of-line)
      (setq begin (point))
      (setq fil (km:buffer-column begin end)) ; $BOH$N%+%i%`?t$r5a$a$k(B
      (km:delete-horizontal-space-and-ZenkakuSpace)
      (km:end-of-line)
      (forward-char 1)
      (km:delete-horizontal-space-and-ZenkakuSpace)
      (setq len (km:buffer-column begin (point))) ; $BJ8;zNs$N%+%i%`?t$r5a$a$k(B
      (funcall function begin fil len))))

(defun km:control-center-line (begin fil len) ;--------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (let (lp1 lp2)
    (setq lp1 (/ (- fil len) 2)
          lp2 (- fil (+ lp1 len)))
    (insert (make-string lp2 (string-to-char " ")))
    (goto-char begin)
    (insert (make-string lp1 (string-to-char " ")))))

(defun km:control-right-line (begin fil len) ;---------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (goto-char begin)
  (insert (make-string (- fil len) (string-to-char " "))))

(defun km:control-left-line (begin fil len) ;----------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (insert (make-string (- fil len) (string-to-char " "))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B7S@~IA2h5!G=(B
;;
(defun km:opposite-direction (dir) ;-------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $BH?BP$NJ}8~$rJV$9(B"
  (cond ((= dir keisen-right) keisen-left)
        ((= dir keisen-left)  keisen-right)
        ((= dir keisen-up)    keisen-down)
        ((= dir keisen-down)  keisen-up)
        (t 0)))

(defun km:direction (command) ;------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B7S@~$NJ}8~$rJV$9(B"
  (cond ((eq command 'keisen-draw-right) keisen-right)
        ((eq command 'keisen-draw-left)  keisen-left)
        ((eq command 'keisen-draw-up)    keisen-up)
        ((eq command 'keisen-draw-down)  keisen-down)
        (t 0)))

(defun km:new-keisen-string () ;-----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B=q$-9~$`$?$a$N?7$7$$7S@~AGJR$r:n$k(B"
  (let (pos factor str old-direction new-direction)
    (setq old-direction (km:direction last-command))
    (setq new-direction (km:direction this-command))
    (setq factor (if (< 1 keisen-width) 16 1))
    (setq str (char-to-string (following-char)))
    (if (setq pos (string-match str keisen-table))
        (setq pos (/ pos keisen-unit-length))
      (setq pos 0)
      (if (= old-direction (km:opposite-direction new-direction))
          (setq old-direction new-direction))
      (if (= old-direction 0)
          (setq old-direction new-direction)))
    (if keisen-draw-force
        ;;$B:Y$$7S@~$O:Y$$7S@~!"B@$$7S@~$OB@$$7S@~(B
        (progn
          (setq pos (logand pos
                            (lognot (* (km:opposite-direction old-direction)
                                       (+ 16 1)))
                            (lognot (* new-direction
                                       (+ 16 1)))))
          (if (/= keisen-width 0)
              (setq pos
                    (logior pos
                            (* (km:opposite-direction old-direction)
                               factor)
                            (* new-direction factor)))))
      ;;$BB@$$7S@~$N>e$K:Y$$7S@~$r0z$$$F$bB@$$7S@~(B
      (if (/= keisen-width 0)
          (setq pos (logior pos
                            (* (km:opposite-direction old-direction)
                               factor)
                            (* new-direction factor)))
        (setq pos (logand pos
                          (lognot (* (km:opposite-direction old-direction)
                                     (+ 16 1)))
                          (lognot (* new-direction
                                     (+ 16 1)))))))
    (char-to-string (sref keisen-table (* pos keisen-unit-length)))))

(defun km:write-keisen (v h) ;-------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B7S@~$rIA$/(B"
  (setq keisen-vertical-move-count   v)
  (setq keisen-horizontal-move-count h)
  (km:insert-keisen (km:new-keisen-string)))

(defun km:insert-keisen (str) ;------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B7S@~$r%]%$%s%H$K%*!<%P!<%i%$%H$7$F%+!<%=%k$r0\F0$9$k(B"
  (let ((pos (point)))
    (km:move-to-column-force (+ (current-column) 2) t)
    (delete-region pos (point)))
  (insert str)
  (let ((col (- (current-column) 2)))
    (cond ((= keisen-vertical-move-count 1)
           ;(km:picture-newline keisen-vertical-move-count)
           (end-of-line)
           (if (eobp)
               (newline)
             (forward-char 1)))
          ((= keisen-vertical-move-count -1)
           (forward-line -1)))
    (km:move-to-column-force (+ col (* keisen-horizontal-move-count 2)) t)))

(defun keisen-draw-right (arg) ;-----------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$r0z$-$J$,$i1&J}8~$K0\F0$9$k(B"
  (interactive "*p")
  (km:adjust-current-column t)
  ;; 94.04.19 by M.I
  (if truncate-lines
      (progn
	(if (>= (- (+ (current-column) arg) (window-hscroll))
		(- (window-width) 4))
	    (scroll-left (+ arg 10)))))
  ;;
  (while (< 0 arg)
    (km:write-keisen 0 1)
    (setq last-command this-command)
    (setq arg (1- arg))))

(defun keisen-draw-left (arg) ;------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$r0z$-$J$,$i:8J}8~$K0\F0$9$k(B"
  (interactive "*p")
  (km:adjust-current-column t)
  ;; 94.04.19 by M.I
  (if truncate-lines
      (progn
	(if (< (- (- (current-column) arg) (window-hscroll)) 0)
	    (scroll-right (+ arg 10)))))
  ;;
  (while (< 0 arg)
    (km:write-keisen 0 -1)
    (setq last-command this-command)
    (setq arg (1- arg))))

(defun keisen-draw-up (arg) ;--------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$r0z$-$J$,$i>eJ}8~$K0\F0$9$k(B"
  (interactive "*p")
  (km:adjust-current-column t)
  (while (< 0 arg)
    (km:write-keisen -1 0)
    (setq last-command this-command)
    (setq arg (1- arg))))

(defun keisen-draw-down (arg) ;------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$r0z$-$J$,$i2<J}8~$K0\F0$9$k(B"
  (interactive "*p")
  (km:adjust-current-column t)
  (while (< 0 arg)
    (km:write-keisen 1 0)
    (setq last-command this-command)
    (setq arg (1- arg))))

(defun keisen-square-line () ;-------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$G;M3Q$rIA$/(B.$B%]%$%s%H$H%^!<%/$,0lD>@~>e$K$"$k$H$-$OD>@~$r0z$/(B"
  (interactive)
  (let* ((begin (km:what-mark-point))
	 (end (point))
	 (beginx (progn (goto-char begin) (current-column)))
	 (beginy (km:what-line begin))
	 (endx   (progn (goto-char end) (current-column)))
	 (endy   (km:what-line end))
	 oldx oldy)
    ;; check position
    (if (= begin (point))
        (setq oldx beginx oldy beginy)
      (setq oldx endx oldy endy))
    (if (> beginx endx)
        (let ((max beginx)
              (min endx))
          (setq beginx (* (/ min 2) 2) endx max)))
    (if (> beginy endy)
        (let ((max beginy)
              (min endy))
          (setq beginy min endy max)))
    ;; draw line
    (cond ((= begin end))             ;$B$J$7(B
          ((= beginx endx)            ;$B=D@~(B
           (let ((len (- endy beginy)))
             (goto-char begin)
             (while (< 0 len)
               (setq this-command 'keisen-draw-down)
               (km:write-keisen 1 0)
               (setq last-command 'keisen-draw-down)
               (setq len (1- len)))
             (setq this-command 'keisen-draw-up)
             (km:write-keisen -1 0)))
          ((= beginy endy)            ;$B2#@~(B
           (let ((len (/ (- endx beginx) 2)))
             (goto-char begin)
             (setq this-command 'keisen-draw-right)
             (while (< 0 len)
               (km:write-keisen 0 1)
               (setq last-command 'keisen-draw-right)
               (setq len (1- len)))
               (setq this-command 'keisen-draw-left)
               (km:write-keisen 0 -1)))
          (t                          ;$B;M3Q(B
           (goto-line beginy)
           (km:move-to-column-force beginx t)
           (let ((lenx (/ (- endx beginx) 2))
                 (leny (- endy beginy))
                 (count))
             (setq count lenx)
             (setq last-command 'keisen-draw-up)
             (setq this-command 'keisen-draw-right)
             (while (< 0 count)
               (km:write-keisen 0 1)
               (setq last-command 'keisen-draw-right)
               (setq count (1- count)))
             (setq count leny)
             (setq this-command 'keisen-draw-down)
             (while (< 0 count)
               (km:write-keisen 1 0)
               (setq last-command 'keisen-draw-down)
               (setq count (1- count)))
             (setq count lenx)
             (setq this-command 'keisen-draw-left)
             (while (< 0 count)
               (km:write-keisen 0 -1)
               (setq last-command 'keisen-draw-left)
               (setq count (1- count)))
             (setq count leny)
             (setq this-command 'keisen-draw-up)
             (while (< 0 count)
               (km:write-keisen -1 0)
               (setq last-command 'keisen-draw-up)
               (setq count (1- count))))))
    (goto-line oldy)
    (km:move-to-column-force oldx)))

;;$B$*$^$1%3!<%J!<(B(?)     by M.Iwamoto
;;  $B$3$N4X?t$O!"(Bkeisen-square-line$B4X?t$r85$K;d$,M7$SH>J,$K:n$C$F$_$?$b$N$G$9(B.
;;  $B8D?ME*$K!"7k9=5$$K$$$C$F$k4X?t$J$N$G;H$C$F$d$C$F$/$@$5$$(B.
(defun keisen-square-line2 () ;------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B;OE@$H=*E@$rG$0U$KA*Br$77S@~$K$h$k;M3Q$rIA2h$9$k(B."
  (interactive)
  (let ((sta_col (* (/ (current-column) 2) 2))  ;$B;OE@7e?t(B
        (sta_lin (km:what-current-line))        ;$B;OE@9T?t(B
        (sta_chr nil)                           ;$B;OE@J8;z(B
        (end_col 0)                             ;$B=*E@7e?t(B
        (end_lin 0)                             ;$B=*E@9T?t(B
        (end_chr nil)                           ;$B=*E@J8;z(B
        (hor_chr nil)                           ;$B;OE@2#$H=*E@=D$N8r:9ItJ8;z(B
        (ver_chr nil)                           ;$B;OE@=D$H=*E@2#$N8r:9ItJ8;z(B
        (loop    t)                             ;$B%k!<%W%U%i%0(B
        (old-keisen-width keisen-width)
	ch)
    ;$B3FJQ?t$N=i4|2=(B
    (setq sta_chr (km:get-two-column-string sta_col sta_lin))
    (setq hor_chr sta_chr ver_chr sta_chr end_chr sta_chr
          end_col sta_col end_lin sta_lin)
    ;$B5/E@%^!<%/=q$-9~$_(B
    (km:change-string sta_col sta_lin "$B!&(B")
    ;$B%a%$%s=hM}(B
    (while loop
      (message "keisen-square-line2[C-p:$B>e(B C-n:$B2<(B C-f:$B1&(B C-b:$B:8(B w:$B7S@~@ZBX(B RET:$B7hDj(B ESC:$B<h>C(B]")
      (setq ch (km:read-char))
      ;$B=*E@$r>e$K(B1$B9T0\F0$9$k(B[Ctrl-p]
      (cond ((= ch ?\C-p)
             ;$B=*E@$,$3$l0J>e>e$K0\F0$G$-$J$$(B
             (cond ((= end_lin 1)
                    (message "Can't move")
                    (sit-for 1))
                   ;$B;OE@$H=*E@$,0lCW$7$?(B
                   ((and (= sta_lin (1- end_lin))(= sta_col end_col))
                    (km:change-string end_col end_lin end_chr)
                    (km:change-string sta_col sta_lin "$B!&(B")
                    (setq hor_chr sta_chr ver_chr sta_chr end_chr sta_chr
                          end_col sta_col end_lin sta_lin))
                   ;$B;OE@%i%$%s$H=*E@%i%$%s$,0lCW$7$?(B
                   ((= sta_lin (1- end_lin))
                    (km:change-string sta_col end_lin ver_chr)
                    (km:change-string sta_col sta_lin
                                      (if (< sta_col end_col) "$B(2(B" "$B(4(B"))
                    (km:change-string end_col end_lin end_chr)
                    (setq end_lin sta_lin end_chr hor_chr ver_chr sta_chr)
                    (km:change-string end_col end_lin
                                      (if (< sta_col end_col) "$B(4(B" "$B(2(B")))
                   ;$B;OE@%+%i%`$H=*E@%+%i%`$,0lCW$7$?(B
                   ((= sta_col end_col)
                    (if (/= sta_lin end_lin)
                        (km:change-string end_col end_lin end_chr))
                    (setq end_lin (1- end_lin)
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        "$B(5(B" "$B(3(B")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin) "$B(3(B" "$B(5(B"))
                    (setq hor_chr end_chr))
                   ;$B;OE@$H=*E@$,BP3Q@~>e$K$"$C$?(B
                   (t
                    (if (= sta_lin end_lin)
                        nil
                      (km:change-string sta_col end_lin ver_chr)
                      (km:change-string end_col end_lin end_chr))
                    (setq end_lin (1- end_lin)
                          ver_chr (km:change-string sta_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "$B(1(B" "$B(0(B")
                                                      (if (< sta_col end_col)
                                                          "$B(.(B" "$B(/(B")))
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "$B(0(B" "$B(1(B")
                                                      (if (< sta_col end_col)
                                                          "$B(/(B" "$B(.(B"))))
                    (km:change-string end_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "$B(/(B" "$B(.(B")
                                        (if (< sta_col end_col) "$B(0(B" "$B(1(B")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "$B(.(B" "$B(/(B")
                                        (if (< sta_col end_col) "$B(1(B" "$B(0(B")))))
             (km:cursol-move end_col end_lin t))
            ;$B=*E@$r2<$K(B1$B9T0\F0$9$k(B[Ctrl-n]
            ((= ch ?\C-n)
             (cond ((and (= sta_lin (1+ end_lin))(= sta_col end_col))
                    (km:change-string end_col end_lin end_chr)
                    (km:change-string sta_col sta_lin "$B!&(B")
                    (setq hor_chr sta_chr ver_chr sta_chr end_chr sta_chr
                          end_col sta_col end_lin sta_lin))
                   ((= sta_lin (1+ end_lin))
                    (km:change-string sta_col end_lin ver_chr)
                    (km:change-string sta_col sta_lin
                                      (if (< sta_col end_col) "$B(2(B" "$B(4(B"))
                    (km:change-string end_col end_lin end_chr)
                    (setq end_lin sta_lin end_chr hor_chr ver_chr sta_chr)
                    (km:change-string end_col end_lin
                                      (if (< sta_col end_col) "$B(4(B" "$B(2(B")))
                   ((= sta_col end_col)
                    (if (/= sta_lin end_lin)
                        (km:change-string end_col end_lin end_chr))
                    (setq end_lin (1+ end_lin)
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        "$B(5(B" "$B(3(B")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin) "$B(3(B" "$B(5(B"))
                    (setq hor_chr end_chr))
                   (t
                    (if (= sta_lin end_lin)
                        nil
                      (km:change-string end_col end_lin end_chr)
                      (km:change-string sta_col end_lin ver_chr))
                    (setq end_lin (1+ end_lin)
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "$B(0(B" "$B(1(B")
                                                      (if (< sta_col end_col)
                                                          "$B(/(B" "$B(.(B")))
                          ver_chr (km:change-string sta_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "$B(1(B" "$B(0(B")
                                                      (if (< sta_col end_col)
                                                          "$B(.(B" "$B(/(B"))))
                    (km:change-string end_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "$B(/(B" "$B(.(B")
                                        (if (< sta_col end_col) "$B(0(B" "$B(1(B")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "$B(.(B" "$B(/(B")
                                        (if (< sta_col end_col) "$B(1(B" "$B(0(B")))))
             (km:cursol-move end_col end_lin t))
            ;$B=*E@$r1&$K(B2$B7e0\F0$9$k(B[Ctrl-f]
            ((= ch ?\C-f)
             (cond ((and (= sta_lin end_lin)(= sta_col (+ end_col 2)))
                    (km:change-string end_col end_lin end_chr)
                    (km:change-string sta_col sta_lin "$B!&(B")
                    (setq hor_chr sta_chr ver_chr sta_chr end_chr sta_chr
                          end_col sta_col end_lin sta_lin))
                   ((= sta_lin end_lin)
                    (if (/= sta_col end_col)
                        (km:change-string end_col end_lin end_chr))
                    (setq end_col (+ end_col 2)
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_col end_col)
                                                        "$B(4(B" "$B(2(B")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_col end_col) "$B(2(B" "$B(4(B"))
                    (setq hor_chr end_chr))
                   ((= sta_col (+ end_col 2))
                    (km:change-string end_col sta_lin hor_chr)
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin) "$B(3(B" "$B(5(B"))
                    (km:change-string end_col end_lin end_chr)
                    (setq end_col sta_col end_chr ver_chr hor_chr sta_chr)
                    (km:change-string end_col end_lin
                                      (if (< sta_lin end_lin) "$B(5(B" "$B(3(B")))
                   (t
                    (if (= sta_col end_col)
                        nil
                      (km:change-string end_col sta_lin hor_chr)
                      (km:change-string end_col end_lin end_chr))
                    (setq end_col (+ end_col 2)
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "$B(0(B" "$B(1(B")
                                                      (if (< sta_col end_col)
                                                          "$B(/(B" "$B(.(B")))
                          hor_chr (km:change-string end_col sta_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "$B(/(B" "$B(.(B")
                                                      (if (< sta_col end_col)
                                                          "$B(0(B" "$B(1(B"))))
                    (km:change-string sta_col end_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "$B(1(B" "$B(0(B")
                                        (if (< sta_col end_col) "$B(.(B" "$B(/(B")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "$B(.(B" "$B(/(B")
                                        (if (< sta_col end_col) "$B(1(B" "$B(0(B")))))
             (km:cursol-move end_col end_lin t))
            ;$B=*E@$r:8$K(B2$B7e0\F0$9$k(B[Ctrl-b]
            ((= ch ?\C-b)
             (cond ((= end_col 0)
                    (message "Can't move!")
                    (sit-for 1))
                   ((and (= sta_lin end_lin)(= sta_col (- end_col 2)))
                    (km:change-string end_col end_lin end_chr)
                    (km:change-string sta_col sta_lin "$B!&(B")
                    (setq hor_chr sta_chr ver_chr sta_chr end_chr sta_chr
                          end_col sta_col end_lin sta_lin))
                   ((= sta_lin end_lin)
                    (if (/= sta_col end_col)
                        (km:change-string end_col end_lin end_chr))
                    (setq end_col (- end_col 2)
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_col end_col)
                                                        "$B(4(B" "$B(2(B")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_col end_col) "$B(2(B" "$B(4(B"))
                    (setq hor_chr end_chr))
                   ((= sta_col (- end_col 2))
                    (km:change-string end_col sta_lin hor_chr)
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin) "$B(3(B" "$B(5(B"))
                    (km:change-string end_col end_lin end_chr)
                    (setq end_col sta_col end_chr ver_chr hor_chr sta_chr)
                    (km:change-string end_col end_lin
                                      (if (< sta_lin end_lin) "$B(5(B" "$B(3(B")))
                   (t
                    (if (= sta_col end_col)
                        nil
                      (km:change-string end_col sta_lin hor_chr)
                      (km:change-string end_col end_lin end_chr))
                    (setq end_col (- end_col 2)
                          hor_chr (km:change-string end_col sta_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "$B(/(B" "$B(.(B")
                                                      (if (< sta_col end_col)
                                                          "$B(0(B" "$B(1(B")))
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "$B(0(B" "$B(1(B")
                                                      (if (< sta_col end_col)
                                                          "$B(/(B" "$B(.(B"))))
                    (km:change-string sta_col end_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "$B(1(B" "$B(0(B")
                                        (if (< sta_col end_col) "$B(.(B" "$B(/(B")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "$B(.(B" "$B(/(B")
                                        (if (< sta_col end_col) "$B(1(B" "$B(0(B")))))
             (km:cursol-move end_col end_lin t))
            ;$B7S@~$N<oN`$rJQ99$9$k(B[w]
            ((= ch ?w)
             (keisen-toggle-width))
            ;$B;OE@$H=*E@$r7k$s$GBP3Q@~$H$J$k;M3Q$r=q$/(B[RET]
            ((= ch ?\C-m)
             (if (and (= sta_col end_col)(= sta_lin end_lin))
                 (km:change-string sta_col sta_lin sta_chr)
               (if (or (= sta_col end_col)(= sta_lin end_lin))
                   (progn (km:change-string sta_col sta_lin sta_chr)
                          (km:change-string end_col end_lin end_chr))
                 (km:change-string sta_col sta_lin sta_chr)
                 (km:change-string end_col sta_lin hor_chr)
                 (km:change-string sta_col end_lin ver_chr)
                 (km:change-string end_col end_lin end_chr))
               ;$B7S@~MQ%^!<%/$N@_Dj(B
               (setq keisen-mark-column sta_col
                     keisen-mark-line   sta_lin)
               (km:cursol-move end_col end_lin t)
               (keisen-square-line))
             ;$B7S@~$N<oN`$r85$KLa$9(B
             (if (= old-keisen-width keisen-width)
                 nil
               (setq keisen-width (cond ((= old-keisen-width 0) 2)
                                        ((= old-keisen-width 1) 0)
                                        ((= old-keisen-width 2) 1)))
               (keisen-toggle-width))
             (setq loop nil))
            ;$B$d!A$a$?!*(B[ESC]
            ((= ch ?\e)
             (if (and (= sta_col end_col)(= sta_lin end_lin))
                 (km:change-string sta_col sta_lin sta_chr)
               (if (or (= sta_col end_col)(= sta_lin end_lin))
                   (progn (km:change-string sta_col sta_lin sta_chr)
                          (km:change-string end_col end_lin end_chr))
                 (km:change-string sta_col sta_lin sta_chr)
                 (km:change-string end_col sta_lin hor_chr)
                 (km:change-string sta_col end_lin ver_chr)
                 (km:change-string end_col end_lin end_chr)))
             ;$B7S@~$N<oN`$r85$KLa$9(B
             (if (= old-keisen-width keisen-width)
                 nil
               (setq keisen-width (cond ((= old-keisen-width 0) 2)
                                        ((= old-keisen-width 1) 0)
                                        ((= old-keisen-width 2) 1)))
               (keisen-toggle-width))
             (setq loop nil))
            ;$BL$Dj5A%-!<$,2!2<$5$l$?(B
            (t
             (message "Undefine key!")
             (sit-for 1))))))

(defun km:get-two-column-string (col lin) ;------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj$5$l$?0LCV$N(B2$B%+%i%`J,$NJ8;zNs$r<hF@$9$k(B.$BNc$r0J2<$K<($9(B.

 column:0    5    10
        +----+----+----
        aaa$B$"(Baa$B$"$"(Ba

  ex.1 (km:get-two-column-string 0 lin) --> \"aa\"
  ex.2 (km:get-two-column-string 2 lin) --> \"a$B$"(B\"
  ex.3 (km:get-two-column-string 4 lin) --> \"$B$"(Ba\"
  ex.4 (km:get-two-column-string 8 lin) --> \"$B$"$"(B\"
"
  (save-excursion
    (km:cursol-move col lin)
    (cond ((= col (current-column))
           (if (eolp)
               "  "
             (if (= (char-width (following-char)) 2)
                 (char-to-string (following-char))
               (concat (char-to-string (following-char))
                       (progn (km:picture-forward-column 1)
                              (if (eolp)
                                  " "
                                (char-to-string (following-char))))))))
          ((> col (current-column))
           (if (eolp)
               "   "
             (concat (char-to-string (following-char))
                     (progn (km:picture-forward-column 1)
                            (if (eolp)
                                " "
                              (char-to-string (following-char)))))))
          (t    ;(< col (current-column))
           (if (eolp)
               "   "
             (concat (char-to-string (preceding-char))
                     (char-to-string (following-char))))))))

(defun km:change-string (col lin str1) ;---------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj$5$l$?0LCV$N(B2$B%+%i%`J,$NJ8;zNs$r;XDjJ8;zNs$KCV49$9$k(B"
  (let (str2 len1 len2)
    (save-excursion
      (setq str2 (km:get-two-column-string col lin) ;$BCV49A0$NJ8;z$r<hF@(B
            len1 (km:string-column str1)
            len2 (km:string-column str2))
      (cond ((= len1 len2)
             (km:cursol-move col lin)
             (delete-text-in-column col (+ col len1))
             (insert str1))
            ((= len1 2)
             (if (= len2 3)
                 (progn (km:cursol-move col lin)
                        (if (= (char-width (sref str2 0)) 1)
                            (progn (delete-text-in-column col (+ col len2))
                                   (insert (concat str1 " ")))
                          (delete-text-in-column (1- col) (+ (1- col) len2))
                          (insert (concat " " str1))))
               (km:cursol-move (1- col) lin)
               (delete-text-in-column (1- col) (+ (1- col) len2))
               (insert (concat " " str1 " "))))
            ((= len2 2)
             (if (= (char-width (sref str1 0)) 1)
                 (progn (km:cursol-move col lin)
                        (delete-text-in-column col (+ col len1)))
               (km:cursol-move (1- col) lin)
               (delete-text-in-column (1- col) (+ (1- col) len1)))
             (insert str1))))
    str2)) ;$BJQ99A0$NJ8;zNs$rJV5Q(B

(defun km:cursol-move (col lin &optional asf) ;--------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (km:picture-move-down (- lin (km:what-current-line)))
  (km:picture-forward-column (- col (current-column)))
  (if (and asf truncate-lines)
      (let ((cwc (- (current-column) (window-hscroll))))
        (if (>= (+ cwc 2) (window-width))
            (scroll-left (+ (- cwc (window-width)) 4))
          (if (< cwc 0)
              (scroll-left cwc))))))
;;$B$($s$I(B $B$*$V(B $B$*$^$1%3!<%J!<(B

(defun km:extend-regexp (course) ;---------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 extend$B%3%^%s%I$N@55,I=8=(B
 keisen-extend-regexp-flag$B$,(Bnil$B$N$H$-!"$9$Y$F$N7S@~(B
                             $B#1$N$H$-!":Y$$7S@~(B
                             $B#2$N$H$-!"B@$$7S@~(B"
  (cond ((null keisen-extend-regexp-flag) ;$B$9$Y$F$N7S@~(B
         (if (or (= course keisen-right) (= course keisen-left))
             "[$B("(#($(%(&('((()(*(+(-(.(/(0(1(2(3(4(5(6(7(8(9(:(;(<(=(>(?(@(B]"
           "[$B(!(#($(%(&('((()(*(+(,(.(/(0(1(2(3(4(5(6(7(8(9(:(;(<(=(>(?(@(B]"))
        ((= keisen-extend-regexp-flag 1) ;$B:Y$$7S@~(B
         (if (or (= course keisen-right) (= course keisen-left))
             "[$B("(#($(%(&('((()(*(+(7(8(9(:(;(<(=(>(?(@(B]"
           "[$B(!(#($(%(&('((()(*(+(7(8(9(:(;(<(=(>(?(@(B]"))
        (t ;(= keisen-extend-regexp-flag 2) ;$BB@$$7S@~(B
         (if (or (= course keisen-right) (= course keisen-left))
             "[$B(-(.(/(0(1(2(3(4(5(6(7(8(9(:(;(<(=(>(?(@(B]"
           "[$B(,(.(/(0(1(2(3(4(5(6(7(8(9(:(;(<(=(>(?(@(B]"))))

(defun keisen-extend-right () ;------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B<!$N7S@~$K$V$D$+$k$^$G7S@~$r1&$K?-$P$7$F0z$/(B"
  (interactive "*")
  (km:adjust-current-column)
                                        ; t $B$rF~$l$k$H0c$C$F$$$F$b>C$($F$7$^$&(B
  (let ((pos (point))
        (len))
    (if (eolp)
        nil
      (forward-char)
      (if (re-search-forward (km:extend-regexp keisen-right) (km:eol) t)
          (progn
	    (setq len (/ (km:buffer-column pos (match-beginning 0)) 2))
	    (goto-char pos)
	    (setq this-command 'keisen-draw-right)
	    (while (< 0 len)
	      (km:write-keisen 0 1)
	      (setq last-command 'keisen-draw-right
		    len (1- len)))
	    (setq this-command 'keisen-draw-left)
	    (km:write-keisen 0 -1)
	    (forward-char)
	    ;; 94.04.19 by M.I
	    (if (and truncate-lines
		     (>= (- (current-column) (window-hscroll))
			 (- (window-width) 4)))
		(scroll-left (+ (- (current-column)
				   (+ (window-hscroll) (window-width))) 4)))
	    )))))

(defun keisen-extend-left () ;-------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B<!$N7S@~$K$V$D$+$k$^$G7S@~$r:8$K?-$P$7$F0z$/(B"
  (interactive "*")
  (km:adjust-current-column)
                                        ; t $B$rF~$l$k$H0c$C$F$$$F$b>C$($F$7$^$&(B
  (let ((pos (point))
        (len))
    (if (re-search-backward (km:extend-regexp keisen-left) (km:bol) t)
        (progn
	  (setq len (/ (km:buffer-column (match-beginning 0) pos) 2))
	  (goto-char pos)
	  (setq this-command 'keisen-draw-left)
	  (while (< 0 len)
	    (km:write-keisen 0 -1)
	    (setq last-command 'keisen-draw-left
		  len (1- len)))
	  (setq this-command 'keisen-draw-right)
	  (km:write-keisen 0 1)
	  (backward-char)
	  ;; 94.04.19 by M.I
	  (if (and truncate-lines
		   (< (- (current-column) (window-hscroll)) 0))
	      (scroll-right (+ (- (window-hscroll) (current-column)) 4)))
	  ))))

(defun keisen-extend-up () ;---------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B<!$N7S@~$K$V$D$+$k$^$G7S@~$r>e$K?-$P$7$F0z$/(B"
  (interactive "*")
  (km:adjust-current-column)
                                        ; t $B$rF~$l$k$H0c$C$F$$$F$b>C$($F$7$^$&(B
  (let ((pos (point))
        (col (current-column))
        (count 0))
    (forward-line -1)
    (km:move-to-column-force col)
    (while (and (not (looking-at (km:extend-regexp keisen-up)))
                (= (forward-line -1) 0))
      (km:move-to-column-force col)
      (setq count (1+ count)))
    (if (prog1 (looking-at (km:extend-regexp keisen-up)) (goto-char pos))
        (progn (setq this-command 'keisen-draw-up)
               (while (<= 0 count)
                 (km:write-keisen -1 0)
                 (setq last-command 'keisen-draw-up)
                 (setq count (1- count)))
               (setq this-command 'keisen-draw-down)
               (km:write-keisen 1 0)
               (forward-line -1)
               (km:move-to-column-force col)))))

(defun keisen-extend-down () ;-------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B<!$N7S@~$K$V$D$+$k$^$G7S@~$r2<$K?-$P$7$F0z$/(B"
  (interactive "*")
  (km:adjust-current-column)
                                        ; t $B$rF~$l$k$H0c$C$F$$$F$b>C$($F$7$^$&(B
  (let ((pos (point))
        (col (current-column))
        (count 0))
    (forward-line 1)
    (km:move-to-column-force col)
    (while (and (not (looking-at (km:extend-regexp keisen-down)))
                (= (forward-line 1) 0))
      (km:move-to-column-force col)
      (setq count (1+ count)))
    (if (prog1 (looking-at (km:extend-regexp keisen-down)) (goto-char pos))
        (progn (setq this-command 'keisen-draw-down)
               (while (<= 0 count)
                 (km:write-keisen 1 0)
                 (setq last-command 'keisen-draw-down)
                 (setq count (1- count)))
               (setq this-command 'keisen-draw-up)
               (km:write-keisen -1 0)
               (forward-line 1)
               (move-to-column col)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B7S@~IA2h5!G=DI2C(B
;;
(defun keisen-arrow () ;-------------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~%^!<%/%]%$%s%H$+$i%+%l%s%H0LCV$^$GLp0u$r0z$/(B"
  (interactive)
  (save-excursion
    (let ((begin (km:what-mark-point))
          (end   (point)))
      (if (/= begin end)
          (cond ((= (km:what-column begin) (km:what-column end)) ;$B=D@~(B
                 (if (< begin end)
                     (km:down-arrow-line end begin) ;$B2<$X(B
                   (km:up-arrow-line begin end))) ;$B>e$X(B
                ((= (km:what-line begin) (km:what-line end)) ;$B2#@~(B
                 (if (< begin end)
                     (km:right-arrow-line begin end) ;$B1&$X(B
                   (km:left-arrow-line end begin))) ;$B:8$X(B
                (t nil)))))) ;$B<P@~!)(B

(defun keisen-line () ;--------------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~%^!<%/%]%$%s%H$+$i%+%l%s%H0LCV$^$G7S@~$r0z$/(B"
  (interactive)
  (save-excursion
    (let ((begin (km:what-mark-point))
          (end   (point)))
      (if (/= begin end)
          (cond ((= (km:what-column begin) (km:what-column end)) ;$B=D@~(B
                 (if (< begin end)
                     (km:vertically-line-region end begin) ;$B2<$X(B
                   (km:vertically-line-region begin end))) ;$B>e$X(B
                ((= (km:what-line begin) (km:what-line end)) ;$B2#@~(B
                 (if (< begin end)
                     (km:horizontally-line-region begin end) ;$B1&$X(B
                   (km:horizontally-line-region end begin))) ;$B:8$X(B
                (t nil)))))) ;$B<P@~!)(B

(defun km:horizontally-line-region (begin end) ;-------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B3+;O%]%$%s%H(Bbegin$B$+$i=*E@%]%$%s%H(Bend$B$^$G7S@~$r2#J}8~$X0z$/(B"
  (save-excursion
    (goto-char begin)
    (km:adjust-current-column)
    (let ((col (km:what-column end))
          (len))
      (if (eolp) nil
        (setq len (/ (+ (km:buffer-column begin end) 1) 2))
        (setq last-command 'keisen-draw-left)
        (setq this-command 'keisen-draw-right)
        (while (< 0 len)
          (km:write-keisen 0 1)
          (setq last-command 'keisen-draw-right)
          (setq len (1- len)))))))

(defun km:vertically-line-region (begin end) ;---------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B3+;O%]%$%s%H(Bbegin$B$+$i=*E@%]%$%s%H(Bend$B$^$G7S@~$r=DJ}8~$X0z$/(B"
  (save-excursion
    (goto-char begin)
    (km:adjust-current-column)
    (let ((col (km:what-column end))
          (len))
      (setq len (+ (- (km:what-line begin) (km:what-line end)) 1))
      (setq last-command 'keisen-draw-down)
      (setq this-command 'keisen-draw-up)
      (while (< 0 len)
        (km:write-keisen -1 0)
        (setq last-command 'keisen-draw-up)
        (setq len (1- len))))))

(defun km:right-arrow-line (begin end) ;---------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B3+;O%]%$%s%H(Bbegin$B$+$i=*E@%]%$%s%H(Bend$B$^$G1&Lp0u$r0z$/(B"
  (let ((end_pos (km:what-point (km:adjusted-column end)))
        (end_col (km:adjusted-column end))
        (old-keisen-width keisen-width))
    (if (= begin end)
        nil
      (setq keisen-width 1)
      (km:horizontally-line-region begin end_pos)
      (setq keisen-width old-keisen-width))
    (km:move-to-column-force end_col nil)
    (keisen-overwrite-string "$B"*(B")))

(defun km:left-arrow-line (begin end) ;----------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B3+;O%]%$%s%H(Bbegin$B$+$i=*E@%]%$%s%H(Bend$B$^$G:8Lp0u$r0z$/(B"
  (let ((sta_pos (km:what-point (+ (km:adjusted-column begin) 2)))
        (sta_col (km:adjusted-column begin))
        (old-keisen-width keisen-width))
    (if (= begin end)
        nil
      (setq keisen-width 1)
      (km:horizontally-line-region sta_pos end)
      (setq keisen-width old-keisen-width))
    (km:move-to-column-force sta_col nil)
    (keisen-overwrite-string "$B"+(B")))

(defun km:up-arrow-line (begin end) ;------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B3+;O%]%$%s%H(Bbegin$B$+$i=*E@%]%$%s%H(Bend$B$^$G>eLp0u$r0z$/(B"
  (let ((end_pos (km:what-point (km:adjusted-column end)))
        (end_col (km:adjusted-column end))
        (old-keisen-width keisen-width))
    (if (= begin end)
        nil
      (setq keisen-width 1)
      (km:vertically-line-region begin
                                 (save-excursion
                                   (goto-char end_pos)
                                   (km:picture-move-down 1)
                                   (point)))
      (setq keisen-width old-keisen-width))
    (km:move-to-column-force end_col nil)
    (keisen-overwrite-string "$B",(B")))

(defun km:down-arrow-line (begin end) ;----------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B3+;O%]%$%s%H(Bbegin$B$+$i=*E@%]%$%s%H(Bend$B$^$G2<Lp0u$r0z$/(B"
  (let ((sta_pos (km:what-point (km:adjusted-column begin)))
        (sta_col (km:adjusted-column begin))
        (old-keisen-width keisen-width))
    (if (= begin end)
        nil
      (setq keisen-width 1)
      (km:vertically-line-region (save-excursion
                                   (goto-char sta_pos)
                                   (km:picture-move-up 1)
                                   (point))
                                 end)
      (setq keisen-width old-keisen-width))
    (km:move-to-column-force sta_col nil)
    (keisen-overwrite-string "$B"-(B")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B7S@~IA2h5!G=DI2C(B Part2
;;
(defun keisen-line-horizontally () ;-- Based by M.Ozawa -----------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B=D@~4V$K7S@~$r0z$/(B"
  (interactive)
  (km:end-of-line)
  (if (and (not (looking-at km:horizontally-regexp)) (looking-at "[^$B"*"+(B]"))
      (progn
	(keisen-set-mark)
	(km:beginning-of-line)
	(keisen-line))
    (let ((keisen-width 0))
      (backward-char 1)
      (keisen-extend-right))
    (backward-char 1)
    (km:end-of-line)
    (keisen-clear-line)
    (keisen-set-mark)
    (km:beginning-of-line)
    (keisen-line)))

(defun keisen-line-vertically () ;-- Based by M.Ozawa -------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B2#@~4V$K7S@~$r0z$/(B"
  (interactive)
  (km:top-of-frame)
  (if (and (not (looking-at km:vertically-regexp)) (looking-at "[^$B","-(B]"))
      (progn
	(keisen-set-mark)
	(km:bottom-of-frame)
	(keisen-line))
    (let ((keisen-width 0))
      (keisen-previous-line)
      (keisen-extend-down))
    (keisen-previous-line)
    (km:top-of-frame)
    (keisen-set-mark)
    (zen-han-change)
    (km:bottom-of-frame)
    (keisen-line)))

(defun keisen-arrow-down () ;-- Based by M.Ozawa ------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B2#@~4V$K2<8~$-Lp0u$r0z$/(B"
  (interactive)
  (km:top-of-frame)
  (if (and (not (looking-at km:vertically-regexp)) (looking-at "[^$B","-(B]"))
      (progn
	(keisen-set-mark)
	(km:bottom-of-frame)
	(keisen-arrow))
    (let ((keisen-width 0))
      (keisen-previous-line)
      (keisen-extend-down))
    (keisen-previous-line)
    (km:top-of-frame)
    (keisen-set-mark)
    (while (not (looking-at km:horizontally-regexp))
      (insert "  ")
      (delete-char 1)
      (backward-char 2)
      (keisen-next-line))
    (exchange-point-and-mark)
    (km:bottom-of-frame)
    (keisen-arrow)))

(defun keisen-arrow-up () ;-- Based by M.Ozawa --------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B2#@~4V$K>e8~$-Lp0u$r0z$/(B"
  (interactive)
  (km:bottom-of-frame)
  (if (and (not (looking-at km:vertically-regexp)) (looking-at "[^$B","-(B]"))
      (progn
	(keisen-set-mark)
	(km:top-of-frame)
	(keisen-arrow))
    (let ((keisen-width 0))
      (keisen-next-line)
      (keisen-extend-up))
    (keisen-next-line)
    (km:bottom-of-frame)
    (keisen-set-mark)
    (while (not (looking-at km:horizontally-regexp))
      (insert "  ")
      (delete-char 1)
      (backward-char 2)
      (keisen-previous-line))
    (exchange-point-and-mark)
    (km:top-of-frame)
    (keisen-arrow)))

(defun keisen-arrow-left () ;-- Based by M.Ozawa ------------------------------
  "$B=D@~4V$K:88~$-Lp0u$r0z$/(B"
  (interactive)
  (km:end-of-line)
  (if (and (not (looking-at km:horizontally-regexp)) (looking-at "[^$B"*"+(B]"))
      (progn
	(keisen-set-mark)
	(km:beginning-of-line)
	(keisen-arrow))
    (let ((keisen-width 0))
      (forward-char)
      (keisen-extend-left))
    (forward-char)
    (keisen-clear-line)
    (km:end-of-line)
    (keisen-set-mark)
    (km:beginning-of-line)
    (keisen-arrow)))

(defun keisen-arrow-right () ;-- Based by M.Ozawa -----------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B=D@~4V$K1&8~$-Lp0u$r0z$/(B"
  (interactive)
  (km:beginning-of-line)
  (if (and (not (looking-at km:horizontally-regexp)) (looking-at "[^$B"*"+(B]"))
      (progn
	(keisen-set-mark)
	(km:end-of-line)
	(keisen-arrow))
    (let ((keisen-width 0))
      (backward-char)
      (keisen-extend-right))
    (backward-char)
    (km:beginning-of-line)
    (keisen-clear-line)
    (keisen-set-mark)
    (km:end-of-line)
    (keisen-arrow)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $BA^F~5!G=(B
;;
(defun keisen-self-insert-internal (str) ;-------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 self-insert-iso$B4X?t$+$iEO$5$l$?J8;zNs$r%$%s%5!<%H$9$k(B"
  (interactive)
  (if keisen-overwrite-mode
      (keisen-overwrite-string str)
    (keisen-insert-string str)))

(defvar keisen-old-after-change-functions nil)
(defun km:after-change-function (beg end len)
(if (memq this-command '(self-insert-command encoded-kbd-handle-8bit))   ;;; patch
      (funcall self-insert-after-hook beg end)))

(defun km:self-insert-after-overwrite-hook (begin end) ;-----------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B7S@~%b!<%I$N(Bself-insert-after-hook$B%*!<%P!<%i%$%H%b!<%I$GJ8;z$rA^F~$9$k(B"
  (let ((str (buffer-substring begin end)))
    (delete-region begin end)
    (keisen-overwrite-string str)))

(defun keisen-overwrite-string (str) ;-----------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%*!<%P!<%i%$%H$GJ8;z$rA^F~$9$k(B"
  (interactive "*sInsert string: ")
  (let ((lis (string-to-char-list str))
	chr wth col)
    (while lis
      (setq chr (car lis)
	    wth (char-width chr)
	    lis (cdr lis)
	    col (current-column))
      (if (looking-at keisen-regexp)
	  (setq lis nil)
	(delete-text-in-column col (+ col wth))
	(insert chr)
	(forward-char -1)
	(if (/= km:vertical-step 0) ; $B$J$J$aJ}8~(B
	    (km:picture-move nil)
	  (if (> km:horizontal-step 0) ; $B1&J}8~(B
	      (forward-char 1)
	    (km:move-to-column-force (- col wth)))) ; $B:8J}8~(B
	))))

(defun km:picture-move (&optional force) ;-- Based by K.Handa -----------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+!<%=%k$r$=$l$>$l(Bkm:horizontal-step/km:vertical-step$BJ,0\F0$9$k(B"
  (let ((h_flg (and (< km:horizontal-step 0)
                    (bolp)))
        (v_flg (and (< km:vertical-step 0)
                    (= (km:what-current-line) 1))))
    (if h_flg nil
      (km:picture-move-down km:vertical-step force)
      (if v_flg nil
        (km:picture-forward-column km:horizontal-step force)))))

(defun km:self-insert-after-insert-hook (begin end) ;--------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B7S@~%b!<%I$N(Bself-insert-after-hook$B%$%s%5!<%H%b!<%I$GJ8;z$rA^F~$9$k(B"
  (let ((pos (point)) end_col end_pos str)
    (if (re-search-forward keisen-regexp (km:eol) t)
        (progn
	  (forward-char -1)
          (setq end_col (current-column))
	  (let ((col (- end_col (km:buffer-column begin end))))
	    (if (/= (move-to-column col) col)
		(let ((d (- col (progn (forward-char -1) (current-column)))))
		  (if (< (point) end)
		      (setq end (+ end d)
			    pos end))
		  (setq end_col (+ end_col d))
		  (insert (make-string d ? ))
		  )))
	  (setq end_pos (km:what-point end_col))
          ;;begin of patch [93.05.19]
          (if (and keisen-auto-line-feed-flag (< (point) end))
              (progn
		(if (/= end_pos end)
		    (delete-region end end_pos))
                (if keisen-auto-enlarge-horizontally-flag
                    (progn
                      (setq str (buffer-substring (point) end))
                      (delete-region (point) end)
                      (keisen-enlarge-horizontally 1)
                      (keisen-insert-string str))
                  (km:auto-line-feed (point) end)))
            (delete-region (point) end_pos)
            (goto-char (min pos (match-beginning 0))))
          ;;end of patch
          ))))

(defun km:auto-line-feed (begin end) ;-----------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B<+F02~9T$r9T$J$&(B."
  (let ((str (buffer-substring begin end)) sta)
    (delete-region begin end)
    (if (keisen-locked-forward-line)
        (if keisen-overwrite-mode
            (keisen-overwrite-string str)
          (keisen-insert-string str))
      (if keisen-auto-enlarge-vertically-flag
          (progn (km:picture-move-down 1)
                 (keisen-enlarge-vertically 1)
                 (km:picture-move-up 1)
                 (if keisen-overwrite-mode
                     (keisen-overwrite-string str)
                   (keisen-insert-string str)))
        (goto-char begin)))))

(defun keisen-insert-string (str) ;--------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%$%s%5!<%H$GJ8;z$rA^F~$9$k(B"
  (interactive "*sInsert string: ")
  (let ((begin (point)))
    (insert str)
    (km:self-insert-after-insert-hook begin (point))))

(defun keisen-insert-blank (arg) ;---------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%]%$%s%H$N8e$N6uGr$rA^F~$9$k(B.$B7S@~$OF0$+$J$$(B"
  (interactive "*p")
  (if (< 0 arg)
      (let ((pos (point)))
        (insert-char ? arg)
        (km:self-insert-after-insert-hook pos (point)))))

(defun keisen-enlarge-vertically (arg) ;---------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%]%$%s%H$N0LCV$G=DJ}8~$K7S@~$r?-$P$9(B.
 $B%+%l%s%H%i%$%s$N0l9T>e$N9T$+$i$N$D$J$,$j$r8+$F%+%l%s%H%i%$%s$NA0$K0l9TA^F~$9(B
$B$k(B."
  (interactive "*p")
  (save-excursion
    (if (and (< 0 arg)
	     (= (forward-line -1) 0))
	(let ((col 0)
	      (str "")
              (count arg))
	  (while (re-search-forward keisen-regexp (km:eol) t)
	    (goto-char (match-beginning 0))
	    (setq str
		  (concat str
			  (make-string (- (current-column) col) ? )
			  (cond ((looking-at "[$B("(#($('((()(+(8(;(<(>(B]") "$B("(B")
				((looking-at "[$B(-(.(/(2(3(4(6(7(9(=(@(B]") "$B(-(B")
				(t "  "))))
	    (forward-char 1)
	    (setq col (current-column)))
	  (end-of-line)
	  (setq str (concat str (make-string (- (current-column) col) ? )))
	  (if (string-match keisen-regexp str)
	      (while (< 0 count)
		(newline)
		(insert str)
		(setq count (1- count))))))))

(defun keisen-enlarge-horizontally (arg) ;-------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%]%$%s%H$N0LCV$G2#J}8~$K7S@~$r?-$P$9(B.
 $B%+%l%s%H%+%i%`$NA0$X$N$D$J$,$j$r8+$F%+%l%s%H%+%i%`$NA0$K0l7eA^F~$9$k(B."
  (interactive "*p")
  (let* ((col  (current-column))
         (oldline (+ (count-lines (point-min) (point))
                     (if (= col 0) 1 0)))
         (count (km:check-vertically oldline))
         (len arg))
    (while (< 0 count)
      (move-to-column col)
      (if (<= (1- col) (current-column))
          (while (< 0 len)
            (cond ((looking-at "[$B(!($(%((()(*(+(9(?(=(@(B]") (insert "$B(!(B"))
                  ((looking-at "[$B(,(/(0(3(4(5(6(8(:(;(>(B]") (insert "$B(,(B"))
                  (t
                   (indent-to (+ 2 (current-column))))
                  ;;(indent-to (+ (* 2 arg) (current-column)))
                  ;;(insert-char ? (* arg 2));$BH>3Q!"A43Q$N$I$A$i$G$b$h$$(B($BA43Q(B)
                  )
            (setq len (1- len))))
      (forward-line 1)
      (setq len arg)
      (setq count (1- count)))
    (goto-line oldline)
    (move-to-column col)))

(defun km:check-vertically (old) ;---------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B=DJ}8~$N7S@~$NHO0O$rD4$Y!"%]%$%s%H$r7S@~$N;O$^$j$N%i%$%s$N:G=i$K7S@~$NHO0O$r(B
$BCM$H$7$FJV$9(B."
  (let ((end (1- old))
        (begin (1+ old)))
    (beginning-of-line)
    (while (and (re-search-forward keisen-regexp (km:eol) t)
                (progn (setq end (1+ end))
                       (= (forward-line 1) 0))))
    (goto-line old)
    (while (and (re-search-forward keisen-regexp (km:eol) t)
                (progn (setq begin (1- begin))
                       (= (forward-line -1) 0))))
    (goto-line begin)
    (1+ (- end begin))))

(defun keisen-newline () ;-----------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%]%$%s%H$N0LCV$G9T$rJ,3d$7$F?7$7$$9T$rA^F~$9$k(B.$B7S@~$OJ,3d$G$-$J$$(B."
  (interactive "*")
  (if (or
       ;;$B%P%C%U%!$N:G=i(B
       (bobp)
       ;;$B%i%$%s$N:G=i$GA0$N9T$K7S@~$,$J$$$H$-(B
       (and (bolp)
            (not (save-excursion
                   (forward-line -1)
                   (re-search-forward keisen-regexp (km:eol) t))))
       ;;$B%+%l%s%H%i%$%s$K7S@~$,$J$$$H$-(B
       (not (save-excursion
              (beginning-of-line)
              (re-search-forward keisen-regexp (km:eol) t)))
       ;;$B%]%$%s%H0J9_$D$.$N9T$N:G8e$^$G7S@~$,$J$$$H$-(B
       (not (save-excursion
              (re-search-forward keisen-regexp
                                 (save-excursion (forward-line 1)
                                                 (end-of-line)
                                                 (point))
                                 t))))
      (newline)
    (forward-line 1)))

(defun keisen-yank () ;--------------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $BJ]B8$7$F$*$$$?J8;zNs$r%]%$%s%H$NA0$KA^F~$9$k(B.
 $BJ8;zNs$O7S@~$r1[$($k$3$H$O$G$-$J$$(B."
  (interactive "*")
  (if (looking-at keisen-regexp)
      nil
    (push-mark (point))
    (let ((str (car kill-ring-yank-pointer))
          (begin 0)
          (end))
      (catch 'exit
        (while (setq end (string-match "\n" str begin))
          (keisen-insert-string (substring str begin end))
          (if keisen-lock
              (if (keisen-locked-forward-line)
                  nil
                (ding)
                (throw 'exit nil))
            (keisen-half-locked-forward-line))
          (setq begin (1+ end)))
        (keisen-insert-string (substring str begin))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B:o=|!JJ]B8!K5!G=(B
;;
(defun keisen-kill-line () ;-- Based by M.Ozawa -------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 "
  (interactive)
  (let ((begin (point)))
    (save-window-excursion
      (save-excursion
	(km:end-of-line-hscroll)
	(km:kill-extract-rectangle begin (point))))))

(defun keisen-clear-keisen (arg) ;-- Based by M.Ozawa -------------------------
  "[$B7S@~%b!<%I5!G=(B]
 "
  (interactive "p")
  (save-excursion
    (while (> arg 0)
      (if (or (looking-at km:vertically-regexp)
	      (looking-at km:horizontally-regexp))
	  (progn (insert "  ")
		 (delete-char 1)))
      (setq arg (1- arg)))))

(defun keisen-clear-frame (&optional save) ;-- Based by M.Ozawa ---------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%U%l!<%`Fb$NJ8;z$r:o=|$9$k(B"
  (interactive "P")
  (let (begin)
    (save-excursion (km:top-of-frame)
		    (km:beginning-of-line)
		    (setq begin (point))
		    (km:bottom-of-frame)
		    (km:end-of-line)
		    (forward-char)
		    (if (not save)
			(km:kill-extract-rectangle begin (point))
		      (setq km:rectangle-save-buffer
			    (km:save-extract-rectangle begin (point)))
		      (message "Save contents of frame"))
		    )))

(defun km:top-of-frame () ;-- Based by M.Ozawa --------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (while (and (not (looking-at km:horizontally-regexp)) (not (km:boblp)))
    (keisen-previous-line))
  (if (looking-at km:horizontally-regexp)
      (keisen-next-line)))

(defun km:bottom-of-frame () ;-- Based by M.Ozawa -----------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (while (and (not (looking-at km:horizontally-regexp)) (not (km:eoblp)))
    (keisen-next-line))
  (if (not (km:boblp))
      (keisen-previous-line)))

(defun keisen-clear-line () ;--------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%+%l%s%H%i%$%s$N%]%$%s%H$+$i<!$N7S@~$^$?$O9TC<$^$G$r:o=|$9$k(B
 $B7S@~$OF0$+$J$$(B"
  (interactive "*")
  (let ((pos (point))
        (col))
    (cond ((looking-at keisen-regexp))                  ;$B7S@~>e(B
          ((re-search-forward keisen-regexp (km:eol) t) ;$B%]%$%s%H0J8e$K7S@~(B
           (goto-char (match-beginning 0))
           (setq col (current-column))
           ;;(skip-chars-backward " $B!!(B\t" pos)
           (kill-region pos (match-beginning 0))
           ;;(kill-region pos (+ (point) (get-code-type (point)) 1))
           ;;(re-search-forward keisen-regexp)
           ;;(goto-char (match-beginning 0))
           (indent-to col)
           (goto-char pos))
          ;$B"-%+%l%s%H%i%$%s$N@hF,%]%$%s%H$+$i8=%]%$%s%H$^$G7S@~$b4^$a$F:o=|(B
          ;  $B$7$F$7$^$&$N$G!"$3$N=hM}$O>J$/(B
          ;((re-search-backward keisen-regexp (km:bol) t);$B%]%$%s%H0JA0$K7S@~(B
          ; (kill-region pos (km:bol)))
          (t                                            ;
           (kill-line)))))

(defun keisen-clear-char () ;--------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%]%$%s%H$N8e$m$N%-%c%i%/%?!<$r#1J8;z>C$9(B.$B$=$N8e$m$N%-%c%i%/%?!<$O:8$K$D$a$i$l(B
$B$k(B.$B7S@~$OF0$+$J$$(B"
  (interactive "*")
  (save-excursion
    (cond ((eobp) nil)
          ((= (following-char) ?\n)
           (if (bolp)
               (delete-char 1)
             (let ((pos (point)))
               (delete-char 1)
               (if (re-search-forward keisen-regexp (km:eol) t)
                   (progn (goto-char pos)
                          (insert "\n"))))))
          ((not (looking-at keisen-regexp))
           (let ((ch (char-width (char-after (point)))))
             (delete-char 1)
             (if (re-search-forward keisen-regexp (km:eol) t)
                 (let (pos)
                   (goto-char (match-beginning 0))
                   (setq pos (point))
                   (indent-to (+ (current-column) ch))
                   (if keisen-text-mode-flag
                       (km:clear-char-on-text pos ch)))))))))

(defun km:clear-char-on-text (pos ch) ;----------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (goto-char pos)
  (if (keisen-locked-forward-line)
      (let ((str (buffer-substring (point) (+ ch (point))))
            (len 0)
            (cnt 0))
        (setq len (char-width (string-to-char str)))
        (if (<= len ch)
            (progn
              (save-excursion (goto-char pos)
                              (keisen-insert-string str))
              (while (not (> cnt len))
                (keisen-clear-char)
                (setq cnt (1+ cnt))))))))

(defun keisen-clear-backward-char () ;-----------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%]%$%s%H$NA0$N%-%c%i%/%?!<$r#1J8;z>C$9(B.$B$=$N8e$m$N%-%c%i%/%?!<$O:8$K$D$a$i$l$k(B.
 $B$7$+$77S@~$OF0$+$:>C$9$3$H$b$G$-$J$$(B"
  (interactive "*")
  (if (bolp)
      nil
    (if (= (preceding-char) ?\t)
        (km:move-to-column-force (1- (current-column)))
      (backward-char 1))
    (if (looking-at keisen-regexp)
        (forward-char 1)))
  (keisen-clear-char))

(defun keisen-shrink-vertically (arg) ;----------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$r=DJ}8~$K=L$a$k(B.$B%+%l%s%H%i%$%s$r0l9T:o=|$7$F7S@~$r0l9T=L$a$k(B"
  (interactive "*p")
  (let ((col (current-column)))
    (beginning-of-line)
    (while (and (< 0 arg)
                (re-search-forward keisen-regexp (km:eol) t))
      (beginning-of-line)
      (delete-region (point) (progn (forward-line 1) (point)))
      (setq arg (1- arg)))
    (move-to-column col)))

(defun keisen-shrink-horizontally (arg) ;--------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$r2#J}8~$K=L$a$k(B.$B%]%$%s%H$N8e$N0l7e$r:o=|$7$F7S@~$r0l9T=L$a$k(B"
  (interactive "*p")
  (let* ((col (km:adjusted-current-column))
         (oldline (+ (count-lines (point-min) (point))
                     (if (= col 0) 1 0)))
         (count (km:check-vertically oldline))
	 line-width beg end)
    (while (< 0 count)
      (setq line-width (progn (end-of-line) (current-column)))
      (if (> col line-width)
	  nil
	(km:move-to-column-force col t)
	(setq beg (point))
	(km:move-to-column-force (min (+ col (* 2 arg)) line-width))
	(setq end (point))
	(delete-region beg end))
      (forward-line 1)
      (setq count (1- count)))
    (goto-line oldline)
    (move-to-column col)))

(defun keisen-clean () ;-------------------------------------------------------
 "[$B7S@~%b!<%I5!G=(B]
 $B9TKv$NL50UL#$J%?%V$d%9%Z!<%9$r<h$j=|$/(B"
 (interactive "*")
 (save-excursion
   (goto-char (point-min))
   (while (re-search-forward "[$B!!(B \t]+$" nil t)
     (delete-region (match-beginning 0) (point))))
 (message "done"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B:o=|!JJ]B8!K5!G=DI2C(B [rect.el$B!"(Bregister.el$B$h$jH4?h(B]
;;
(defvar km:rectangle-save-buffer nil "$B6k7A%P%C%U%!(B")
(defvar km:rectangle-save-register-alist nil "$B6k7A%P%C%U%!%l%8%9%?(B")

(defun keisen-kill-rectangle () ;----------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
  $B7S@~%^!<%/@_Dj%]%$%s%H(B(km:what-mark-point)$B$H%+%l%s%H%]%$%s%H(B(point)$B$r7k$s$G(B
$BBP3Q@~$H$J$k;M3Q7A$NOHFb$r6k7A%P%C%U%!(B(km:rectangle-save-buffer)$B$KJ]B8$7!"$=$N(B
$BOHFb$NJ8;zNs$O:o=|$9$k!#:o=|$7$?ItJ,$O6uGr$K$h$C$FKd$a$i$l$k!#(B
  $BOHFb$K7S@~$,B8:_$7$?>l9g!"6uGr$H$7$FJ]B8$5$l$k!#(B
  $B7S@~$OF0$$$?$j>C$($?$j$7$J$$!#(B"
  (interactive)
  (let ((start (km:what-mark-point))
        (end   (point)))
    (setq km:rectangle-save-buffer (km:kill-extract-rectangle start end))))

(defun keisen-kill-rectangle-to-register (char) ;------------------------------
  "[$B7S@~%b!<%I5!G=(B]
  $B7S@~%^!<%/@_Dj%]%$%s%H(B(km:what-mark-point)$B$H%+%l%s%H%]%$%s%H(B(point)$B$r7k$s$G(B
$BBP3Q@~$H$J$k;M3Q7A$NOHFb$r6k7A%P%C%U%!%l%8%9%?(B(km:rectangle-save-register
-alist)$B$K;XDj$7$?%l%8%9%?L>$GJ]B8$7!"$=$NOHFb$NJ8;zNs$O:o=|$9$k!#:o=|$7$?ItJ,(B
$B$O6uGr$K$h$C$FKd$a$i$l$k!#(B
  $BOHFb$K7S@~$,B8:_$7$?>l9g!"6uGr$H$7$FJ]B8$5$l$k!#(B
  $B7S@~$OF0$$$?$j>C$($?$j$7$J$$!#(B"
  (interactive "cKeisen kill rectangle to register: \n")
  (let ((start (km:what-mark-point))
        (end   (point)))
    (km:set-register char (km:kill-extract-rectangle start end))))

(defun keisen-delete-rectangle () ;--------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
  $B7S@~%^!<%/@_Dj%]%$%s%H(B(km:what-mark-point)$B$H%+%l%s%H%]%$%s%H(B(point)$B$r7k$s$G(B
$BBP3Q@~$H$J$k;M3Q7A$NOHFb$r6k7A%P%C%U%!(B(km:rectangle-save-buffer)$B$KJ]B8$7!"$=$N(B
$BOHFb$NJ8;zNs$O:o=|$9$k!#(B
  $BOHFb$K7S@~$,B8:_$7$?>l9g!"6uGr$H$7$FJ]B8$5$l$k!#(B
  $B7S@~$OF0$$$?$j>C$($?$j$7$J$$!#(B"
  (interactive)
  (let ((start (km:what-mark-point))
        (end   (point)))
    (setq km:rectangle-save-buffer (km:delete-extract-rectangle start end))))

(defun keisen-delete-rectangle-to-register (char) ;----------------------------
  "[$B7S@~%b!<%I5!G=(B]
  $B7S@~%^!<%/@_Dj%]%$%s%H(B(km:what-mark-point)$B$H%+%l%s%H%]%$%s%H(B(point)$B$r7k$s$G(B
$BBP3Q@~$H$J$k;M3Q7A$NOHFb$r6k7A%P%C%U%!%l%8%9%?(B(km:rectangle-save-register
-alist)$B$K;XDj$7$?%l%8%9%?L>$GJ]B8$7!"$=$NOHFb$NJ8;zNs$O:o=|$9$k!#(B
  $BOHFb$K7S@~$,B8:_$7$?>l9g!"6uGr$H$7$FJ]B8$5$l$k!#(B
  $B7S@~$OF0$$$?$j>C$($?$j$7$J$$!#(B"
  (interactive "cKeisen delete rectangle to register: \n")
  (let ((start (km:what-mark-point))
        (end   (point)))
    (km:set-register char (km:delete-extract-rectangle start end))))

(defun keisen-save-rectangle () ;----------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
  $B7S@~%^!<%/@_Dj%]%$%s%H(B(km:what-mark-point)$B$H%+%l%s%H%]%$%s%H(B(point)$B$r7k$s$G(B
$BBP3Q@~$H$J$k;M3Q7A$NOHFb$r6k7A%P%C%U%!(B(km:rectangle-save-buffer)$B$KJ]B8$9$k!#(B
  $BOHFb$NJ8;zNs$O:o=|$7$J$$!#(B
  $BOHFb$K7S@~$,B8:_$7$?>l9g!"6uGr$H$_$J$7$FJ]B8$5$l$k!#(B"
  (interactive)
  (let ((start (km:what-mark-point))
        (end   (point)))
    (setq km:rectangle-save-buffer (km:save-extract-rectangle start end))))

(defun keisen-save-rectangle-to-register (char) ;------------------------------
  "[$B7S@~%b!<%I5!G=(B]
  $B7S@~%^!<%/@_Dj%]%$%s%H(B(km:what-mark-point)$B$H%+%l%s%H%]%$%s%H(B(point)$B$r7k$s$G(B
$BBP3Q@~$H$J$k;M3Q7A$NOHFb$r6k7A%P%C%U%!%l%8%9%?(B(km:rectangle-save-buffer-alist)
$B$K;XDj$7$?%l%8%9%?L>$GJ]B8$9$k!#(B
  $BOHFb$NJ8;zNs$O:o=|$7$J$$!#(B
  $BOHFb$K7S@~$,B8:_$7$?>l9g!"6uGr$H$_$J$7$FJ]B8$5$l$k!#(B"
  (interactive "cKeisen save rectangle to register: \n")
  (let ((start (km:what-mark-point))
        (end   (point)))
    (km:set-register char (km:save-extract-rectangle start end))))

(defun keisen-yank-rectangle () ;----------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
  $B%+%l%s%H%]%$%s%H(B(point)$B$r;OE@$H$7$F!"6k7A%P%C%U%!(B(km:rectangle-save-buffer)
$B$KJ]B8$5$l$F$$$kJ8;zNs$r%+%l%s%H%P%C%U%!$KA^F~$9$k!#(B
  $B7S@~$OF0$$$?$j>C$($?$j$7$J$$!#(B
  $B$J$*!"3F@)8f%U%i%0$K@)8B;v9`$,$"$k$N$GCm0U$9$k$3$H!#(B
    1. keisen-overwrite-mode$B$OM-8z(B
    2. keisen-auto-line-feed-flag$B$OL58z(B
    3. keisen-auto-enlarge-vertically-flag$B$OL58z(B
    4. keisen-auto-enlarge-horizontally-flag$B$OM-8z(B"
  (interactive)
  (km:insert-rectangle km:rectangle-save-buffer))

(defun keisen-yank-rectangle-from-register (char) ;----------------------------
  "[$B7S@~%b!<%I5!G=(B]
  $B%+%l%s%H%]%$%s%H(B(point)$B$r;OE@$H$7$F!"6k7A%P%C%U%!%l%8%9%?(B(km:rectangle-save
-register-alist)$B$N;XDj$5$l$?%l%8%9%?L>$KJ]B8$5$l$F$$$kJ8;zNs$r%+%l%s%H%P%C%U%!(B
$B$KA^F~$9$k!#(B
  $B7S@~$OF0$$$?$j>C$($?$j$7$J$$!#(B
  $B$J$*!"3F@)8f%U%i%0$K@)8B;v9`$,$"$k$N$GCm0U$9$k$3$H!#(B
    1. keisen-overwrite-mode$B$OM-8z(B
    2. keisen-auto-line-feed-flag$B$OL58z(B
    3. keisen-auto-enlarge-vertically-flag$B$OL58z(B
    4. keisen-auto-enlarge-horizontally-flag$B$OM-8z(B"
  (interactive "cKeisen yank rectangle from register: \n")
  (km:insert-rectangle (km:get-register char)))

(defun keisen-view-rectangle-register (char) ;---------------------------------
  "[$B7S@~%b!<%I5!G=(B]
  $B6k7A%P%C%U%!%l%8%9%?(B(km:rectangle-save-register-alist)$B$N;XDj$5$l$?%l%8%9%?L>(B
$B$KJ]B8$5$l$F$$$kJ8;zNs$rI=<($9$k!#(B"
  (interactive "cKeisen view rectangle register: \n")
  (let ((val (km:get-register char)))
    (if (null val)
        (message "Register %s is empty" (single-key-description char))
      (with-output-to-temp-buffer "*Output*"
        (princ "Register ")
        (princ (single-key-description char))
        (princ " contains ")
        (if (integerp val)
            (princ val)
          (if (markerp val)
              (progn
                (princ "a buffer position:\nbuffer ")
                (princ (buffer-name (marker-buffer val)))
                (princ ", position ")
                (princ (+ 0 val)))
            (if (consp val)
                (progn
                  (princ "the rectangle:\n")
                  (while val
                    (princ (car val))
                    (terpri)
                    (setq val (cdr val))))
              (princ "the string:\n")
              (princ val))))))))

(defun keisen-open-rectangle () ;----------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
  $B7S@~%^!<%/@_Dj%]%$%s%H(B(km:what-mark-point)$B$H%+%l%s%H%]%$%s%H(B(point)$B$r7k$s$G(B
$BBP3Q@~$H$J$k;M3Q7A$NOHFb$K6uGr$rA^F~$9$k!#(B
  $BOH$N1&B&$NJ8;zNs$O6uGr$,A^F~$5$l$?J,!"1&$X%7%U%H$5$l$k!#(B
  $B7S@~$OF0$$$?$j>C$($?$j$7$J$$!#(B"
  (interactive)
  (let ((start (km:what-mark-point))
        (end   (point))
        (old_flag keisen-auto-line-feed-flag))
    (setq keisen-auto-line-feed-flag nil)
    (km:operate-on-rectangle 'km:open-rectangle-line start end nil)
    (setq keisen-auto-line-feed-flag old_flag)))

(defun keisen-clear-rectangle () ;---------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
  $B7S@~%^!<%/@_Dj%]%$%s%H(B(km:what-mark-point)$B$H%+%l%s%H%]%$%s%H(B(point)$B$r7k$s$G(B
$BBP3Q@~$H$J$k;M3Q7A$NOHFb$r>C5n$9$k!#(B
  $BOH$N1&B&$NJ8;zNs$O6uGr$,>C5n$5$l$?J,!":8$X%7%U%H$5$l$k!#(B
  $B7S@~$OF0$$$?$j>C$($?$j$7$J$$!#(B"
  (interactive)
  (let ((start (km:what-mark-point))
        (end   (point)))
    (km:operate-on-rectangle 'km:clear-rectangle-line start end t)))

(defun km:operate-on-rectangle (function start end coerce-tabs) ;--------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (let (sta_col sta_pos end_col end_pos)
    (save-excursion
      (goto-char start)
      (setq sta_col (current-column))  ;$B3+;O%+%i%`(B
      (beginning-of-line)
      (setq sta_pos (point)))          ;$B3+;O%i%$%s$N@hF,%]%$%s%H(B
    (save-excursion
      (goto-char end)
      (setq end_col (current-column))  ;$B=*N;%+%i%`(B
      (forward-line 1)
      (setq end_pos (point-marker)))   ;$B=*N;%+%i%`$N<!%+%i%`%]%$%s%H(B
    ;$B%+%i%`$NBg>.%A%'%C%/(B
    (if (< end_col sta_col)
        (let ((temp sta_col))
          (setq sta_col end_col end_col temp)))
    (if (/= end_col sta_col)
        (save-excursion
          (goto-char sta_pos)
          (while (< (point) end_pos)
            (let (startpos begextra endextra)
              ;
              (move-to-column sta_col)
              (and coerce-tabs
                   (> (current-column) sta_col)
                   (km:rectangle-coerce-tab sta_col))
              (setq begextra (- (current-column) sta_col)
                    startpos (point))
              ;
              (move-to-column end_col)
              (if (> (current-column) end_col)
                  (if coerce-tabs
                      (km:rectangle-coerce-tab end_col)
                    (forward-char -1)))
              (setq endextra (- end_col (current-column)))
              ;
              (if (< begextra 0)
                  (setq endextra (+ endextra begextra)
                        begextra 0))
              ;
              (funcall function startpos begextra endextra))
            (forward-line 1))))
    (- end_col sta_col)))

(defun km:kill-extract-rectangle (start end) ;---------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (let (lines)
    (km:operate-on-rectangle 'km:kill-extract-rectangle-line start end t)
    (nreverse lines)))

(defun km:kill-extract-rectangle-line (startdelpos begextra endextra) ;--------
  "[$B7S@~%b!<%I4X?t(B]
"
  (save-excursion
    (km:extract-rectangle-line startdelpos begextra endextra 2)))

(defun km:delete-extract-rectangle (start end) ;-------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (let (lines)
    (km:operate-on-rectangle 'km:delete-extract-rectangle-line start end t)
    (nreverse lines)))

(defun km:delete-extract-rectangle-line (startdelpos begextra endextra) ;------
  "[$B7S@~%b!<%I4X?t(B]
"
  (save-excursion
    (km:extract-rectangle-line startdelpos begextra endextra 1)))

(defun km:save-extract-rectangle (start end) ;---------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (let (lines)
    (km:operate-on-rectangle 'km:save-extract-rectangle-line start end t)
    (nreverse lines)))

(defun km:save-extract-rectangle-line (startdelpos begextra endextra) ;--------
  "[$B7S@~%b!<%I4X?t(B]
"
  (save-excursion
   (km:extract-rectangle-line startdelpos begextra endextra 0)))

(defun km:extract-rectangle-line (startdelpos begextra endextra delete_type) ;-
  "[$B7S@~%b!<%I4X?t(B]
"
  (let ((line "")
        (endcol (current-column))
	lines)
    (goto-char startdelpos)
    (while (> endcol (current-column))
      (let ((ch (char-to-string (following-char))))
        (if (string-match keisen-regexp ch) ;$B7S@~!)(B
            (progn (setq line
                         (concat line
                                 (make-string (char-width (string-to-char ch))
                                              (string-to-char " "))))
                   (forward-char 1))
          (setq line (concat line ch))
          (cond ((= delete_type 0)
                 (forward-char))
                ((= delete_type 1)
                 (keisen-clear-char)
                 (setq endcol (- endcol (char-width (string-to-char ch)))))
                ((= delete_type 2)
                 (keisen-clear-char)
                 (keisen-insert-string (make-string
                                        (char-width (string-to-char ch))
                                        (string-to-char " "))))))))
    (setq lines (cons line lines))))

(defun km:insert-rectangle (rectangle) ;---------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (let ((lines rectangle)
        (insertcolumn (current-column))
        (first t)
        (old_flag keisen-auto-line-feed-flag))
    (setq keisen-auto-line-feed-flag nil)
    (while lines
      (or first
          (progn
           (forward-line 1)
           (or (bolp) (insert ?\n))
           (move-to-column insertcolumn)
           (if (> (current-column) insertcolumn)
               (km:rectangle-coerce-tab insertcolumn))
           (if (< (current-column) insertcolumn)
               (indent-to insertcolumn))))
      (setq first nil)
      (if keisen-overwrite-mode
          (keisen-overwrite-string (car lines))
        (keisen-insert-string (car lines)))
      (setq lines (cdr lines)))
    (setq keisen-auto-line-feed-flag old_flag)))

(defun km:open-rectangle-line (startpos begextra endextra)
  "[$B7S@~%b!<%I4X?t(B]
  $B%+%l%s%H%i%$%s$N;XDj%]%$%s%H(B(startpos)$B$+$i%+%l%s%H%]%$%s%H(B(point)$B$^$G6uGr$rA^(B
$BF~$9$k!#J8;zNs$OA^F~$7$?J,!"1&$X%7%U%H$5$l$k!#(B
  $B7S@~$OF0$+$7$?$j>C$7$?$j$O$7$J$$!#(B"
  (let ((num (km:buffer-column startpos (point))))
    (goto-char startpos)
    (keisen-insert-string (make-string num (string-to-char " ")))))

(defun km:clear-rectangle-line (startpos begextra endextra) ;------------------
  "[$B7S@~%b!<%I4X?t(B]
  $B%+%l%s%H%i%$%s$N;XDj%]%$%s%H(B(startpos)$B$+$i%+%l%s%H%]%$%s%H(B(point)$B$^$G:o=|$7!"(B
$B6uGr$GKd$a$k!#(B
  $B7S@~$OF0$+$7$?$j>C$7$?$j$O$7$J$$!#(B"
  (let ((end (point)))
    (goto-char startpos)
    (while (> end (point))
      (let ((ch (following-char)))
        (if (string-match keisen-regexp ch)
            (forward-char 1)
          (keisen-clear-char)
          (keisen-insert-string (make-string (char-width (string-to-char ch))
                                             (string-to-char " "))))))))

(defun km:rectangle-coerce-tab (column) ;--------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (let ((aftercol (current-column))
        (indent-tabs-mode nil))
    (delete-char -1)
    (indent-to aftercol)
    (backward-char (- aftercol column))))

(defun km:get-register (char) ;------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
  $B;XDj$5$l$?%l%8%9%?L>(B(char)$B$NFbMF$r6k7A%P%C%U%!%l%8%9%?(B(km:rectangle-save
-register-alist)$B$+$i<h$j=P$9!#(B"
  (cdr (assq char km:rectangle-save-register-alist)))

(defun km:set-register (char value) ;------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
  $B;XDj$5$l$?%l%8%9%?L>(B(char)$B$GJ8;zNs(B(value)$B$r6k7A%P%C%U%!%l%8%9%?(B(km:rectangle
-save-register-alist)$B$KEPO?$9$k!#(B"
  (let ((aelt (assq char km:rectangle-save-register-alist)))
    (if aelt
        (setcdr aelt value)
      (setq aelt (cons char value))
      (setq km:rectangle-save-register-alist
            (cons aelt km:rectangle-save-register-alist)))))

;;$B$*$^$1%3!<%J!<Bh(B2$BCF(B
;;  keisen-square-line2$B4X?t$GL#$r$7$a$F$7$^$C$?;d$O!"$H$&$H$&$3$s$J4X?t$^$G(B
;;  $B:n$C$F$7$^$C$?(B...
;;  $B$O$C$-$j8@$C$F!"BgJQ$G$7$?(B.$B$G$b!"JXMx(B($B$+$J(B?)$B$@$H;W$&$N$G;H$C$F$M!*(B
(defun keisen-rectangle () ;---------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B;OE@$H=*E@$rG$0U$KA*Br$7OHFb$NJ8;zNs$rJ]B8!":o=|$J$I@)8f$9$k(B."
  (interactive)
  (let ((sta_pos (point))       ;$B;OE@%]%$%s%H(B
        (sta_col 0)             ;$B;OE@%+%i%`(B
        (sta_lin 0)             ;$B;OE@%i%$%s(B
        (end_col 0)             ;$B=*E@%+%i%`(B
        (end_lin 0)             ;$B=*E@%i%$%s(B
        (loop1   t)             ;$B%k!<%W%U%i%0(B $B$=$N(B1
        (loop2   t)             ;$B%k!<%W%U%i%0(B $B$=$N(B2
        (ch      nil))          ;$BF~NO%-!<(B
    ;$B3FJQ?t$N=i4|2=(B
    (setq sta_col (km:what-column sta_pos)
          sta_lin (km:what-line   sta_pos))
    (setq end_col sta_col end_lin sta_lin)
    ;$B%+!<%=%kE@LG3+;O(B
    (km:cursol-flash-start)
    ;$B%a%$%s=hM}(B
    (while loop1
      (message
       "keisen-rectangle[C-p:$B>e(B C-n:$B2<(B C-f:$B1&(B C-b:$B:8(B RET:$B7hDj(B ESC:$B<h>C(B]")
      (setq ch (km:read-char))
      ;$B=*E@$r>e$K(B1$B9T0\F0$9$k(B[Ctrl-p]
      (cond ((= ch ?\C-p)
             (if (= end_lin 1)
                 (progn (message "Can't move")
                        (sit-for 1))
               (km:cursol-flash-stop)
               (cond ((< sta_lin end_lin)
                      (if (= sta_col end_col)
                          (km:inverse-off-string end_col end_lin)
                        (km:inverse-off-horizontal sta_col end_lin))
                      (setq end_lin (1- end_lin))
                      (km:cursol-move end_col end_lin t)
                      (km:inverse-off-string end_col end_lin))
                     (t
                      (km:inverse-on-string end_col end_lin)
                      (setq end_lin (1- end_lin))
                      (km:cursol-move end_col end_lin t)
                      (if (/= sta_col end_col)
                          (km:inverse-on-horizontal sta_col end_lin))))
               (km:cursol-flash-start)))
            ;$B=*E@$r2<$K(B1$B9T0\F0$9$k(B[Ctrl-n]
            ((= ch ?\C-n)
             (km:cursol-flash-stop)
             (cond ((> sta_lin end_lin)
                    (if (= sta_col end_col)
                        (km:inverse-off-string end_col end_lin)
                      (km:inverse-off-horizontal sta_col end_lin))
                    (setq end_lin (1+ end_lin))
                    (km:cursol-move end_col end_lin t)
                    (km:inverse-off-string end_col end_lin))
                   (t
                    (setq end_lin (1+ end_lin))
                    (if (<= sta_col end_col)
                        (km:cursol-move end_col end_lin t)
                      (if (save-excursion
                            (km:cursol-move sta_col (1- end_lin))
                            (forward-char)
                            (eolp))
                          (progn
                            (km:inverse-off-string sta_col (1- end_lin))
                            (km:cursol-move end_col end_lin)
                            (km:inverse-on-string sta_col (1- end_lin)))
                        (km:cursol-move end_col end_lin t)))
                    (km:inverse-on-string end_col (1- end_lin))
                    (if (/= sta_col end_col)
                        (km:inverse-on-horizontal sta_col end_lin))))
             (km:cursol-flash-start))
            ;$B=*E@$r1&$K0\F0$9$k(B[Ctrl-f]
            ((= ch ?\C-f)
             (km:cursol-flash-stop)
             (cond ((> sta_col end_col)
                    (if (/= sta_lin end_lin)
                        (km:inverse-off-vertical sta_lin end_lin))
                    (forward-char)
                    (setq end_col (current-column))
                    (km:inverse-off-string end_col end_lin))
                   (t
                    (km:inverse-on-string end_col end_lin)
                    (forward-char)
                    (setq end_col (current-column))
                    (if (/= sta_lin end_lin)
                        (km:inverse-on-vertical sta_lin end_lin))))
             (km:cursol-flash-start))
            ;$B=*E@$r:8$K0\F0$9$k(B[Ctrl-b]
            ((= ch ?\C-b)
             (if (bolp)
                 (progn (message "Can't move")
                        (sit-for 1))
               (km:cursol-flash-stop)
               (cond ((< sta_col end_col)
                      (if (/= sta_lin end_lin)
                          (km:inverse-off-vertical sta_lin end_lin))
                      (backward-char)
                      (setq end_col (current-column))
                      (km:inverse-off-string end_col end_lin))
                     (t
                      (km:inverse-on-string end_col end_lin)
                      (backward-char)
                      (setq end_col (current-column))
                      (if (/= sta_lin end_lin)
                          (km:inverse-on-vertical sta_lin end_lin))))
               (km:cursol-flash-start)))
            ;$B7hDj%-!<(B[RET]$B$,2!2<$5$l$?(B
            ((= ch ?\C-m)
             (while loop2
               (message
                "keisen-rectangle[k:$B:o=|(B&$BJ]B8(B d:$B:o=|(B($B:85M(B)&$BJ]B8(B s:$BJ]B8(B o:$B%*!<%W%s(B c:$B%/%j%"(B]")
	       (setq ch (km:read-char))
               (cond ((= ch ?k)
                      (km:cursol-flash-stop)
                      ;$B7S@~MQ%^!<%/$N@_Dj(B
                      (setq keisen-mark-column sta_col
                            keisen-mark-line   sta_lin)
                      (km:inverse-off-square sta_col sta_lin end_col end_lin)
                      (km:cursol-move end_col end_lin t)
                      (keisen-kill-rectangle)
                      (setq loop2 nil))
                     ((= ch ?d))
                     ((= ch ?s))
                     ((= ch ?o)
                      (km:cursol-flash-stop)
                      ;$B7S@~MQ%^!<%/$N@_Dj(B
                      (setq keisen-mark-column sta_col
                            keisen-mark-line   sta_lin)
                      (km:inverse-off-square sta_col sta_lin end_col end_lin)
                      (km:cursol-move end_col end_lin t)
                      (keisen-open-rectangle)
                      (setq loop2 nil))
                     ((= ch ?c)
                      (km:cursol-flash-stop)
                      ;$B7S@~MQ%^!<%/$N@_Dj(B
                      (setq keisen-mark-column sta_col
                            keisen-mark-line   sta_lin)
                      (km:inverse-off-square sta_col sta_lin end_col end_lin)
                      (km:cursol-move end_col end_lin t)
                      (keisen-clear-rectangle)
                      (setq loop2 nil))
                     ;$BL$Dj5A%-!<$,2!2<$5$l$?(B
                     (t
                      (message "Undefine key!")
                      (sit-for 1))))
             (setq loop1 nil))
            ;$B<h>C%-!<(B[ESC]$B$,2!2<$5$l$?(B
            ((= ch ?\e)
             (km:cursol-flash-stop)
             (km:inverse-off-square sta_col sta_lin end_col end_lin)
             (km:cursol-move sta_col sta_lin t)
             (setq loop1 nil))
            ;$BL$Dj5A%-!<$,2!2<$5$l$?(B
            (t
             (message "Undefine key!")
             (sit-for 1))))))

(defun km:inverse-off-square (sta_col sta_lin end_col end_lin) ;---------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (save-excursion
    (let ((max_col (max sta_col end_col))
          (min_col (min sta_col end_col))
          (cur_lin (min sta_lin end_lin))
          (stp_lin (max sta_lin end_lin)))
      (while (not (> cur_lin stp_lin))
        (km:cursol-move max_col cur_lin)
        (forward-char)
        (km:inverse-off-horizontal min_col cur_lin)
        (setq cur_lin (1+ cur_lin))))))

(defun km:inverse-on-horizontal (sta_col sta_lin) ;----------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H9T(B($B2#(B)$B$N;XDj%+%i%`4V$NJ8;zNs$NB0@-$r!VH?E>!W$K$9$k(B"
  (save-excursion
    (let ((pos (point)))
      (km:cursol-move sta_col sta_lin)
      (if (> pos (point))
	  (km:inverse-on-region (point) pos)
	(km:inverse-on-region pos
			      (progn
				(if (eolp) (insert " ")	(forward-char))
				(point)))))))

(defun km:inverse-off-horizontal (sta_col sta_lin) ;---------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H9T(B($B2#(B)$B$N;XDj%+%i%`4V$NJ8;zNs$NB0@-$r!VH?E>!W$+$i85$KLa$9(B"
  (save-excursion
    (let ((pos (point)))
      (km:cursol-move sta_col sta_lin)
      (if (> pos (point))
	  (km:inverse-off-region (point) pos)
	(km:inverse-off-region pos (progn (forward-char) (point)))))))

(defun km:inverse-on-vertical (sta_lin end_lin) ;------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H7e(B($B=D(B)$B$N;XDj%i%$%s4V$NJ8;zNs$NB0@-$r!VH?E>!W$K$9$k(B"
  (let ((col (current-column))
        (lin (min sta_lin end_lin))
        (stp (max sta_lin end_lin)))
    (while (not (> lin stp))
      (km:inverse-on-string col lin)
      (setq lin (+ lin 1)))))

(defun km:inverse-off-vertical (sta_lin end_lin) ;-----------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H7e(B($B=D(B)$B$N;XDj%i%$%s4V$NJ8;zNs$NB0@-$r!VH?E>!W$+$i85$KLa$9(B"
  (let ((col (current-column))
        (lin (min sta_lin end_lin))
        (stp (max sta_lin end_lin)))
    (while (not (> lin stp))
      (km:inverse-off-string col lin)
      (setq lin (+ lin 1)))))

(defun km:inverse-on-string (col lin) ;----------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj0LCV$N(B1$BJ8;z$@$1B0@-$r!VH?E>!W$K$9$k(B"
  (save-excursion
    (km:cursol-move col lin)
    (km:inverse-on-region (point)
			  (progn
			    (if (eolp) (insert " ") (forward-char))
			    (point)))))

(defun km:inverse-off-string (col lin) ;---------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj0LCV$N(B1$BJ8;z$@$1B0@-$r!VH?E>!W$+$i85$KLa$9(B"
  (save-excursion
    (km:cursol-move col lin)
    (km:inverse-off-region (point) (progn (forward-char) (point)))))

(defvar km:cursol-flash-process nil "$B%+!<%=%kE@LG%W%m%;%9(B")
(defvar km:cursol-flash-interval 1 "$B%+!<%=%kE@LG4V3V(B")
(defvar km:cursol-flash-flag nil "$B%+!<%=%kE@LG%U%i%0(B")

(defun km:cursol-flash-start () ;----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+!<%=%kE@LG%W%m%;%9$r5/F0$9$k(B"
  (let ((live (and km:cursol-flash-process
		   (eq (process-status km:cursol-flash-process) 'run))))
    (if (not live)
	(progn
	  (if km:cursol-flash-process ;2$B=E5/F0$G$"$k(B
	      (delete-process km:cursol-flash-process))
	  (let ((process-connection-type nil))
	    (setq km:cursol-flash-process
		  (start-process "cursol-flash" nil
				 (concat exec-directory "wakeup")
				 (int-to-string km:cursol-flash-interval))))
	  (process-kill-without-query km:cursol-flash-process)
	  (set-process-filter   km:cursol-flash-process 'km:cursol-flash)))))

(defun km:cursol-flash-stop () ;-----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+!<%=%kE@LG%W%m%;%9$r=*N;$9$k(B"
  (if km:cursol-flash-process ;$B%W%m%;%95/F0Cf(B?
      (progn ;Yes
	(delete-process km:cursol-flash-process) ;$B%+!<%=%kE@LG%W%m%;%9:o=|(B
	(if (not km:cursol-flash-flag) ;$B%+!<%=%k>C5nCf(B?
	    ;; $B%+!<%=%kE@Et(B
	    (km:inverse-off-region (point) (progn (forward-char) (point))))
	(setq km:cursol-flash-flag    nil
	      km:cursol-flash-process nil))))

(defun km:cursol-flash (proc string) ;-----------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (let ((sta (point))
        (end (progn
	       (if (eolp) (insert " ") (forward-char))
	       (point))))
    (if km:cursol-flash-flag
	(km:inverse-on-region sta end) ;$B%+!<%=%k>C5n(B
      (km:inverse-off-region sta end)) ;$B%+!<%=%kE@Et(B
    (setq km:cursol-flash-flag (not km:cursol-flash-flag))))
;$B$($s$I(B $B$*$V(B $B$*$^$1%3!<%J!<(B

(defun keisen-insert-register (char &optional arg) ;-- Changed by M.Ozawa -----
  "[$B7S@~%b!<%I5!G=(B]
 "
  (interactive "cInsert register: \nP")
  (push-mark)
  (let ((val (get-register char)))
    (if (consp val)
	(if (eq major-mode 'keisen-mode)
	    (keisen-yank-rectangle-from-register char)
	  (insert-rectangle val))
      (if (stringp val)
	(if (eq major-mode 'keisen-mode)
	    (if keisen-overwrite-mode
		(keisen-overwrite-string val)
	      (keisen-insert-string val))
	  (insert val))
	(if (or (integerp val) (markerp val))
	    (princ (+ 0 val) (current-buffer))
	  (error "Register does not contain text")))))
  (or arg (exchange-point-and-mark)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  $B!J$*$^$1!K(B
;;      for laser printer in nasu lab.
;;
(defun zenkaku-space-current-buffer () ;---------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%+%l%s%H%P%C%U%!Fb$NO"B3$7$?Fs$D$NH>3Q%9%Z!<%9$r0l$D$NA43Q%9%Z!<%9$KJQ49$9$k(B"
  (interactive "*")
  (zenkaku-space-region (point-min) (point-max)))

(defun zenkaku-space-region (begin end) ;--------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%j!<%8%g%sFb$NO"B3$7$?Fs$D$NH>3Q%9%Z!<%9$r0l$D$NA43Q%9%Z!<%9$KJQ49$9$k(B"
  (interactive "*r")
  (save-excursion
    (goto-char begin)
    (while (re-search-forward "  \\|\t" end t)
      (if (= (preceding-char) ?\t)
          (progn (delete-backward-char 1)
                 (insert ? tab-width)
                 (backward-char (1+ tab-width)))
        (delete-backward-char 2)
        (insert "$B!!(B")))))              ;$BA43Q%9%Z!<%9(B

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B%^!<%/@_Dj(B
;;
(defvar keisen-mark-column nil "$B7S@~MQ%^!<%/@_Dj%+%i%`0LCV(B")
(defvar keisen-mark-line nil "$B7S@~MQ%^!<%/@_Dj%i%$%s0LCV(B")

(defun keisen-set-mark () ;----------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~%b!<%IMQ$N%^!<%/@_Dj%3%^%s%I(B"
  (interactive)
  (set-mark-command nil)
  (setq keisen-mark-column (current-column)         ; $B%^!<%/%+%i%`@_Dj(B
        keisen-mark-line   (km:what-current-line))) ; $B%^!<%/%i%$%s@_Dj(B

(defun km:what-mark-point () ;-------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B7S@~%b!<%IMQ$N%^!<%/@_Dj0LCV$r5a$a$k(B"
  (save-excursion
    (goto-line keisen-mark-line)
    (km:move-to-column-force keisen-mark-column nil)
    (point)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B%b!<%I(B
;;
(defun keisen-toggle-line () ;-- Based by S.Kobayashi -------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%+!<%=%k0\F0%b!<%I$N@Z$j49$($k(B."
  (interactive)
  (setq keisen-move-mode (not keisen-move-mode))
  (if keisen-move-mode
      (message "$B%+!<%=%k0\F0%b!<%I(B:Keisen")
    (message "$B%+!<%=%k0\F0%b!<%I(B:Major")))

(defun keisen-toggle-move () ;-------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%+!<%=%k0\F0%l%Y%k$r@Z$j49$($k(B."
  (interactive)
  (cond ((= keisen-move-level 0)
         (setq keisen-move-level 1)
         (message "$B%+!<%=%k0\F0%l%Y%k(B:Level1"))
        ((= keisen-move-level 1)
         (setq keisen-move-level 2)
         (message "$B%+!<%=%k0\F0%l%Y%k(B:Level2"))
        ((= keisen-move-level 2)
         (setq keisen-move-level 0)
         (message "$B%+!<%=%k0\F0%l%Y%k(B:Normal"))))

(defun keisen-toggle-auto-enlarge () ;-----------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$N<+F03HD%%b!<%I$r@Z$j49$($k(B."
  (interactive)
  (cond (keisen-auto-enlarge-vertically-flag
         (setq keisen-auto-enlarge-vertically-flag nil
               keisen-auto-enlarge-horizontally-flag t)
         (message "$B<+F03HD%%b!<%I(B:ON[$B2#J}8~(B]"))
        (keisen-auto-enlarge-horizontally-flag
         (setq keisen-auto-enlarge-horizontally-flag nil)
         (message "$B<+F03HD%%b!<%I(B:OFF"))
        (t
         (setq keisen-auto-enlarge-vertically-flag t)
         (message "$B<+F03HD%%b!<%I(B:ON[$B=DJ}8~(B]"))))

(defun keisen-toggle-auto-line-feed () ;---------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$N<+F02~9T%b!<%I$r@Z$j49$($k(B."
  (interactive)
  (setq keisen-auto-line-feed-flag (not keisen-auto-line-feed-flag))
  (if keisen-auto-line-feed-flag
      (message "$B<+F02~9T%b!<%I(B:ON")
    (message "$B<+F02~9T%b!<%I(B:OFF")))

(defun keisen-overwrite-mode () ;----------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~%b!<%I$G$N%$%s%5!<%H%b!<%I$H%*!<%P!<%i%$%H%b!<%I$r@Z$jBX$($k(B."
  (interactive)
  (if keisen-overwrite-mode
      (setq self-insert-after-hook 'km:self-insert-after-insert-hook)
    (setq self-insert-after-hook 'km:self-insert-after-overwrite-hook))
  (setq keisen-overwrite-mode (not keisen-overwrite-mode))
  (km:update-mode-line))

(defun keisen-toggle-width () ;------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~$NB@$5$r@Z$j49$($k(B."
  (interactive)
  (setq keisen-width (cond ((= keisen-width 0) 1)   ;$B>C5n"*:Y@~(B
                           ((= keisen-width 1) 2)   ;$B:Y@~"*B@@~(B
                           ((= keisen-width 2) 0))) ;$BB@@~"*>C5n(B
  (km:update-mode-line))

(defun km:update-mode-line () ;------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%b!<%I%i%$%s$r?7$7$/=q$-49$($k(B."
  (let ((v km:vertical-step)
        (h km:horizontal-step))
    (setq mode-name (format "$B7S@~(B:%s:%s:%s"
                            (car (nthcdr (+ 2 (% h 3) (* 5 (1+ (% v 2))))
                                         '(wnw $B"+",(B $B",(B $B","*(B ene
                                               Left $B"+(B none $B"*(B
                                               Right wsw $B"+"-(B $B"-(B $B"-"*(B ese)))
                            (nth  keisen-width '($B!!(B $B(+(B $B(6(B))
                            (if (eq self-insert-after-hook
                                    'km:self-insert-after-overwrite-hook)
                                '$B#O(B
                              '$B#I(B)))
    (set-buffer-modified-p (buffer-modified-p))))

;;;###autoload
(defun keisen-mode () ;--------------------------------------------------------
  "[$B7S@~%b!<%I(B]

$B!&7S@~%b!<%I$G$O7S@~$OJ8;z$r%G%j!<%H$7$F$bF0$+$:7S@~$KBP$9$k%3%^%s%I0J30$G$O(B
  $BF0$+$9$3$H$b>C$9$3$H$b$G$-$J$$(B.
$B!&%*!<%P!<%i%$%H$G$b%$%s%5!<%H$G$b$I$A$i$G$bF~NO$G$-$k(B.
  $B!J(Boverwrite$B$O7S@~%b!<%I$N(Bkeisen-overwrite-mode$B$r;HMQ$9$k!K(B
$B!&7S@~$NB@$5$O#2<oN`!">C5nMQ$N@~#1<oN`(B.
$B!&%?%V$O7S@~%b!<%I$K$O$$$k;~$K%9%Z!<%9$KJQ49$9$k(B.
$B!&(B()$B$N$D$$$F$$$k%3%^%s%I$O(BC-u$B$G0z?t$rM?$($k$3$H$,$G$-$k(B.

$B(#(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!($(B
$B("7S@~%b!<%I5!G=0lMwI=!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B('(!(((!(!(((!(!(!(!(!(!(!(!(!(!(!(((!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("%-!<("4X?tL>>N!!!!!!!!!!!!!!("@bL@!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B(<(,(;(,(,(;(,(,(,(,(,(,(,(,(,(,(,(;(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(>(B
$B("0\("(BC-j $B("(Bkeisen-locked         $B("7S@~$rHt$S1[$($J$$HO0O$G2~9T(B            $B("(B
$B("F0("(B    $B("(B     -forward-line-ext$B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("(B  $B("(BC-oj$B("(Bkeisen-change-locked  $B("7S@~$rHt$S1[$($J$$HO0O$G2~9T(B            $B("(B
$B("(B  $B("(B    $B("(B        -forward-after$B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("(B  $B("(BLFD $B("(Bkeisen-half-locked $B!!(B $B("=DJ}8~$N7S@~$rHt$S1[$($J$$HO0O$G2~9T(B $B!!(B $B("(B
$B("!!("(B    $B("(B         -forward-line$B("(B $B!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!(B $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("(B  $B("(BC-e $B("(Bkeisen-end-of-line    $B("%+%l%s%H9T$G6uGr$G$J$$0lHV:G8e$NJ8;z$K0\("(B
$B("!!("!!!!("!!!!!!!!!!!!!!!!!!!!!!("F0!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-o $B("(Bkeisen-forward-jump$B!!(B $B("%+%l%s%HOH$+$i1&OH$X0\F0!!!!!!!!!!!!!!!!("(B
$B("!!("(B C-f$B("!!!!!!!!!!!!!!!!(B-frame$B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-o $B("(Bkeisen-backward-jump  $B("%+%l%s%HOH$+$i:8OH$X0\F0!!!!!!!!!!!!!!!!("(B
$B("!!("(B C-b$B("!!!!!!!!!!!!!!!!(B-frame$B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-o $B("(Bkeisen-previous-jump$B!!("%+%l%s%HOH$+$i>e$NOH$X0\F0!!!!!!!!!!!!!!("(B
$B("!!("(B C-p$B("!!!!!!!!!!!!!!!!(B-frame$B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-o $B("(Bkeisen-next-jump-frame$B("%+%l%s%HOH$+$i2<$NOH$X0\F0!!!!!!!!!!!!!!("(B
$B("!!("(B C-n$B("!!!!!!!!!!!!!!!!!!!!!!("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B('(!(+(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("IA("(BM-OC$B("(Bkeisen-draw-right ()$B!!("7S@~$r0z$-$J$,$i1&J}8~$K0\F0$9$k!!!!!!!!("(B
$B("2h("(B    $B("(B                    $B!!("(B(keisen-key-flag$B$,(Bnil$B$N;~(B)              $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("(B  $B("(BM-OD$B("(Bkeisen-draw-left ()$B!!(B $B("7S@~$r0z$-$J$,$i:8J}8~$K0\F0$9$k!!!!!!!!("(B
$B("!!("(B    $B("(B                   $B!!(B $B("(B(keisen-key-flag$B$,(Bnil$B$N;~(B)              $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-OA$B("(Bkeisen-draw-up ()     $B("7S@~$r0z$-$J$,$i>eJ}8~$K0\F0$9$k!!!!!!!!("(B
$B("!!("(B    $B("(B                      $B("(B(keisen-key-flag$B$,(Bnil$B$N;~(B)              $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-OB$B("(Bkeisen-draw-down ()   $B("7S@~$r0z$-$J$,$i2<J}8~$K0\F0$9$k!!!!!!!!("(B
$B("!!("(B    $B("(B                      $B("(B(keisen-key-flag$B$,(Bnil$B$N;~(B)              $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-f $B("(Bkeisen-draw-right ()  $B("7S@~$r0z$-$J$,$i1&J}8~$K0\F0$9$k!!(B $B!!!!(B $B("(B
$B("!!("(B    $B("(B                      $B("(B(keisen-key-flag$B$,(Bt$B$N;~(B)                $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-b $B("(Bkeisen-draw-left ()   $B("7S@~$r0z$-$J$,$i:8J}8~$K0\F0$9$k(B $B!!!!!!(B $B("(B
$B("!!("(B    $B("(B                      $B("(B(keisen-key-flag$B$,(Bt$B$N;~(B) $B!!!!!!!!!!!!!!(B $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-p $B("(Bkeisen-draw-up ()$B!!!!(B $B("7S@~$r0z$-$J$,$i>eJ}8~$K0\F0$9$k!!!!!!!!("(B
$B("!!("(B    $B("(B                 $B!!!!(B $B("(B(keisen-key-flag$B$,(Bt$B$N;~(B) $B!!!!!!!!!!!!!!(B $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-n $B("(Bkeisen-draw-down ()$B!!(B $B("7S@~$r0z$-$J$,$i2<J}8~$K0\F0$9$k!!!!!!!!("(B
$B("!!("(B    $B("(B                   $B!!(B $B("(B(keisen-key-flag$B$,(Bt$B$N;~(B) $B!!!!!!!!!!!!!!(B $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-r $B("(Bkeisen-square-line$B!!!!("%j!<%8%g%s$rBP3Q@~$H8+$F7S@~$G;M3Q$rIA$/("(B
$B("!!("(B    $B("(B                  $B!!!!("%j!<%8%g%s$,0lD>@~>e$K$"$k$H$-$OD>@~$r0z("(B
$B("!!("(B    $B("(B                  $B!!!!("$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-s $B("(Bkeisen-square-line2   $B("%]%$%s%H$N0L0LCV$r;OE@$H$7$F!"%_%K%P%C%U("(B
$B("!!("(B    $B("(B                      $B("%!$K=>$$=*E@$rDj$a(BRET$B%-!<$r2!2<$9$k$H;O(B $B("(B
$B("!!("(B    $B("(B                      $B("E@$H=*E@$rBP3Q@~$H8+$F7S@~$G;M3Q$rIA$/(B  $B("(B
$B("!!("(B    $B("(B                      $B(";OE@$H=*E@$,0lD>@~>e$K$"$k$H$-$OD>@~$r0z("(B
$B("!!("(B    $B("(B                      $B("$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!("(B    $B("(B                      $B("(BESC$B%-!<$G%-%c%s%;%k$9$k$3$H$b=PMh$k!!!!(B $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-cf$B("(Bkeisen-extend-right   $B("<!$N7S@~$K$V$D$+$k$^$G7S@~$r1&$K?-$P$7$F("(B
$B("!!("(B    $B("(B                      $B("0z$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-cb$B("(Bkeisen-extend-left    $B("<!$N7S@~$K$V$D$+$k$^$G7S@~$r:8$K?-$P$7$F("(B
$B("!!("(B    $B("(B                      $B("0z$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-cp$B("(Bkeisen-extend-up$B!!!!!!("<!$N7S@~$K$V$D$+$k$^$G7S@~$r>e$K?-$P$7$F("(B
$B("!!("(B    $B("(B                $B!!!!!!("0z$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-cn$B("(Bkeisen-extend-down$B!!!!("<!$N7S@~$K$V$D$+$k$^$G7S@~$r2<$K?-$P$7$F("(B
$B("!!("(B    $B("(B                  $B!!!!("0z$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-o $B("(Bkeisen-line       $B!!!!("<!$N7S@~$K$V$D$+$k$^$G7S@~$r2<$K?-$P$7$F("(B
$B("!!("(B C-h$B("(B         -horizontally$B("0z$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-o $B("(Bkeisen-line-vertically$B("<!$N7S@~$K$V$D$+$k$^$G7S@~$r2<$K?-$P$7$F("(B
$B("!!("(B C-v$B("(B                      $B("0z$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-o $B("(Bkeisen-arrow-down     $B("<!$N7S@~$K$V$D$+$k$^$G7S@~$r2<$K?-$P$7$F("(B
$B("!!("(B C-d$B("(B                      $B("0z$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-o $B("(Bkeisen-arrow-up       $B("<!$N7S@~$K$V$D$+$k$^$G7S@~$r2<$K?-$P$7$F("(B
$B("!!("(B C-u$B("(B                      $B("0z$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-o $B("(Bkeisen-arrow-right    $B("<!$N7S@~$K$V$D$+$k$^$G7S@~$r2<$K?-$P$7$F("(B
$B("!!("(B C-r$B("(B                      $B("0z$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-o $B("(Bkeisen-arrow-left     $B("<!$N7S@~$K$V$D$+$k$^$G7S@~$r2<$K?-$P$7$F("(B
$B("!!("(B C-l$B("(B                      $B("0z$/!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B('(!(+(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("A^("!!!!("(Bkeisen-overwrite      $B("J8;zNs$r%*!<%P!<%i%$%H$9$k!!!!!!!!!!!!!!("(B
$B("F~("!!!!("!!!!!!!!!!(B     -string$B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("!!!!("(Bkeisen-insert-string$B!!("J8;zNs$r%$%s%5!<%H$9$k!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("!!!!("(Bkeisen-insert-register$B("J8;zNs$r%$%s%5!<%H$9$k!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BRET $B("(Bkeisen-newline$B!!!!!!!!("%]%$%s%H$N0LCV$G9T$rJ,3d$7$F?7$7$$9T$rA^("(B
$B("!!("(B    $B("(B              $B!!!!!!!!("F~$9$k!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-sp$B("(Bkeisen-insert-blank ()$B("%]%$%s%H$N8e$N6uGr$rA^F~$9$k!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-cv$B("(Bkeisen-enlarge$B!!!!!!(B  $B("%]%$%s%H$N0LCV$G=DJ}8~$K7S@~$r?-$P$9!!!!("(B
$B("!!("(B    $B("(B         -vertically()$B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-ch$B("(Bkeisen-enlarge$B!!!!!!!!("%]%$%s%H$N0LCV$G2#J}8~$K7S@~$r?-$P$9!!!!("(B
$B("!!("(B    $B("!!!!!!(B -horizontally()$B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-y $B("(Bkeisen-yank$B!!!!!!!!!!(B $B("J]B8$7$F$*$$$?J8;zNs$r%]%$%s%H$NA0$KA^F~("(B
$B("!!("(B    $B("(B           $B!!!!!!!!!!(B $B("$9$k!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-c>$B("(Bkeisen-movement-right $B("1&J}8~$XJ8;zNs$r%*!<%P!<%i%$%H$9$k!!!!!!("(B
$B("!!("(B    $B("(B                      $B("(B(keisen-overwrite-mode$B$,(Bnon-nil$B$N;~(B)$B!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-c<$B("(Bkeisen-movement-left  $B(":8J}8~$XJ8;zNs$r%*!<%P!<%i%$%H$9$k!!!!!!("(B
$B("!!("(B    $B("(B                      $B("(B(keisen-overwrite-mode$B$,(Bnon-nil$B$N;~(B)$B!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-c^$B("(Bkeisen-movement-up    $B(">eJ}8~$XJ8;zNs$r%*!<%P!<%i%$%H$9$k!!!!!!("(B
$B("!!("(B    $B("(B                      $B("(B(keisen-overwrite-mode$B$,(Bnon-nil$B$N;~(B)$B!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-c.$B("(Bkeisen-movement-down$B!!("2<J}8~$XJ8;zNs$r%*!<%P!<%i%$%H$9$k!!!!!!("(B
$B("!!("(B    $B("(B                    $B!!("(B(keisen-overwrite-mode$B$,(Bnon-nil$B$N;~(B)$B!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-c`$B("(Bkeisen-movement-nw$B!!!!(":8>e(B($BKL@>(B:NorthWest)$BJ}8~$XJ8;zNs$r%*!<%P("(B
$B("!!("(B    $B("(B                  $B!!!!("!<%i%$%H$9$k!!!!(B $B!!!!(B           $B!!!!!!!!("(B
$B("!!("(B    $B("(B                  $B!!!!("(B(keisen-overwrite-mode$B$,(Bnon-nil$B$N;~(B)$B!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-c'$B("(Bkeisen-movement-ne$B!!!!("1&>e(B($BKLEl(B:NorthEast)$BJ}8~$XJ8;zNs$r%*!<%P("(B
$B("!!("(B    $B("(B                  $B!!!!("!<%i%$%H$9$k!!!!(B $B!!!!(B           $B!!!!!!!!("(B
$B("!!("(B    $B("(B                  $B!!!!("(B(keisen-overwrite-mode$B$,(Bnon-nil$B$N;~(B)$B!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-c/$B("(Bkeisen-movement-sw$B!!!!(":82<(B($BFn@>(B:SouthWest)$BJ}8~$XJ8;zNs$r%*!<%P("(B
$B("!!("(B    $B("(B                  $B!!!!("!<%i%$%H$9$k!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!("(B    $B("(B                  $B!!!!("(B(keisen-overwrite-mode$B$,(Bnon-nil$B$N;~(B)$B!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-c\\$B("(Bkeisen-movement-se$B!!!!("1&2<(B($BFnEl(B:SouthEast)$BJ}8~$XJ8;zNs$r%*!<%P("(B
$B("!!("(B    $B("(B                  $B!!!!("%i%$%H$9$k!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!("(B    $B("(B                  $B!!!!("(B(keisen-overwrite-mode$B$,(Bnon-nil$B$N;~(B)$B!!!!("(B
$B('(!(+(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B(":o("(BC-k $B("(Bkeisen-clear-line$B!!!!(B $B("%]%$%s%H$+$i<!$N7S@~$^$?$O9TC<$^$G$r:o=|("(B
$B("=|("!!!!("!!!!!!!!!!!!!!!!!!!!!!("!&J]B8$9$k!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-d $B("(Bkeisen-clear-char$B!!!!(B $B("%]%$%s%H$N8e$m$N%-%c%i%/%?!<$r#1J8;z>C5n("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-of$B("(Bkeisen-clear-frame    $B("%]%$%s%H$N8e$m$N%-%c%i%/%?!<$r#1J8;z>C5n("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-od$B("(Bkeisen-clear-keisen   $B("%]%$%s%H$N8e$m$N%-%c%i%/%?!<$r#1J8;z>C5n("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BDEL $B("(Bkeisen-clear-backward $B("%]%$%s%H$NA0$N%-%c%i%/%?!<$r#1J8;z>C5n!!("(B
$B("!!("(B    $B("(B                 -char$B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-c $B("(Bkeisen-shrink$B!!!!!!!!(B $B("7S@~$r=DJ}8~$K=L$a$k!!!!!!!!!!!!!!!!!!!!("(B
$B("!!("(B C-v$B("!!!!!!!!(B -vertically()$B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-c $B("(Bkeisen-shrink$B!!!!!!!!(B $B("7S@~$r2#J}8~$K=L$a$k!!!!!!!!!!!!!!!!!!!!("(B
$B("!!("(B C-h$B("(B       -horizontally()$B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-cc$B("(Bkeisen-clean          $B("9TKv$N%?%V$d%9%Z!<%9$r<h$j=|$/!!!!!!!!!!("(B
$B('(!(+(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("%b("(B    $B("(Bkeisen-mode           $B("7S@~%b!<%I$K$O$$$k!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!C('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("%I("(BC-co$B("(Bkeisen-overwrite-mode $B("%*!<%P!<%i%$%H%b!<%I$N%H%0%k%9%$%C%A!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-cl$B("(Bkeisen-toggle-line    $B("%+!<%=%k0\F0%b!<%I$N%H%0%k%9%$%C%A!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-cm$B("(Bkeisen-toggle-move    $B("%+!<%=%k0\F0%l%Y%k$N%H%0%k%9%$%C%A!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-ce$B("(Bkeisen-toggle-auto    $B("<+F03HD%%b!<%I$N%H%0%k%9%$%C%A!!!!!!!!!!("(B
$B("!!("(B    $B("(B              -enlarge$B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-cj$B("(Bkeisen-toggle-auto    $B("<+F02~9T%b!<%I$N%H%0%k%9%$%C%A!!!!!!!!!!("(B
$B("!!("(B    $B("(B            -line-feed$B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-\\ $B("(Bkeisen-key-mode       $B("7S@~$NIA2h%-!<$N%H%0%k%9%$%C%A!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-w $B("(Bkeisen-toggle-width   $B("7S@~$NB@$5$r@Z$j49$($k!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-c $B("(Bkeisen-mode-exit      $B("7S@~%b!<%I$+$iH4$1$F85$N%b!<%I$KLa$k!!!!("(B
$B("!!("(B C-c$B("(B                      $B("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BC-om$B("(Bkeisen-status         $B("7S@~%b!<%I>uBV;2>H(B                      $B("(B
$B('(!(+(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("$*("(BC-ck$B("(Bzenkaku-space-current $B("%+%l%s%H%P%C%U%!Fb$NO"B3$7$?Fs$D$NH>3Q%9("(B
$B("$^("(B    $B("(B               -buffer$B("%Z!<%9$rA43Q%9%Z!<%9$KJQ49$9$k!!!!!!!!!!("(B
$B("$1('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bzenkaku-space-region  $B("%j!<%8%g%sFb$NO"B3$7$?Fs$D$NH>3Q%9%Z!<%9("(B
$B("!!("(B    $B("(B                      $B("$rA43Q%9%Z!<%9$KJQ49$9$k!!!!!!!!!!!!!!!!("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-center-line    $B("7S@~$NOHFb$GJ8;zNs$rCf1{$X0\F0$9$k(B      $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-right-line     $B("7S@~$NOHFb$GJ8;zNs$r1&5M$K$9$k(B          $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-left-line      $B("7S@~$NOHFb$GJ8;zNs$r:85M$K$9$k(B          $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(BM-h $B("(Bkeisen-rectangle      $B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-kill-rectangle $B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-kill           $B("(B                                        $B("(B
$B("!!("(B    $B("(B-rectangle-to-register$B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-delete         $B("(B                                        $B("(B
$B("!!("(B    $B("(B-rectangle-to-register$B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-save-rectangle $B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-save-rectangle $B("(B                                        $B("(B
$B("!!("(B    $B("(B-rectangle-to-register$B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-yank-rectangle $B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-yank-rectangle $B("(B                                        $B("(B
$B("!!("(B    $B("(B        -from-register$B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-view-rectangle $B("(B                                        $B("(B
$B("!!("(B    $B("(B             -register$B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-open-rectangle $B("(B                                        $B("(B
$B("!!('(!(!(+(!(!(!(!(!(!(!(!(!(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("!!("(B    $B("(Bkeisen-clear-rectangle$B("(B                                        $B("(B
$B(&(!(*(!(!(*(!(!(!(!(!(!(!(!(!(!(!(*(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(%(B
$B(#(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!($(B
$B("7S@~%b!<%IJQ?t0lMwI=(B                                                      $B("(B
$B('(!(!(!(!(!(!(!(!(!(!(!(!(!(((!(!(((!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("JQ?tL>>N!!!!!!!!!!!!!!!!!!("=i4|("@bL@(B                                    $B("(B
$B(<(,(,(,(,(,(,(,(,(,(,(,(,(,(;(,(,(;(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(,(>(B
$B("(Bkeisen-version$B!!!!!!!!!!!!("!!!!("7S@~$N%P!<%8%g%s(B                        $B("(B
$B('(!(!(!(!(!(!(!(!(!(!(!(!(!(+(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("(Bkeisen-extend-regexp-flag $B("(Bnil $B("3HD%%3%^%s%I$,%A%'%C%/$9$k7S@~!!!!!!!!(B  $B("(B
$B("!!!!!!!!!!!!!!!!!!!!!!!!!!("!!!!("(B nil$B$N$H$-$9$Y$F$N7S@~!!!!!!!!!!!!!!!!!!("(B
$B("!!!!!!!!!!!!!!!!!!!!!!!!!!("!!!!("(B $B#1$N$H$-:Y$$7S@~!!!!!!!!!!!!!!!!!!!!!!(B $B("(B
$B("!!!!!!!!!!!!!!!!!!!!!!!!!!("!!!!("(B $B#2$N$H$-B@$$7S@~!!!!!!!!!!!!!!!!!!!!!!(B $B("(B
$B('(!(!(!(!(!(!(!(!(!(!(!(!(!(+(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("(Bkeisen-draw-force$B!!!!!!!!(B $B("(Bnil $B("(Bnil$B$N$H$-:Y$$7S@~$OB@$$7S@~$K4^$^$l$k!!(B $B("(B
$B("!!!!!!!!!!!!!!!!!!!!!!!!!!("!!!!("(Bt  $B$N$H$-:Y$$7S@~$O:Y$$7S@~$H$7$FIA2h(B   $B("(B
$B('(!(!(!(!(!(!(!(!(!(!(!(!(!(+(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("(Bkeisen-adjust-column-force$B("(Bt$B!!(B $B("(Bnil$B$N$H$-$O7S@~%3%^%s%I$r;H$C$?$H$-%+%i(B $B("(B
$B("!!!!!!!!!!!!!!!!!!!!!!!!!!("!!!!("%`%A%'%C%/$r$7$J$$!!!!!!!!!!!!!!!!!!!!!!("(B
$B("!!!!!!!!!!!!!!!!!!!!!!!!!!("!!!!("(Bt  $B$N$H$-6/@)E*$K%]%$%s%H$r6v?t%+%i%`$K(B $B("(B
$B("!!!!!!!!!!!!!!!!!!!!!!!!!!("!!!!("%]%$%s%H$r0\F0$5$;$k(B   $B!!!!!!!!!!!!!!!!(B $B("(B
$B('(!(!(!(!(!(!(!(!(!(!(!(!(!(+(!(!(+(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!()(B
$B("(Bkeisen-mode-hook$B!!!!!!!!!!("(Bnil $B("7S@~%b!<%I$N%U%C%/!!!!!!!!!!!!!!!!!!!!(B  $B("(B
$B(&(!(!(!(!(!(!(!(!(!(!(!(!(!(*(!(!(*(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(!(%(B
"
  (interactive)
  (if (eq major-mode 'keisen-mode)
      (keisen-mode-exit)
    (make-local-variable 'keisen-old-local-map)
    (setq keisen-old-local-map (current-local-map))
    (use-local-map keisen-mode-map)
    (make-local-variable 'keisen-old-mode-name)
    (setq keisen-old-mode-name mode-name)
    (make-local-variable 'keisen-old-major-mode)
    (setq keisen-old-major-mode major-mode)
    (setq major-mode 'keisen-mode)
    (make-local-variable 'keisen-old-overwrite-mode)
    (setq keisen-old-overwrite-mode overwrite-mode)
    (overwrite-mode 0)
    (if (>= emacs-major-version 19)
	(progn
	  (if (not (boundp 'self-insert-after-hook))
	      (defvar self-insert-after-hook nil))
	  (make-local-variable 'keisen-old-auto-fill-function)
	  (setq keisen-old-auto-fill-function auto-fill-function)
	  (setq auto-fill-function nil))
      (make-local-variable 'keisen-old-auto-fill-hook)
      (setq keisen-old-auto-fill-hook auto-fill-hook)
      (setq auto-fill-hook nil))
    (make-local-variable 'keisen-old-self-insert-after-hook)
    (setq keisen-old-self-insert-after-hook self-insert-after-hook)
    (if (setq keisen-overwrite-mode keisen-old-overwrite-mode)
        (setq self-insert-after-hook 'km:self-insert-after-overwrite-hook)
      (setq self-insert-after-hook 'km:self-insert-after-insert-hook))
    (untabify (point-min) (point-max))                              ;
    (make-local-variable 'keisen-old-indent-tabs-mode)    ;
    (setq keisen-old-indent-tabs-mode indent-tabs-mode)   ;
    (setq indent-tabs-mode nil)                           ;
    (run-hooks 'keisen-mode-hook) ;93.11.02
    (km:update-mode-line)

    ;; check keyboard-coding-system  -- 93.09.20
    (if (= emacs-major-version 19)
	(if (not (eq keyboard-coding-system *euc-japan*))
	    (progn
	      (setq keisen-old-keyboard-coding-system keyboard-coding-system)
	      (set-keyboard-coding-system *euc-japan*))))
    (if nil; (= emacs-major-version 20)
	(if (not (eq default-keyboard-coding-system 'euc-japan))
	    (progn
	      (setq keisen-old-keyboard-coding-system default-keyboard-coding-system)
	      (set-keyboard-coding-system 'euc-japan))))
    ;

    ;; begin of patch
    ;(let (i)
    ;  (setq i 160)
    ;  (while (< i 256)
    ;   (aset global-map i 'keisen-self-insert-iso)
    ;   (setq i (1+ i))))
    ;;$B",(Bglobal-map$B$r=q$-49$($k$N$O4m81$J$N$G:o=|$9$k(B -- 93.09.20
    ;;$B"-(Bself-insert-iso$B4X?t$G;HMQ$9$k(Bselfinsert-internal$B$rFbIt4X?t$KCV$-49$($k(B
    (if (or running-xemacs
	    (< emacs-major-version 20))
	(progn
	  (fset 'old-self-insert-internal (symbol-function 'self-insert-internal))
	  (fset 'self-insert-internal (symbol-function 'keisen-self-insert-internal)))
      (setq keisen-old-after-change-functions after-change-functions)
      (set (make-local-variable 'after-change-functions)
	   (list 'km:after-change-function))
      )
    ;; end of patch

    ;; begin of patch -- Based by M.Ozawa
    (if (fboundp 'km:old-insert-register)
	nil
      (fset 'km:old-insert-register (symbol-function 'insert-register))
      (fset 'insert-register (symbol-function 'keisen-insert-register))
      (fset 'km:old-get-register (symbol-function 'get-register))
      (fset 'get-register (symbol-function 'km:get-register))
      (fset 'km:old-set-register (symbol-function 'set-register))
      (fset 'set-register (symbol-function 'km:set-register)))
    ;; end of patch

    (setq keisen-key-flag (not keisen-key-flag)) ;93.10.29
    (keisen-key-mode)

    (message
     (substitute-command-keys
      "Type \\[keisen-mode-exit] in this buffer to return it to %s mode.")
     keisen-old-mode-name)
    (if keisen-mode-view-status-flag (keisen-status))))
;; end of patch

(defun keisen-mode-exit () ;---------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~%b!<%I$+$iH4$1$k(B."
  (interactive)
  (if (not (eq major-mode 'keisen-mode))
      (error "You arenot editing keisen.")
    ;(keisen-clean)                                       ;option
    ;; begin of patch  -- 93.10.15
    (while
        (let (ch)
          (message
           "$B9TKv$NL50UL#$J%?%V$d%9%Z!<%9$r<h$j=|$-$^$9$+!)(B [Yes:RET/No:SPC]")
	  (setq ch (km:read-char))
          (cond ((= ch ?\C-m) (keisen-clean) nil)
                ((= ch 32) nil)
                (t (ding) t))))
    ;; end of patch
    (setq mode-name keisen-old-mode-name)
    (use-local-map keisen-old-local-map)
    (setq major-mode keisen-old-major-mode)
    (if (>= emacs-major-version 19)
	(setq auto-fill-function keisen-old-auto-fill-function)
      (setq auto-fill-hook keisen-old-auto-fill-hook))
    (overwrite-mode (if keisen-old-overwrite-mode 1 0))
    (setq self-insert-after-hook keisen-old-self-insert-after-hook)
    (setq indent-tabs-mode keisen-old-indent-tabs-mode)  ;
    ;;(tabify (point-min) (point-max))                             ;
    (kill-local-variable 'keisen-old-mode-name)
    (kill-local-variable 'keisen-old-local-map)
    (if (>= emacs-major-version 19)
	(kill-local-variable 'keisen-old-auto-fill-function)
      (kill-local-variable 'keisen-old-auto-fill-hook))
    (kill-local-variable 'keisen-old-overwrite-mode)
    (kill-local-variable 'keisen-old-self-insert-after-hook)
    (kill-local-variable 'keisen-old-indent-tabs-mode)
    (set-buffer-modified-p (buffer-modified-p))
    (if keisen-old-keyboard-coding-system
	(set-keyboard-coding-system keisen-old-keyboard-coding-system))

    ;begin of patch
    ;(let (i)
    ;  (setq i 160)
    ;  (while (< i 256)
    ;   (aset global-map i 'self-insert-iso)
    ;   (setq i (1+ i))))
    (if (or running-xemacs
	    (< emacs-major-version 20))
	(fset 'self-insert-internal (symbol-function 'old-self-insert-internal))
      (setq after-change-functions keisen-old-after-change-functions))
    ;end of patch

    ;; begin of patch -- Based by M.Ozawa
    (if (not (fboundp 'km:old-insert-register))
	nil
      (fset 'insert-register (symbol-function 'km:old-insert-register))
      (fset 'get-register (symbol-function 'km:old-get-register))
      (fset 'set-register (symbol-function 'km:old-set-register)))
    ;; end of patch
    (message "Quit keisen-mode")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B7S@~%b!<%I>uBV;2>H(B
;;
(defun keisen-status () ;------------------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B7S@~%b!<%I$GDs6!$7$F$$$k3F<o%b!<%IN`$N>uBV$rI=<($9$k(B"
  (interactive)
  (unwind-protect
      (save-window-excursion
        (save-excursion
          (set-buffer (get-buffer-create " *km:status-window*"))
          (erase-buffer)
          (setq mode-line-format "  --< $B7S@~%b!<%I>uBVI=(B >--")
          (km:create-status-table))
        (km:overlay-window 6)
        (switch-to-buffer " *km:status-window*")
        (select-window (next-window))
        (sit-for keisen-status-display-interval-time))))

(defun km:create-status-table () ;---------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B3F<o%b!<%IN`$N>uBV$r%P%C%U%!$K=q$-9~$`(B"
  (goto-char (point-min))
  (insert (format "$B%+!<%=%k0\F0%b!<%I(B : %s\n"
                  (if keisen-move-mode "Keisen" "Major")))
  (insert (format "$B%+!<%=%k0\F0%l%Y%k(B : %s\n"
                  (cond ((= keisen-move-level 0) "Normal")
                        ((= keisen-move-level 1) "Level1")
                        ((= keisen-move-level 2) "Level2"))))
  (insert (format "$B<+F03HD%%b!<%I(B     : %s\n"
                  (if keisen-auto-enlarge-vertically-flag "ON[$B=DJ}8~(B]"
                    (if keisen-auto-enlarge-horizontally-flag "ON[$B2#J}8~(B]"
                      "OFF"))))
  (insert (format "$B<+F02~9T%b!<%I(B     : %s\n"
                  (if keisen-auto-line-feed-flag "ON" "OFF")))
  (insert (format "$B7S@~$NIA2h%-!<(B     : %s\n"
                  (if keisen-key-flag "$B%+!<%=%k%-!<(B" "M-[pnbf]$B%-!<(B")))
  (goto-char (point-min)))

(defun km:overlay-window (height) ;-- Based by Toshihiko Miyazaki -------------
  "[$B7S@~%b!<%I4X?t(B]
 $B7S@~%b!<%I>uBVI=$NI=<(%&%#%s%I%&$N%5%$%:$rD4@0$9$k(B"
  (save-excursion
    (let ((oldot (save-excursion (beginning-of-line) (point)))
          (top   (save-excursion (move-to-window-line height) (point)))
          (newin (split-window-vertically height)))
      (if (< oldot top) (setq top oldot))
      (set-window-start newin top))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   $B7S@~%b!<%IMQ6&DL%k!<%A%s(B
;;
(defun km:adjusted-current-column () ;-----------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H%]%$%s%H$N%+%i%`?t$rJV5Q$9$k(B
 $B$?$@$7!"(Bkeisen-adjust-column-force$B$,(Bt$B$N$H$-%+%i%`?t$r6v?t$K$7$FJV5Q$9$k(B
 $B$D$^$j!"%+%l%s%H%]%$%s%H$N%+%i%`?t$,4q?t$J$i(B(- (current-column) 1)$B!"6v?t$J$i(B
 (current-column)$B$rJV$9(B"
  (if keisen-adjust-column-force
      (* (/ (current-column) 2) 2)
    (current-column)))

(defun km:adjust-current-column (&optional force)
  (km:move-to-column-force (km:adjusted-current-column) force))

(defun km:adjusted-column (pos) ;----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj%]%$%s%H(Bpos$B$N%+%i%`?t$rJV5Q$9$k(B
 $B$?$@$7!"(Bkeisen-adjust-column-force$B$,(Bt$B$N$H$-%+%i%`?t$r6v?t$K$7$FJV5Q$9$k(B
 $B$D$^$j!";XDj%]%$%s%H(Bpos$B$N%+%i%`?t$,4q?t$J$i(B(- (current-column) 1)$B!"6v?t$J$i(B
 (current-column)$B$rJV$9(B"
  (save-excursion
    (goto-char pos)
    (km:adjusted-current-column)))

(defun km:what-current-line () ;-----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H0LCV$N9THV9f$rJV$9(B"
  (save-restriction
    (widen)
    (save-excursion
      (beginning-of-line)
      (1+ (count-lines (point-min) (point))))))

(defun km:delete-horizontal-space-and-ZenkakuSpace () ;------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H0LCV$NA08e$N6uGr$H%?%V5Z$S!"A43Q$N6uGr$rA4$F:o=|$9$k(B
 simple.el$B$N(Bdelete-horizontal-space$B$rH4?h!"2~B$$7$?(B"
  (skip-chars-backward "$B!!(B \t")
  (delete-region (point) (progn
                           (skip-chars-forward "$B!!(B \t")
                           (point))))

(defun km:what-line (pos) ;----------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj$5$l$?%]%$%s%H(Bpos$B$N%i%$%s?t$rJV5Q$9$k(B"
  (save-excursion
    (goto-char pos)
    (km:what-current-line)))

(defun km:what-column (pos) ;--------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj$5$l$?%]%$%s%H(Bpos$B$N%+%i%`?t$rJV5Q$9$k(B"
  (save-excursion
    (goto-char pos)
    (current-column)))

(defun km:what-point (col) ;---------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H9T$N;XDj%+%i%`(Bcol$B$N%]%$%s%H$rJV5Q$9$k(B"
  (save-excursion
    (km:move-to-column-force col nil)
    (point)))

(defun km:string-length (str col) ;--------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj$5$l$?J8;zNs(Bstr$B$N@hF,$+$i;XDj%+%i%`(Bcol$B$^$G$N%P%$%H?t$r?t$($k(B"
  (length (km:get-string str col nil)))

(defun km:string-column (str) ;------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj$5$l$?J8;zNs(Bstr$B$N%+%i%`?t$r?t$($k(B"
  (string-width str))

(defun km:buffer-column (begin end) ;------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B;XDj$5$l$?(Bbegin$B%]%$%s%H$+$i(Bend$B%]%$%s%H$^$G$N%+%i%`?t$r?t$($k(B"
  (let ((str (buffer-substring begin end)))
    (km:string-column str)))

(defun km:get-string (str get_col &optional flg) ;-----------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $BJ8;zNs$N@hF,$+$i;XDj%+%i%`?tJ,$H$j$@$9(B"
  (let* ((cl (string-to-char-list str))
	 (lis cl)
	 (col 0)
	 char)
    (while (and lis (< col get_col))
      (setq char (car lis)
	    lis (cdr lis)
	    col (+ col (char-width char))))
    (if lis (setcdr lis nil))
    (setq str (length (mapconcat (function char-to-string) cl "")))
    (if flg
        (concat str (make-string (- get_col col) ? ))
      str)))

(defun km:eol () ;-------------------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H%i%$%s$N:G=*7e$N0LCV$rJV$9(B"
  (save-excursion
    (end-of-line)
    (point)))

(defun km:bol () ;-------------------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H%i%$%s$N:G=i$N7e$N0LCV$rJV$9(B"
  (save-excursion
    (beginning-of-line)
    (point)))

(defun km:what-window-line (pos) ;---------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
"
  (save-excursion
    (let ((top (progn (goto-char pos) (vertical-motion 0) (point)))
          (cnt 0))
      (goto-char (point-min))
      (while (if (= top (point))
                 nil
               (vertical-motion 1) (setq cnt (1+ cnt)) t))
      cnt)))

(defun km:eoblp () ;-----------------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H%i%$%s$,%P%C%U%!$N:G=*%i%$%s$+%A%'%C%/$9$k(B
 $B%+%l%s%H%i%$%s$,%P%C%U%!$N:G8e$J$i$P(Bt$B!"$=$&$G$J$1$l$P(Bnil$B$rJV5Q$9$k(B"
 (if (< (save-excursion                         (vertical-motion 0) (point))
        (save-excursion (goto-char (point-max)) (vertical-motion 0) (point)))
     nil
   t))

(defun km:boblp () ;-----------------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%+%l%s%H%i%$%s$,%P%C%U%!$N@hF,%i%$%s$+%A%'%C%/$9$k(B
 $B%+%l%s%H%i%$%s$,%P%C%U%!$N@hF,$J$i$P(Bt$B!"$=$&$G$J$1$l$P(Bnil$B$rJV5Q$9$k(B"
 (if (< (point-min) (save-excursion (vertical-motion 0) (point)))
     nil
   t))

;; alternative function for those in old mule-util.el
;;(or (fboundp 'delete-text-in-column)
;;    (defun delete-text-in-column(col1 col2) ;-----------------------------------
;;      "[$B7S@~%b!<%I4X?t(B]
;; $B;XDj$5$l$?Fs$D$N%+%i%`0LCV$N4V$NJ8;z$r:o=|$9$k(B"
;;      (let ((pos1 (km:what-point col1))
;;	    (pos2 (km:what-point col2)))
;;	(delete-region pos1 pos2))))

;; Copy from mule-util.el of XEmacs.
(or (fboundp 'delete-text-in-column)
    (defun delete-text-in-column (from to) ;-----------------------------------
      "Delete the text between column FROM and TO (exclusive) of the current line.
Nil of FORM or TO means the current column.
If there's a character across the borders, the character is replaced
with the same width of spaces before deleting."
      (save-excursion
	(let (p1 p2)
	  (if from
	      (progn
		(setq p1 (move-to-column from))
		(if (> p1 from)
		    (progn
		      (delete-char -1)
		      (insert-char ?  (- p1 (current-column)))
		      (forward-char (- from p1))))))
	  (setq p1 (point))
	  (if to
	      (progn
		(setq p2 (move-to-column to))
		(if (> p2 to)
		    (progn
		      (delete-char -1)
		      (insert-char ?  (- p2 (current-column)))
		      (forward-char (- to p2))))))
	  (setq p2 (point))
	  (delete-region p1 p2)))))

(provide 'keisen-mule)
;;; keisen-mule.el ends here
