;;; -*- Mode: Emacs-Lisp ; Coding: iso-2022-jp -*-
;;
;; keisen mode commands for Emacs
;; Copyright (C) 1986,1992,1993,1994 Free Software Foundation, Inc.
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
;; ベースとして、MULE対応への修正及び機能追加を行ったものです。
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
;;   Version  : 2.02γ
;;
;;;
;; History
;;   1993.05.17 08:30 ver 1.90.00    M.Iwamoto
;;      [[ MULE対応版罫線モード αリリース ]]
;;   1993.05.17 11:10 ver 1.90.01    M.Iwamoto
;;      -- keisen-extend-left関数のバグ改修
;;   1993.05.17 13:09 ver 1.90.02    M.Iwamoto
;;      -- keisen-center-line関数の追加
;;      -- keisen-right-line関数の追加
;;      -- keisen-left-line関数の追加
;;   1993.05.25 09:15 ver 1.90.03    M.Iwamoto
;;      -- 自動改行機能の追加
;;      -- 自動拡張機能の追加
;;   1993.06.08 08:44 ver 1.90.04    M.Iwamoto
;;      -- keisen-clear-backward-char関数のバグ改修
;;      -- keisen-overwrite-string関数のバグ改修
;;      -- keisen-kill-rectangle関数の追加
;;      -- keisen-yank-rectangle関数の追加
;;      -- keisen-open-rectangle関数の追加
;;      -- keisen-clear-rectangle関数の追加
;;   1993.06.14 16:20 ver 1.90.05    M.Iwamoto		<非公開>
;;      -- keisen-clear-char関数のバグ改修
;;      -- keisen-enlarge-vertically関数のバグ改修
;;      -- keisen-shrink-horizontally関数のバグ改修
;;      -- keisen-extend-right関数の一部仕様変更
;;	-- keisen-extend-left関数の一部仕様変更
;;	-- keisen-extend-up関数の一部仕様変更
;;	-- keisen-extend-down関数の一部仕様変更
;;   1993.10.20 12:53 ver 1.95.00    M.Iwamoto
;;      [[ MULE対応版罫線モード βリリース ]]
;;      -- keisen-movement-right関数の追加
;;      -- keisen-movement-left関数の追加
;;      -- keisen-movement-up関数の追加
;;      -- keisen-movement-down関数の追加
;;      -- keisen-movement-wnw関数の追加
;;      -- keisen-movement-ene関数の追加
;;      -- keisen-movement-wsw関数の追加
;;      -- keisen-movement-ese関数の追加
;;      -- keisen-movement-nw関数の追加
;;      -- keisen-movement-ne関数の追加
;;      -- keisen-movement-sw関数の追加
;;      -- keisen-movement-se関数の追加
;;      -- keisen-picture-set-tab-stops関数の追加
;;      -- keisen-picture-tab-search関数の追加
;;      -- keisen-picture-tab関数の追加
;;      -- keisen-set-mark関数の仕様変更
;;      -- keisen-center-line関数のバグ改修
;;      -- keisen-right-line関数のバグ改修
;;      -- keisen-left-line関数のバグ改修
;;      -- keisen-arrow関数の追加
;;      -- keisen-line関数の追加
;;      -- keisen-square-line2関数の追加
;;      -- keisen-rectangle関数の追加
;;      -- keisen-save-rectangle関数の追加
;;      -- keisen-delete-rectangle関数の追加
;;      -- keisen-status関数の追加
;;      -- keisen-previous-line関数の仕様変更
;;      -- keisen-next-line関数の仕様変更
;;      -- keisen-forward-jump-frame関数の追加
;;      -- keisen-backward-jump-frame関数の追加
;;      -- keisen-previous-jump-frame関数の追加
;;      -- keisen-next-jump-frame関数の追加
;;      -- keisen-kill-rectangle-to-register関数の追加
;;      -- keisen-delete-rectangle-to-register関数の追加
;;      -- keisen-save-rectangle-to-register関数の追加
;;      -- keisen-yank-rectangle-from-register関数の追加
;;      -- keisen-view-rectangle-register関数の追加
;;   1993.11.04 12:00 ver 1.95.01    M.Iwamoto
;;      -- keisen-mode関数のバグ修正
;;      -- keisen-key-mode関数の修正
;;      -- keisen-save-rectangle-to-register関数のバグ修正   
;;;
;; Unofficial History
;;   1994.11.04 14:00 ver ?.??.??   Sakai Kiyotaka <ksakai@mtl.t.u-tokyo.ac.jp>
;;	-- modified for Mule Ver.2.1
;;   1994.12.13 18:40 ver ?.??.??   Tatsuo Furukawa <tatsuo@kobe.hp.com>
;;	-- Mule 2.x にてカーソル移動がおかしいという不具合を修正
;;;
;;   1993.11.25 11:50 ver 1.95.02    M.Iwamoto		<非公開>
;;      -- km:new-keisen-string関数のバグ修正
;;   1994.02.16 17:27 ver 1.95.03    M.Ozawa		<非公開>
;;      -- km:beginning-of-line関数のバグ修正
;;      -- km:end-of-line関数のバグ修正
;;   1994.02.16 18:18 ver 1.95.04    M.Iwamoto
;;      -- km:eoblp関数のバグ修正
;;   1994.03.18 12:56 ver 1.96.00    M.Ozawa		<非公開>
;;      -- 同期スクロールモードの追加
;;          keisen-sync-mode
;;          keisen-sync-mode-exit
;;          keisen-sync-change-region
;;   1994.03.30 10:33 ver 1.96.01    M.Ozawa		<非公開>
;;      -- km:beginning-of-line関数のバグ修正
;;   1994.03.30 12:41 ver 1.97.00    M.Iwamoto		<非公開>
;;      -- keisen-clear-keisen関数の追加
;;      -- keisen-clear-frame関数の追加
;;      -- keisen-line-horizontally関数の追加
;;      -- keisen-line-vertically関数の追加
;;      -- keisen-arrow-down関数の追加
;;      -- keisen-arrow-up関数の追加
;;      -- keisen-arrow-right関数の追加
;;      -- keisen-arrow-left関数の追加
;;      -- keisen-insert-register関数の追加
;;      -- keisen-locked-forward-line-ext関数の追加
;;      -- keisen-change-locked-forward-after関数の追加
;;   1994.03.30 14:22 ver 1.97.01    M.Ozawa		<非公開>
;;      -- km:beginning-of-line関数のバグ修正
;;      -- km:top-of-frame関数のバグ修正
;;      -- km:bottom-of-frame関数のバグ修正
;;   1994.03.30 17:53 ver 1.97.02    M.Iwamoto
;;      -- km:beginning-of-line関数のバグ修正
;;   1994.04.04 11:40 ver 1.97.03    M.Ozawa
;;      -- keisen-arrow-left関数のバグ修正
;;      -- keisen-arrow-right関数のバグ修正
;;   1994.04.05 08:28 ver 1.97.04    M.Iwamoto		<非公開>
;;      -- provideの名称ミスを修正
;;   1994.04.18 15:00 ver 1.97.05    M.Iwamoto		<非公開>
;;      -- keisen-next-line関数の仕様変更
;;      -- 上記仕様変更に伴いkeisen-move-stop変数追加
;;   1994.04.19 17:21 ver 1.97.06    M.Iwamoto		<非公開>
;;	-- keisen-draw-right関数の仕様変更
;;	-- keisen-draw-left関数の仕様変更
;;	-- keisen-extend-right関数の仕様変更
;;	-- keisen-extend-left関数の仕様変更
;;   1994.04.22 16:20 ver 1.97.07    M.Ozawa		<非公開>
;;      -- km:beginning-of-line関数のバグ修正
;;	-- km:end-of-line関数のバグ修正
;;   1994.04.22 16:30 ver 1.97.08    M.Iwamoto		<非公開>
;;	-- keisen-beginning-of-line関数のバグ修正
;;	-- keisen-end-of-line関数のバグ修正
;;   1994.04.26 13:05 ver 1.97.09    M.Iwamoto		<非公開>
;;	-- keisen-forward-word-hscroll関数の追加
;;	-- keisen-backward-word-hscroll関数の追加
;;   1994.06.02 16:05 ver 1.97.10    M.Iwamoto		<非公開>
;;	-- keisen-clear-frame関数のバグ修正
;;	-- keisen-kill-line関数の追加
;;   1994.11.04 17:30 ver 2.00	     M.Iwamoto(Based by S.Kiyotaka)
;;							<非公開>
;;      [[ Mule-2.x対応版罫線モード γリリース ]]
;;   1994.11.09 22:42 ver 2.01       M.Iwamoto		<非公開>
;;      -- keisen-sync-mode関数のバグ修正
;;	-- km:sync-reverse-region関数のバグ修正
;;   1994.12.13 20:35 ver 2.02       M.Iwamoto(Based by T.Furukawa)
;;      -- keisen-half-locked-forward-line関数のバグ修正
;;
;;
;; Emacs-20 version:
;;   1998.05.08 16:05 Emacs20 version, ver 0.01   A.Anazawa   <非公開>
;;      -- km:*em20-p* 変数を導入し、Emacs20(Meadow)に対応
;;	-- delete-text-in-column の代替関数 km:delete-text-in-column を作成
;;
;; 再配布条件は，上記のとおり，GPL に従いますが，本バージョンは非常に
;; 不完全なものです．万が一再配布される際は，その点を十分にお伝えくだ
;; さるよう，お願いいたします．-- 穴澤 <anazawa@lares.dti.ne.jp>
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
;;   変数
;;
;;(defconst keisen-version "MULE版罫線モード ver 2.02 \"γリリース\""
(defconst keisen-version "Emacs20版罫線モード ver 2.02 \"γリリース\""
  "罫線モードバージョン番号")

(defvar keisen-mode-view-status-flag nil
  "罫線モード起動時にモード状態の表示フラグ
tなら表示、nilなら表示しない。")

(defvar keisen-text-mode-flag nil
  "罫線モード用のテキストモードフラグ(現状nil固定)")

(defvar keisen-auto-line-feed-flag nil
  "罫線枠内で文字列を自動改行するフラグ")

(defvar keisen-auto-enlarge-vertically-flag nil
  "罫線枠内で文字列が入りきらなかった場合、縦方向へ自動拡張するフラグ
keisen-auto-line-feed-flagがnilのときは無効")

(defvar keisen-auto-enlarge-horizontally-flag nil
  "罫線枠内で文字列が入りきらなかった場合、横方向へ自動拡張するフラグ
keisen-auto-line-feed-flagがtのときは無効")

(defvar keisen-move-mode nil ; Based by S.Kobayashi
  "カーソル移動モード
tなら罫線を飛び超えてカーソルを移動、nilなら無条件にカーソルを移動する")

(defvar keisen-move-stop nil ; 94.04.18 by M.I
  "カーソル移動ストップモード
tなら最終ラインでカーソルが停止、nilなら無条件にカーソルを移動する")

(defvar keisen-move-level 0
  "カーソル移動レベル
0なら画面の端へ、1なら各枠の端へ、2なら文字列の端へ移動する" )

(defvar keisen-status-display-interval-time 2
  "罫線モード状態表の表示時間")

(defvar keisen-mode-hook nil
  "罫線モードのフック")

(defvar keisen-mode-map nil
  "罫線モードのキーマップ")

(defvar keisen-extend-regexp-flag nil
  "extendコマンドの正規表現を決定するflag
nilのときすべての罫線、１のとき細い罫線、２のとき太い罫線")

(defvar keisen-vertical-move-count 0
  "垂直方向の移動量")

(defvar keisen-horizontal-move-count 1
  "水平方向の移動量")

(defconst keisen-draw-force nil
  "nilのとき細い罫線は太い罫線に含まれる
non-nilのとき太い罫線の上に細い罫線を引くと細い罫線が書かれる")

(defconst keisen-adjust-column-force t
  "nilのときは罫線コマンドを使ったときカラムチェックをしない
non-nilのとき強制的にポイントのカラム数が偶数にポイントを移動させる")

(defvar keisen-lock nil
  "non-nilのとき挿入、消去、削除ともに罫線を越えることはできない")

(defvar keisen-width 1
  "罫線の太さ 0のとき消去、1のとき細線、2のとき太線")

(defvar keisen-overwrite-mode nil
  "罫線モードの中でのオーバーライトモードかどうかのフラッグ
nilならインサートモード、non-nilならオーバーライトモード")

(defvar keisen-key-flag nil ; Based by T.Sakano
  "罫線の描画キーフラグ
nilならカーソルキー、non-nilならM-[pnbf]キーを描画に使用する。")

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
　　　└　─┘┴　┌│├┐┬┤┼\
　　└└──┴┴┌┌┝┝┬┬┼┼\
　└　└┘┸┘┸│├│├┤┼┤┼\
┗┗┗┗┸┸┸┸┝┝┝┝┼┼┼┼\
　─┘┴　─┘┴┐┬┥┼┐┬┥┼\
━━┷┷━━┷┷┯┯┿┿┯┯┿┿\
┛┸┛┸┛┸┛┸┸┥┥┼┥┼┥┼\
┻┻┻┻┻┻┻┻┿┿┿┿┿┿┿┿\
　┌│├┐┰┤┼　┌│├┐┰┤┼\
┏┏┝┝┰┰┼┼┏┏┝┝┰┰┼┼\
┃┠┃┠┨╂┨╂┃┠┃┠┨╂┨╂\
┣┣┣┣╂╂╂╂┣┣┣┣╂╂╂╂\
┓┰┥┼┓┰┥┼┓┰┥┼┓┰┥┼\
┳┳┿┿┳┳┿┿┳┳┿┿┳┳┿┿\
┫╂┫╂┫╂╂╂┫╂┫╂┫╂╂╂\
╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋"
  "罫線キャラクタの各方向の枝の有無を8ビットで表現する.
インデックスの上位4ビットは太い線の有無を示し、下位4ビットが細い線の有無を示す.
(下左上右)")

(defconst keisen-unit-length (length (char-to-string (sref keisen-table 0)))
  "罫線素片のバイト数")

(defconst keisen-regexp
  "[─│┌┐┘└├┬┤┴┼━┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂]"
  "罫線判別の正規表現")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   キーバインディング
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
  ;CTRL-Oマップ
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
  "[罫線モード機能]
 罫線を描くキーを変更する。
 keisen-key-flagがnilならば、カーソルキー
                    tならば、M-[pnbf]キーを描画に使用する。"
  (interactive)
  (setq keisen-key-flag (not keisen-key-flag))
  (if keisen-key-flag
      (progn
        ;カーソル移動
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
        ;罫線描画
        (define-key keisen-mode-map "\ef"  'keisen-draw-right)
        (define-key keisen-mode-map "\eb"  'keisen-draw-left)
        (define-key keisen-mode-map "\ep"  'keisen-draw-up)
        (define-key keisen-mode-map "\en"  'keisen-draw-down)
        (message  "描画にM-[pnbf]キーを使用します"))
    ;罫線描画
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
    ;カーソル移動
    (define-key keisen-mode-map "\ef"  'keisen-forward-char-hscroll)
    (define-key keisen-mode-map "\eb"  'keisen-backward-char-hscroll)
    (define-key keisen-mode-map "\ep"  'keisen-previous-line)
    (define-key keisen-mode-map "\en"  'keisen-next-line)
    (message "描画にカーソルキーを使用します")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   移動機能
;;
(defun keisen-locked-forward-line () ;-----------------------------------------
  "[罫線モード機能]
 罫線を飛び越えない範囲で改行する.
 まず下にいってから罫線にぶつかるまで左にいく.
 改行できたらt、できなかったらnilを返す."
  (interactive)
  (while (and (looking-at keisen-regexp) (not (bolp))) ;罫線上からの脱出
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
    (= (count-lines pos (point)) 2)))                  ;返す値(t,nil)

(defun keisen-half-locked-forward-line () ;------------------------------------
  "[罫線モード機能]
 縦方向の罫線を飛び越えない範囲で改行する.
 罫線でないところまで下にいき罫線にぶつかるまで左にいく."
  (interactive)
  (while (and (looking-at keisen-regexp) (not (bolp))) ;罫線上からの脱出右へ
    (backward-char))
  (let ((col (current-column))
        flag)
    (while (and (setq flag (= (forward-line 1) 0))     ;罫線上からの脱出下へ
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
  "[罫線モード機能]
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
  "[罫線モード関数]
 "
  (save-excursion
    (skip-chars-forward " ")
    (if (looking-at km:vertically-regexp) nil t)))

(defun keisen-change-locked-forward-after () ;-- Based by M.Ozawa -------------
  "[罫線モード機能]
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
;ポイントをカレントラインで空白でない一番最後のキャラクターに移動させる"
;  (interactive "P")
;  (if arg (forward-line (1- (prefix-numeric-value arg))))
;  (beginning-of-line)
;  (skip-chars-backward "　 \t" (km:eol)))

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
;;   移動機能 [picture.elより抜粋]
;;
(defun km:move-to-column-force (column &optional force) ;-- Based by K.Handa --
  "[罫線モード関数]
 ポイントをcolumnに移動させる.移動できないときはタブをスペースに置き換えたり
行末にスペースを挿入したりして移動させる.もしforceがnon-nilでcolumnが漢字コ
ードの２バイト目なら漢字を半角スペース２つに置き換える"
  (if (and (/= (move-to-column column t) column) force)
      (let ((w (char-width (char-before (point)))))
	(delete-char -1)
	(insert (make-string w ? ))
	(move-to-column column))))

(defun km:picture-move-down (arg &optional force) ;-- Based by K.Handa --------
  "[罫線モード関数]
 カーソルを下へ移動さる。もし、移動先がなければ空白を挿入して移動する.
 引数arg があたえられたならば、その指定ライン数分下へ移動する."
  (let ((col (current-column)))
    (km:picture-newline arg)
    (km:move-to-column-force col force)))

(defun km:picture-move-up (arg) ;----------------------------------------------
  "[罫線モード関数]
 カーソルを上へ移動さる。もし、移動先がなければ空白を挿入して移動する.
 引数arg があたえられたならば、その指定ライン数分上へ移動する."
  (km:picture-move-down (- arg)))

(defun km:picture-forward-column (arg &optional force) ;-- Based by K.Handa ---
  "[罫線モード関数]
 カーソルを右へ移動さる。もし、カレント位置が (eolp) ならば空白を挿入して移動
する.引数arg があたえられたならば、その指定カラム数分右へ移動する."
  (let ((prev-clm (current-column)))
    (km:move-to-column-force (+ prev-clm arg) force)
    (if (and (/= arg 0) (= prev-clm (current-column)))
        (km:move-to-column-force (+ prev-clm (1+ arg))))))

(defun km:picture-backward-column (arg) ;--------------------------------------
  "[罫線モード関数]
 カーソルを左へ移動さる。
 引数arg があたえられたならば、その指定カラム数分左へ移動する."
  (km:move-to-column-force (- (current-column) arg)))

(defun km:picture-newline (arg) ;----------------------------------------------
  "[罫線モード関数]
 改行する.引数arg があたえられたならば、その指定数分改行する."
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
;;   移動(タブ)機能 [picture.elより抜粋]
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
  "[罫線モード機能]
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
  "[罫線モード機能]
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
  "[罫線モード機能]
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
;;   移動機能追加 − 1992.10.01
;;
(defun keisen-next-line () ;-- Based by S.Kobayashi ---------------------------
  "[罫線モード機能]
 カーソルを下へ移動する.
 keisen-move-modeが  tの時、罫線を飛び超えて移動する.
                   nilの時、無条件に次の行へ移動する."
  (interactive)
  (if (and keisen-move-stop (km:eoblp)) ; 94.04.18 by M.I
      nil
    (if truncate-lines           ;
	(km:picture-move-down 1) ; 1993.10.15 by M.Iwamoto
      (km:next-window-line 1)))  ;
  (if keisen-move-mode
      (while (and (looking-at "[─━]") (not (bolp)))
        (if truncate-lines                  ;
            (km:picture-move-down 1)    ; 1993.10.15 by M.Iwamoto
          (km:next-window-line 1)))))       ;

(defun keisen-previous-line () ;-- Based by S.Kobayashi -----------------------
  "[罫線モード機能]
 カーソルを上へ移動する.
 keisen-move-modeが  tの時、罫線を飛び超えて移動する.
                   nilの時、無条件に前の行へ移動する."
  (interactive)
  (if truncate-lines                ;
      (km:picture-move-up 1)    ; 1993.10.15 by M.Iwamoto
    (km:previous-window-line 1))    ;
  (if keisen-move-mode
      (let ((end t))
        (while (and (looking-at "[─━]") (not (bolp)) end)
          (if truncate-lines                ;
              (km:picture-move-up 1)    ; 1993.10.15 by M.Iwamoto
            (km:previous-window-line 1))    ;
          (if (= (km:what-current-line) 1)
              (setq end nil))))))

(defun km:next-window-line (n) ;-----------------------------------------------
  "[罫線モード関数]
 カーソルを下に移動する.
 truncate-linesがnilの時、(window-width)以上の文字列があると次の行へつづけて
表示される.通常、カーソルを移動するとこの行は飛びこされてしまう.
 それを、ビジュアル的に次の行となる位置へカーソルを移動する."
  (let ((cur_col (- (current-column)
                    (save-excursion (vertical-motion 0) (current-column)))))
    (if (not (km:eoblp))
        (vertical-motion n)
      (vertical-motion 0)
      (km:picture-newline n))
    (km:move-to-column-force (+ (current-column) cur_col))))

(defun km:previous-window-line (n) ;-------------------------------------------
   "[罫線モード関数]
 カーソルを上に移動する.
 truncate-linesがnilの時、(window-width)以上の文字列があると次の行へつづけて
表示される.通常、カーソルを移動するとこの行は飛びこされてしまう.
 それを、ビジュアル的に次の行となる位置へカーソルを移動する."
   (let ((cur_col (- (current-column)
                     (save-excursion (vertical-motion 0) (current-column)))))
     (vertical-motion (- n))
     (km:move-to-column-force (+ (current-column) cur_col))))

(defun keisen-beginning-of-line () ;-- Based by S.Kobayashi -------------------
  "[罫線モード機能]
 カレント行のそれぞれの先頭へカーソルを移動する.
 keisen-move-levelが0の時は、カレント行の先頭へ移動する.
                    1の時は、カレントポイントに近い罫線へ移動する.ただし、既に
                             カレントポイントのすぐ左隣に罫線があった場合はそ
                             れを飛び越える.
                    2の時は、文字列の先頭へ移動する.該当する文字列が無い場合は
                             keisen-move-levelが1の時と同様.
 カレントポイントが既に行の先頭の場合は、なにもしない."
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
                   (while (and (looking-at "[ 　]") (not (bolp)))
                     (keisen-forward-char-hscroll 1))
                   (if (and (> sta-pos (point))
                            (looking-at "[^│├┃┣┠┝┤┫┨┥]"))
                       nil
                     (goto-char cur-pos))))))))

(defun keisen-end-of-line () ;-- Based by S.Kobayashi -------------------------
  "[罫線モード機能]
 カレント行のそれぞれの最後へカーソルを移動する.
 keisen-move-levelが0の時は、カレント行の最後へ移動する.
                    1の時は、カレントポイントに近い罫線へ移動する.ただし、既に
                             カレントポイントのすぐ右隣に罫線があった場合はそ
                             れを飛び越える.
                    2の時は、文字列の最後へ移動する.該当する文字列が無い場合は
                             keisen-move-levelが1の時と同様.
 カレントポイントが既に行の最後の場合は、なにもしない."
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
                   (while (and (looking-at "[ 　]") (not (eolp)))
                     (keisen-backward-char-hscroll 1))
                   (if (and (< sta-pos (point))
                            (looking-at "[^│├┃┣┠┝┤┫┨┥]"))
                       nil
                     (goto-char cur-pos))))))))

(defun km:beginning-of-line () ;-- Changed by M.Ozawa -------------------------
  "[罫線モード関数]
 カレント枠内の先頭へカーソルを移動する."
  (let* (pos (point))
    (if (bolp)
	nil
      (if (looking-at "[│┤┃┫┨┥├┣┠┝]")
	  (keisen-backward-char-hscroll 1))
      (while (and (or (looking-at "[^│┤┃┫┨┥├┣┠┝]") (eobp))
		  (not (bolp)))
	(keisen-backward-char-hscroll 1))
      (if (looking-at "[│┤┃┫┨┥├┣┠┝]")
	  (keisen-forward-char-hscroll 1))
      (if (eq pos (point))
	  (keisen-backward-char-hscroll 1))
      )))

(defun km:end-of-line () ;-- Chenged by M.Ozawa -------------------------------
  "[罫線モード関数]
 カレント枠内の最後へカーソルを移動する."
  (if (looking-at "[│┤┃┫┨┥├┣┠┝]")
      (keisen-forward-char-hscroll 1))
  (while (and (looking-at "[^│┤┃┫┨├┃┣┠┝]") (not (eolp)))
    (keisen-forward-char-hscroll 1))
  (if (not (eolp))
      (keisen-backward-char-hscroll 1)))

(defun keisen-forward-char-hscroll (arg) ;-------------------------------------
  "[罫線モード機能]
 罫線モードでカーソルを右へ移動した時にウィンドウをオーバーしたら、右へ自動的
に水平スクロールする.
 ただし、truncate-linesがtの時のみである."
  (interactive "p")
  (if (eq truncate-lines nil)
      (km:picture-forward-column arg nil)
    (progn
      (if (>= (- (+ (current-column) arg) (window-hscroll))
              (- (window-width) 4)) ; patch 92.09.25 "2 -> 4"
          (scroll-left (+ arg 10))) ; patch 92.09.25 "arg -> (+ arg 10)"
      (km:picture-forward-column arg nil)
      ;↓↓↓↓↓
      (km:sync-hscroll))))

(defun keisen-backward-char-hscroll (arg) ;------------------------------------
  "[罫線モード機能]
 罫線モードでカーソルを左へ移動した時にウィンドウをオーバーしたら、左へ自動的
に水平スクロールする.
 ただし、truncate-linesがtの時のみである."
  (interactive "p")
  (if (eq truncate-lines nil)
      (backward-char arg)
    (progn
      (if (< (- (- (current-column) arg) (window-hscroll)) 0)
          (scroll-right (+ arg 10))) ; patch 92.09.25 "arg -> (+ arg 10)"
      (backward-char arg)
      ;↓↓↓↓↓
      (km:sync-hscroll))))

(defun km:end-of-line-hscroll () ;---------------------------------------------
  "[罫線モード関数]
 罫線モードでカレント行の終りがウィンドウ外であれば、右へ自動的に水平スクロール
する。ただし、truncate-linesがtの時のみである。"
  (if (eq truncate-lines nil)
      (end-of-line)
    (end-of-line)
    (if (> (current-column) (+ (window-width) (window-hscroll)))
        (scroll-left (+ 2 (- (current-column) (window-width))))))
  ;↓↓↓↓↓
  (km:sync-hscroll))

(defun km:beginning-of-line-hscroll () ;---------------------------------------
  "[罫線モード関数]
 罫線モードでカレント行の先頭がウィンドウ外であれば、左へ自動的に水平スクロール
する。ただし、truncate-linesがtの時のみである。"
  (if (window-hscroll)
      (scroll-right 5000))
  (beginning-of-line)
  ;↓↓↓↓↓
  (km:sync-hscroll))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   移動機能追加 Part2 [picture.elより抜粋] − 1993.09.14
;;
(defconst km:vertical-step   0 "縦方向へのカーソル移動ステップ数")
(defconst km:horizontal-step 1 "横方向へのカーソル移動ステップ数")

(defun keisen-movement-right () ;----------------------------------------------
  "[罫線モード機能]
 右方向への文字入力を指定"
  (interactive)
  (km:set-motion 0 1))

(defun keisen-movement-left () ;-----------------------------------------------
  "[罫線モード機能]
 左方向への文字入力を指定"
  (interactive)
  (km:set-motion 0 -1))

(defun keisen-movement-up () ;-------------------------------------------------
  "[罫線モード機能]
 上方向への文字入力を指定"
  (interactive)
  (km:set-motion -1 0))

(defun keisen-movement-down () ;-----------------------------------------------
  "[罫線モード機能]
 下方向への文字入力を指定"
  (interactive)
  (km:set-motion 1 0))

(defun keisen-movement-nw () ;-------------------------------------------------
  "[罫線モード機能]
 左上方向への文字入力を指定"
  (interactive)
  (km:set-motion -1 -1))

(defun keisen-movement-ne () ;-------------------------------------------------
  "[罫線モード機能]
 右上方向への文字入力を指定"
  (interactive)
  (km:set-motion -1 1))

(defun keisen-movement-sw () ;-------------------------------------------------
  "[罫線モード機能]
 左下方向への文字入力を指定"
  (interactive)
  (km:set-motion 1 -1))

(defun keisen-movement-se () ;-------------------------------------------------
  "[罫線モード機能]
 右下方向への文字入力を指定"
  (interactive)
  (km:set-motion 1 1))

(defun keisen-movement-wnw () ;------------------------------------------------
  "[罫線モード機能]
 左上(左へは2カラム)方向への文字入力を指定"
  (interactive)
  (km:set-motion -1 -2))

(defun keisen-movement-ene () ;------------------------------------------------
  "[罫線モード機能]
 右上(右へは2カラム)方向への文字入力を指定"
  (interactive)
  (km:set-motion -1 2))

(defun keisen-movement-wsw () ;------------------------------------------------
  "[罫線モード機能]
 左下(左へは2カラム)方向への文字入力を指定"
  (interactive)
  (km:set-motion 1 -2))

(defun keisen-movement-ese () ;------------------------------------------------
  "[罫線モード機能]
 右下(右へは2カラム)方向への文字入力を指定"
  (interactive)
  (km:set-motion 1 2))

(defun km:set-motion (vert horiz) ;--------------------------------------------
  "[罫線モード関数]
 各ステップ数の設定を行なう(オーバライトモード時のみ有効)"
  (if (not keisen-overwrite-mode) ; オーバライトモード？
      (ding)
    (setq km:vertical-step   vert
          km:horizontal-step horiz)
    (km:update-mode-line)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   移動機能追加 Part3 − 1993.10.18
;;
(defconst km:vertically-regexp
  "[│┌┐┘└├┬┤┴┼┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂]")
(defconst km:horizontally-regexp
  "[─┌┐┘└├┬┤┴┼━┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂]")

(defun keisen-forward-jump-frame () ;-- Changed by M.Ozawa --------------------
  "[罫線モード機能]
"
   (interactive)
   (if (eolp) ;最終カラムか？
       nil
     (if (looking-at km:vertically-regexp)
         (keisen-forward-char-hscroll 1)
       (while (if (and (not (looking-at km:vertically-regexp)) (not (eolp)))
                  (progn (keisen-forward-char-hscroll 1) t)
                (if (not (eolp)) (keisen-forward-char-hscroll 1)) nil))))
   (if (or (km:boblp) (eolp)) ;先頭ラインまたは最終カラムか？
       nil
     (if (looking-at km:horizontally-regexp)
         (km:picture-move-up 1))
     (while (if (and (not (looking-at km:horizontally-regexp))
                     (not (km:boblp)))
                (progn (km:picture-move-up 1) t)
              (km:picture-move-down 1) nil))))

(defun keisen-backward-jump-frame () ;-- Changed by M.Ozawa -------------------
  "[罫線モード機能]
"
  (interactive)
  (if (bolp) ;先頭カラムか？
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
  (if (or (km:boblp) (bolp)) ;先頭ラインまたは先頭カラムか？
      nil
    (if (looking-at km:horizontally-regexp)
        (km:picture-move-up 1)
      (while (if (and (not (looking-at km:horizontally-regexp))
                      (not (km:boblp)))
                 (progn (km:picture-move-up 1) t)
               (km:picture-move-down 1) nil)))))

(defun keisen-previous-jump-frame () ;-----------------------------------------
  "[罫線モード機能]
"
  (interactive)
  (if (km:boblp) ;先頭ラインか？
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
  (if (bolp) ;先頭カラムか？
      nil
    (while (if (and (not (looking-at km:vertically-regexp)) (not (bolp)))
               (progn (keisen-backward-char-hscroll 1) t)
             (keisen-forward-char-hscroll 1) nil))))

(defun keisen-next-jump-frame () ;---------------------------------------------
  "[罫線モード機能]
"
  (interactive)
  (if (km:eoblp) ;最終ラインか？
      nil
    (if (looking-at km:horizontally-regexp)
        (km:picture-move-up 1)
      (while (if (and (not (looking-at km:horizontally-regexp))
                      (not (km:eoblp)))
                 (progn (km:picture-move-down 1) t)
               (km:picture-move-down 1) nil))))
  (if (bolp) ;先頭カラムか？
      nil
    (while (if (and (not (looking-at km:vertically-regexp)) (not (bolp)))
               (progn (keisen-backward-char-hscroll 1) t)
             (keisen-forward-char-hscroll 1) nil))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   同期スクロール機能追加 − 1994.02.23 Based by M.Ozawa
;;
(make-variable-buffer-local 'km:sync-buffer)
(make-variable-buffer-local 'km:sync-height)

(defun km:sync-set-region () ;-------------------------------------------------
  "[罫線モード関数]
 シンクロブッファに表示する範囲の設定する"
  (let ((loop     t)
        (b_line nil)
        (e_line nil)
        (chr    nil)
        (flag   nil)
	begin end)
    (point-to-register 'pos)
    (vertical-motion 0)
    (message "表示範囲を設定して下さい")
    (sit-for 1)
    (while loop
      (if b_line
	  (message "[C-p:上 C-n:下 RET:先頭設定 C-c:訂正 C-g:取消]")
	(message "[C-p:上 C-n:下 RET:決定 C-c:訂正 C-g:取消]"))
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
                   (progn (message "指定範囲が大き過ぎます")
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
  "[罫線モード関数]
 指定された行の先頭のポイントを返す"
  (save-excursion
    (goto-line line)
    (beginning-of-line)
    (point)))

(defun km:sync-point-eol (line) ;----------------------------------------------
  "[罫線モード関数]
 指定された行の最終のポイントを返す"
  (save-excursion
    (goto-line line)
    (end-of-line)
    (point)))

(defun km:sync-reverse-region (b_line e_line) ;--------------------------------
  "[罫線モード関数]
 指定範囲をまでを反転させる"
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
  "[罫線モード関数]
 表示が反転しているのをもとに戻す"
  (let ((old-buffer-read-only buffer-read-only))
    (if old-buffer-read-only
        (toggle-read-only))
    (km:inverse-off-region (point-min) (point-max))
    (if old-buffer-read-only
        (toggle-read-only))))

(defun km:pop-up-sync-window () ;----------------------------------------------
  "[罫線モード関数]
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
  "[罫線モード機能]
 シンクロモードにする"
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
  "[罫線モード機能]
 シンクロモードを抜ける"
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
  "[罫線モード機能]
 表示範囲の変更"
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
  "[罫線モード関数]
 スクロールカラム数を合わせる"
  (if km:sync-buffer
      (let ((km:root-window (get-buffer-window (current-buffer)))
            (km:sync-window (get-buffer-window km:sync-buffer)))
        (if (and km:sync-window (eq km:root-window (selected-window)))
	    (set-window-hscroll km:sync-window
				(window-hscroll km:root-window))))))

(defun keisen-sync-other-window (arg) ;----------------------------------------
  "[罫線モード機能]
 "
  (interactive "p")
  (while (> arg 0)
    (select-window (next-window))
    (setq arg (1- arg)))
  (if (eq (current-buffer) km:sync-buffer)
      (select-window (next-window))))

(defun km:count-window () ;----------------------------------------------------
  "[罫線モード関数]
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
  "[罫線モード機能]
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
  "[罫線モード機能]
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
;;   文字列編集機能
;;
(defun keisen-center-line () ;-------------------------------------------------
  "[罫線モード機能]
 カレントポイントの前後の罫線と罫線の間にある文字列をその中央へ移動する"
  (interactive)
  (km:control-line 'km:control-center-line))

(defun keisen-right-line () ;--------------------------------------------------
  "[罫線モード機能]
 カレントポイントの前後の罫線と罫線の間にある文字列をその右側の罫線へ詰る"
  (interactive)
  (km:control-line 'km:control-right-line))

(defun keisen-left-line () ;---------------------------------------------------
  "[罫線モード機能]
 カレントポイントの前後の罫線と罫線の間にある文字列をその左側の罫線へ詰る"
  (interactive)
  (km:control-line 'km:control-left-line))

(defun km:control-line (function) ;--------------------------------------------
  "[罫線モード関数]
 枠内の文字列編集を制御する"
  (save-excursion
    (let (begin end fil len)
      (km:end-of-line)
      (forward-char 1)
      (setq end (point))
      (km:beginning-of-line)
      (setq begin (point))
      (setq fil (km:buffer-column begin end)) ; 枠のカラム数を求める
      (km:delete-horizontal-space-and-ZenkakuSpace)
      (km:end-of-line)
      (forward-char 1)
      (km:delete-horizontal-space-and-ZenkakuSpace)
      (setq len (km:buffer-column begin (point))) ; 文字列のカラム数を求める
      (funcall function begin fil len))))

(defun km:control-center-line (begin fil len) ;--------------------------------
  "[罫線モード関数]
"
  (let (lp1 lp2)
    (setq lp1 (/ (- fil len) 2)
          lp2 (- fil (+ lp1 len)))
    (insert (make-string lp2 (string-to-char " ")))
    (goto-char begin)
    (insert (make-string lp1 (string-to-char " ")))))

(defun km:control-right-line (begin fil len) ;---------------------------------
  "[罫線モード関数]
"
  (goto-char begin)
  (insert (make-string (- fil len) (string-to-char " "))))

(defun km:control-left-line (begin fil len) ;----------------------------------
  "[罫線モード関数]
"
  (insert (make-string (- fil len) (string-to-char " "))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   罫線描画機能
;;
(defun km:opposite-direction (dir) ;-------------------------------------------
  "[罫線モード関数]
 反対の方向を返す"
  (cond ((= dir keisen-right) keisen-left)
        ((= dir keisen-left)  keisen-right)
        ((= dir keisen-up)    keisen-down)
        ((= dir keisen-down)  keisen-up)
        (t 0)))

(defun km:direction (command) ;------------------------------------------------
  "[罫線モード関数]
 罫線の方向を返す"
  (cond ((eq command 'keisen-draw-right) keisen-right)
        ((eq command 'keisen-draw-left)  keisen-left)
        ((eq command 'keisen-draw-up)    keisen-up)
        ((eq command 'keisen-draw-down)  keisen-down)
        (t 0)))

(defun km:new-keisen-string () ;-----------------------------------------------
  "[罫線モード関数]
 書き込むための新しい罫線素片を作る"
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
        ;;細い罫線は細い罫線、太い罫線は太い罫線
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
      ;;太い罫線の上に細い罫線を引いても太い罫線
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
  "[罫線モード関数]
 罫線を描く"
  (setq keisen-vertical-move-count   v)
  (setq keisen-horizontal-move-count h)
  (km:insert-keisen (km:new-keisen-string)))

(defun km:insert-keisen (str) ;------------------------------------------------
  "[罫線モード関数]
 罫線をポイントにオーバーライトしてカーソルを移動する"
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
  "[罫線モード機能]
 罫線を引きながら右方向に移動する"
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
  "[罫線モード機能]
 罫線を引きながら左方向に移動する"
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
  "[罫線モード機能]
 罫線を引きながら上方向に移動する"
  (interactive "*p")
  (km:adjust-current-column t)
  (while (< 0 arg)
    (km:write-keisen -1 0)
    (setq last-command this-command)
    (setq arg (1- arg))))

(defun keisen-draw-down (arg) ;------------------------------------------------
  "[罫線モード機能]
 罫線を引きながら下方向に移動する"
  (interactive "*p")
  (km:adjust-current-column t)
  (while (< 0 arg)
    (km:write-keisen 1 0)
    (setq last-command this-command)
    (setq arg (1- arg))))

(defun keisen-square-line () ;-------------------------------------------------
  "[罫線モード機能]
 罫線で四角を描く.ポイントとマークが一直線上にあるときは直線を引く"
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
    (cond ((= begin end))             ;なし
          ((= beginx endx)            ;縦線
           (let ((len (- endy beginy)))
             (goto-char begin)
             (while (< 0 len)
               (setq this-command 'keisen-draw-down)
               (km:write-keisen 1 0)
               (setq last-command 'keisen-draw-down)
               (setq len (1- len)))
             (setq this-command 'keisen-draw-up)
             (km:write-keisen -1 0)))
          ((= beginy endy)            ;横線
           (let ((len (/ (- endx beginx) 2)))
             (goto-char begin)
             (setq this-command 'keisen-draw-right)
             (while (< 0 len)
               (km:write-keisen 0 1)
               (setq last-command 'keisen-draw-right)
               (setq len (1- len)))
               (setq this-command 'keisen-draw-left)
               (km:write-keisen 0 -1)))
          (t                          ;四角
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

;;おまけコーナー(?)     by M.Iwamoto
;;  この関数は、keisen-square-line関数を元に私が遊び半分に作ってみたものです.
;;  個人的に、結構気にいってる関数なので使ってやってください.
(defun keisen-square-line2 () ;------------------------------------------------
  "[罫線モード機能]
 始点と終点を任意に選択し罫線による四角を描画する."
  (interactive)
  (let ((sta_col (* (/ (current-column) 2) 2))  ;始点桁数
        (sta_lin (km:what-current-line))        ;始点行数
        (sta_chr nil)                           ;始点文字
        (end_col 0)                             ;終点桁数
        (end_lin 0)                             ;終点行数
        (end_chr nil)                           ;終点文字
        (hor_chr nil)                           ;始点横と終点縦の交差部文字
        (ver_chr nil)                           ;始点縦と終点横の交差部文字
        (loop    t)                             ;ループフラグ
        (old-keisen-width keisen-width)
	ch)
    ;各変数の初期化
    (setq sta_chr (km:get-two-column-string sta_col sta_lin))
    (setq hor_chr sta_chr ver_chr sta_chr end_chr sta_chr
          end_col sta_col end_lin sta_lin)
    ;起点マーク書き込み
    (km:change-string sta_col sta_lin "・")
    ;メイン処理
    (while loop
      (message "keisen-square-line2[C-p:上 C-n:下 C-f:右 C-b:左 w:罫線切替 RET:決定 ESC:取消]")
      (setq ch (km:read-char))
      ;終点を上に1行移動する[Ctrl-p]
      (cond ((= ch ?\C-p)
             ;終点がこれ以上上に移動できない
             (cond ((= end_lin 1)
                    (message "Can't move")
                    (sit-for 1))
                   ;始点と終点が一致した
                   ((and (= sta_lin (1- end_lin))(= sta_col end_col))
                    (km:change-string end_col end_lin end_chr)
                    (km:change-string sta_col sta_lin "・")
                    (setq hor_chr sta_chr ver_chr sta_chr end_chr sta_chr
                          end_col sta_col end_lin sta_lin))
                   ;始点ラインと終点ラインが一致した
                   ((= sta_lin (1- end_lin))
                    (km:change-string sta_col end_lin ver_chr)
                    (km:change-string sta_col sta_lin
                                      (if (< sta_col end_col) "┣" "┫"))
                    (km:change-string end_col end_lin end_chr)
                    (setq end_lin sta_lin end_chr hor_chr ver_chr sta_chr)
                    (km:change-string end_col end_lin
                                      (if (< sta_col end_col) "┫" "┣")))
                   ;始点カラムと終点カラムが一致した
                   ((= sta_col end_col)
                    (if (/= sta_lin end_lin)
                        (km:change-string end_col end_lin end_chr))
                    (setq end_lin (1- end_lin)
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        "┻" "┳")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin) "┳" "┻"))
                    (setq hor_chr end_chr))
                   ;始点と終点が対角線上にあった
                   (t
                    (if (= sta_lin end_lin)
                        nil
                      (km:change-string sta_col end_lin ver_chr)
                      (km:change-string end_col end_lin end_chr))
                    (setq end_lin (1- end_lin)
                          ver_chr (km:change-string sta_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "┗" "┛")
                                                      (if (< sta_col end_col)
                                                          "┏" "┓")))
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "┛" "┗")
                                                      (if (< sta_col end_col)
                                                          "┓" "┏"))))
                    (km:change-string end_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "┓" "┏")
                                        (if (< sta_col end_col) "┛" "┗")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "┏" "┓")
                                        (if (< sta_col end_col) "┗" "┛")))))
             (km:cursol-move end_col end_lin t))
            ;終点を下に1行移動する[Ctrl-n]
            ((= ch ?\C-n)
             (cond ((and (= sta_lin (1+ end_lin))(= sta_col end_col))
                    (km:change-string end_col end_lin end_chr)
                    (km:change-string sta_col sta_lin "・")
                    (setq hor_chr sta_chr ver_chr sta_chr end_chr sta_chr
                          end_col sta_col end_lin sta_lin))
                   ((= sta_lin (1+ end_lin))
                    (km:change-string sta_col end_lin ver_chr)
                    (km:change-string sta_col sta_lin
                                      (if (< sta_col end_col) "┣" "┫"))
                    (km:change-string end_col end_lin end_chr)
                    (setq end_lin sta_lin end_chr hor_chr ver_chr sta_chr)
                    (km:change-string end_col end_lin
                                      (if (< sta_col end_col) "┫" "┣")))
                   ((= sta_col end_col)
                    (if (/= sta_lin end_lin)
                        (km:change-string end_col end_lin end_chr))
                    (setq end_lin (1+ end_lin)
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        "┻" "┳")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin) "┳" "┻"))
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
                                                            "┛" "┗")
                                                      (if (< sta_col end_col)
                                                          "┓" "┏")))
                          ver_chr (km:change-string sta_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "┗" "┛")
                                                      (if (< sta_col end_col)
                                                          "┏" "┓"))))
                    (km:change-string end_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "┓" "┏")
                                        (if (< sta_col end_col) "┛" "┗")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "┏" "┓")
                                        (if (< sta_col end_col) "┗" "┛")))))
             (km:cursol-move end_col end_lin t))
            ;終点を右に2桁移動する[Ctrl-f]
            ((= ch ?\C-f)
             (cond ((and (= sta_lin end_lin)(= sta_col (+ end_col 2)))
                    (km:change-string end_col end_lin end_chr)
                    (km:change-string sta_col sta_lin "・")
                    (setq hor_chr sta_chr ver_chr sta_chr end_chr sta_chr
                          end_col sta_col end_lin sta_lin))
                   ((= sta_lin end_lin)
                    (if (/= sta_col end_col)
                        (km:change-string end_col end_lin end_chr))
                    (setq end_col (+ end_col 2)
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_col end_col)
                                                        "┫" "┣")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_col end_col) "┣" "┫"))
                    (setq hor_chr end_chr))
                   ((= sta_col (+ end_col 2))
                    (km:change-string end_col sta_lin hor_chr)
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin) "┳" "┻"))
                    (km:change-string end_col end_lin end_chr)
                    (setq end_col sta_col end_chr ver_chr hor_chr sta_chr)
                    (km:change-string end_col end_lin
                                      (if (< sta_lin end_lin) "┻" "┳")))
                   (t
                    (if (= sta_col end_col)
                        nil
                      (km:change-string end_col sta_lin hor_chr)
                      (km:change-string end_col end_lin end_chr))
                    (setq end_col (+ end_col 2)
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "┛" "┗")
                                                      (if (< sta_col end_col)
                                                          "┓" "┏")))
                          hor_chr (km:change-string end_col sta_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "┓" "┏")
                                                      (if (< sta_col end_col)
                                                          "┛" "┗"))))
                    (km:change-string sta_col end_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "┗" "┛")
                                        (if (< sta_col end_col) "┏" "┓")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "┏" "┓")
                                        (if (< sta_col end_col) "┗" "┛")))))
             (km:cursol-move end_col end_lin t))
            ;終点を左に2桁移動する[Ctrl-b]
            ((= ch ?\C-b)
             (cond ((= end_col 0)
                    (message "Can't move!")
                    (sit-for 1))
                   ((and (= sta_lin end_lin)(= sta_col (- end_col 2)))
                    (km:change-string end_col end_lin end_chr)
                    (km:change-string sta_col sta_lin "・")
                    (setq hor_chr sta_chr ver_chr sta_chr end_chr sta_chr
                          end_col sta_col end_lin sta_lin))
                   ((= sta_lin end_lin)
                    (if (/= sta_col end_col)
                        (km:change-string end_col end_lin end_chr))
                    (setq end_col (- end_col 2)
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_col end_col)
                                                        "┫" "┣")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_col end_col) "┣" "┫"))
                    (setq hor_chr end_chr))
                   ((= sta_col (- end_col 2))
                    (km:change-string end_col sta_lin hor_chr)
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin) "┳" "┻"))
                    (km:change-string end_col end_lin end_chr)
                    (setq end_col sta_col end_chr ver_chr hor_chr sta_chr)
                    (km:change-string end_col end_lin
                                      (if (< sta_lin end_lin) "┻" "┳")))
                   (t
                    (if (= sta_col end_col)
                        nil
                      (km:change-string end_col sta_lin hor_chr)
                      (km:change-string end_col end_lin end_chr))
                    (setq end_col (- end_col 2)
                          hor_chr (km:change-string end_col sta_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "┓" "┏")
                                                      (if (< sta_col end_col)
                                                          "┛" "┗")))
                          end_chr (km:change-string end_col end_lin
                                                    (if (< sta_lin end_lin)
                                                        (if (< sta_col end_col)
                                                            "┛" "┗")
                                                      (if (< sta_col end_col)
                                                          "┓" "┏"))))
                    (km:change-string sta_col end_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "┗" "┛")
                                        (if (< sta_col end_col) "┏" "┓")))
                    (km:change-string sta_col sta_lin
                                      (if (< sta_lin end_lin)
                                          (if (< sta_col end_col) "┏" "┓")
                                        (if (< sta_col end_col) "┗" "┛")))))
             (km:cursol-move end_col end_lin t))
            ;罫線の種類を変更する[w]
            ((= ch ?w)
             (keisen-toggle-width))
            ;始点と終点を結んで対角線となる四角を書く[RET]
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
               ;罫線用マークの設定
               (setq keisen-mark-column sta_col
                     keisen-mark-line   sta_lin)
               (km:cursol-move end_col end_lin t)
               (keisen-square-line))
             ;罫線の種類を元に戻す
             (if (= old-keisen-width keisen-width)
                 nil
               (setq keisen-width (cond ((= old-keisen-width 0) 2)
                                        ((= old-keisen-width 1) 0)
                                        ((= old-keisen-width 2) 1)))
               (keisen-toggle-width))
             (setq loop nil))
            ;や〜めた！[ESC]
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
             ;罫線の種類を元に戻す
             (if (= old-keisen-width keisen-width)
                 nil
               (setq keisen-width (cond ((= old-keisen-width 0) 2)
                                        ((= old-keisen-width 1) 0)
                                        ((= old-keisen-width 2) 1)))
               (keisen-toggle-width))
             (setq loop nil))
            ;未定義キーが押下された
            (t
             (message "Undefine key!")
             (sit-for 1))))))

(defun km:get-two-column-string (col lin) ;------------------------------------
  "[罫線モード関数]
 指定された位置の2カラム分の文字列を取得する.例を以下に示す.

 column:0    5    10
        +----+----+----
        aaaあaaああa

  ex.1 (km:get-two-column-string 0 lin) --> \"aa\"
  ex.2 (km:get-two-column-string 2 lin) --> \"aあ\"
  ex.3 (km:get-two-column-string 4 lin) --> \"あa\"
  ex.4 (km:get-two-column-string 8 lin) --> \"ああ\"
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
  "[罫線モード関数]
 指定された位置の2カラム分の文字列を指定文字列に置換する"
  (let (str2 len1 len2)
    (save-excursion
      (setq str2 (km:get-two-column-string col lin) ;置換前の文字を取得
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
    str2)) ;変更前の文字列を返却

(defun km:cursol-move (col lin &optional asf) ;--------------------------------
  "[罫線モード関数]
"
  (km:picture-move-down (- lin (km:what-current-line)))
  (km:picture-forward-column (- col (current-column)))
  (if (and asf truncate-lines)
      (let ((cwc (- (current-column) (window-hscroll))))
        (if (>= (+ cwc 2) (window-width))
            (scroll-left (+ (- cwc (window-width)) 4))
          (if (< cwc 0)
              (scroll-left cwc))))))
;;えんど おぶ おまけコーナー

(defun km:extend-regexp (course) ;---------------------------------------------
  "[罫線モード関数]
 extendコマンドの正規表現
 keisen-extend-regexp-flagがnilのとき、すべての罫線
                             １のとき、細い罫線
                             ２のとき、太い罫線"
  (cond ((null keisen-extend-regexp-flag) ;すべての罫線
         (if (or (= course keisen-right) (= course keisen-left))
             "[│┌┐┘└├┬┤┴┼┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂]"
           "[─┌┐┘└├┬┤┴┼━┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂]"))
        ((= keisen-extend-regexp-flag 1) ;細い罫線
         (if (or (= course keisen-right) (= course keisen-left))
             "[│┌┐┘└├┬┤┴┼┠┯┨┷┿┝┰┥┸╂]"
           "[─┌┐┘└├┬┤┴┼┠┯┨┷┿┝┰┥┸╂]"))
        (t ;(= keisen-extend-regexp-flag 2) ;太い罫線
         (if (or (= course keisen-right) (= course keisen-left))
             "[┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂]"
           "[━┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂]"))))

(defun keisen-extend-right () ;------------------------------------------------
  "[罫線モード機能]
 次の罫線にぶつかるまで罫線を右に伸ばして引く"
  (interactive "*")
  (km:adjust-current-column)
                                        ; t を入れると違っていても消えてしまう
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
  "[罫線モード機能]
 次の罫線にぶつかるまで罫線を左に伸ばして引く"
  (interactive "*")
  (km:adjust-current-column)
                                        ; t を入れると違っていても消えてしまう
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
  "[罫線モード機能]
 次の罫線にぶつかるまで罫線を上に伸ばして引く"
  (interactive "*")
  (km:adjust-current-column)
                                        ; t を入れると違っていても消えてしまう
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
  "[罫線モード機能]
 次の罫線にぶつかるまで罫線を下に伸ばして引く"
  (interactive "*")
  (km:adjust-current-column)
                                        ; t を入れると違っていても消えてしまう
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
;;   罫線描画機能追加
;;
(defun keisen-arrow () ;-------------------------------------------------------
  "[罫線モード機能]
 罫線マークポイントからカレント位置まで矢印を引く"
  (interactive)
  (save-excursion
    (let ((begin (km:what-mark-point))
          (end   (point)))
      (if (/= begin end)
          (cond ((= (km:what-column begin) (km:what-column end)) ;縦線
                 (if (< begin end)
                     (km:down-arrow-line end begin) ;下へ
                   (km:up-arrow-line begin end))) ;上へ
                ((= (km:what-line begin) (km:what-line end)) ;横線
                 (if (< begin end)
                     (km:right-arrow-line begin end) ;右へ
                   (km:left-arrow-line end begin))) ;左へ
                (t nil)))))) ;斜線？

(defun keisen-line () ;--------------------------------------------------------
  "[罫線モード機能]
 罫線マークポイントからカレント位置まで罫線を引く"
  (interactive)
  (save-excursion
    (let ((begin (km:what-mark-point))
          (end   (point)))
      (if (/= begin end)
          (cond ((= (km:what-column begin) (km:what-column end)) ;縦線
                 (if (< begin end)
                     (km:vertically-line-region end begin) ;下へ
                   (km:vertically-line-region begin end))) ;上へ
                ((= (km:what-line begin) (km:what-line end)) ;横線
                 (if (< begin end)
                     (km:horizontally-line-region begin end) ;右へ
                   (km:horizontally-line-region end begin))) ;左へ
                (t nil)))))) ;斜線？

(defun km:horizontally-line-region (begin end) ;-------------------------------
  "[罫線モード関数]
 開始ポイントbeginから終点ポイントendまで罫線を横方向へ引く"
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
  "[罫線モード関数]
 開始ポイントbeginから終点ポイントendまで罫線を縦方向へ引く"
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
  "[罫線モード関数]
 開始ポイントbeginから終点ポイントendまで右矢印を引く"
  (let ((end_pos (km:what-point (km:adjusted-column end)))
        (end_col (km:adjusted-column end))
        (old-keisen-width keisen-width))
    (if (= begin end)
        nil
      (setq keisen-width 1)
      (km:horizontally-line-region begin end_pos)
      (setq keisen-width old-keisen-width))
    (km:move-to-column-force end_col nil)
    (keisen-overwrite-string "→")))

(defun km:left-arrow-line (begin end) ;----------------------------------------
  "[罫線モード関数]
 開始ポイントbeginから終点ポイントendまで左矢印を引く"
  (let ((sta_pos (km:what-point (+ (km:adjusted-column begin) 2)))
        (sta_col (km:adjusted-column begin))
        (old-keisen-width keisen-width))
    (if (= begin end)
        nil
      (setq keisen-width 1)
      (km:horizontally-line-region sta_pos end)
      (setq keisen-width old-keisen-width))
    (km:move-to-column-force sta_col nil)
    (keisen-overwrite-string "←")))

(defun km:up-arrow-line (begin end) ;------------------------------------------
  "[罫線モード関数]
 開始ポイントbeginから終点ポイントendまで上矢印を引く"
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
    (keisen-overwrite-string "↑")))

(defun km:down-arrow-line (begin end) ;----------------------------------------
  "[罫線モード関数]
 開始ポイントbeginから終点ポイントendまで下矢印を引く"
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
    (keisen-overwrite-string "↓")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   罫線描画機能追加 Part2
;;
(defun keisen-line-horizontally () ;-- Based by M.Ozawa -----------------------
  "[罫線モード機能]
 縦線間に罫線を引く"
  (interactive)
  (km:end-of-line)
  (if (and (not (looking-at km:horizontally-regexp)) (looking-at "[^→←]"))
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
  "[罫線モード機能]
 横線間に罫線を引く"
  (interactive)
  (km:top-of-frame)
  (if (and (not (looking-at km:vertically-regexp)) (looking-at "[^↑↓]"))
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
  "[罫線モード機能]
 横線間に下向き矢印を引く"
  (interactive)
  (km:top-of-frame)
  (if (and (not (looking-at km:vertically-regexp)) (looking-at "[^↑↓]"))
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
  "[罫線モード機能]
 横線間に上向き矢印を引く"
  (interactive)
  (km:bottom-of-frame)
  (if (and (not (looking-at km:vertically-regexp)) (looking-at "[^↑↓]"))
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
  "縦線間に左向き矢印を引く"
  (interactive)
  (km:end-of-line)
  (if (and (not (looking-at km:horizontally-regexp)) (looking-at "[^→←]"))
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
  "[罫線モード機能]
 縦線間に右向き矢印を引く"
  (interactive)
  (km:beginning-of-line)
  (if (and (not (looking-at km:horizontally-regexp)) (looking-at "[^→←]"))
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
;;   挿入機能
;;
(defun keisen-self-insert-internal (str) ;-------------------------------------
  "[罫線モード機能]
 self-insert-iso関数から渡された文字列をインサートする"
  (interactive)
  (if keisen-overwrite-mode
      (keisen-overwrite-string str)
    (keisen-insert-string str)))

(defvar keisen-old-after-change-functions nil)
(defun km:after-change-function (beg end len)
(if (memq this-command '(self-insert-command encoded-kbd-handle-8bit))   ;;; patch
      (funcall self-insert-after-hook beg end)))

(defun km:self-insert-after-overwrite-hook (begin end) ;-----------------------
  "[罫線モード関数]
 罫線モードのself-insert-after-hookオーバーライトモードで文字を挿入する"
  (let ((str (buffer-substring begin end)))
    (delete-region begin end)
    (keisen-overwrite-string str)))

(defun keisen-overwrite-string (str) ;-----------------------------------------
  "[罫線モード機能]
 オーバーライトで文字を挿入する"
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
	(if (/= km:vertical-step 0) ; ななめ方向
	    (km:picture-move nil)
	  (if (> km:horizontal-step 0) ; 右方向
	      (forward-char 1)
	    (km:move-to-column-force (- col wth)))) ; 左方向
	))))

(defun km:picture-move (&optional force) ;-- Based by K.Handa -----------------
  "[罫線モード関数]
 カーソルをそれぞれkm:horizontal-step/km:vertical-step分移動する"
  (let ((h_flg (and (< km:horizontal-step 0)
                    (bolp)))
        (v_flg (and (< km:vertical-step 0)
                    (= (km:what-current-line) 1))))
    (if h_flg nil
      (km:picture-move-down km:vertical-step force)
      (if v_flg nil
        (km:picture-forward-column km:horizontal-step force)))))

(defun km:self-insert-after-insert-hook (begin end) ;--------------------------
  "[罫線モード関数]
 罫線モードのself-insert-after-hookインサートモードで文字を挿入する"
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
  "[罫線モード関数]
 自動改行を行なう."
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
  "[罫線モード機能]
 インサートで文字を挿入する"
  (interactive "*sInsert string: ")
  (let ((begin (point)))
    (insert str)
    (km:self-insert-after-insert-hook begin (point))))

(defun keisen-insert-blank (arg) ;---------------------------------------------
  "[罫線モード機能]
 ポイントの後の空白を挿入する.罫線は動かない"
  (interactive "*p")
  (if (< 0 arg)
      (let ((pos (point)))
        (insert-char ? arg)
        (km:self-insert-after-insert-hook pos (point)))))

(defun keisen-enlarge-vertically (arg) ;---------------------------------------
  "[罫線モード機能]
 ポイントの位置で縦方向に罫線を伸ばす.
 カレントラインの一行上の行からのつながりを見てカレントラインの前に一行挿入す
る."
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
			  (cond ((looking-at "[│┌┐├┬┤┼┯┿┝┥]") "│")
				((looking-at "[┃┏┓┣┳┫╋┠┨┰╂]") "┃")
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
  "[罫線モード機能]
 ポイントの位置で横方向に罫線を伸ばす.
 カレントカラムの前へのつながりを見てカレントカラムの前に一桁挿入する."
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
            (cond ((looking-at "[─┐┘┬┤┴┼┨┸┰╂]") (insert "─"))
                  ((looking-at "[━┓┛┳┫┻╋┯┷┿┥]") (insert "━"))
                  (t
                   (indent-to (+ 2 (current-column))))
                  ;;(indent-to (+ (* 2 arg) (current-column)))
                  ;;(insert-char ? (* arg 2));半角、全角のどちらでもよい(全角)
                  )
            (setq len (1- len))))
      (forward-line 1)
      (setq len arg)
      (setq count (1- count)))
    (goto-line oldline)
    (move-to-column col)))

(defun km:check-vertically (old) ;---------------------------------------------
  "[罫線モード関数]
 縦方向の罫線の範囲を調べ、ポイントを罫線の始まりのラインの最初に罫線の範囲を
値として返す."
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
  "[罫線モード機能]
 ポイントの位置で行を分割して新しい行を挿入する.罫線は分割できない."
  (interactive "*")
  (if (or
       ;;バッファの最初
       (bobp)
       ;;ラインの最初で前の行に罫線がないとき
       (and (bolp)
            (not (save-excursion
                   (forward-line -1)
                   (re-search-forward keisen-regexp (km:eol) t))))
       ;;カレントラインに罫線がないとき
       (not (save-excursion
              (beginning-of-line)
              (re-search-forward keisen-regexp (km:eol) t)))
       ;;ポイント以降つぎの行の最後まで罫線がないとき
       (not (save-excursion
              (re-search-forward keisen-regexp
                                 (save-excursion (forward-line 1)
                                                 (end-of-line)
                                                 (point))
                                 t))))
      (newline)
    (forward-line 1)))

(defun keisen-yank () ;--------------------------------------------------------
  "[罫線モード機能]
 保存しておいた文字列をポイントの前に挿入する.
 文字列は罫線を越えることはできない."
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
;;   削除（保存）機能
;;
(defun keisen-kill-line () ;-- Based by M.Ozawa -------------------------------
  "[罫線モード機能]
 "
  (interactive)
  (let ((begin (point)))
    (save-window-excursion
      (save-excursion
	(km:end-of-line-hscroll)
	(km:kill-extract-rectangle begin (point))))))

(defun keisen-clear-keisen (arg) ;-- Based by M.Ozawa -------------------------
  "[罫線モード機能]
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
  "[罫線モード機能]
 フレーム内の文字を削除する"
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
  "[罫線モード関数]
"
  (while (and (not (looking-at km:horizontally-regexp)) (not (km:boblp)))
    (keisen-previous-line))
  (if (looking-at km:horizontally-regexp)
      (keisen-next-line)))

(defun km:bottom-of-frame () ;-- Based by M.Ozawa -----------------------------
  "[罫線モード関数]
"
  (while (and (not (looking-at km:horizontally-regexp)) (not (km:eoblp)))
    (keisen-next-line))
  (if (not (km:boblp))
      (keisen-previous-line)))

(defun keisen-clear-line () ;--------------------------------------------------
  "[罫線モード機能]
 カレントラインのポイントから次の罫線または行端までを削除する
 罫線は動かない"
  (interactive "*")
  (let ((pos (point))
        (col))
    (cond ((looking-at keisen-regexp))                  ;罫線上
          ((re-search-forward keisen-regexp (km:eol) t) ;ポイント以後に罫線
           (goto-char (match-beginning 0))
           (setq col (current-column))
           ;;(skip-chars-backward " 　\t" pos)
           (kill-region pos (match-beginning 0))
           ;;(kill-region pos (+ (point) (get-code-type (point)) 1))
           ;;(re-search-forward keisen-regexp)
           ;;(goto-char (match-beginning 0))
           (indent-to col)
           (goto-char pos))
          ;↓カレントラインの先頭ポイントから現ポイントまで罫線も含めて削除
          ;  してしまうので、この処理は省く
          ;((re-search-backward keisen-regexp (km:bol) t);ポイント以前に罫線
          ; (kill-region pos (km:bol)))
          (t                                            ;
           (kill-line)))))

(defun keisen-clear-char () ;--------------------------------------------------
  "[罫線モード機能]
 ポイントの後ろのキャラクターを１文字消す.その後ろのキャラクターは左につめられ
る.罫線は動かない"
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
  "[罫線モード関数]
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
  "[罫線モード機能]
 ポイントの前のキャラクターを１文字消す.その後ろのキャラクターは左につめられる.
 しかし罫線は動かず消すこともできない"
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
  "[罫線モード機能]
 罫線を縦方向に縮める.カレントラインを一行削除して罫線を一行縮める"
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
  "[罫線モード機能]
 罫線を横方向に縮める.ポイントの後の一桁を削除して罫線を一行縮める"
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
 "[罫線モード機能]
 行末の無意味なタブやスペースを取り除く"
 (interactive "*")
 (save-excursion
   (goto-char (point-min))
   (while (re-search-forward "[　 \t]+$" nil t)
     (delete-region (match-beginning 0) (point))))
 (message "done"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   削除（保存）機能追加 [rect.el、register.elより抜粋]
;;
(defvar km:rectangle-save-buffer nil "矩形バッファ")
(defvar km:rectangle-save-register-alist nil "矩形バッファレジスタ")

(defun keisen-kill-rectangle () ;----------------------------------------------
  "[罫線モード機能]
  罫線マーク設定ポイント(km:what-mark-point)とカレントポイント(point)を結んで
対角線となる四角形の枠内を矩形バッファ(km:rectangle-save-buffer)に保存し、その
枠内の文字列は削除する。削除した部分は空白によって埋められる。
  枠内に罫線が存在した場合、空白として保存される。
  罫線は動いたり消えたりしない。"
  (interactive)
  (let ((start (km:what-mark-point))
        (end   (point)))
    (setq km:rectangle-save-buffer (km:kill-extract-rectangle start end))))

(defun keisen-kill-rectangle-to-register (char) ;------------------------------
  "[罫線モード機能]
  罫線マーク設定ポイント(km:what-mark-point)とカレントポイント(point)を結んで
対角線となる四角形の枠内を矩形バッファレジスタ(km:rectangle-save-register
-alist)に指定したレジスタ名で保存し、その枠内の文字列は削除する。削除した部分
は空白によって埋められる。
  枠内に罫線が存在した場合、空白として保存される。
  罫線は動いたり消えたりしない。"
  (interactive "cKeisen kill rectangle to register: \n")
  (let ((start (km:what-mark-point))
        (end   (point)))
    (km:set-register char (km:kill-extract-rectangle start end))))

(defun keisen-delete-rectangle () ;--------------------------------------------
  "[罫線モード機能]
  罫線マーク設定ポイント(km:what-mark-point)とカレントポイント(point)を結んで
対角線となる四角形の枠内を矩形バッファ(km:rectangle-save-buffer)に保存し、その
枠内の文字列は削除する。
  枠内に罫線が存在した場合、空白として保存される。
  罫線は動いたり消えたりしない。"
  (interactive)
  (let ((start (km:what-mark-point))
        (end   (point)))
    (setq km:rectangle-save-buffer (km:delete-extract-rectangle start end))))

(defun keisen-delete-rectangle-to-register (char) ;----------------------------
  "[罫線モード機能]
  罫線マーク設定ポイント(km:what-mark-point)とカレントポイント(point)を結んで
対角線となる四角形の枠内を矩形バッファレジスタ(km:rectangle-save-register
-alist)に指定したレジスタ名で保存し、その枠内の文字列は削除する。
  枠内に罫線が存在した場合、空白として保存される。
  罫線は動いたり消えたりしない。"
  (interactive "cKeisen delete rectangle to register: \n")
  (let ((start (km:what-mark-point))
        (end   (point)))
    (km:set-register char (km:delete-extract-rectangle start end))))

(defun keisen-save-rectangle () ;----------------------------------------------
  "[罫線モード機能]
  罫線マーク設定ポイント(km:what-mark-point)とカレントポイント(point)を結んで
対角線となる四角形の枠内を矩形バッファ(km:rectangle-save-buffer)に保存する。
  枠内の文字列は削除しない。
  枠内に罫線が存在した場合、空白とみなして保存される。"
  (interactive)
  (let ((start (km:what-mark-point))
        (end   (point)))
    (setq km:rectangle-save-buffer (km:save-extract-rectangle start end))))

(defun keisen-save-rectangle-to-register (char) ;------------------------------
  "[罫線モード機能]
  罫線マーク設定ポイント(km:what-mark-point)とカレントポイント(point)を結んで
対角線となる四角形の枠内を矩形バッファレジスタ(km:rectangle-save-buffer-alist)
に指定したレジスタ名で保存する。
  枠内の文字列は削除しない。
  枠内に罫線が存在した場合、空白とみなして保存される。"
  (interactive "cKeisen save rectangle to register: \n")
  (let ((start (km:what-mark-point))
        (end   (point)))
    (km:set-register char (km:save-extract-rectangle start end))))

(defun keisen-yank-rectangle () ;----------------------------------------------
  "[罫線モード機能]
  カレントポイント(point)を始点として、矩形バッファ(km:rectangle-save-buffer)
に保存されている文字列をカレントバッファに挿入する。
  罫線は動いたり消えたりしない。
  なお、各制御フラグに制限事項があるので注意すること。
    1. keisen-overwrite-modeは有効
    2. keisen-auto-line-feed-flagは無効
    3. keisen-auto-enlarge-vertically-flagは無効
    4. keisen-auto-enlarge-horizontally-flagは有効"
  (interactive)
  (km:insert-rectangle km:rectangle-save-buffer))

(defun keisen-yank-rectangle-from-register (char) ;----------------------------
  "[罫線モード機能]
  カレントポイント(point)を始点として、矩形バッファレジスタ(km:rectangle-save
-register-alist)の指定されたレジスタ名に保存されている文字列をカレントバッファ
に挿入する。
  罫線は動いたり消えたりしない。
  なお、各制御フラグに制限事項があるので注意すること。
    1. keisen-overwrite-modeは有効
    2. keisen-auto-line-feed-flagは無効
    3. keisen-auto-enlarge-vertically-flagは無効
    4. keisen-auto-enlarge-horizontally-flagは有効"
  (interactive "cKeisen yank rectangle from register: \n")
  (km:insert-rectangle (km:get-register char)))

(defun keisen-view-rectangle-register (char) ;---------------------------------
  "[罫線モード機能]
  矩形バッファレジスタ(km:rectangle-save-register-alist)の指定されたレジスタ名
に保存されている文字列を表示する。"
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
  "[罫線モード機能]
  罫線マーク設定ポイント(km:what-mark-point)とカレントポイント(point)を結んで
対角線となる四角形の枠内に空白を挿入する。
  枠の右側の文字列は空白が挿入された分、右へシフトされる。
  罫線は動いたり消えたりしない。"
  (interactive)
  (let ((start (km:what-mark-point))
        (end   (point))
        (old_flag keisen-auto-line-feed-flag))
    (setq keisen-auto-line-feed-flag nil)
    (km:operate-on-rectangle 'km:open-rectangle-line start end nil)
    (setq keisen-auto-line-feed-flag old_flag)))

(defun keisen-clear-rectangle () ;---------------------------------------------
  "[罫線モード機能]
  罫線マーク設定ポイント(km:what-mark-point)とカレントポイント(point)を結んで
対角線となる四角形の枠内を消去する。
  枠の右側の文字列は空白が消去された分、左へシフトされる。
  罫線は動いたり消えたりしない。"
  (interactive)
  (let ((start (km:what-mark-point))
        (end   (point)))
    (km:operate-on-rectangle 'km:clear-rectangle-line start end t)))

(defun km:operate-on-rectangle (function start end coerce-tabs) ;--------------
  "[罫線モード関数]
"
  (let (sta_col sta_pos end_col end_pos)
    (save-excursion
      (goto-char start)
      (setq sta_col (current-column))  ;開始カラム
      (beginning-of-line)
      (setq sta_pos (point)))          ;開始ラインの先頭ポイント
    (save-excursion
      (goto-char end)
      (setq end_col (current-column))  ;終了カラム
      (forward-line 1)
      (setq end_pos (point-marker)))   ;終了カラムの次カラムポイント
    ;カラムの大小チェック
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
  "[罫線モード関数]
"
  (let (lines)
    (km:operate-on-rectangle 'km:kill-extract-rectangle-line start end t)
    (nreverse lines)))

(defun km:kill-extract-rectangle-line (startdelpos begextra endextra) ;--------
  "[罫線モード関数]
"
  (save-excursion
    (km:extract-rectangle-line startdelpos begextra endextra 2)))

(defun km:delete-extract-rectangle (start end) ;-------------------------------
  "[罫線モード関数]
"
  (let (lines)
    (km:operate-on-rectangle 'km:delete-extract-rectangle-line start end t)
    (nreverse lines)))

(defun km:delete-extract-rectangle-line (startdelpos begextra endextra) ;------
  "[罫線モード関数]
"
  (save-excursion
    (km:extract-rectangle-line startdelpos begextra endextra 1)))

(defun km:save-extract-rectangle (start end) ;---------------------------------
  "[罫線モード関数]
"
  (let (lines)
    (km:operate-on-rectangle 'km:save-extract-rectangle-line start end t)
    (nreverse lines)))

(defun km:save-extract-rectangle-line (startdelpos begextra endextra) ;--------
  "[罫線モード関数]
"
  (save-excursion
   (km:extract-rectangle-line startdelpos begextra endextra 0)))

(defun km:extract-rectangle-line (startdelpos begextra endextra delete_type) ;-
  "[罫線モード関数]
"
  (let ((line "")
        (endcol (current-column))
	lines)
    (goto-char startdelpos)
    (while (> endcol (current-column))
      (let ((ch (char-to-string (following-char))))
        (if (string-match keisen-regexp ch) ;罫線？
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
  "[罫線モード関数]
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
  "[罫線モード関数]
  カレントラインの指定ポイント(startpos)からカレントポイント(point)まで空白を挿
入する。文字列は挿入した分、右へシフトされる。
  罫線は動かしたり消したりはしない。"
  (let ((num (km:buffer-column startpos (point))))
    (goto-char startpos)
    (keisen-insert-string (make-string num (string-to-char " ")))))

(defun km:clear-rectangle-line (startpos begextra endextra) ;------------------
  "[罫線モード関数]
  カレントラインの指定ポイント(startpos)からカレントポイント(point)まで削除し、
空白で埋める。
  罫線は動かしたり消したりはしない。"
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
  "[罫線モード関数]
"
  (let ((aftercol (current-column))
        (indent-tabs-mode nil))
    (delete-char -1)
    (indent-to aftercol)
    (backward-char (- aftercol column))))

(defun km:get-register (char) ;------------------------------------------------
  "[罫線モード関数]
  指定されたレジスタ名(char)の内容を矩形バッファレジスタ(km:rectangle-save
-register-alist)から取り出す。"
  (cdr (assq char km:rectangle-save-register-alist)))

(defun km:set-register (char value) ;------------------------------------------
  "[罫線モード関数]
  指定されたレジスタ名(char)で文字列(value)を矩形バッファレジスタ(km:rectangle
-save-register-alist)に登録する。"
  (let ((aelt (assq char km:rectangle-save-register-alist)))
    (if aelt
        (setcdr aelt value)
      (setq aelt (cons char value))
      (setq km:rectangle-save-register-alist
            (cons aelt km:rectangle-save-register-alist)))))

;;おまけコーナー第2弾
;;  keisen-square-line2関数で味をしめてしまった私は、とうとうこんな関数まで
;;  作ってしまった...
;;  はっきり言って、大変でした.でも、便利(かな?)だと思うので使ってね！
(defun keisen-rectangle () ;---------------------------------------------------
  "[罫線モード機能]
 始点と終点を任意に選択し枠内の文字列を保存、削除など制御する."
  (interactive)
  (let ((sta_pos (point))       ;始点ポイント
        (sta_col 0)             ;始点カラム
        (sta_lin 0)             ;始点ライン
        (end_col 0)             ;終点カラム
        (end_lin 0)             ;終点ライン
        (loop1   t)             ;ループフラグ その1
        (loop2   t)             ;ループフラグ その2
        (ch      nil))          ;入力キー
    ;各変数の初期化
    (setq sta_col (km:what-column sta_pos)
          sta_lin (km:what-line   sta_pos))
    (setq end_col sta_col end_lin sta_lin)
    ;カーソル点滅開始
    (km:cursol-flash-start)
    ;メイン処理
    (while loop1
      (message
       "keisen-rectangle[C-p:上 C-n:下 C-f:右 C-b:左 RET:決定 ESC:取消]")
      (setq ch (km:read-char))
      ;終点を上に1行移動する[Ctrl-p]
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
            ;終点を下に1行移動する[Ctrl-n]
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
            ;終点を右に移動する[Ctrl-f]
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
            ;終点を左に移動する[Ctrl-b]
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
            ;決定キー[RET]が押下された
            ((= ch ?\C-m)
             (while loop2
               (message
                "keisen-rectangle[k:削除&保存 d:削除(左詰)&保存 s:保存 o:オープン c:クリア]")
	       (setq ch (km:read-char))
               (cond ((= ch ?k)
                      (km:cursol-flash-stop)
                      ;罫線用マークの設定
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
                      ;罫線用マークの設定
                      (setq keisen-mark-column sta_col
                            keisen-mark-line   sta_lin)
                      (km:inverse-off-square sta_col sta_lin end_col end_lin)
                      (km:cursol-move end_col end_lin t)
                      (keisen-open-rectangle)
                      (setq loop2 nil))
                     ((= ch ?c)
                      (km:cursol-flash-stop)
                      ;罫線用マークの設定
                      (setq keisen-mark-column sta_col
                            keisen-mark-line   sta_lin)
                      (km:inverse-off-square sta_col sta_lin end_col end_lin)
                      (km:cursol-move end_col end_lin t)
                      (keisen-clear-rectangle)
                      (setq loop2 nil))
                     ;未定義キーが押下された
                     (t
                      (message "Undefine key!")
                      (sit-for 1))))
             (setq loop1 nil))
            ;取消キー[ESC]が押下された
            ((= ch ?\e)
             (km:cursol-flash-stop)
             (km:inverse-off-square sta_col sta_lin end_col end_lin)
             (km:cursol-move sta_col sta_lin t)
             (setq loop1 nil))
            ;未定義キーが押下された
            (t
             (message "Undefine key!")
             (sit-for 1))))))

(defun km:inverse-off-square (sta_col sta_lin end_col end_lin) ;---------------
  "[罫線モード関数]
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
  "[罫線モード関数]
 カレント行(横)の指定カラム間の文字列の属性を「反転」にする"
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
  "[罫線モード関数]
 カレント行(横)の指定カラム間の文字列の属性を「反転」から元に戻す"
  (save-excursion
    (let ((pos (point)))
      (km:cursol-move sta_col sta_lin)
      (if (> pos (point))
	  (km:inverse-off-region (point) pos)
	(km:inverse-off-region pos (progn (forward-char) (point)))))))

(defun km:inverse-on-vertical (sta_lin end_lin) ;------------------------------
  "[罫線モード関数]
 カレント桁(縦)の指定ライン間の文字列の属性を「反転」にする"
  (let ((col (current-column))
        (lin (min sta_lin end_lin))
        (stp (max sta_lin end_lin)))
    (while (not (> lin stp))
      (km:inverse-on-string col lin)
      (setq lin (+ lin 1)))))

(defun km:inverse-off-vertical (sta_lin end_lin) ;-----------------------------
  "[罫線モード関数]
 カレント桁(縦)の指定ライン間の文字列の属性を「反転」から元に戻す"
  (let ((col (current-column))
        (lin (min sta_lin end_lin))
        (stp (max sta_lin end_lin)))
    (while (not (> lin stp))
      (km:inverse-off-string col lin)
      (setq lin (+ lin 1)))))

(defun km:inverse-on-string (col lin) ;----------------------------------------
  "[罫線モード関数]
 指定位置の1文字だけ属性を「反転」にする"
  (save-excursion
    (km:cursol-move col lin)
    (km:inverse-on-region (point)
			  (progn
			    (if (eolp) (insert " ") (forward-char))
			    (point)))))

(defun km:inverse-off-string (col lin) ;---------------------------------------
  "[罫線モード関数]
 指定位置の1文字だけ属性を「反転」から元に戻す"
  (save-excursion
    (km:cursol-move col lin)
    (km:inverse-off-region (point) (progn (forward-char) (point)))))

(defvar km:cursol-flash-process nil "カーソル点滅プロセス")
(defvar km:cursol-flash-interval 1 "カーソル点滅間隔")
(defvar km:cursol-flash-flag nil "カーソル点滅フラグ")

(defun km:cursol-flash-start () ;----------------------------------------------
  "[罫線モード関数]
 カーソル点滅プロセスを起動する"
  (let ((live (and km:cursol-flash-process
		   (eq (process-status km:cursol-flash-process) 'run))))
    (if (not live)
	(progn
	  (if km:cursol-flash-process ;2重起動である
	      (delete-process km:cursol-flash-process))
	  (let ((process-connection-type nil))
	    (setq km:cursol-flash-process
		  (start-process "cursol-flash" nil
				 (concat exec-directory "wakeup")
				 (int-to-string km:cursol-flash-interval))))
	  (process-kill-without-query km:cursol-flash-process)
	  (set-process-filter   km:cursol-flash-process 'km:cursol-flash)))))

(defun km:cursol-flash-stop () ;-----------------------------------------------
  "[罫線モード関数]
 カーソル点滅プロセスを終了する"
  (if km:cursol-flash-process ;プロセス起動中?
      (progn ;Yes
	(delete-process km:cursol-flash-process) ;カーソル点滅プロセス削除
	(if (not km:cursol-flash-flag) ;カーソル消去中?
	    ;; カーソル点灯
	    (km:inverse-off-region (point) (progn (forward-char) (point))))
	(setq km:cursol-flash-flag    nil
	      km:cursol-flash-process nil))))

(defun km:cursol-flash (proc string) ;-----------------------------------------
  "[罫線モード関数]
"
  (let ((sta (point))
        (end (progn
	       (if (eolp) (insert " ") (forward-char))
	       (point))))
    (if km:cursol-flash-flag
	(km:inverse-on-region sta end) ;カーソル消去
      (km:inverse-off-region sta end)) ;カーソル点灯
    (setq km:cursol-flash-flag (not km:cursol-flash-flag))))
;えんど おぶ おまけコーナー

(defun keisen-insert-register (char &optional arg) ;-- Changed by M.Ozawa -----
  "[罫線モード機能]
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
;;  （おまけ）
;;      for laser printer in nasu lab.
;;
(defun zenkaku-space-current-buffer () ;---------------------------------------
  "[罫線モード機能]
 カレントバッファ内の連続した二つの半角スペースを一つの全角スペースに変換する"
  (interactive "*")
  (zenkaku-space-region (point-min) (point-max)))

(defun zenkaku-space-region (begin end) ;--------------------------------------
  "[罫線モード機能]
 リージョン内の連続した二つの半角スペースを一つの全角スペースに変換する"
  (interactive "*r")
  (save-excursion
    (goto-char begin)
    (while (re-search-forward "  \\|\t" end t)
      (if (= (preceding-char) ?\t)
          (progn (delete-backward-char 1)
                 (insert ? tab-width)
                 (backward-char (1+ tab-width)))
        (delete-backward-char 2)
        (insert "　")))))              ;全角スペース

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   マーク設定
;;
(defvar keisen-mark-column nil "罫線用マーク設定カラム位置")
(defvar keisen-mark-line nil "罫線用マーク設定ライン位置")

(defun keisen-set-mark () ;----------------------------------------------------
  "[罫線モード機能]
 罫線モード用のマーク設定コマンド"
  (interactive)
  (set-mark-command nil)
  (setq keisen-mark-column (current-column)         ; マークカラム設定
        keisen-mark-line   (km:what-current-line))) ; マークライン設定

(defun km:what-mark-point () ;-------------------------------------------------
  "[罫線モード関数]
 罫線モード用のマーク設定位置を求める"
  (save-excursion
    (goto-line keisen-mark-line)
    (km:move-to-column-force keisen-mark-column nil)
    (point)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   モード
;;
(defun keisen-toggle-line () ;-- Based by S.Kobayashi -------------------------
  "[罫線モード機能]
 カーソル移動モードの切り換える."
  (interactive)
  (setq keisen-move-mode (not keisen-move-mode))
  (if keisen-move-mode
      (message "カーソル移動モード:Keisen")
    (message "カーソル移動モード:Major")))

(defun keisen-toggle-move () ;-------------------------------------------------
  "[罫線モード機能]
 カーソル移動レベルを切り換える."
  (interactive)
  (cond ((= keisen-move-level 0)
         (setq keisen-move-level 1)
         (message "カーソル移動レベル:Level1"))
        ((= keisen-move-level 1)
         (setq keisen-move-level 2)
         (message "カーソル移動レベル:Level2"))
        ((= keisen-move-level 2)
         (setq keisen-move-level 0)
         (message "カーソル移動レベル:Normal"))))

(defun keisen-toggle-auto-enlarge () ;-----------------------------------------
  "[罫線モード機能]
 罫線の自動拡張モードを切り換える."
  (interactive)
  (cond (keisen-auto-enlarge-vertically-flag
         (setq keisen-auto-enlarge-vertically-flag nil
               keisen-auto-enlarge-horizontally-flag t)
         (message "自動拡張モード:ON[横方向]"))
        (keisen-auto-enlarge-horizontally-flag
         (setq keisen-auto-enlarge-horizontally-flag nil)
         (message "自動拡張モード:OFF"))
        (t
         (setq keisen-auto-enlarge-vertically-flag t)
         (message "自動拡張モード:ON[縦方向]"))))

(defun keisen-toggle-auto-line-feed () ;---------------------------------------
  "[罫線モード機能]
 罫線の自動改行モードを切り換える."
  (interactive)
  (setq keisen-auto-line-feed-flag (not keisen-auto-line-feed-flag))
  (if keisen-auto-line-feed-flag
      (message "自動改行モード:ON")
    (message "自動改行モード:OFF")))

(defun keisen-overwrite-mode () ;----------------------------------------------
  "[罫線モード機能]
 罫線モードでのインサートモードとオーバーライトモードを切り替える."
  (interactive)
  (if keisen-overwrite-mode
      (setq self-insert-after-hook 'km:self-insert-after-insert-hook)
    (setq self-insert-after-hook 'km:self-insert-after-overwrite-hook))
  (setq keisen-overwrite-mode (not keisen-overwrite-mode))
  (km:update-mode-line))

(defun keisen-toggle-width () ;------------------------------------------------
  "[罫線モード機能]
 罫線の太さを切り換える."
  (interactive)
  (setq keisen-width (cond ((= keisen-width 0) 1)   ;消去→細線
                           ((= keisen-width 1) 2)   ;細線→太線
                           ((= keisen-width 2) 0))) ;太線→消去
  (km:update-mode-line))

(defun km:update-mode-line () ;------------------------------------------------
  "[罫線モード関数]
 モードラインを新しく書き換える."
  (let ((v km:vertical-step)
        (h km:horizontal-step))
    (setq mode-name (format "罫線:%s:%s:%s"
                            (car (nthcdr (+ 2 (% h 3) (* 5 (1+ (% v 2))))
                                         '(wnw ←↑ ↑ ↑→ ene
                                               Left ← none →
                                               Right wsw ←↓ ↓ ↓→ ese)))
                            (nth  keisen-width '(　 ┼ ╋))
                            (if (eq self-insert-after-hook
                                    'km:self-insert-after-overwrite-hook)
                                'Ｏ
                              'Ｉ)))
    (set-buffer-modified-p (buffer-modified-p))))

;;;###autoload
(defun keisen-mode () ;--------------------------------------------------------
  "[罫線モード]

・罫線モードでは罫線は文字をデリートしても動かず罫線に対するコマンド以外では
  動かすことも消すこともできない.
・オーバーライトでもインサートでもどちらでも入力できる.
  （overwriteは罫線モードのkeisen-overwrite-modeを使用する）
・罫線の太さは２種類、消去用の線１種類.
・タブは罫線モードにはいる時にスペースに変換する.
・()のついているコマンドはC-uで引数を与えることができる.

┌─────────────────────────────────────┐
│罫線モード機能一覧表　　　　　　　　　　　　　　　　　　　　　　　　　　　│
├─┬──┬───────────┬────────────────────┤
│　│キー│関数名称　　　　　　　│説明　　　　　　　　　　　　　　　　　　│
┝━┿━━┿━━━━━━━━━━━┿━━━━━━━━━━━━━━━━━━━━┥
│移│C-j │keisen-locked         │罫線を飛び越えない範囲で改行            │
│動│    │     -forward-line-ext│                                        │
│　├──┼───────────┼────────────────────┤
│  │C-oj│keisen-change-locked  │罫線を飛び越えない範囲で改行            │
│  │    │        -forward-after│                                        │
│　├──┼───────────┼────────────────────┤
│  │LFD │keisen-half-locked 　 │縦方向の罫線を飛び越えない範囲で改行 　 │
│　│    │         -forward-line│ 　　　　　　　　　　　　　　　　　　　 │
│　├──┼───────────┼────────────────────┤
│  │C-e │keisen-end-of-line    │カレント行で空白でない一番最後の文字に移│
│　│　　│　　　　　　　　　　　│動　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-o │keisen-forward-jump　 │カレント枠から右枠へ移動　　　　　　　　│
│　│ C-f│　　　　　　　　-frame│　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-o │keisen-backward-jump  │カレント枠から左枠へ移動　　　　　　　　│
│　│ C-b│　　　　　　　　-frame│　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-o │keisen-previous-jump　│カレント枠から上の枠へ移動　　　　　　　│
│　│ C-p│　　　　　　　　-frame│　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-o │keisen-next-jump-frame│カレント枠から下の枠へ移動　　　　　　　│
│　│ C-n│　　　　　　　　　　　│　　　　　　　　　　　　　　　　　　　　│
├─┼──┼───────────┼────────────────────┤
│描│M-OC│keisen-draw-right ()　│罫線を引きながら右方向に移動する　　　　│
│画│    │                    　│(keisen-key-flagがnilの時)              │
│　├──┼───────────┼────────────────────┤
│  │M-OD│keisen-draw-left ()　 │罫線を引きながら左方向に移動する　　　　│
│　│    │                   　 │(keisen-key-flagがnilの時)              │
│　├──┼───────────┼────────────────────┤
│　│M-OA│keisen-draw-up ()     │罫線を引きながら上方向に移動する　　　　│
│　│    │                      │(keisen-key-flagがnilの時)              │
│　├──┼───────────┼────────────────────┤
│　│M-OB│keisen-draw-down ()   │罫線を引きながら下方向に移動する　　　　│
│　│    │                      │(keisen-key-flagがnilの時)              │
│　├──┼───────────┼────────────────────┤
│　│M-f │keisen-draw-right ()  │罫線を引きながら右方向に移動する　 　　 │
│　│    │                      │(keisen-key-flagがtの時)                │
│　├──┼───────────┼────────────────────┤
│　│M-b │keisen-draw-left ()   │罫線を引きながら左方向に移動する 　　　 │
│　│    │                      │(keisen-key-flagがtの時) 　　　　　　　 │
│　├──┼───────────┼────────────────────┤
│　│M-p │keisen-draw-up ()　　 │罫線を引きながら上方向に移動する　　　　│
│　│    │                 　　 │(keisen-key-flagがtの時) 　　　　　　　 │
│　├──┼───────────┼────────────────────┤
│　│M-n │keisen-draw-down ()　 │罫線を引きながら下方向に移動する　　　　│
│　│    │                   　 │(keisen-key-flagがtの時) 　　　　　　　 │
│　├──┼───────────┼────────────────────┤
│　│M-r │keisen-square-line　　│リージョンを対角線と見て罫線で四角を描く│
│　│    │                  　　│リージョンが一直線上にあるときは直線を引│
│　│    │                  　　│く　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│M-s │keisen-square-line2   │ポイントの位位置を始点として、ミニバッフ│
│　│    │                      │ァに従い終点を定めRETキーを押下すると始 │
│　│    │                      │点と終点を対角線と見て罫線で四角を描く  │
│　│    │                      │始点と終点が一直線上にあるときは直線を引│
│　│    │                      │く　　　　　　　　　　　　　　　　　　　│
│　│    │                      │ESCキーでキャンセルすることも出来る　　 │
│　├──┼───────────┼────────────────────┤
│　│C-cf│keisen-extend-right   │次の罫線にぶつかるまで罫線を右に伸ばして│
│　│    │                      │引く　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-cb│keisen-extend-left    │次の罫線にぶつかるまで罫線を左に伸ばして│
│　│    │                      │引く　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-cp│keisen-extend-up　　　│次の罫線にぶつかるまで罫線を上に伸ばして│
│　│    │                　　　│引く　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-cn│keisen-extend-down　　│次の罫線にぶつかるまで罫線を下に伸ばして│
│　│    │                  　　│引く　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-o │keisen-line       　　│次の罫線にぶつかるまで罫線を下に伸ばして│
│　│ C-h│         -horizontally│引く　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-o │keisen-line-vertically│次の罫線にぶつかるまで罫線を下に伸ばして│
│　│ C-v│                      │引く　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-o │keisen-arrow-down     │次の罫線にぶつかるまで罫線を下に伸ばして│
│　│ C-d│                      │引く　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-o │keisen-arrow-up       │次の罫線にぶつかるまで罫線を下に伸ばして│
│　│ C-u│                      │引く　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-o │keisen-arrow-right    │次の罫線にぶつかるまで罫線を下に伸ばして│
│　│ C-r│                      │引く　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-o │keisen-arrow-left     │次の罫線にぶつかるまで罫線を下に伸ばして│
│　│ C-l│                      │引く　　　　　　　　　　　　　　　　　　│
├─┼──┼───────────┼────────────────────┤
│挿│　　│keisen-overwrite      │文字列をオーバーライトする　　　　　　　│
│入│　　│　　　　　     -string│　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│　　│keisen-insert-string　│文字列をインサートする　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│　　│keisen-insert-register│文字列をインサートする　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│RET │keisen-newline　　　　│ポイントの位置で行を分割して新しい行を挿│
│　│    │              　　　　│入する　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│M-sp│keisen-insert-blank ()│ポイントの後の空白を挿入する　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-cv│keisen-enlarge　　　  │ポイントの位置で縦方向に罫線を伸ばす　　│
│　│    │         -vertically()│　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-ch│keisen-enlarge　　　　│ポイントの位置で横方向に罫線を伸ばす　　│
│　│    │　　　 -horizontally()│　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-y │keisen-yank　　　　　 │保存しておいた文字列をポイントの前に挿入│
│　│    │           　　　　　 │する　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-c>│keisen-movement-right │右方向へ文字列をオーバーライトする　　　│
│　│    │                      │(keisen-overwrite-modeがnon-nilの時)　　│
│　├──┼───────────┼────────────────────┤
│　│C-c<│keisen-movement-left  │左方向へ文字列をオーバーライトする　　　│
│　│    │                      │(keisen-overwrite-modeがnon-nilの時)　　│
│　├──┼───────────┼────────────────────┤
│　│C-c^│keisen-movement-up    │上方向へ文字列をオーバーライトする　　　│
│　│    │                      │(keisen-overwrite-modeがnon-nilの時)　　│
│　├──┼───────────┼────────────────────┤
│　│C-c.│keisen-movement-down　│下方向へ文字列をオーバーライトする　　　│
│　│    │                    　│(keisen-overwrite-modeがnon-nilの時)　　│
│　├──┼───────────┼────────────────────┤
│　│C-c`│keisen-movement-nw　　│左上(北西:NorthWest)方向へ文字列をオーバ│
│　│    │                  　　│ーライトする　　 　　           　　　　│
│　│    │                  　　│(keisen-overwrite-modeがnon-nilの時)　　│
│　├──┼───────────┼────────────────────┤
│　│C-c'│keisen-movement-ne　　│右上(北東:NorthEast)方向へ文字列をオーバ│
│　│    │                  　　│ーライトする　　 　　           　　　　│
│　│    │                  　　│(keisen-overwrite-modeがnon-nilの時)　　│
│　├──┼───────────┼────────────────────┤
│　│C-c/│keisen-movement-sw　　│左下(南西:SouthWest)方向へ文字列をオーバ│
│　│    │                  　　│ーライトする　　　　　　　　　　　　　　│
│　│    │                  　　│(keisen-overwrite-modeがnon-nilの時)　　│
│　├──┼───────────┼────────────────────┤
│　│C-c\\│keisen-movement-se　　│右下(南東:SouthEast)方向へ文字列をオーバ│
│　│    │                  　　│ライトする　　　　　　　　　　　　　　　│
│　│    │                  　　│(keisen-overwrite-modeがnon-nilの時)　　│
├─┼──┼───────────┼────────────────────┤
│削│C-k │keisen-clear-line　　 │ポイントから次の罫線または行端までを削除│
│除│　　│　　　　　　　　　　　│・保存する　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-d │keisen-clear-char　　 │ポイントの後ろのキャラクターを１文字消去│
│　├──┼───────────┼────────────────────┤
│　│C-of│keisen-clear-frame    │ポイントの後ろのキャラクターを１文字消去│
│　├──┼───────────┼────────────────────┤
│　│C-od│keisen-clear-keisen   │ポイントの後ろのキャラクターを１文字消去│
│　├──┼───────────┼────────────────────┤
│　│DEL │keisen-clear-backward │ポイントの前のキャラクターを１文字消去　│
│　│    │                 -char│　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-c │keisen-shrink　　　　 │罫線を縦方向に縮める　　　　　　　　　　│
│　│ C-v│　　　　 -vertically()│　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-c │keisen-shrink　　　　 │罫線を横方向に縮める　　　　　　　　　　│
│　│ C-h│       -horizontally()│　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-cc│keisen-clean          │行末のタブやスペースを取り除く　　　　　│
├─┼──┼───────────┼────────────────────┤
│モ│    │keisen-mode           │罫線モードにはいる　　　　　　　　　　　│
│｜├──┼───────────┼────────────────────┤
│ド│C-co│keisen-overwrite-mode │オーバーライトモードのトグルスイッチ　　│
│　├──┼───────────┼────────────────────┤
│　│C-cl│keisen-toggle-line    │カーソル移動モードのトグルスイッチ　　　│
│　├──┼───────────┼────────────────────┤
│　│C-cm│keisen-toggle-move    │カーソル移動レベルのトグルスイッチ　　　│
│　├──┼───────────┼────────────────────┤
│　│C-ce│keisen-toggle-auto    │自動拡張モードのトグルスイッチ　　　　　│
│　│    │              -enlarge│　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-cj│keisen-toggle-auto    │自動改行モードのトグルスイッチ　　　　　│
│　│    │            -line-feed│　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│M-\\ │keisen-key-mode       │罫線の描画キーのトグルスイッチ　　　　　│
│　├──┼───────────┼────────────────────┤
│　│M-w │keisen-toggle-width   │罫線の太さを切り換える　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-c │keisen-mode-exit      │罫線モードから抜けて元のモードに戻る　　│
│　│ C-c│                      │　　　　　　　　　　　　　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│C-om│keisen-status         │罫線モード状態参照                      │
├─┼──┼───────────┼────────────────────┤
│お│C-ck│zenkaku-space-current │カレントバッファ内の連続した二つの半角ス│
│ま│    │               -buffer│ペースを全角スペースに変換する　　　　　│
│け├──┼───────────┼────────────────────┤
│　│    │zenkaku-space-region  │リージョン内の連続した二つの半角スペース│
│　│    │                      │を全角スペースに変換する　　　　　　　　│
│　├──┼───────────┼────────────────────┤
│　│    │keisen-center-line    │罫線の枠内で文字列を中央へ移動する      │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-right-line     │罫線の枠内で文字列を右詰にする          │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-left-line      │罫線の枠内で文字列を左詰にする          │
│　├──┼───────────┼────────────────────┤
│　│M-h │keisen-rectangle      │                                        │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-kill-rectangle │                                        │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-kill           │                                        │
│　│    │-rectangle-to-register│                                        │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-delete         │                                        │
│　│    │-rectangle-to-register│                                        │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-save-rectangle │                                        │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-save-rectangle │                                        │
│　│    │-rectangle-to-register│                                        │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-yank-rectangle │                                        │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-yank-rectangle │                                        │
│　│    │        -from-register│                                        │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-view-rectangle │                                        │
│　│    │             -register│                                        │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-open-rectangle │                                        │
│　├──┼───────────┼────────────────────┤
│　│    │keisen-clear-rectangle│                                        │
└─┴──┴───────────┴────────────────────┘
┌─────────────────────────────────────┐
│罫線モード変数一覧表                                                      │
├─────────────┬──┬────────────────────┤
│変数名称　　　　　　　　　│初期│説明                                    │
┝━━━━━━━━━━━━━┿━━┿━━━━━━━━━━━━━━━━━━━━┥
│keisen-version　　　　　　│　　│罫線のバージョン                        │
├─────────────┼──┼────────────────────┤
│keisen-extend-regexp-flag │nil │拡張コマンドがチェックする罫線　　　　  │
│　　　　　　　　　　　　　│　　│ nilのときすべての罫線　　　　　　　　　│
│　　　　　　　　　　　　　│　　│ １のとき細い罫線　　　　　　　　　　　 │
│　　　　　　　　　　　　　│　　│ ２のとき太い罫線　　　　　　　　　　　 │
├─────────────┼──┼────────────────────┤
│keisen-draw-force　　　　 │nil │nilのとき細い罫線は太い罫線に含まれる　 │
│　　　　　　　　　　　　　│　　│t  のとき細い罫線は細い罫線として描画   │
├─────────────┼──┼────────────────────┤
│keisen-adjust-column-force│t　 │nilのときは罫線コマンドを使ったときカラ │
│　　　　　　　　　　　　　│　　│ムチェックをしない　　　　　　　　　　　│
│　　　　　　　　　　　　　│　　│t  のとき強制的にポイントを偶数カラムに │
│　　　　　　　　　　　　　│　　│ポイントを移動させる   　　　　　　　　 │
├─────────────┼──┼────────────────────┤
│keisen-mode-hook　　　　　│nil │罫線モードのフック　　　　　　　　　　  │
└─────────────┴──┴────────────────────┘
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
    ;;↑global-mapを書き換えるのは危険なので削除する -- 93.09.20
    ;;↓self-insert-iso関数で使用するselfinsert-internalを内部関数に置き換える
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
  "[罫線モード機能]
 罫線モードから抜ける."
  (interactive)
  (if (not (eq major-mode 'keisen-mode))
      (error "You arenot editing keisen.")
    ;(keisen-clean)                                       ;option
    ;; begin of patch  -- 93.10.15
    (while
        (let (ch)
          (message
           "行末の無意味なタブやスペースを取り除きますか？ [Yes:RET/No:SPC]")
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
;;   罫線モード状態参照
;;
(defun keisen-status () ;------------------------------------------------------
  "[罫線モード機能]
 罫線モードで提供している各種モード類の状態を表示する"
  (interactive)
  (unwind-protect
      (save-window-excursion
        (save-excursion
          (set-buffer (get-buffer-create " *km:status-window*"))
          (erase-buffer)
          (setq mode-line-format "  --< 罫線モード状態表 >--")
          (km:create-status-table))
        (km:overlay-window 6)
        (switch-to-buffer " *km:status-window*")
        (select-window (next-window))
        (sit-for keisen-status-display-interval-time))))

(defun km:create-status-table () ;---------------------------------------------
  "[罫線モード関数]
 各種モード類の状態をバッファに書き込む"
  (goto-char (point-min))
  (insert (format "カーソル移動モード : %s\n"
                  (if keisen-move-mode "Keisen" "Major")))
  (insert (format "カーソル移動レベル : %s\n"
                  (cond ((= keisen-move-level 0) "Normal")
                        ((= keisen-move-level 1) "Level1")
                        ((= keisen-move-level 2) "Level2"))))
  (insert (format "自動拡張モード     : %s\n"
                  (if keisen-auto-enlarge-vertically-flag "ON[縦方向]"
                    (if keisen-auto-enlarge-horizontally-flag "ON[横方向]"
                      "OFF"))))
  (insert (format "自動改行モード     : %s\n"
                  (if keisen-auto-line-feed-flag "ON" "OFF")))
  (insert (format "罫線の描画キー     : %s\n"
                  (if keisen-key-flag "カーソルキー" "M-[pnbf]キー")))
  (goto-char (point-min)))

(defun km:overlay-window (height) ;-- Based by Toshihiko Miyazaki -------------
  "[罫線モード関数]
 罫線モード状態表の表示ウィンドウのサイズを調整する"
  (save-excursion
    (let ((oldot (save-excursion (beginning-of-line) (point)))
          (top   (save-excursion (move-to-window-line height) (point)))
          (newin (split-window-vertically height)))
      (if (< oldot top) (setq top oldot))
      (set-window-start newin top))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   罫線モード用共通ルーチン
;;
(defun km:adjusted-current-column () ;-----------------------------------------
  "[罫線モード関数]
 カレントポイントのカラム数を返却する
 ただし、keisen-adjust-column-forceがtのときカラム数を偶数にして返却する
 つまり、カレントポイントのカラム数が奇数なら(- (current-column) 1)、偶数なら
 (current-column)を返す"
  (if keisen-adjust-column-force
      (* (/ (current-column) 2) 2)
    (current-column)))

(defun km:adjust-current-column (&optional force)
  (km:move-to-column-force (km:adjusted-current-column) force))

(defun km:adjusted-column (pos) ;----------------------------------------------
  "[罫線モード関数]
 指定ポイントposのカラム数を返却する
 ただし、keisen-adjust-column-forceがtのときカラム数を偶数にして返却する
 つまり、指定ポイントposのカラム数が奇数なら(- (current-column) 1)、偶数なら
 (current-column)を返す"
  (save-excursion
    (goto-char pos)
    (km:adjusted-current-column)))

(defun km:what-current-line () ;-----------------------------------------------
  "[罫線モード関数]
 カレント位置の行番号を返す"
  (save-restriction
    (widen)
    (save-excursion
      (beginning-of-line)
      (1+ (count-lines (point-min) (point))))))

(defun km:delete-horizontal-space-and-ZenkakuSpace () ;------------------------
  "[罫線モード関数]
 カレント位置の前後の空白とタブ及び、全角の空白を全て削除する
 simple.elのdelete-horizontal-spaceを抜粋、改造した"
  (skip-chars-backward "　 \t")
  (delete-region (point) (progn
                           (skip-chars-forward "　 \t")
                           (point))))

(defun km:what-line (pos) ;----------------------------------------------------
  "[罫線モード関数]
 指定されたポイントposのライン数を返却する"
  (save-excursion
    (goto-char pos)
    (km:what-current-line)))

(defun km:what-column (pos) ;--------------------------------------------------
  "[罫線モード関数]
 指定されたポイントposのカラム数を返却する"
  (save-excursion
    (goto-char pos)
    (current-column)))

(defun km:what-point (col) ;---------------------------------------------------
  "[罫線モード関数]
 カレント行の指定カラムcolのポイントを返却する"
  (save-excursion
    (km:move-to-column-force col nil)
    (point)))

(defun km:string-length (str col) ;--------------------------------------------
  "[罫線モード関数]
 指定された文字列strの先頭から指定カラムcolまでのバイト数を数える"
  (length (km:get-string str col nil)))

(defun km:string-column (str) ;------------------------------------------------
  "[罫線モード関数]
 指定された文字列strのカラム数を数える"
  (string-width str))

(defun km:buffer-column (begin end) ;------------------------------------------
  "[罫線モード関数]
 指定されたbeginポイントからendポイントまでのカラム数を数える"
  (let ((str (buffer-substring begin end)))
    (km:string-column str)))

(defun km:get-string (str get_col &optional flg) ;-----------------------------
  "[罫線モード関数]
 文字列の先頭から指定カラム数分とりだす"
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
  "[罫線モード関数]
 カレントラインの最終桁の位置を返す"
  (save-excursion
    (end-of-line)
    (point)))

(defun km:bol () ;-------------------------------------------------------------
  "[罫線モード関数]
 カレントラインの最初の桁の位置を返す"
  (save-excursion
    (beginning-of-line)
    (point)))

(defun km:what-window-line (pos) ;---------------------------------------------
  "[罫線モード関数]
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
  "[罫線モード関数]
 カレントラインがバッファの最終ラインかチェックする
 カレントラインがバッファの最後ならばt、そうでなければnilを返却する"
 (if (< (save-excursion                         (vertical-motion 0) (point))
        (save-excursion (goto-char (point-max)) (vertical-motion 0) (point)))
     nil
   t))

(defun km:boblp () ;-----------------------------------------------------------
  "[罫線モード関数]
 カレントラインがバッファの先頭ラインかチェックする
 カレントラインがバッファの先頭ならばt、そうでなければnilを返却する"
 (if (< (point-min) (save-excursion (vertical-motion 0) (point)))
     nil
   t))

;; alternative function for those in old mule-util.el
;;(or (fboundp 'delete-text-in-column)
;;    (defun delete-text-in-column(col1 col2) ;-----------------------------------
;;      "[罫線モード関数]
;; 指定された二つのカラム位置の間の文字を削除する"
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
