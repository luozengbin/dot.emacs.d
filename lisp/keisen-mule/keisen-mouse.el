;;; -*- Mode: Emacs-Lisp ; Coding: iso-2022-jp -*-
;;
;; keisen mode commands for Emacs
;; Copyright (C) 1986,1992-1995 Free Software Foundation, Inc.
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
;; $B%Y!<%9$H$7$F!"2-DL?.%7%9%F%`$N4dK\$5$s$,(BMULE$BBP1~$X$N=$@55Z$S5!G=(B
;; $BDI2C$r9T$C$?$b$N$K!"(Bmule 2.x$B$N(BGUI$B5!G=$rMxMQ$7$F%^%&%9A`:n$G7S@~(B
;; $B$r0z$/5!G=$rDI2C$9$k$?$a$N%b%8%e!<%k$G$9!#(B:-)
;;
;; ~/.emacs $B$K(B
;; 
;;  (if (boundp 'MULE)
;;      (if window-system
;;          (autoload 'keisen-mode "keisen-mouse" "MULE$BHG7S@~%b!<%I!\%^%&%9(B" t))
;;    (autoload 'keisen-mode "keisen-mule" "MULE$BHG7S@~%b!<%I(B" t))
;;
;; $B$N$h$&$J(B4$B9T$rF~$l$F$*$/$HNI$$$G$7$g$&(B
;;
;;;
;; keisen-mouse.el ver 1.0 for keisen-mule 2.02$B&C(B
;; Author: $B>.NS(B $B@56=(B (masaoki@tky.hp.com)
;;

;; keisen-mule 2.02$B&C$,I,MW$G$9(B
(require 'keisen-mule)

;; $BJQ?t$NDj5A(B
(defvar keisen-mouse-restrict-direction t
  "*non-nil$B$J$i$P(B, $B%^%&%9$N%I%i%C%0$N<+M30\F0$rM^@)$7$FD>@~$r(B
 $BIA$/$h$&$K$9$k(B")

(defvar keisen-mouse-use-hilite-region t
  "*non-nil$B$J$i$P(B, $B%^%&%9A`:n$G;M3Q$rIA$$$?$j(B, $B%I%i%C%0$r$9$k>l9g$KHO0O$r(B
 $B%O%$%i%$%H$9$k(B. $BCY$$%^%7%s$G$O(Bnil$B$K$7$?J}$,NI$$$H;W$&(B")

(defvar keisen-mouse-connection-list
  '("  " "$B("(B" "$B(-(B" "$B("(B" "$B("(B" "$B(-(B" "$B(-(B" "$B(-(B" "$B(-(B"
    "$B(!(B" "$B(%(B" "$B(0(B" "$B($(B" "$B()(B" "$B(9(B" "$B(/(B" "$B(9(B" "$B(9(B"
    "$B(,(B" "$B(0(B" "$B(0(B" "$B(/(B" "$B(>(B" "$B(4(B" "$B(/(B" "$B(4(B" "$B(4(B"
    "$B(!(B" "$B(&(B" "$B(1(B" "$B(#(B" "$B('(B" "$B(7(B" "$B(.(B" "$B(7(B" "$B(7(B"
    "$B(!(B" "$B(*(B" "$B(?(B" "$B(((B" "$B(+(B" "$B(@(B" "$B(=(B" "$B(@(B" "$B(@(B"
    "$B(,(B" "$B(:(B" "$B(5(B" "$B(8(B" "$B(;(B" "$B(6(B" "$B(3(B" "$B(6(B" "$B(6(B"
    "$B(,(B" "$B(1(B" "$B(1(B" "$B(.(B" "$B(<(B" "$B(2(B" "$B(.(B" "$B(2(B" "$B(2(B"
    "$B(,(B" "$B(:(B" "$B(5(B" "$B(8(B" "$B(;(B" "$B(6(B" "$B(3(B" "$B(6(B" "$B(6(B"
    "$B(,(B" "$B(:(B" "$B(5(B" "$B(8(B" "$B(;(B" "$B(6(B" "$B(3(B" "$B(6(B" "$B(6(B")
  "$B@\B3$rI=$9(Bvector$B$+$i3:Ev$9$k7S@~J8;z$rCj=P$9$k$?$a$N%j%9%H(B")

(defvar keisen-mouse-last-point nil
  "$B%^%&%9$rN%$7$?:G8e$N%]%$%s%H(B")

(defvar keisen-fill-bar-string nil
  "$B7S@~$N0\F0;~$K;H$&0l;~JQ?t(B")

(defvar keisen-mouse-hilite-face 'default
  "$B%I%i%C%0$7$?HO0O$rI=<($9$k$N$K;H$&$?$a$N(Bface$B$r3JG<$9$k0l;~JQ?t(B")

;; $B%a%K%e!<%P!<$NDj5A(B
(defvar keisen-mode-menu (make-sparse-keymap "Keisen"))
(define-key keisen-mode-map [menu-bar keisen]
  (cons "Keisen" keisen-mode-menu))
(define-key keisen-mode-menu [extend-right]
  '("Extend Right" . keisen-extend-right))
(define-key-after keisen-mode-menu [extend-left]
  '("Extend Left" . keisen-extend-left) 'extend-right)
(define-key-after keisen-mode-menu [extend-up]
  '("Extend Up" . keisen-extend-up) 'extend-left)
(define-key-after keisen-mode-menu [extend-down]
  '("Extend Down" . keisen-extend-down) 'extend-up)
(define-key-after keisen-mode-menu [sep1]
  '("--" . nil) 'extend-down)
(define-key-after keisen-mode-menu [shrink-v]
  '("Shrink Table Vertically" . keisen-shrink-vertically) 'sep1)
(define-key-after keisen-mode-menu [shrink-h]
  '("Shrink Table Horizontally" . keisen-shrink-horizontally) 'shrink-v)
(define-key-after keisen-mode-menu [enlarge-v]
  '("Enlarge Table Vertically" . keisen-enlarge-vertically) 'shrink-h)
(define-key-after keisen-mode-menu [enlarge-h]
  '("Enlarge Table Horizontally" . keisen-enlarge-horizontally) 'enlarge-v)
(define-key-after keisen-mode-menu [sep2]
  '("--" . nil) 'enlarge-h)
(define-key-after keisen-mode-menu [width]
  '("Toggle Line Width" . keisen-toggle-width) 'sep2)
(define-key-after keisen-mode-menu [kill]
  '("Kill Rectangle" . keisen-kill-rectangle) 'width)
(define-key-after keisen-mode-menu [yank]
  '("Yank Rectangle" . keisen-yank-rectangle) 'kill)
(define-key-after keisen-mode-menu [center]
  '("Center strings" . keisen-center-line) 'yank)
(define-key-after keisen-mode-menu [left]
  '("Pull strings Left" . keisen-left-line) 'center)
(define-key-after keisen-mode-menu [right]
  '("Pull strings Right" . keisen-right-line) 'left)
(define-key-after keisen-mode-menu [sep3]
  '("--" . nil) 'right)
(define-key-after keisen-mode-menu [a-right]
  '("Arrow Right" . keisen-arrow-right) 'sep3)
(define-key-after keisen-mode-menu [a-left]
  '("Arrow Left" . keisen-arrow-left) 'a-right)
(define-key-after keisen-mode-menu [a-up]
  '("Arrow Up" . keisen-arrow-up) 'a-left)
(define-key-after keisen-mode-menu [a-down]
  '("Arrow Down" . keisen-arrow-down) 'a-up)
(define-key-after keisen-mode-menu [sep4]
  '("--" . nil) 'a-down)
(define-key-after keisen-mode-menu [stat]
  '("Mode Status" . keisen-status) 'sep4)
(define-key-after keisen-mode-menu [help]
  '("Help" . describe-mode) 'stat)

;; $B4X?t$NDj5A(B
(defun km:if-shrink-val (xp x) ;-----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 0$B$+$i(Bxp$B$N?tCMHO0O$K(Bx$B$,F~$C$F$$$k$+(B, x$B$H(Bxp$B$NId9f$,0c$&>l9g$O(Bt"
  (if (> xp 0)
      (if (> x 0)
          (> xp x)
        t)
    (if (> x 0) t
      (> x xp))))

(defun km:if-shrink-rectangle (initial-xy prev-xy current-xy) ;----------------
  "[$B7S@~%b!<%I4X?t(B]
 initial-xy$B$+$i(Bprev-xy$B$N6k7AHO0O$K(Bcurrent-xy$B$,4^$^$l$k>l9g$O(Bt,
 $B$=$&$G$J$1$l$P(Bnil$B$rJV$9(B. $B$=$l$>$l$N0z?t$O(Bassoc-list$B$K$J$C$F$$$k(B"
  ;;(print (cons initial-xy (cons prev-xy (list current-xy))))
  (if (null prev-xy) nil
    (let* ((x0 (car initial-xy))
           (y0 (cdr initial-xy))
           (px (- (car prev-xy) x0))
           (py (- (cdr prev-xy) y0))
           (cx (- (car current-xy) x0))
           (cy (- (cdr current-xy) y0)))
      (or (km:if-shrink-val px cx)
          (km:if-shrink-val py cy)))))

(defun km:move-to-position (posn) ;--------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $BI,MW$J$i%9%Z!<%9$d2~9T$rF~$l$J$,$i(B, event$B$GF@$?2hLL>e$N(Bposn$B$N0LCV$K(B
 $B%+!<%=%k$r0\F0$9$k(B"
  (goto-char (window-start))
  (let ((row (cdr (posn-col-row posn)))
        (indent-tabs-mode nil))
    (setq row (forward-line row))
    (or (bolp) (insert ?\n))
    (while (< 0 row)
      (insert ?\n)
      (setq row (1- row)))
    (km:move-to-column-force
     (+ (car (posn-col-row posn))
	(window-hscroll))
     nil)))

(defun km:hilite-rectangle-line (pos ignore ignore) ;--------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B6k7ANN0h$N0l9T$r%O%$%i%$%H$9$k(B"
  (put-text-property pos (point) 'face keisen-mouse-hilite-face))

(defun km:hilite-rectangle (start end) ;---------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B6k7ANN0h$r%O%$%i%$%H$9$k(B"
  (cond (keisen-mouse-use-hilite-region
         ;; start$B$H(Bend$B$,=g$K$J$C$F$$$J$$$H@5$7$/F/$+$J$$(B
         (if (> start end)
             (let ((buf start))
               (setq start end
                     end buf)))
         (km:operate-on-rectangle 'km:hilite-rectangle-line
                               start end nil))))

(defun km:keisen-char-vector (str) ;-------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B0z?t$N7S@~J8;z#1J8;z$N@\B3J}8~$rI=$9(Bvector$B$rJV$9(B"
  (let (p1 p2 p3 p4)
    (setq p1 (if (string-match str "$B("('(+(*()(&(%(<(:(;(>(B")
                 1
               (if (string-match str "$B(-(7(@(?(9(1(0(6(2(5(4(B")
                   2 0))
          p2 (if (string-match str "$B("('(+((()(#($(<(8(;(>(B")
                 1
               (if (string-match str "$B(-(7(@(=(9(.(/(6(2(3(4(B")
                   2 0))
          p3 (if (string-match str "$B(!(((+(*()($(%(?(=(@(9(B")
                 1
               (if (string-match str "$B(,(3(6(5(4(/(0(;(>(8(:(B")
                   2 0))
          p4 (if (string-match str "$B(!(((+(*('(#(&(?(=(@(7(B")
                 1
               (if (string-match str "$B(,(3(6(5(2(.(1(;(<(8(:(B")
                   2 0)))
    (vector p1 p2 p3 p4)))

(defun km:following-char-vector () ;-------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%]%$%s%H0LCV$N7S@~J8;z$N@\B3J}8~$rI=$9(Bvector$B$rJV$9(B"
  (km:keisen-char-vector (char-to-string (following-char))))

(defun km:vector-to-keisen (v) ;-----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $BM?$($i$l$?(Bvector$B$KBP1~$9$k7S@~J8;z$rJV$9(B"
  (let ((val (+ (aref v 0) (* 3 (aref v 1))
                (* 9 (aref v 2)) (* 27 (aref v 3)))))
    (nth val keisen-mouse-connection-list)))

(defun km:central-vector (v1 v2 v3 v4) ;---------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B>e2<:81&$N7S@~J8;z$N(Bvector$B$+$i(B, $BE,@Z$JCf?4(Bvector$B$r5a$a$k(B"
  (vector (aref v1 1) (aref v2 0) (aref v3 3) (aref v4 2)))

(defun km:relative-vector (x y) ;----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%]%$%s%H0LCV$+$iM?$($i$l$?AjBP:BI80LCV$N7S@~J8;z$N(Bvector$B$rJV$9(B"
  (save-excursion
    (let ((col (current-column)))
      (cond ((= y 1)
             (end-of-line)
             (if (eobp)
                 (newline)
               (forward-char 1)))
            ((= y -1)
             (if (< (forward-line -1) 0) ; $B:G>e9T$+$i>e$K9T$3$&$H$7$?(B
                 (setq col -100))))
      (setq col (+ col (* x 2)))
      (if (> 0 col)
          [0 0 0 0]
        (km:move-to-column-force col nil)
        (km:following-char-vector)))))

(defun km:col-horizontal-bar () ;----------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%]%$%s%H0LCV$+$i2#J}8~$K$D$J$,$k7S@~$NN>=*C<0LCV$r5a$a(B, 
 $B;OE@$H=*E@$N(Bcolumn$B$N(B2$BMWAG$N(Bvector$B$K$7$FJV$9(B"
  (save-excursion
    (let ((c0 (current-column))
          c c1 c2)
      (setq c (max 0 (- c0 2)))
      (km:move-to-column-force c nil)
      ;; $B$^$::8J}8~$rC5$7$F9T$/(B
      (while (and (string-match "[$B(!(,(((3(8(=(*(5(:(?(+(6(@(;(B]"
                                (char-to-string (following-char)))
                  (> c 1))
        (setq c (- c 2))
        (km:move-to-column-force c nil))
      (or (string-match "[$B(#(&(.(1('(2(<(7(B]"
                        (char-to-string (following-char)))
          (setq c (+ c 2)))
      (setq c1 (max 0 c))
      ;; $B1&J}8~$rC5$9(B
      (setq c (+ c0 2))
      (km:move-to-column-force c nil)
      (while (and (string-match "[$B(!(,(((3(8(=(*(5(:(?(+(6(@(;(B]"
                                (char-to-string (following-char)))
                  (null (eolp)))
        (setq c (+ c 2))
        (km:move-to-column-force c nil))
      (or (string-match "[$B($(%(/(0(9(>(4()(B]"
                        (char-to-string (following-char)))
          (setq c (- c 2)))
      (setq c2 c)
      (vector c1 c2))))

;; horizontal $B$H(B vertical $B$G$O(B bar $B$rI=$9(B vector $B$N0UL#$,0c$&$3$H$KCm0U(B
(defun km:col-vertical-bar () ;------------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%]%$%s%H0LCV$+$i=DJ}8~$K$D$J$,$k7S@~$NN>=*C<0LCV$r5a$a(B, 
 $B;OE@$N%]%$%s%H$HD9$5$N(B2$BMWAG$N(Bvector$B$K$7$FJV$9(B"
  (save-excursion
    (let ((p (point))
          p1 p2)
      (km:picture-move-down -1)
      ;; $B$^$:>eJ}8~$rC5$7$F9T$/(B
      (while (and (string-match "[$B("(-()(4(9(>('(2(<(7(+(6(@(;(B]"
                                (char-to-string (following-char)))
                  (null (bobp)))
        (km:picture-move-down -1))
      (or (string-match "[$B(#($(.(/(((3(8(=(B]"
                        (char-to-string (following-char)))
          (km:picture-move-down 1))
      (setq p1 (point))
      ;; $B2<J}8~$rC5$9(B
      ;; $B>e$K0lEY>e$,$C$F$$$k$N$G!"=i4|$N(Bpoint$B$N%P%C%U%!Fb$N0LCV$O$:$l$F$$$k(B
      ;; $B$+$b$7$l$J$$$N$G!"8=:_$N(Bpoint$B$+$i!"$^$?5U$K2<$,$k(B
      (setq p2 1)
      (km:picture-move-down 1)
      (while (and (string-match "[$B("(-()(4(9(>('(2(<(7(+(6(@(;(B]"
                                (char-to-string (following-char)))
                  (null (eobp)))
        (setq p2 (1+ p2))
        (km:picture-move-down 1))
      (or (string-match "[$B(&(%(1(0(*(5(:(?(B]"
                        (char-to-string (following-char)))
          (setq p2 (1- p2)))
      (vector p1 p2))))

(defun km:hilite-horizontal-bar (bar face) ;-----------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 2$BMWAG$N(Bvector$B$r%]%$%s%H0LCV$+$iN>C<$H8+$F%O%$%i%$%H$9$k(B"
  (and keisen-mouse-use-hilite-region
       bar
       (save-excursion
         (km:move-to-column-force (aref bar 0) nil)
         (let ((p (point)))
           (km:move-to-column-force (aref bar 1) nil)
           (forward-char 1)
           (put-text-property p (point) 'face face)))))

(defun km:hilite-vertical-bar (bar face) ;-------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 2$BMWAG$N(Bvector$B$r%]%$%s%H0LCV$+$iN>C<$H8+$F%O%$%i%$%H$9$k(B"
  (and keisen-mouse-use-hilite-region
       bar
       (save-excursion
         (goto-char (aref bar 0))
         (let ((c (aref bar 1))
               w p)
           (while (>= c 0)
             (save-excursion
               (setq w (char-bytes (sref (char-to-string (following-char)) 0))
                     p (point))
               (if (= w 1) (setq w 2))
               (put-text-property p (+ p w) 'face face))
             (km:picture-move-down 1)
             (setq c (1- c)))))))

(defun km:check-horizontal-bar (vec y) ;---------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%]%$%s%H0LCV$+$i(Bvec$B$GI=$5$l$k(Bbar$B$r=DJ}8~$K0\F02DG=$+$I$&$+D4$Y$k(B
 $B0\F02DG=$G$"$l$P(B, vec$B$KBP$7$F0\F0$7$?8e$KJd40$5$l$k$Y$-J8;zNs$r(B
 keisen-fill-bar-string $B$KF~$l(B, t$B$rJV$9(B"
  (setq keisen-fill-bar-string nil)
  (save-excursion
    (if (save-excursion (< (forward-line y) 0))
        nil
      (km:picture-move-down y)
      (let ((c0 (aref vec 0))
            (c1 (aref vec 1))
            (ai (if (> y 0) 0 1))
            (r t) v1 v2 v3)
        (while (and r (>= c1 c0))
          (km:move-to-column-force c0 nil)
          (setq v1 (km:following-char-vector))
          (setq v2 (km:relative-vector 0 (- y)))
          (setq v3 (vector (aref v2 ai) (aref v2 ai) 0 0))
          ;; $B:8C<$N=hM}(B
          (if (= c0 (aref vec 0))
              (if (or (/= (aref v2 0) 0) ; "$B(!(B" $B$N$H$-$O9g@.$7$?$/$J$$(B
                      (/= (aref v2 1) 0))
                  (aset v3 2 (aref v2 2)))
            (if (/= (aref v1 2) 0)
                (setq r nil)))
          ;; $B1&C<$N=hM}(B
          (if (= c0 c1)
              (if (or (/= (aref v2 0) 0) ; "$B(!(B" $B$N$H$-$O9g@.$7$?$/$J$$(B
                      (/= (aref v2 1) 0))
                  (aset v3 3 (aref v2 3)))
            (if (/= (aref v1 3) 0)
                (setq r nil)))
          (setq keisen-fill-bar-string
                (concat keisen-fill-bar-string
                        (km:vector-to-keisen v3)))
          (setq c0 (+ c0 2)))
        r))))

(defun km:check-vertical-bar (vec x) ;-----------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 vec$B$GI=$5$l$k=D(Bbar$B$r2#J}8~$K0\F02DG=$+$I$&$+D4$Y$k(B
 $B0\F02DG=$G$"$l$P(B, vec$B$KBP$7$F0\F0$7$?8e$KJd40$5$l$k$Y$-J8;zNs$r(B
 keisen-fill-bar-string $B$KF~$l(B, t$B$rJV$9(B"
  (setq keisen-fill-bar-string nil)
  (save-excursion
    (let ((x-org (current-column))
          (x-new (+ (current-column) (* 2 x))))
      (goto-char (aref vec 0))
      (if (< x-new 0)
          nil
        (let ((c (aref vec 1))
              (ai (if (> x 0) 2 3))
              (r t) v1 v2 v3)
          (while (and r (>= c 0))
            (km:move-to-column-force x-org nil)
            (setq v2 (km:following-char-vector))
            (km:move-to-column-force x-new nil)
            (setq v1 (km:following-char-vector))
            (setq v3 (vector 0 0 (aref v2 ai) (aref v2 ai)))
            ;; $B>eC<$N=hM}(B
            (if (= c (aref vec 1))
                (if (or (/= (aref v2 2) 0) ; "$B("(B" $B$N$H$-$O9g@.$7$?$/$J$$(B
                        (/= (aref v2 3) 0))
                    (aset v3 0 (aref v2 0)))
              (if (/= (aref v1 0) 0)
                  (setq r nil)))
            ;; $B2<C<$N=hM}(B
            (if (= c 0)
                (if (or (/= (aref v2 2) 0) ; "$B("(B" $B$N$H$-$O9g@.$7$?$/$J$$(B
                        (/= (aref v2 3) 0))
                    (aset v3 1 (aref v2 1)))
              (if (/= (aref v1 1) 0)
                  (setq r nil)))
            (setq keisen-fill-bar-string
                  (concat keisen-fill-bar-string
                          (km:vector-to-keisen v3)))
            (km:picture-move-down 1)
            (setq c (1- c)))
          r)))))

(defun km:add-direction (str dir wid) ;----------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B7S@~J8;z(Bstr$B$NJ}8~(Bdir$B$KB@$5(Bwid$B$N7S@~$r2C$((B, $BJV$9(B"
  (let ((vec (km:keisen-char-vector str)))
    (aset vec dir wid)
    (km:vector-to-keisen vec)))

(defun km:width-direction (str dir) ;------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B7S@~J8;z(Bstr$B$NJ}8~(Bdir$B$N7S@~$NB@$5$rJV$9(B"
  (aref (km:keisen-char-vector str) dir))

(defun km:replace-keisen-string (str dir) ;------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%]%$%s%H0LCV$+$i7S@~J8;zNs$r(Bdir(0=$B1&(B,1=$B2<(B)$B$K8~$+$C$FJ#?tJ8;z=E$M=q$-$9$k(B
 $B%P%C%U%!>e$G=E$M=q$-$5$l$?85$NJ8;zNs$rJV$9(B"
  (save-excursion
    (let ((org-str nil)
          (p 0)
          (len (length str))
          d1 d2 pat
          w ss c)
      (cond ((= dir 0) ; $B1&J}8~$K9T$/(B
             (setq d1 2
                   d2 3
                   pat "[$B(!(,(B]")
             (setq keisen-vertical-move-count 0)
             (setq keisen-horizontal-move-count 1))
            ((= dir 1) ; $B2<J}8~$K9T$/(B
             (setq d1 0
                   d2 1
                   pat "[$B("(-(B]")
             (setq keisen-vertical-move-count 1)
             (setq keisen-horizontal-move-count 0)))
      (while (> len p)
        (setq c (char-to-string (following-char)))
        (if (= (length c) 1)
            (setq c "  "))
        (setq org-str (concat org-str c))
        (setq w (char-bytes (sref str p)))
        (if (= w 1) (setq w 2))
        (setq ss (substring str p (+ p w)))
        (and (= p 0)
             (not (string-match pat c))
             (setq ss (km:add-direction ss d1 (km:width-direction c d1))))
        (setq p (+ p w))
        (and (>= p len)
             (not (string-match pat c))
             (setq ss (km:add-direction ss d2 (km:width-direction c d2))))
        (km:insert-keisen ss))
      org-str)))

(defun km:bar-move-up-down (bar y) ;-------------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%]%$%s%H0LCV$N2#J}8~$N7S@~(Bbar$B$r>e2<$K0\F0$9$k(B
 $B0\F0$G$-$?$i(B t $B$rJV$9(B"
  (let ((possible (km:check-horizontal-bar bar y))
        org-str)
    (if (null possible)
        nil
      (km:move-to-column-force (aref bar 0) nil)
      (setq org-str
            (km:replace-keisen-string keisen-fill-bar-string 0))
      (km:picture-move-down y)
      (km:move-to-column-force (aref bar 0) nil)
      (km:replace-keisen-string org-str 0)
      t)))

(defun km:bar-move-left-right (bar x) ;----------------------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%]%$%s%H0LCV$N2#J}8~$N7S@~(Bbar$B$r:81&$K0\F0$9$k(B
 $B0\F0$G$-$?$i(B t $B$rJV$9(B"
  (let ((possible (km:check-vertical-bar bar x))
        (col (current-column))
        org-str)
    (if (null possible)
        nil
      (goto-char (aref bar 0))
      (setq org-str
            (km:replace-keisen-string keisen-fill-bar-string 1))
      (km:move-to-column-force (+ col (* x 2)) nil)
      (km:replace-keisen-string org-str 1)
      ;; $B=D(Bbar$B$OF0$+$9$HCM$,JQ2=$9$k(B
      (aset bar 0 (point))
      t)))

(defun km:drag-region (event face &optional adjust) ;--------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%^%&%9$G(Bevent$B$N;XDj0LCV$+$i6k7AHO0O$r%I%i%C%0$9$k(B. $B:G8e$K%\%?%s(B
 $B$,%j%j!<%9$5$l$?(Bevent$B$rJV$9(B. keisen-mouse-use-hilite-region$B$,(Bt$B$J(B
 $B$i$P(B, $B;XDj$5$l$?(Bface$B$GHO0O$r%O%$%i%$%HI=<($9$k(B"
  (let* ((e0 (event-end event))
         (w0 (posn-window e0))
         (x-y0 (posn-col-row e0))
         (x0 (+ (car x-y0) (window-hscroll)))
         (px-y nil)
         (pp nil))
    (km:move-to-position e0)
    (if adjust
        (setq x0 (* (/ x0 2) 2)))
    (km:move-to-column-force x0 t)
    (setq x-y0 (cons x0 (cdr x-y0)))
    (keisen-set-mark)
    (track-mouse
      (let ((keep t))
        (while keep
          (setq event (read-event))
          (if (eq (event-basic-type event) 'mouse-movement)
              (let* ((posn (event-end event))
                     (w (posn-window posn))
                     (x-y (posn-col-row posn)))
                (if truncate-lines
                    (setq x-y (cons (+ (car x-y) (window-hscroll)) (cdr x-y))))
                ;; frame$B$+$i$O$_=P$7$?$j(B, Window$B$+$i$O$_=P$7$?>l9g$O=hM}$r$7$J$$(B
                (cond ((and (windowp w) (eq w w0))
                       ;; $B6k7ANN0h$,>.$5$/$J$C$?$i!"$O$_=P$?J,$r>C$9(B
                       (and (km:if-shrink-rectangle x-y0 px-y x-y)
                            (setq keisen-mouse-hilite-face 'default)
                            (km:hilite-rectangle (km:what-mark-point) pp))
                       ;; $B6k7ANN0h$r%O%$%i%$%H$9$k(B
                       (km:move-to-position posn)
                       (setq keisen-mouse-hilite-face face
                             pp (point))
                       (km:hilite-rectangle (km:what-mark-point) pp)
                       (setq px-y x-y))))
            (setq keep nil)))))
    event))

(defun km:drag-keisen-horizontally (event vbar w0 x0) ;------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%I%i%C%0A`:n$N(Bevent$B$K$h$C$FF@$i$l$k0LCV$K8~$+$C$F(B, $B=DJ}8~$N7S@~$N(Bbar$B$r(B
 $B?eJ?J}8~$K0\F0$9$k(B. $B0\F08e$N?7$7$$(Bx0$B$rJV$9(B"
  (let* ((posn (event-end event))
         (w (posn-window posn))
         (x-y (posn-col-row posn))
         (keep t)
         (x (+ (- (car x-y) x0) (window-hscroll))))
    ;; frame$B$+$i$O$_=P$7$?$j!"(BWindow$B$+$i$O$_=P$7$?>l9g$O=hM}$r$7$J$$(B
    (cond ((and (windowp w) (eq w w0))
           (if vbar
               (while (and keep
                           (/= x 1)
                           (/= x 0)
                           (/= x -1))
                 (cond ((> x 1)
                        (if (km:bar-move-left-right vbar 1)
                            (progn
                              (setq x0 (+ x0 2))
                              (setq x (- x 2)))
                          (setq keep nil)))
                       ((> -1 x)
                        (if (km:bar-move-left-right vbar -1)
                            (progn
                              (setq x0 (- x0 2))
                              (setq x (+ x 2)))
                          (setq keep nil)))
                       (t (setq keep nil))))))))
  x0)

(defun km:drag-keisen-vertically (event hbar w0 y0) ;--------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B%I%i%C%0A`:n$N(Bevent$B$K$h$C$FF@$i$l$k0LCV$K8~$+$C$F(B, $B2#J}8~$N7S@~$N(Bbar$B$r(B
 $B?bD>J}8~$K0\F0$9$k(B. $B0\F08e$N?7$7$$(By0$B$rJV$9(B"
  (let* ((posn (event-end event))
         (w (posn-window posn))
         (x-y (posn-col-row posn))
         (keep t)
         (y (- (cdr x-y) y0)))
    ;; frame$B$+$i$O$_=P$7$?$j!"(BWindow$B$+$i$O$_=P$7$?>l9g$O=hM}$r$7$J$$(B
    (cond ((and (windowp w) (eq w w0))
           (if hbar
               (while (and keep (/= y 0))
                 (cond ((> y 0)
                        (if (km:bar-move-up-down hbar 1)
                            (progn
                              (setq y0 (1+ y0))
                              (setq y (1- y)))
                          (setq keep nil)))
                       ((> 0 y)
                        (if (km:bar-move-up-down hbar -1)
                            (progn
                              (setq y0 (1- y0))
                              (setq y (1+ y)))
                          (setq keep nil)))
                       (t (setq keep nil))))))))
  y0)

(defun km:substring (str offset col &optional flg) ;---------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $BJ8;zNs$N(Boffset$B%+%i%`0LCV$+$i;XDj%+%i%`$^$G<h$j=P$9(B
 flg$B$,(Bt$B$N>l9g(B, $BG\I}$NJ8;z$,6-3&$KF~$C$?>l9g$O%9%Z!<%9$rJd40$9$k(B"
  (let ((pos 0)
        (c 0)
        ch ret)
    (while (< c offset)
      (setq ch (sref str pos))
      (setq c (+ c (char-width ch))
            pos (+ pos (char-bytes ch))))
    (if flg
        (setq ret (make-string (- c offset) ? ))
      (setq ret ""))
    (while (< c col)
      (setq ch (sref str pos))
      (if (<= (+ c (char-width ch)) col)
          (setq ret (concat ret (char-to-string ch)))
        (if flg
            (setq ret (concat ret (make-string (- col c) ? )))))
      (setq c (+ c (char-width ch))
            pos (+ pos (char-bytes ch))))
    ret))

(defun km:mouse-move-rectangle (rect begin end x y) ;--------------------------
  "[$B7S@~%b!<%I4X?t(B]
 $B6k7A%G!<%?$r(Bx$B$,@5$J$i8e$+$i(Bx$B%+%i%`(B, $BIi$J$iA0$+$i(B-x$B%+%i%`(B, 
 y$B$,@5$J$i:G8e$+$i(By$B9T(B, $BIi$J$i@hF,$+$i(B-y$B9T>.$5$/$7$F(B, $B%]%$%s%H(B
 $B0LCV0J9_(B(x,y)$B$N0LCV$K$K>e=q$-$GA^F~$9$k(B"
  (let ((xlen (km:string-column (nth 0 rect)))
        (ylen (length rect))
        (new-end end)
        xs xe ys ye yc rect2 p)
    (if (or (>= (abs x) xlen)
            (>= (abs y) ylen))
        nil
      (setq xs 0
            xe xlen
            ys 0
            ye ylen)
      (cond ((< x 0)
             (setq xs (- xs x)))
            ((< 0 x)
             (setq xe (- xe x))))
      (cond ((< y 0)
             (setq ys (- ys y)))
            ((< 0 y)
             (setq ye (- ye y))))
      (setq yc ys)
      (while (< yc ye)
        (setq rect2
              (cons (km:substring (nth yc rect) xs xe t) rect2))
        (setq yc (1+ yc)))
      (setq rect2 (nreverse rect2))
      (save-excursion
        (goto-char begin)
        (if (> y 0) (km:picture-move-down y))
        (km:move-to-column-force (+ (current-column) (max 0 x)))
        (setq begin (point))
        (km:insert-rectangle rect2)
        (goto-char begin)
        (km:picture-move-down (1- (- ye ys)))
        (km:move-to-column-force (+ (current-column) (- xe xs)))
        (setq new-end (point))
        (setq keisen-mouse-hilite-face 'region)
        (km:hilite-rectangle begin new-end)))
    new-end))

;; $B%$%s%?%i%/%F%#%V4X?t$NDj5A(B
(defun keisen-mouse-draw-line (event) ;----------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%^%&%9$G7S@~$r$R$/(B. $B%I%i%C%0A`:n$J$N$G(Bdown-mouse-x$B$K%P%$%s%I$9$k(B.
 keisen-mouse-restrict-direction$B$,(Bt$B$K$J$C$F$$$k$H(B, $B:G=i$KF0$$$?J}8~$K(B
 $B$N$_7S@~$,0z$1(B, $BESCf$+$iJ}8~$rJQ$($k$3$H$,$G$-$J$$(B"
  (interactive "e")
  (let* ((e0 (event-end event))
         (w0 (posn-window e0))
         (x-y0 (posn-col-row e0))
         (x0 (+ (car x-y0) (window-hscroll)))
         (y0 (cdr x-y0))
         (hmode nil)
         (vmode nil))
    (km:move-to-position e0)
    (if keisen-adjust-column-force
        (setq x0 (* (/ (1+ x0) 2) 2)))
    (km:move-to-column-force x0 t)
    (setq x-y0 (cons x0 y0))
    (or (equal x-y0 keisen-mouse-last-point) (setq last-command 'nil))
    (track-mouse
      (let ((keep t))
        (while keep
          (setq event (read-event))
          (if (eq (event-basic-type event) 'mouse-movement)
              (let* ((posn (event-end event))
                     (w (posn-window posn))
                     (x-y (posn-col-row posn))
                     (x (+ (car x-y) (window-hscroll)))
                     (y (cdr x-y))
                     (v (- y y0))
                     (h (/ (- x x0) 2)))
                ;; frame$B$+$i$O$_=P$7$?$j!"(BWindow$B$+$i$O$_=P$7$?>l9g$O=hM}$r$7$J$$(B
                (cond ((and (windowp w) (eq w w0))
                       ;; hmode$B$b(Bvmode$B$b%;%C%H$5$l$F$$$J$$$J$i%;%C%H$9$k(B
                       (or hmode vmode
                           (if (and (= v 0) (/= h 0))
                               (setq hmode t)
                             (or (= v 0) (setq vmode t))))
                       ;; $B0lEY>e2<$KF0$-=P$7$?$i!":81&$K$OF0$+$J$$(B
                       ;; $B0lEY:81&$KF0$-=P$7$?$i!">e2<$K$OF0$+$J$$(B
                       (and keisen-mouse-restrict-direction
                            (cond (vmode (setq h 0))
                                  (hmode (setq v 0))))
                       (cond ((> v 0)
                              (setq this-command 'keisen-draw-down)
                              (keisen-draw-down v))
                             ((> 0 v)
                              (setq this-command 'keisen-draw-up)
                              (keisen-draw-up (- v))))
                       (cond ((> h 0)
                              (setq this-command 'keisen-draw-right)
                              (keisen-draw-right h))
                             ((> 0 h)
                              (setq this-command 'keisen-draw-left)
                              (keisen-draw-left (- h))))
                       (setq y0 (+ y0 v)
                             x0 (+ x0 (* 2 h)))
                       (and (< y0 0) (setq y0 0))
                       (and (< x0 0) (setq x0 0))
                       )))
            (setq keep nil)))
        (setq keisen-mouse-last-point (cons x0 y0))))))

(defun keisen-mouse-transform-char (event) ;-----------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%^%&%9$G;XDj$7$?%]%$%s%H$N7S@~J8;z$r<~0O$K@5$7$/@\B3$9$k$h$&$K=$@5$9$k(B"
  (interactive "e")
  (mouse-set-point event)
  (let ((x (car (posn-col-row (event-end event)))))
    (if keisen-adjust-column-force
        (setq x (* (/ (1+ x) 2) 2)))
    (km:move-to-column-force x))
  (save-excursion
    (let ((str (km:vector-to-keisen
                (km:central-vector
                 (km:relative-vector 0 -1)
                 (km:relative-vector 0 1)
                 (km:relative-vector -1 0)
                 (km:relative-vector 1 0)))))
      (km:insert-keisen str))))
                                    
(defun keisen-mouse-down (event) ;---------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%^%&%9$G;XDj$7$?%]%$%s%H$r;X$7(B, $B%/%j%C%/2s?t$K1~$8$F2<0L$N5!G=$r8F$SJ,$1$k(B"
  (interactive "e")
  (mouse-set-point event)
  (let ((count (event-click-count event)))
    (if (= count 1)
        (keisen-mouse-draw-line event)
      ;; 2$B2s(Bclick$B$7$?$H$-$O!"(Bdouble-xx$B$H(Bdouble-down-xx$B$N(B2$B$D$N(Bevent$B$,(B
      ;; $BMh$k$N$G!"(Bdown$B$N$H$-$O=hM}$7$J$$(B
      (and (= count 2)
           (null (memq 'down (event-modifiers event)))
           (keisen-mouse-transform-char event)))))

(defun keisen-mouse-square-line (event) ;--------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%^%&%9$G;XDj$7$?HO0O$K7S@~$G;M3Q$rIA$/(B"
  (interactive "e")
  (mouse-set-point event)
  (setq event (km:drag-region event 'region keisen-adjust-column-force))
  (km:move-to-position (event-end event))
  (keisen-square-line)
  ;; $B%O%$%i%$%H$7$?NN0h$r85$KLa$9(B
  (setq keisen-mouse-hilite-face 'default)
  (km:hilite-rectangle (km:what-mark-point) (point)))

(defun keisen-mouse-drag-line (event) ;----------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%^%&%9$G4{B8$N7S@~$r%I%i%C%00\F0$9$k(B"
  (interactive "e")
  (mouse-set-point event)
  (let ((vec (km:following-char-vector))
        hbar vbar x0 y0 col-row w0
        (keep t)
        (posn0 (event-end event)))
    (or (and (= (aref vec 0) 0)
             (= (aref vec 1) 0))
        (setq vbar (km:col-vertical-bar)))
    (or (and (= (aref vec 2) 0)
             (= (aref vec 3) 0))
        (setq hbar (km:col-horizontal-bar)))
    (km:hilite-vertical-bar vbar 'region)
    (km:hilite-horizontal-bar hbar 'region)
    (setq col-row (posn-col-row posn0)
          w0 (posn-window posn0))
    (setq x0 (+ (car col-row) (window-hscroll))
          y0 (cdr col-row))
    (if keisen-adjust-column-force
        (setq x0 (* (/ (1+ x0) 2) 2)))
    (track-mouse
      (while keep
        (setq event (read-event))
        (if (eq (event-basic-type event) 'mouse-movement)
            (let (nx ny)
              ;; y$BJ}8~$X$N0\F0=hM}(B
              (save-excursion
                (km:hilite-horizontal-bar hbar 'default)
                (setq ny (km:drag-keisen-vertically event hbar w0 y0)))
              (km:move-to-column-force x0)
              (if (= ny y0) nil
                (km:picture-move-down (- ny y0))
                (cond (vbar
                       (km:hilite-vertical-bar vbar 'default)
                       (setq vbar (km:col-vertical-bar))
                       (km:hilite-vertical-bar vbar 'region)))
                (setq y0 ny))
              (km:hilite-horizontal-bar hbar 'region)
              ;; x$BJ}8~$X$N0\F0=hM}(B
              (save-excursion
                (km:hilite-vertical-bar vbar 'default)
                (setq nx (km:drag-keisen-horizontally event vbar w0 x0)))
              (if (= nx x0) nil
                (km:move-to-column-force nx)
                (cond (hbar
                       (km:hilite-horizontal-bar hbar 'default)
                       (setq hbar (km:col-horizontal-bar))
                       (km:hilite-horizontal-bar hbar 'region)))
                (setq x0 nx))
              (km:hilite-vertical-bar vbar 'region))
          (setq keep nil))))
    (km:hilite-horizontal-bar hbar 'default)
    (km:hilite-vertical-bar vbar 'default)))

(defun keisen-mouse-drag-char (event) ;----------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%^%&%9$GI=Cf$NJ8;z$r%I%i%C%0$9$k(B"
  (interactive "e")
  (mouse-set-point event)
  (let* ((posn0 (event-end event))
         (w0 (posn-window posn0))
         (x-y0 (posn-col-row posn0))
         (x0 (+ (car x-y0) (window-hscroll)))
         (y0 (cdr x-y0))
         (keep t)
         begin end rect moved posn x-y w x y)
    (save-excursion
      (km:top-of-frame)
      (km:beginning-of-line)
      (setq begin (point))
      (km:bottom-of-frame)
      (km:end-of-line)
      (forward-char 1)
      (setq end (point))
      (setq rect (km:save-extract-rectangle begin (point)))
      (setq keisen-mouse-hilite-face 'region)
      (km:hilite-rectangle begin end))
    (track-mouse
      (while keep
        (setq event (read-event))
        (cond ((eq (event-basic-type event) 'mouse-movement)
               (setq posn (event-end event))
               (setq x-y (posn-col-row posn)
                     w (posn-window posn))
               (setq x (+ (car x-y) (window-hscroll))
                     y (cdr x-y))
               (and (windowp w)
                    (eq w w0)
                    (or moved (/= x x0) (/= y y0))
                    (progn
                      (setq moved t)
                      (km:kill-extract-rectangle begin end)
                      (setq end
                            (km:mouse-move-rectangle
                             rect begin end (- x x0) (- y y0))))))
              (t (setq keep nil)))))
    (setq keisen-mouse-hilite-face 'default)
    (km:hilite-rectangle begin end)))

(defun keisen-mouse-drag-* (event) ;-------------------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%^%&%9$GJ8;z$+7S@~$r%I%i%C%0$9$k(B"
  (interactive "e")
  (mouse-set-point event)
  (if (string-match "[$B(!(B-$B(@(B]" (char-to-string (following-char)))
      (keisen-mouse-drag-line event)
    (keisen-mouse-drag-char event)))

(defun keisen-mouse-copy-rectangle (event) ;-----------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%^%&%9$G;XDj$7$?HO0O$r6k7A%P%C%U%!$KJ]B8$9$k(B"
  (interactive "e")
  (mouse-set-point event)
  ;; $B%I%i%C%0$9$k(B
  (setq event (km:drag-region event 'highlight))
  ;; $BHO0O$N=*E@$K9T$/(B
  (km:move-to-position (event-end event))
  ;; $B%O%$%i%$%H$7$?NN0h$r85$KLa$9(B
  (setq keisen-mouse-hilite-face 'default)
  (let ((pp (point)))
    (km:hilite-rectangle (km:what-mark-point) pp)
    ;; $B%l%8%9%?$KJ]B8$9$k(B
    (setq km:rectangle-save-buffer
          (km:save-extract-rectangle (km:what-mark-point) pp))))

(defun keisen-mouse-yank-rectangle (event) ;-----------------------------------
  "[$B7S@~%b!<%I5!G=(B]
 $B%^%&%9$G;XDj$7$?0LCV$K6k7A%P%C%U%!$r%Z!<%9%H$9$k(B"
  (interactive "e")
  (mouse-set-point event)
  (km:insert-rectangle km:rectangle-save-buffer))

;; $B%^%&%9$N%^%C%T%s%0$r$9$k(B
;;
;; $B%\%?%s(B1 : $B%I%i%C%0$7$F7S@~$r0z$/(B
;; $B%\%?%s(B2 : $B%I%i%C%0$7$F7S@~$dI=$NCf?H$r0\F0$9$k(B
;; $B%\%?%s(B3 : $B%I%i%C%0$7$F7S@~$K$h$k;M3Q$rIA$/(B
;; $B%\%?%s(B1$B%@%V%k%/%j%C%/(B : $B<~0O$N7S@~$H@5$7$/$D$J$,$k$h$&$K7S@~$N(B
;;                         $B8~$-$r=$@5$9$k(B
;; M-$B%\%?%s(B1 : $B6k7A%3%T!<(B
;; M-$B%\%?%s(B2 : $B6k7A%Z!<%9%H(B
;;
(define-key keisen-mode-map [down-mouse-1] 'keisen-mouse-down)
(define-key keisen-mode-map [double-mouse-1] 'keisen-mouse-down)
(define-key keisen-mode-map [down-mouse-3] 'keisen-mouse-square-line)
(define-key keisen-mode-map [down-mouse-2] 'keisen-mouse-drag-*)
(define-key keisen-mode-map [M-down-mouse-1] 'keisen-mouse-copy-rectangle)
(define-key keisen-mode-map [M-mouse-2] 'keisen-mouse-yank-rectangle)

;;; keisen-mouse.el ends here
