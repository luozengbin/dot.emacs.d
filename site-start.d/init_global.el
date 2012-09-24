;;; Commentary:

;; 利用する環境共通の設定

;;; Code:

(message "init_global ...")

;;; 初期位置
(cd "~/")

;;
;; frame setting
;;______________________________________________________________________
;; 画面サイズ、色の設定
(setq default-frame-alist
      (append '(
		(width                . 120            )   ;; フレーム幅
		(height               . 40             )   ;; フレーム高
		;; (left-fringe          . 3           )   ;; 左フリンジ幅
		;; (right-fringe         . 3           )   ;; 右フリンジ幅
		(menu-bar-lines       . 0              )   ;; メニューバー
		(tool-bar-lines       . 0              )   ;; ツールバー
		(vertical-scroll-bars . nil            )   ;; スクロールバー
		;; (cursor-type          . bar         )   ;; カーソル種別
		;; (cursor-color         . "yellow"    )   ;; カーソル色
		;; (alpha                . (95 70)     )   ;; 背景の透過
		) default-frame-alist))
(setq initial-frame-alist default-frame-alist)

;; フレームタイトルの設定
(setq frame-title-format (format "%%f - Emacs@%s" (system-name)))

;;
;; startup
;;______________________________________________________________________
;; emacsclient を利用するためにサーバ起動
;; サーバが起動していた場合は先に起動していた方を優先
;; http://d.hatena.ne.jp/syohex/20101224/1293206906
;; emacs --daemonも同じ効果です
(require 'server)
(unless (server-running-p) (server-start))
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

;;起動時のmessageを表示しない
(setq inhibit-startup-message t)

;; Bell
;; (setq visible-bell t)
(setq ring-bell-function 'ignore)

;;
;; codeing setting
;; M-x describe-coding-system で設定状況を確認することが出来る
;;______________________________________________________________________
(set-language-environment 'Japanese)

(if windows-p
    (progn
      ;; (prefer-coding-system 'utf-8)  ; windowsの場合これは不便（特にProcess IOで問題が起こる）
      ;; ファイル読み込みで優先使用するエンコードの指定
      (set-coding-system-priority 'utf-8)
      )
  ;; 他のシステム極力UTF-8とする
  (prefer-coding-system 'utf-8))

;; 新規ファイル保存コーディングの指定
(setq default-buffer-file-coding-system 'utf-8-unix)
;; ターミナルから使っていて、キーボード入力と画面出力の文字コード
(set-terminal-coding-system 'utf-8)
;;(set-keyboard-coding-system 'utf-8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 文字コード
;;  機種依存文字例：～①㈱©
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (install-elisp "https://raw.github.com/awasira/cp5022x.el/master/cp5022x.el")
;; http://nijino.homelinux.net/emacs/emacs23-ja.html
;; http://murakan.cocolog-nifty.com/blog/2011/06/emacs-emacs23-1.html
;; http://carz.air-nifty.com/sowhat/2010/08/ntemacs-mew-tha.html
;; http://d.hatena.ne.jp/kiwanami/20091103/1257243524
(require 'cp5022x)
;;(set-coding-system-priority 'utf-8 'cp50220 'euc-jp 'iso-2022-jp 'cp932)

;;
;; mode line setting
;;______________________________________________________________________
;; ファイルサイズの表示
(size-indication-mode t)

;; モードラインに行番号を表示する
(line-number-mode t)

;; モードラインに列番号の表示
(column-number-mode t)

;; 単語集計マイナーモード
;; (install-elisp "http://www.emacswiki.org/emacs/download/wc-mode.el")
;;(require 'wc-mode)
;; 有効にすると編集が遅くなく
;;(global-wc-mode t)

;; 時刻の表示
(setq display-time-24hr-format t)
(setq display-time-string-forms '(24-hours ":" minutes))
(display-time-mode t)

;; バッテリー残量を表示する
(when mac-p
 (display-battery-mode t))

;; 現在編集している関数名を表示する
(require 'which-func)
(add-to-list 'which-func-modes 'org-mode)
(add-to-list 'which-func-modes 'elisp-mode)
;; (which-func-mode 1)

;; ファイル名がかぶった場合、バッファー名をわかりやすくする
(require 'uniquify)
;; バッファー名をfilename<dir>の形式にする
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; *で囲んまれた文字を表示対象外とする
(setq uniquify-ignore-buffers-re "*[^*]+*")

;; デフォールトmajar modeの指定
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook
	  '(lambda ()
	     (setq fill-column 70)
	     (auto-fill-mode 1)))

;; マイナーモードの名称を非表示するためのラブラリ
;; (install-elisp "http://www.eskimo.com/~seldon/diminish.el")
(require 'diminish)

;;
;; my-powerline
;;______________________________________________________________________
;; (require 'my-powerline)
;; (require 'powerline)
;; (powerline-default)

;;
;; buffer backup & auto save
;;______________________________________________________________________
;; ---- emacs自身の自動保存機能
;; バックアップONの設定
(let ((my-backup-dir (concat my-cache-dir "backups/")))
  (if (not (file-exists-p my-backup-dir)) (mkdir my-backup-dir t))
  (setq backup-directory-alist
        `(("\\.*$" . ,(expand-file-name my-backup-dir))))
  (setq auto-save-list-file-prefix (expand-file-name (concat my-cache-dir ".saves-")))
  (setq auto-save-file-name-transforms
        `((".*" ,(expand-file-name my-backup-dir) t)))
  ;; 編集中ファイルのバックアップ間隔(秒)
  (setq auto-save-timeout 120)
  ;; 編集中ファイルのバックアップ間隔(打鍵)
  (setq auto-save-interval 512)

  ;; バックアップのバージョンコントロールを有効にする
  (setq version-control t)
  ;; バックアップ世代数
  (setq kept-old-versions 1)
  (setq kept-new-versions 2)
  ;; 古いバックアップファイルの削除
  (setq delete-old-versions t)
)

;; バックアップOFFの設定
(setq make-backup-files nil)
(setq auto-save-default nil)
;; 変更ファイルの番号つきバックアップ
(setq version-control nil)

;;; TRAMP のファイルに対して効果的に backup-directory-alist の効果を消します
(add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp nil))

;; 上書き時の警告表示
;; (setq trim-versions-without-asking nil)

;; ファイル内のカーソルの位置を保存する
(require 'saveplace)
;; 有効化する
(setq-default save-place t)
;; 保存場所の指定
(custom-set-variables
 '(save-place-file (concat my-cache-dir ".emacs-places")))

;; GCを減らして軽くする
(setq gc-cons-threshold (* 100 gc-cons-threshold))

;; ログの記録行数を増やす
(setq message-log-max 10000)

;; ダイアログボックスを使わないようにする
(setq use-dialog-box nil)
(defalias 'message-box 'message)

;; ミニバッファ履歴リストの最大長
(setq history-length 1000)

;; ;; ファイル更新日を自動的に書き換える。
;; ;; ファイルの先頭から 8 行以内に "last updated : "をつけくわえればよい
;; (require 'time-stamp)
;; ;; 日本語で日付を入れたくないのでlocaleをCにする
;; (defun time-stamp-with-locale-c ()
;;   (let ((system-time-locale "C"))
;;     (time-stamp)
;;     nil))

;; (if (not (memq 'time-stamp-with-locale-c write-file-hooks))
;;     (add-hook 'write-file-hooks 'time-stamp-with-locale-c))

;; (setq time-stamp-active t)
;; (setq time-stamp-start "Last Updated : ")
;; (setq time-stamp-format "%04y/%02m/%02d %3a %02H:%02M:%02S")
;; (setq time-stamp-end "  ") ;;;Last Updated : の後に空白2つ以上いれると置換

;;
;; recent mode setting
;;______________________________________________________________________
;; 最近使ったファイルをメニューに表示
(recentf-mode 1)
;; (setq recentf-max-menu-items 10)
;; 最近使ったファイルを500個にする
(setq recentf-max-saved-items 500)
;; 保存対象外
(setq recentf-exclude '("/TAGS"
			"/TAGS$"
			"/var/tmp/"
			".emacs-places"
			".emacs.bmk"
			".emacs~"
			".framesize.el"
			".framesize.el~"
			".ido.last"
			".java_base.tag"
			".kkcrc"
			".migemo-pattern"
			".recentf"
			".recentf~"
			".skk-jisyo"
			".skk-jisyo.BAK"
			".skk-record"
			".windows"
			".windows~"))

;; recentf
(custom-set-variables
 '(recentf-save-file (concat my-cache-dir ".recentf")))

;; ディレクトリも保存対象にする、最近使った順で表示する
;; (install-elisp "http://www.emacswiki.org/emacs/download/recentf-ext.el")
(require 'recentf-ext)

;; ;; tempbufで長時間使用しないバッファーを自動的に閉じる
;; ;; (install-elisp-from-emacswiki "tempbuf.el")
;; (require 'tempbuf)
;; ;; ファイル開く度に自動的有効する
;; (add-hook 'find-file-hook 'turn-on-tempbuf-mode)
;; ;; diredモードも自動クローズを有効化する
;; (add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)

;; bookmark登録設定直後に保存を行うようにする
(setq bookmark-default-file (convert-standard-filename (my-cache-dir "bookmarks")))
(setq bookmark-save-flag 1)

;;
;; buffer scroll
;;______________________________________________________________________
;; スクロール行数（一行ごとのスクロール）
;; (setq vertical-centering-font-regexp ".*")
;; (setq scroll-conservatively 35
;;       scroll-margin          0
;;       scroll-step            1)

;; C-v や M-v した時に以前の画面にあった文字を何行分残すか(初期設定 2)
(setq next-screen-context-lines 0)

;; 上端、下端における余白幅(初期設定 0)
;; (setq scroll-margin 10)

;; スムーズスクロールFeatureの追加
;; (install-elisp "http://www.emacswiki.org/emacs/download/smooth-scroll.el")
(require 'smooth-scroll)
;; (smooth-scroll-mode t)                  ;スクロール時カーソルの位置が変わる問題がある
(global-set-key [(control  down)]  'scroll-up-1)
(global-set-key [(control  up)]    'scroll-down-1)
(global-set-key [(control  left)]  'scroll-right-1)
(global-set-key [(control  right)] 'scroll-left-1)

;;; 慣性スクロール inertial-scroll.el
;; (auto-install-from-url "http://github.com/kiwanami/emacs-deferred/raw/master/deferred.el")
;; (auto-install-from-url "http://github.com/kiwanami/emacs-inertial-scroll/raw/master/inertial-scroll.el")
(require 'inertial-scroll)
(setq inertias-global-minor-mode-map
      (inertias-define-keymap
       '(
         ;; Mouse wheel scrolling
         ("<wheel-up>"   . inertias-down-wheel)
         ("<wheel-down>" . inertias-up-wheel)
         ("<mouse-4>"    . inertias-down-wheel)
         ("<mouse-5>"    . inertias-up-wheel)
         ;; Scroll keys
         ("<next>"  . inertias-up)
         ("<prior>" . inertias-down)
         ("C-v"     . inertias-up)
         ("M-v"     . inertias-down)
         ) inertias-prefix-key))
(inertias-global-minor-mode 1)

(setq inertias-initial-velocity-wheel 30) ; 初速マウス
(setq inertias-initial-velocity 70)       ; 初速（大きいほど一気にスクロールする）
(setq inertias-friction 120)              ; 摩擦抵抗（大きいほどすぐ止まる）
(setq inertias-rest-coef 0)               ; 画面端でのバウンド量（0はバウンドしない。1.0で弾性反発）
(setq inertias-update-time 60)            ; 画面描画のwait時間（msec）
(setq inertias-rebound-flash nil)

;;
;; autofill & truncate
;;______________________________________________________________________
;; Truncate
;; バッファ画面外文字の切り捨て表示
(setq truncate-lines t)
(setq default-truncate-lines t)

;; ウィンドウ縦分割時のバッファ画面外文字の詰めて表示する
(setq truncate-partial-width-windows nil)

;; Fill column
(setq fill-column 85)

;;
;; mini buffer
;;______________________________________________________________________
;; ミニバッファーを再帰的に呼び出せるようにする
(setq enable-recursive-minibuffers nil)

;; キーストロークをエコエリアに早く表示する
(setq echo-keystrokes 0.1)

;; 大きいファイルを開こうとした時に警告を発生させる
;; デフォルトは10MBなので25MBに拡張する
(setq large-file-warning-threshold (* 25 1024 1024))

(setq max-lisp-eval-depth 10000)
(setq max-specpdl-size 10000)

;; yesと入力とするのは面倒なのでyで十分
(defalias 'yes-or-no-p 'y-or-n-p)

;; ミニバッファーで入力取り消ししても履歴を残す
(defadvice abort-recursive-edit (before minibuffer-save activate)
  (when (eq (selected-window) (active-minibuffer-window))
    (add-to-history minibuffer-history-variable (minibuffer-contents))))

;;
;; desktop-save-mode
;;______________________________________________________________________
;;; http://www.emacswiki.org/DeskTop

;; (require 'desktop)
;; (setq desktop-path `(,my-cache-dir))
;; (setq desktop-dirname my-cache-dir)
;; (setq desktop-base-file-name "emacs-desktop")

;; ;; save mini buffer history
;; (setq desktop-globals-to-save '(extended-command-history))
;; (setq desktop-files-not-to-save "")

;; (desktop-save-mode 1)

(provide 'init_global)
;;; init_global.el ends here
