;;; -*- Mode: Emacs-Lisp ; Coding: iso-2022-jp -*-
;;
;; keisen mode commands for Emacs
;; Copyright (C) 1986,1992-1995 Free Software Foundation, Inc.
;;
;;;
;; 本プログラムはフリー・ソフトウェアです。あなたは、Free Software
;; Foundation が公表した GNU 一般公有使用許諾の「バージョン 1」あるいはそれ
;; 以降の各バージョンの中からいずれかを選択し、そのバージョンが定める条項に
;; 従って本プログラムを再頒布または変更することができます。
;;
;; 本プログラムは有用とは思いますが、頒布にあたっては、市場性及び特定目的適
;; 合性についての暗黙の保証を含めて、いかなる保証も行ないません。詳細につい
;; ては GNU 一般公有使用許諾書をお読み下さい。
;;
;; あなたは、本プログラムと一緒に GNU 一般公有使用許諾書の写しを受け取ってい
;; るはずです。そうでない場合は、Free Software Foundation, Inc., 675 Mass
;; Ave, Cambridge, MA 02139, USA へ手紙を書いて下さい。
;;
;;;
;; このプログラムは、三重大学工学部電気電子工学科の平成２年度卒業生
;; 鳥居 健さんと杉本 哲也さんが作成し、鎌部 浩さんが配布したものを
;; ベースとして、沖通信システムの岩本さんがMULE対応への修正及び機能
;; 追加を行ったものに、mule 2.xのGUI機能を利用してマウス操作で罫線
;; を引く機能を追加するためのモジュールです。:-)
;;
;; ~/.emacs に
;; 
;;  (if (boundp 'MULE)
;;      (if window-system
;;          (autoload 'keisen-mode "keisen-mouse" "MULE版罫線モード＋マウス" t))
;;    (autoload 'keisen-mode "keisen-mule" "MULE版罫線モード" t))
;;
;; のような4行を入れておくと良いでしょう
;;
;;;
;; keisen-mouse.el ver 1.0 for keisen-mule 2.02γ
;; Author: 小林 正興 (masaoki@tky.hp.com)
;;

;; keisen-mule 2.02γが必要です
(require 'keisen-mule)

;; 変数の定義
(defvar keisen-mouse-restrict-direction t
  "*non-nilならば, マウスのドラッグの自由移動を抑制して直線を
 描くようにする")

(defvar keisen-mouse-use-hilite-region t
  "*non-nilならば, マウス操作で四角を描いたり, ドラッグをする場合に範囲を
 ハイライトする. 遅いマシンではnilにした方が良いと思う")

(defvar keisen-mouse-connection-list
  '("  " "│" "┃" "│" "│" "┃" "┃" "┃" "┃"
    "─" "┘" "┛" "┐" "┤" "┨" "┓" "┨" "┨"
    "━" "┛" "┛" "┓" "┥" "┫" "┓" "┫" "┫"
    "─" "└" "┗" "┌" "├" "┠" "┏" "┠" "┠"
    "─" "┴" "┸" "┬" "┼" "╂" "┰" "╂" "╂"
    "━" "┷" "┻" "┯" "┿" "╋" "┳" "╋" "╋"
    "━" "┗" "┗" "┏" "┝" "┣" "┏" "┣" "┣"
    "━" "┷" "┻" "┯" "┿" "╋" "┳" "╋" "╋"
    "━" "┷" "┻" "┯" "┿" "╋" "┳" "╋" "╋")
  "接続を表すvectorから該当する罫線文字を抽出するためのリスト")

(defvar keisen-mouse-last-point nil
  "マウスを離した最後のポイント")

(defvar keisen-fill-bar-string nil
  "罫線の移動時に使う一時変数")

(defvar keisen-mouse-hilite-face 'default
  "ドラッグした範囲を表示するのに使うためのfaceを格納する一時変数")

;; メニューバーの定義
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

;; 関数の定義
(defun km:if-shrink-val (xp x) ;-----------------------------------------------
  "[罫線モード関数]
 0からxpの数値範囲にxが入っているか, xとxpの符号が違う場合はt"
  (if (> xp 0)
      (if (> x 0)
          (> xp x)
        t)
    (if (> x 0) t
      (> x xp))))

(defun km:if-shrink-rectangle (initial-xy prev-xy current-xy) ;----------------
  "[罫線モード関数]
 initial-xyからprev-xyの矩形範囲にcurrent-xyが含まれる場合はt,
 そうでなければnilを返す. それぞれの引数はassoc-listになっている"
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
  "[罫線モード関数]
 必要ならスペースや改行を入れながら, eventで得た画面上のposnの位置に
 カーソルを移動する"
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
  "[罫線モード関数]
 矩形領域の一行をハイライトする"
  (put-text-property pos (point) 'face keisen-mouse-hilite-face))

(defun km:hilite-rectangle (start end) ;---------------------------------------
  "[罫線モード関数]
 矩形領域をハイライトする"
  (cond (keisen-mouse-use-hilite-region
         ;; startとendが順になっていないと正しく働かない
         (if (> start end)
             (let ((buf start))
               (setq start end
                     end buf)))
         (km:operate-on-rectangle 'km:hilite-rectangle-line
                               start end nil))))

(defun km:keisen-char-vector (str) ;-------------------------------------------
  "[罫線モード関数]
 引数の罫線文字１文字の接続方向を表すvectorを返す"
  (let (p1 p2 p3 p4)
    (setq p1 (if (string-match str "│├┼┴┤└┘┝┷┿┥")
                 1
               (if (string-match str "┃┠╂┸┨┗┛╋┣┻┫")
                   2 0))
          p2 (if (string-match str "│├┼┬┤┌┐┝┯┿┥")
                 1
               (if (string-match str "┃┠╂┰┨┏┓╋┣┳┫")
                   2 0))
          p3 (if (string-match str "─┬┼┴┤┐┘┸┰╂┨")
                 1
               (if (string-match str "━┳╋┻┫┓┛┿┥┯┷")
                   2 0))
          p4 (if (string-match str "─┬┼┴├┌└┸┰╂┠")
                 1
               (if (string-match str "━┳╋┻┣┏┗┿┝┯┷")
                   2 0)))
    (vector p1 p2 p3 p4)))

(defun km:following-char-vector () ;-------------------------------------------
  "[罫線モード関数]
 ポイント位置の罫線文字の接続方向を表すvectorを返す"
  (km:keisen-char-vector (char-to-string (following-char))))

(defun km:vector-to-keisen (v) ;-----------------------------------------------
  "[罫線モード関数]
 与えられたvectorに対応する罫線文字を返す"
  (let ((val (+ (aref v 0) (* 3 (aref v 1))
                (* 9 (aref v 2)) (* 27 (aref v 3)))))
    (nth val keisen-mouse-connection-list)))

(defun km:central-vector (v1 v2 v3 v4) ;---------------------------------------
  "[罫線モード関数]
 上下左右の罫線文字のvectorから, 適切な中心vectorを求める"
  (vector (aref v1 1) (aref v2 0) (aref v3 3) (aref v4 2)))

(defun km:relative-vector (x y) ;----------------------------------------------
  "[罫線モード関数]
 ポイント位置から与えられた相対座標位置の罫線文字のvectorを返す"
  (save-excursion
    (let ((col (current-column)))
      (cond ((= y 1)
             (end-of-line)
             (if (eobp)
                 (newline)
               (forward-char 1)))
            ((= y -1)
             (if (< (forward-line -1) 0) ; 最上行から上に行こうとした
                 (setq col -100))))
      (setq col (+ col (* x 2)))
      (if (> 0 col)
          [0 0 0 0]
        (km:move-to-column-force col nil)
        (km:following-char-vector)))))

(defun km:col-horizontal-bar () ;----------------------------------------------
  "[罫線モード関数]
 ポイント位置から横方向につながる罫線の両終端位置を求め, 
 始点と終点のcolumnの2要素のvectorにして返す"
  (save-excursion
    (let ((c0 (current-column))
          c c1 c2)
      (setq c (max 0 (- c0 2)))
      (km:move-to-column-force c nil)
      ;; まず左方向を探して行く
      (while (and (string-match "[─━┬┳┯┰┴┻┷┸┼╋╂┿]"
                                (char-to-string (following-char)))
                  (> c 1))
        (setq c (- c 2))
        (km:move-to-column-force c nil))
      (or (string-match "[┌└┏┗├┣┝┠]"
                        (char-to-string (following-char)))
          (setq c (+ c 2)))
      (setq c1 (max 0 c))
      ;; 右方向を探す
      (setq c (+ c0 2))
      (km:move-to-column-force c nil)
      (while (and (string-match "[─━┬┳┯┰┴┻┷┸┼╋╂┿]"
                                (char-to-string (following-char)))
                  (null (eolp)))
        (setq c (+ c 2))
        (km:move-to-column-force c nil))
      (or (string-match "[┐┘┓┛┨┥┫┤]"
                        (char-to-string (following-char)))
          (setq c (- c 2)))
      (setq c2 c)
      (vector c1 c2))))

;; horizontal と vertical では bar を表す vector の意味が違うことに注意
(defun km:col-vertical-bar () ;------------------------------------------------
  "[罫線モード関数]
 ポイント位置から縦方向につながる罫線の両終端位置を求め, 
 始点のポイントと長さの2要素のvectorにして返す"
  (save-excursion
    (let ((p (point))
          p1 p2)
      (km:picture-move-down -1)
      ;; まず上方向を探して行く
      (while (and (string-match "[│┃┤┫┨┥├┣┝┠┼╋╂┿]"
                                (char-to-string (following-char)))
                  (null (bobp)))
        (km:picture-move-down -1))
      (or (string-match "[┌┐┏┓┬┳┯┰]"
                        (char-to-string (following-char)))
          (km:picture-move-down 1))
      (setq p1 (point))
      ;; 下方向を探す
      ;; 上に一度上がっているので、初期のpointのバッファ内の位置はずれている
      ;; かもしれないので、現在のpointから、また逆に下がる
      (setq p2 1)
      (km:picture-move-down 1)
      (while (and (string-match "[│┃┤┫┨┥├┣┝┠┼╋╂┿]"
                                (char-to-string (following-char)))
                  (null (eobp)))
        (setq p2 (1+ p2))
        (km:picture-move-down 1))
      (or (string-match "[└┘┗┛┴┻┷┸]"
                        (char-to-string (following-char)))
          (setq p2 (1- p2)))
      (vector p1 p2))))

(defun km:hilite-horizontal-bar (bar face) ;-----------------------------------
  "[罫線モード関数]
 2要素のvectorをポイント位置から両端と見てハイライトする"
  (and keisen-mouse-use-hilite-region
       bar
       (save-excursion
         (km:move-to-column-force (aref bar 0) nil)
         (let ((p (point)))
           (km:move-to-column-force (aref bar 1) nil)
           (forward-char 1)
           (put-text-property p (point) 'face face)))))

(defun km:hilite-vertical-bar (bar face) ;-------------------------------------
  "[罫線モード関数]
 2要素のvectorをポイント位置から両端と見てハイライトする"
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
  "[罫線モード関数]
 ポイント位置からvecで表されるbarを縦方向に移動可能かどうか調べる
 移動可能であれば, vecに対して移動した後に補完されるべき文字列を
 keisen-fill-bar-string に入れ, tを返す"
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
          ;; 左端の処理
          (if (= c0 (aref vec 0))
              (if (or (/= (aref v2 0) 0) ; "─" のときは合成したくない
                      (/= (aref v2 1) 0))
                  (aset v3 2 (aref v2 2)))
            (if (/= (aref v1 2) 0)
                (setq r nil)))
          ;; 右端の処理
          (if (= c0 c1)
              (if (or (/= (aref v2 0) 0) ; "─" のときは合成したくない
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
  "[罫線モード関数]
 vecで表される縦barを横方向に移動可能かどうか調べる
 移動可能であれば, vecに対して移動した後に補完されるべき文字列を
 keisen-fill-bar-string に入れ, tを返す"
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
            ;; 上端の処理
            (if (= c (aref vec 1))
                (if (or (/= (aref v2 2) 0) ; "│" のときは合成したくない
                        (/= (aref v2 3) 0))
                    (aset v3 0 (aref v2 0)))
              (if (/= (aref v1 0) 0)
                  (setq r nil)))
            ;; 下端の処理
            (if (= c 0)
                (if (or (/= (aref v2 2) 0) ; "│" のときは合成したくない
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
  "[罫線モード関数]
 罫線文字strの方向dirに太さwidの罫線を加え, 返す"
  (let ((vec (km:keisen-char-vector str)))
    (aset vec dir wid)
    (km:vector-to-keisen vec)))

(defun km:width-direction (str dir) ;------------------------------------------
  "[罫線モード関数]
 罫線文字strの方向dirの罫線の太さを返す"
  (aref (km:keisen-char-vector str) dir))

(defun km:replace-keisen-string (str dir) ;------------------------------------
  "[罫線モード関数]
 ポイント位置から罫線文字列をdir(0=右,1=下)に向かって複数文字重ね書きする
 バッファ上で重ね書きされた元の文字列を返す"
  (save-excursion
    (let ((org-str nil)
          (p 0)
          (len (length str))
          d1 d2 pat
          w ss c)
      (cond ((= dir 0) ; 右方向に行く
             (setq d1 2
                   d2 3
                   pat "[─━]")
             (setq keisen-vertical-move-count 0)
             (setq keisen-horizontal-move-count 1))
            ((= dir 1) ; 下方向に行く
             (setq d1 0
                   d2 1
                   pat "[│┃]")
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
  "[罫線モード関数]
 ポイント位置の横方向の罫線barを上下に移動する
 移動できたら t を返す"
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
  "[罫線モード関数]
 ポイント位置の横方向の罫線barを左右に移動する
 移動できたら t を返す"
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
      ;; 縦barは動かすと値が変化する
      (aset bar 0 (point))
      t)))

(defun km:drag-region (event face &optional adjust) ;--------------------------
  "[罫線モード関数]
 マウスでeventの指定位置から矩形範囲をドラッグする. 最後にボタン
 がリリースされたeventを返す. keisen-mouse-use-hilite-regionがtな
 らば, 指定されたfaceで範囲をハイライト表示する"
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
                ;; frameからはみ出したり, Windowからはみ出した場合は処理をしない
                (cond ((and (windowp w) (eq w w0))
                       ;; 矩形領域が小さくなったら、はみ出た分を消す
                       (and (km:if-shrink-rectangle x-y0 px-y x-y)
                            (setq keisen-mouse-hilite-face 'default)
                            (km:hilite-rectangle (km:what-mark-point) pp))
                       ;; 矩形領域をハイライトする
                       (km:move-to-position posn)
                       (setq keisen-mouse-hilite-face face
                             pp (point))
                       (km:hilite-rectangle (km:what-mark-point) pp)
                       (setq px-y x-y))))
            (setq keep nil)))))
    event))

(defun km:drag-keisen-horizontally (event vbar w0 x0) ;------------------------
  "[罫線モード関数]
 ドラッグ操作のeventによって得られる位置に向かって, 縦方向の罫線のbarを
 水平方向に移動する. 移動後の新しいx0を返す"
  (let* ((posn (event-end event))
         (w (posn-window posn))
         (x-y (posn-col-row posn))
         (keep t)
         (x (+ (- (car x-y) x0) (window-hscroll))))
    ;; frameからはみ出したり、Windowからはみ出した場合は処理をしない
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
  "[罫線モード関数]
 ドラッグ操作のeventによって得られる位置に向かって, 横方向の罫線のbarを
 垂直方向に移動する. 移動後の新しいy0を返す"
  (let* ((posn (event-end event))
         (w (posn-window posn))
         (x-y (posn-col-row posn))
         (keep t)
         (y (- (cdr x-y) y0)))
    ;; frameからはみ出したり、Windowからはみ出した場合は処理をしない
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
  "[罫線モード関数]
 文字列のoffsetカラム位置から指定カラムまで取り出す
 flgがtの場合, 倍幅の文字が境界に入った場合はスペースを補完する"
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
  "[罫線モード関数]
 矩形データをxが正なら後からxカラム, 負なら前から-xカラム, 
 yが正なら最後からy行, 負なら先頭から-y行小さくして, ポイント
 位置以降(x,y)の位置にに上書きで挿入する"
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

;; インタラクティブ関数の定義
(defun keisen-mouse-draw-line (event) ;----------------------------------------
  "[罫線モード機能]
 マウスで罫線をひく. ドラッグ操作なのでdown-mouse-xにバインドする.
 keisen-mouse-restrict-directionがtになっていると, 最初に動いた方向に
 のみ罫線が引け, 途中から方向を変えることができない"
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
                ;; frameからはみ出したり、Windowからはみ出した場合は処理をしない
                (cond ((and (windowp w) (eq w w0))
                       ;; hmodeもvmodeもセットされていないならセットする
                       (or hmode vmode
                           (if (and (= v 0) (/= h 0))
                               (setq hmode t)
                             (or (= v 0) (setq vmode t))))
                       ;; 一度上下に動き出したら、左右には動かない
                       ;; 一度左右に動き出したら、上下には動かない
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
  "[罫線モード機能]
 マウスで指定したポイントの罫線文字を周囲に正しく接続するように修正する"
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
  "[罫線モード機能]
 マウスで指定したポイントを指し, クリック回数に応じて下位の機能を呼び分ける"
  (interactive "e")
  (mouse-set-point event)
  (let ((count (event-click-count event)))
    (if (= count 1)
        (keisen-mouse-draw-line event)
      ;; 2回clickしたときは、double-xxとdouble-down-xxの2つのeventが
      ;; 来るので、downのときは処理しない
      (and (= count 2)
           (null (memq 'down (event-modifiers event)))
           (keisen-mouse-transform-char event)))))

(defun keisen-mouse-square-line (event) ;--------------------------------------
  "[罫線モード機能]
 マウスで指定した範囲に罫線で四角を描く"
  (interactive "e")
  (mouse-set-point event)
  (setq event (km:drag-region event 'region keisen-adjust-column-force))
  (km:move-to-position (event-end event))
  (keisen-square-line)
  ;; ハイライトした領域を元に戻す
  (setq keisen-mouse-hilite-face 'default)
  (km:hilite-rectangle (km:what-mark-point) (point)))

(defun keisen-mouse-drag-line (event) ;----------------------------------------
  "[罫線モード機能]
 マウスで既存の罫線をドラッグ移動する"
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
              ;; y方向への移動処理
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
              ;; x方向への移動処理
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
  "[罫線モード機能]
 マウスで表中の文字をドラッグする"
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
  "[罫線モード機能]
 マウスで文字か罫線をドラッグする"
  (interactive "e")
  (mouse-set-point event)
  (if (string-match "[─-╂]" (char-to-string (following-char)))
      (keisen-mouse-drag-line event)
    (keisen-mouse-drag-char event)))

(defun keisen-mouse-copy-rectangle (event) ;-----------------------------------
  "[罫線モード機能]
 マウスで指定した範囲を矩形バッファに保存する"
  (interactive "e")
  (mouse-set-point event)
  ;; ドラッグする
  (setq event (km:drag-region event 'highlight))
  ;; 範囲の終点に行く
  (km:move-to-position (event-end event))
  ;; ハイライトした領域を元に戻す
  (setq keisen-mouse-hilite-face 'default)
  (let ((pp (point)))
    (km:hilite-rectangle (km:what-mark-point) pp)
    ;; レジスタに保存する
    (setq km:rectangle-save-buffer
          (km:save-extract-rectangle (km:what-mark-point) pp))))

(defun keisen-mouse-yank-rectangle (event) ;-----------------------------------
  "[罫線モード機能]
 マウスで指定した位置に矩形バッファをペーストする"
  (interactive "e")
  (mouse-set-point event)
  (km:insert-rectangle km:rectangle-save-buffer))

;; マウスのマッピングをする
;;
;; ボタン1 : ドラッグして罫線を引く
;; ボタン2 : ドラッグして罫線や表の中身を移動する
;; ボタン3 : ドラッグして罫線による四角を描く
;; ボタン1ダブルクリック : 周囲の罫線と正しくつながるように罫線の
;;                         向きを修正する
;; M-ボタン1 : 矩形コピー
;; M-ボタン2 : 矩形ペースト
;;
(define-key keisen-mode-map [down-mouse-1] 'keisen-mouse-down)
(define-key keisen-mode-map [double-mouse-1] 'keisen-mouse-down)
(define-key keisen-mode-map [down-mouse-3] 'keisen-mouse-square-line)
(define-key keisen-mode-map [down-mouse-2] 'keisen-mouse-drag-*)
(define-key keisen-mode-map [M-down-mouse-1] 'keisen-mouse-copy-rectangle)
(define-key keisen-mode-map [M-mouse-2] 'keisen-mouse-yank-rectangle)

;;; keisen-mouse.el ends here
