;;; Commentary:

;; format設定

;;; Code:

(message "init_format ...")

;;
;; tab indent
;;______________________________________________________________________

;; TABキーのサイズ設定
;; (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
;; (8 16 24 32 40 48 56 64 72 80 88 96 104 112 120)

;; TAB はスペース 4 個ぶんを基本
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(c-set-offset 'case-label '+)
;; 言語に特化したインデント幅の設定
;; (setq c-indent-level 4)
;; (setq js-indent-level 4)
;; (setq cperl-indent-level 4)
;; (setq perl-indent-level 4)

;;
;; tab action
;;______________________________________________________________________
;; 指定したサイズで選択したリージョンをインデントする
(defun my-indent-rigidly (arg)
  "indent-rigidly でインデント数を後から指定するラッパー関数"
  (interactive "nインデント数: ")
  (indent-rigidly (region-beginning) (region-end) arg)
  )

;; 選択したリージョンを4文字単位でインデントする
(defun my-indent-rigidly-4 ()
  "選択したリージョンを4文字単位で→方向へインデントする."
  (interactive)
  (let (indent-size)
    (setq indent-size 4)
    (save-excursion
      (if mark-active
          (indent-rigidly (region-beginning) (region-end) indent-size)
        (indent-rigidly (line-beginning-position) (line-end-position) indent-size))
      (setq mark-active t deactivate-mark nil)
      )
    )
  )
(global-set-key [(control tab)] 'my-indent-rigidly-4)

;; 選択したリージョンを4文字単位でデインデントする
(defun  my-backtab ()
  "選択したリージョンを4文字単位で左方向へインデントする."
  (interactive)
  (let (indent-size)
    (setq indent-size -4)
    (save-excursion
      (if mark-active
          (indent-rigidly (region-beginning) (region-end) indent-size)
        (indent-rigidly (line-beginning-position) (line-end-position) indent-size))
      (setq mark-active t deactivate-mark nil)
      )
    )
  )

(cond 
 (windows-p (global-set-key [backtab] 'my-backtab))
 (mac-p (global-set-key [S-tab] 'my-backtab))
 )


;; {}を改行してインデント
(fset 'parentheses-and-indent "\C-e {\C-j\C-j\C-i\C-p\C-i")

;;インデントを幅を4にする設定で適当なのは"stroustrup"な気がする
;; 参考リンク：http://w.livedoor.jp/whiteflare503/d/Emacs%20%A5%A4%A5%F3%A5%C7%A5%F3%A5%C8
(add-hook 'c-mode-common-hook     ;;C/C++/Javaなどの共通設定フック
          '(lambda()
             (c-toggle-auto-hungry-state 1)              ;;[←]でカーソルの左側を一気に削除する
             (setq c-auto-newline t)                     ;;全自動インデント
             (define-key c-mode-base-map "\C-m" 'newline-and-indent)
             (define-key c-mode-base-map  (kbd "C-{") 'parentheses-and-indent)
             (setq indent-tabs-mode nil)                 ;;インデントスペースでする
             (c-set-style "stroustrup")                  ;;スタイルはストラウストラップ
             ))

;;
;; outline
;;______________________________________________________________________
;; ;; text-mode の時に outline-minor-mode
;; (add-hook 'text-mode-hook '(lambda () (outline-minor-mode t)))

;; ;; 適当に色付け、知るか
;; (add-hook 'outline-minor-mode-hook
;;           '(lambda()
;;              (highlight-regexp "^\* .*" 'outline-1)
;;              (highlight-regexp "^\*\* .*" 'outline-2)
;;              (highlight-regexp "^\*\*\* .*" 'outline-3)))

;;
;; auto format
;;______________________________________________________________________
;; 貼り付けソースコードを自動Format
(dolist (command '(yank yank-pop))
  (eval
   `(defadvice ,command (after indent-region activate)
      (and (not current-prefix-arg)
           (member major-mode
                   '(emacs-lisp-mode
                     lisp-mode
                     clojure-mode
                     scheme-mode
                     haskell-mode
                     java-mode
                     ruby-mode
                     rspec-mode
                     python-mode
                     c-mode
                     c++-mode
                     objc-mode
                     latex-mode
                     js-mode
                     plain-tex-mode))
           (let ((mark-even-if-inactive transient-mark-mode))
             (indent-region (region-beginning) (region-end) nil))))))

;;
;; downcase & upcase
;;______________________________________________________________________
;; downcaseの有効化
(put 'downcase-region 'disabled nil)
;; upcaseの有効化
(put 'upcase-region 'disabled nil)

;;
;; テキスト整形
;;______________________________________________________________________
;; align で整列
;; http://sks.s201.xrea.com/blog/archives/602
;;(require 'align)

;; 日本語文章の整形
;; (install-elisp "http://taiyaki.org/elisp/mell/src/mell.el")
;; (install-elisp "http://taiyaki.org/elisp/text-adjust/src/text-adjust.el")
;; ■使い方
;; 1) M-x text-adjust を実行すると文章が整形される.
;; 2) 使用可能な関数の概要.
;;     text-adjust-codecheck : 半角カナ, 規格外文字を「〓」に置き換える.
;;     text-adjust-hankaku   : 全角英数文字を半角にする.
;;     text-adjust-kutouten  : 句読点を「, 」「. 」に置き換える.
;;     text-adjust-space     : 全角文字と半角文字の間に空白を入れる.
;;     text-adjust           : これらをすべて実行する.
;;     text-adjust-fill      : 句読点優先で, fill-region をする.
;;    適応範囲はリージョンがある場合はその範囲を,
;;    なければ mark-paragraph で得られた値. 
;;
;;     *-region : 上記関数をリージョン内で実行する.
;;     *-buffer : 上記関数をバッファ内で実行する.
(require 'text-adjust)

;; boxes
;; http://boxes.thomasjensen.com/
;; #!/bin/sh
;; nkf -We | boxes "$@" |nkf -Ew

(provide 'init_format)
;;; init_format.el ends here
