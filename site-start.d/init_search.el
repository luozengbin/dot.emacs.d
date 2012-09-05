;;; Commentary:

;; 検索機能のカスタマイズ

;;; Code:

(message "init_search ...")

;;
;; basic key binding
;;______________________________________________________________________
;; M-% 対話式置換を押す安いようにする
(global-set-key (kbd "C-c r") 'query-replace)

;; キーバンドの見直し
(define-key isearch-mode-map "\C-b" 'isearch-delete-char)
(define-key isearch-mode-map [backspace] 'isearch-del-char)

;; isearch の終了時のカーソル位置を検索対象単語の前へ持っていく
(define-key isearch-mode-map "\C-q" 'isearch-exit)
(add-hook 'isearch-mode-end-hook
          (lambda ()
            (cond
             ((eq last-input-char ?\C-q)
              (goto-char (match-beginning 0))))))

;;
;; highlight
;;______________________________________________________________________
;; 検索終了してもハイライトを残る
;; ハイライトをクリア用のコマンド (call-interactively 'lazy-highlight-cleanup)
(setq lazy-highlight-cleanup nil)

;;
;; auto select search ward
;;______________________________________________________________________
;;i-searchモードを開く際に自動的にリージョン選択した
(defadvice isearch-mode (around isearch-mode-default-string (forward &optional regexp op-fun recursive-edit word-p) activate)
  (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
      (progn
        (isearch-update-ring (buffer-substring-no-properties (mark) (point)))
        (deactivate-mark)
        ad-do-it
        (if (not forward)
            (isearch-repeat-backward)
          (goto-char (mark))
          (isearch-repeat-forward)))
    ad-do-it))

;;
;; migemo
;; http://0xcc.net/
;; http://sourceforge.net/projects/migemo/
;;______________________________________________________________________
;; migemo でisearchモードでローマ字で日本語検索をサポートする
;; (install-elisp "https://bitbucket.org/sakito/dot.emacs.d/raw/4e671a49c2a5/local-lisp/migemo.el")
(cond
 (windows-p
  (setq migemo-command (concat os-local-bin "cmigemo-default-win32/cmigemo.exe"))
  (setq migemo-dictionary (concat os-local-bin "cmigemo-default-win32/dict/utf-8/migemo-dict")))
 (mac-p
  (setq migemo-command "cmigemo")
  (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict"))
 (t
  (setq migemo-command "cmigemo")
  (setq migemo-dictionary "/usr/share/migemo/utf-8/migemo-dict")))

;; migemoのコマンドラインオプション
(setq migemo-options '("-q" "--emacs" "-i" "\a"))
;; cmigemoで必須の設定
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-use-pattern-alist t)
;; キャッシュの設定
(setq migemo-use-frequent-pattern-alist t)
(setq migemo-coding-system 'utf-8-unix)
(setq migemo-pattern-alist-length 1000)
(setq migemo-pattern-alist-file (concat my-cache-dir "migemo-pattern"))
(setq migemo-frequent-pattern-alist-file (concat my-cache-dir "migemo-frequent"))

;; デフォルトはmigemoを無効化する
(setq migemo-isearch-enable-p nil)
(load-library "migemo")
(require 'migemo)
;; migemoを起動する
(migemo-init)

;;
;; color moccur edit
;;______________________________________________________________________
;; color-moccur でoccurの改善版、操作性UP、i-searchで「M-o」で切り替えできる
;; (install-elisp-from-emacswiki "color-moccur.el")
;; (install-elisp-from-emacswiki "moccur-edit.el")
(require 'color-moccur)
(require 'moccur-edit)
;; 複数の検索語や、特定のフェイスのみマッチ等の機能を有効にする
;; 詳細は http://www.bookshelf.jp/soft/meadow_50.html#SEC751
(setq moccur-split-word t)
;; migemoがrequireできる環境ならmigemoを使う
(when (require 'migemo nil t) ;第三引数がnon-nilだとloadできなかった場合にエラーではなくnilを返す
  (setq moccur-use-migemo t))
;; C-gにquiteコマンドを割り当てする
(define-key moccur-mode-map (kbd "C-g") 'moccur-quit)
;; カーソル位置の単語をバッファ内から探す設定例
(global-set-key (kbd "C-z o") (lambda () (interactive)
                         (if (thing-at-point 'symbol)
                             (call-interactively 'occur-by-moccur (thing-at-point 'symbol))
                           (call-interactively 'occur-by-moccur))))

;;
;; anything-c-moccur設定
;; 使い方：http://d.hatena.ne.jp/IMAKADO/20080724/1216882563
;;______________________________________________________________________
;; (install-elisp "http://svn.coderepos.org/share/lang/elisp/anything-c-moccur/trunk/anything-c-moccur.el")
;; TODO インストールを行う
;;      anything-c-moccur-higligt-info-line-flagオプションの動作確認
;; anything-c-moccurの設定
(require 'anything-c-moccur)
;; カスタマイズ可能変数の設定(M-x customize-group anything-c-moccur でも設定可能)
(setq
 ;;`anything-idle-delay'
 anything-c-moccur-anything-idle-delay 0.2
 ;; `anything-c-moccur-dmoccur'などのコマンドでバッファの情報をハイライトする
 anything-c-moccur-higligt-info-line-flag t
 ;; 現在選択中の候補の位置を他のwindowに表示する
 anything-c-moccur-enable-auto-look-flag t
 ;; `anything-c-moccur-occur-by-moccur'の起動時にポイントの位置の単語を初期パターンにする
 anything-c-moccur-enable-initial-pattern t)
;; キーバインドの割当
(define-key anything-c-moccur-anything-map (kbd "<down>")  'anything-c-moccur-next-line)
(define-key anything-c-moccur-anything-map (kbd "<up>")  'anything-c-moccur-previous-line)

(global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur) ;バッファ内検索
(global-set-key (kbd "C-M-o") 'anything-c-moccur-dmoccur) ;ディレクトリ
(define-key isearch-mode-map (kbd "M-o") 'anything-c-moccur-from-isearch)
;; diredモードでマークされたファイルを検索対象にする、"O"に割り当て
(add-hook 'dired-mode-hook ;dired
          '(lambda ()
             (require 'key-chord)
             ;; 元々のコマンドを "[O-P]" key-chordに割り当てする
             (key-chord-define dired-mode-map "op" (lookup-key (current-local-map) "O"))
             (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))

;;
;; anything-grepのwindows対応
;;______________________________________________________________________
(if windows-p
    (defun agrep-do-grep (command pwd)
      "Insert result of COMMAND. The current directory is PWD.
GNU grep is expected for COMMAND. The grep result is colorized."

      (if (and windows-p (executable-find "cygpath"))
          (setq pwd (my-shell-command-to-single-line (concat "cygpath --windows " pwd))))

      (let ((process-environment process-environment))
        (when (eq grep-highlight-matches t)
          ;; Modify `process-environment' locally bound in `call-process-shell-command'.
          (setenv "GREP_OPTIONS" (concat (getenv "GREP_OPTIONS") " --color=always"))
          ;; for GNU grep 2.5.1
          (setenv "GREP_COLOR" "01;31")
          ;; for GNU grep 2.5.1-cvs
          (setenv "GREP_COLORS" "mt=01;31:fn=:ln=:bn=:se=:ml=:cx=:ne"))
        (set (make-local-variable 'agrep-source-local) (anything-get-current-source))
        (add-to-list 'agrep-waiting-source agrep-source-local)
        (set-process-sentinel
         (start-process-shell-command "anything-grep" (current-buffer)
                                      (format "cd %s | %s" pwd command))
         'agrep-sentinel))))

;;
;; grep 改善
;;______________________________________________________________________

;; igrep
;; (install-elisp-from-emacswiki "igrep.el")
;; http://d.hatena.ne.jp/tomoya/20090826/1251261798
;;(require 'igrep)
;; (autoload 'igrep "igrep"
;;   "*Run `grep` PROGRAM to match REGEX in FILES..." t)
;; (autoload 'igrep-find "igrep"
;;   "*Run `grep` via `find`..." t)
;; (autoload 'igrep-visited-files "igrep"
;;   "*Run `grep` ... on all visited files." t)
;; (autoload 'dired-do-igrep "igrep"
;;   "*Run `grep` on the marked (or next prefix ARG) files." t)
;; (autoload 'dired-do-igrep-find "igrep"
;;   "*Run `grep` via `find` on the marked (or next prefix ARG) directories." t)
;; (autoload 'Buffer-menu-igrep "igrep"
;;   "*Run `grep` on the files visited in buffers marked with '>'." t)
;; (autoload 'igrep-insinuate "igrep"
;;   "Define `grep' aliases for the corresponding `igrep' commands." t)

;; grep-a-lot 複数 *grep*バッファーを持たせるようにする
;; (install-elisp-from-emacswiki "grep-a-lot.el")
(require 'grep-a-lot)
(grep-a-lot-setup-keys)
;; igrepむけの設定
(grep-a-lot-advise igrep)

;;grepから検索結果を直接編集
;; https://raw.github.com/mhayashi1120/Emacs-wgrep/master/wgrep.el
(require 'wgrep nil t)

;;------------------   wgrepの旧バージョンgrep-editの設定
;; ;; grep検索結果を直接編集できるようにする
;; ;; (install-elisp-from-emacswiki "grep-edit.el")
;; (require 'grep-edit)
;; (defadvice grep-edit-change-file (around inhibit-read-only activate)
;;   ""
;;   (let ((inhibit-read-only t))
;;     ad-do-it))
;; ;; (progn (ad-disable-advice 'grep-edit-change-file 'around 'inhibit-read-only) (ad-update 'grep-edit-change-file)) 
;; (defun my-grep-edit-setup ()
;;   (define-key grep-mode-map '[up] nil)
;;   (define-key grep-mode-map "\C-c\C-c" 'grep-edit-finish-edit)
;;   (message (substitute-command-keys "\\[grep-edit-finish-edit] to apply changes."))
;;   (set (make-local-variable 'inhibit-read-only) t)
;;   )
;; (add-hook 'grep-setup-hook 'my-grep-edit-setup t)
;;------------------------------------------------------

;; color-grep
;; ;; (install-elisp "http://www.bookshelf.jp/elc/color-grep.el")
;; (require 'color-grep)
;; ;; grep バッファを kill 時に，開いたバッファを消す
;; (setq color-grep-sync-kill-buffer t)

;; 拡張grep関数のローディング
;; M-x my-lgrep
;; M-x my-rgrep

;;
;; locate
;;______________________________________________________________________
;;; http://dev.ariel-networks.com/articles/emacs/part1/

(defvar local-locate-db-name "locate.db" "locate dbのファイル名")
(defvar local-locate-command "locate.findutils" "locateコマンド")

;; locateコマンドラインを作る為の共通関数
(defun locate-make-command-line (search-string dbpath &rest opts)
  (append
   ;; 大文字小文字を虫するように設定
   (list local-locate-command "-i")
   (when (and dbpath (file-exists-p dbpath))
     (list "-d" dbpath))
   opts
   (list search-string)))

;; home以下のファイルを探す為のlocateコマンドライン
(defun home-locate-make-command-line (search-string &optional &rest opts)
  (apply 'locate-make-command-line
         search-string
         ;; home直下の locate.db を使うように指定
         (expand-file-name local-locate-db-name "~")
         opts))

(defun locate-at-home ()
  (interactive)
  (let (;; 標準のlocateでhome以下を探すように設定する．
        (locate-make-command-line 'home-locate-make-command-line))
    (call-interactively 'locate)))

;; プロジェクト毎のlocate dbを使ったlocateコマンドライン
(defun plocate-make-command-line (search-string &optional &rest opts)
  (princ (find-file-upward local-locate-db-name))
  (apply 'locate-make-command-line
         search-string
         (find-file-upward local-locate-db-name)
         opts))

;; プロジェクト毎のlocate dbを使ったlocateコマンド
(defun plocate (search-string &optional arg)
  (interactive
   (list
    (locate-prompt-for-search-string)
    current-prefix-arg))
  (let ((locate-make-command-line 'plocate-make-command-line))
    (locate search-string nil arg)))

;;
;; 検索＆置換強化
;; ReplacePlus --> http://www.emacswiki.org/emacs/ReplacePlus
;; IsearchPlus --> http://www.emacswiki.org/emacs/IsearchPlus
;;______________________________________________________________________
;; (install-elisp "http://www.emacswiki.org/emacs/download/replace+.el")
(require 'my-search)
(define-key global-map (kbd "C-z r") 'my-replace-string)
;;
;; imenu 改善
;;______________________________________________________________________
;; 自動でimenuのインデックスを作る
(setq imenu-auto-rescan t)

;; バッファーのサマリを表示する
;; (install-elisp-from-emacswiki "summarye.el")
;; M-x se/make-summary-buffer
(require 'summarye)

;;
;; ace-jump-mode
;; http://d.hatena.ne.jp/syohex/20120304/1330822993
;;______________________________________________________________________
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

(provide 'init_search)
;;; init_search.el ends here
