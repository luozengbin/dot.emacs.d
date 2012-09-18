;;; Commentary:

;; dired 機能のカスタマイズ

;;; Code:

(message "init_dired ...")

;; (install-elisp "http://www.emacswiki.org/emacs/download/w32-symlinks.el")
(when windows-p
  (require 'w32-symlinks))

;;
;; 基本設定
;;______________________________________________________________________
;; ディレクトリを先に表示する
(setq ls-lisp-dirs-first t)

;; サイズ表示を分かりやすくする
(setq dired-listing-switches "-alh")

;; 画像を直接開けるように
(auto-image-file-mode t)

;; windowsショートカットを有効にする
(custom-set-variables '(w32-symlinks-handle-shortcuts t))

;; diredのコピー、削除操作のネストを自動化する
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

;; フォルダー開けない問題
(require 'ls-lisp)
;; (setq ls-lisp-use-insert-directory-program t)
;; (setq insert-directory-program "C:/ProgramData/cygwin/bin/ls.exe")

;; 関数の有効化
(put 'dired-find-alternate-file 'disabled nil)

;; ごみ箱を有効
;;(setq delete-by-moving-to-trash t)

;; diredビュー間のファイルコピーを有効化する
(setq dired-dwim-target t)

;; 同じバッファーで見る
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd "<return>")
              'dired-find-alternate-file) ; was dired-advertised-find-file
            (define-key dired-mode-map (kbd "^")
              (lambda () (interactive) (find-alternate-file ".."))); was dired-up-directory
            ))

;; diff結果を見やすくする
(setq diff-switches "-u")

;;
;; 圧縮、解凍
;;______________________________________________________________________
;; 圧縮されたファイルも編集できるようにする
(auto-compression-mode t)

;; zipファイルサポート
;; (setq dired-compress-file-suffixes
;;       (append dired-compress-file-suffixes '(("\\.zip\\'" "" "unzip")))
;; )

;; atool を使い dired のサポートする圧縮形式を増やす
;; http://d.hatena.ne.jp/mooz/20110911/p1
(defvar my-dired-additional-compression-suffixes
  '(".7z" ".Z" ".a" ".ace" ".alz" ".arc" ".arj" ".bz" ".bz2" ".cab" ".cpio"
    ".deb" ".gz" ".jar" ".lha" ".lrz" ".lz" ".lzh" ".lzma" ".lzo" ".rar"
    ".rpm" ".rz" ".t7z" ".tZ" ".tar" ".tbz" ".tbz2" ".tgz" ".tlz" ".txz"
    ".tzo" ".war" ".xz" ".zip"))

(eval-after-load "dired-aux"
  '(progn
     (require 'cl)
     (loop for suffix in my-dired-additional-compression-suffixes
           do (add-to-list 'dired-compress-file-suffixes
                           `(,(concat "\\" suffix "\\'") "" "aunpack")))))

;;
;; 検索
;;______________________________________________________________________
;; ディレクトリの検索
;; (install-elisp "http://www.emacswiki.org/emacs/download/findr.el")
;; (install-elisp "http://www.bookshelf.jp/elc/find-dired-lisp.el")

;; (autoload 'findr "findr" "Find file name." t)
(autoload 'findr-search "findr" "Find text in files." t)
(autoload 'findr-query-replace "findr" "Replace text in files." t)

(autoload 'find-dired-lisp "find-dired-lisp" "findr" t nil)
(autoload 'find-grep-dired-lisp "find-dired-lisp" "findr" t nil)


;;
;; ディレクトリへの移動
;;______________________________________________________________________
(defun open-dired-from-recentf (keyword)
  (interactive "s移動先パスの一部: ")
  (with-temp-buffer
    (mapcar (lambda (x) (insert (format "%s\n" x)))
            recentf-list)
    (goto-char (point-min))
    (search-forward keyword)
    (dired (file-name-directory (thing-at-point 'line)))
    ))
(global-set-key (kbd "C-x C-d") 'open-dired-from-recentf)

;;
;; speedbar 設定
;;______________________________________________________________________
;; (install-elisp "http://www.emacswiki.org/emacs/download/sr-speedbar.el")
;; speedbarをバッファー画面と同じフレームに表示する
(require 'sr-speedbar)
(setq sr-speedbar-right-side nil)
;; speedbarの表示と非表示
(global-set-key [f9] 'sr-speedbar-toggle)

;; delete-window時にsr-speedbar-windowの幅を一定に保つようする
(defadvice delete-window (after delete-window-advice activate)
  (if (sr-speedbar-window-exist-p sr-speedbar-window)
      (let ((current-window (selected-window))
            (win-width (sr-speedbar-current-window-take-width sr-speedbar-window)))
        (unless (= win-width sr-speedbar-width)
          (select-window sr-speedbar-window)
          (if (< win-width sr-speedbar-width)
              (enlarge-window-horizontally (- sr-speedbar-width win-width))
            (shrink-window-horizontally (- win-width sr-speedbar-width)))
          (select-window current-window)))))

;;; すべてのファイルを表示するように
(setq speedbar-show-unknown-files t)

;;; speedbar に拡張子を登録 → http://www.miura-takeshi.com/2010/0121-100438.html
;; (add-hook 'speedbar-mode-hook
;;           '(lambda ()
;;              (speedbar-add-supported-extension '("js" "as" "html" "css" "php"))))


;;
;; 拡張機能
;;______________________________________________________________________
;; DiredPlus拡張をロードする
;; (install-elisp "http://www.emacswiki.org/emacs/download/dired+.el")
(require 'dired+)


;; diredを便利にする
(load "dired-x")
(add-hook 'dired-load-hook (lambda () (load "dired-x")))

;; diredから"r"でファイル名をインライン編集する
(load "wdired")
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
(setq wdired-allow-to-change-permissions t)

;; ドライブ一覧の表示, M-x netdir
;; (install-elisp "http://www.bookshelf.jp/elc/mmemo-drive.el")
(when windows-p
  (autoload 'netdir "mmemo-drive" "My computer" t)
  (autoload 'netcomp "mmemo-drive" "My network" t)
  )

;;
;; DiredDetails & DiredDetails+
;;______________________________________________________________________
;;; http://www.emacswiki.org/emacs/DiredDetails
(require 'dired-details+)
;; (setq dired-details-propagate-flag nil)
;; (setq dired-details-hidden-string "")

;;
;; MyDired
;;______________________________________________________________________
;; ソート、ハイライトの拡張設定
(require 'my-dired)

;;; dired のキー割り当て追加
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map "z" 'dired-open-dwim) ; luanch target with window application
            (define-key dired-mode-map "E" 'dired-exec-explorer) ; open with explorer
            (define-key dired-mode-map "Z" 'my-dired-do-compress)
            (define-key dired-mode-map (kbd "C-z o") 'dired-find-file-other-window-as-root)
            (define-key dired-mode-map (kbd "C-z s") 'occur-by-moccur)
            (define-key dired-mode-map (kbd "SPC")   'my-dired-toggle-mark)
            (if linux-p
                (define-key dired-mode-map (kbd "C-z RET") 'dired-find-file-as-root))))
;;; exeplorer or finderを開く
(define-key global-map (kbd "C-z E") 'my-exec-explorer-atpoint)
(define-key dired-mode-map (kbd "C-z E") 'dired-exec-explorer)

;; direx 拡張ライブラリ
;; popwin.elと相性が良いシンプルなディレクトリ・エクスプローラ
;; 記事：http://cx4a.blogspot.com/2011/12/popwineldirexel.html
;; メモ：
;;| キー                 | コマンド                     | 説明                               |
;;|----------------------+------------------------------+------------------------------------|
;;| n, C-n, <down>       | direx:next-node              | 次のノードを選択する               |
;;| p, C-p, <up>         | direx:previous-node          | 前のノードを選択する               |
;;| C-M-n, C-M-<down>    | direx:next-sibling           | 次の兄弟ノードを選択する           |
;;| C-M-p, C-M-<up>      | direx:previous-sibling       | 前の兄弟ノードを選択する           |
;;| ^, C-M-u, C-M-<left> | direx:up-node                | 親ノードを選択する                 |
;;| C-M-d, C-M-<right>   | direx:down-node              | 最初の子ノードを選択する           |
;;| f                    | direx:find-node              | そのノードを現在のウィンドウに開く |
;;| o                    | direx:find-node-other-window | そのノードを別のウィンドウに開く   |
;;| RET                  | direx:maybe-find-node        | そのノードをトグルする             |
;;| q                    | quit-window                  | ウィンドウを閉じる                 |
;;___________________________________________________________________________________________|
;; install --> git clone https://github.com/m2ym/direx-el.git
(require 'direx)
(require 'popwin)

;; direx:direx-modeのバッファをウィンドウ左辺に幅30でポップアップ
;; :dedicatedにtを指定することで、direxウィンドウ内でのバッファの切り替えが
;; ポップアップ前のウィンドウに移譲される
(push '(direx:direx-mode :position left :width 30 :dedicated t)
      popwin:special-display-config)
;;ツリーの表示で使われる罫線の設定
(setq direx:leaf-icon "  "
      direx:open-icon "- "
      direx:closed-icon "+ ")

;;; システムコールでファイルを実行する
(define-key direx:direx-mode-map (kbd "z") 'direx:open-item-x)
(defun direx:open-item-x (&optional item)
  (interactive)
  (setq item (or item (direx:item-at-point!)))
  (let ((filename (direx:file-full-name (direx:item-tree item))))
    (open-file-dwim filename)))

;; 元のコマンド --> dired-jump
(global-set-key (kbd "C-x j") 'direx:jump-to-directory-other-window)
(global-set-key (kbd "C-x C-j") '(lambda () (interactive) (popwin:find-file default-directory)))

;; diredを快適見る
;; M-x dired-jump-other-window
;; (push '(dired-mode :position top) popwin:special-display-config)
;; (remove '(dired-mode :position top) popwin:special-display-config)

(provide 'init_dired)
;;; init_dired.el ends here
