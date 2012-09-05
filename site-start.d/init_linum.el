;;; Commentary:

;; linum設定

;;; Code:

(message "init_linum ...")

(require 'linum)

;; 行番号のフォーマット
;;(set-face-attribute 'linum nil :foreground "HotPink" :height 0.8)
(set-face-attribute 'linum nil :height 0.9)
(setq linum-format "%4d")


;;
;; yalinum 行番号表示にスクロールバー
;;______________________________________________________________________
;;; http://d.hatena.ne.jp/tm8st/20101110/1289405603
;;; http://sheephead.homelinux.org/2011/03/25/6706/

(require 'yalinum)

;; ;;フックにかける
;; (dolist (hook (list
;;                'c-mode-hook
;;                'emacs-lisp-mode-hook
;;                'lisp-interaction-mode-hook
;;                'lisp-mode-hook
;;                'java-mode-hook
;;                'haskell-mode-hook
;;                'sh-mode-hook
;;                'python-mode-hook
;;                'ess-mode-hook
;;                'inferior-ess-mode-hook
;;                'lua-mode-hook
;;                'scala-mode-hook))
;;   (add-hook hook '(lambda ()
;;                     (yalinum-mode 1))))

;;yalinumの背景色の設定
(set-face-background 'yalinum-bar-face "DarkOliveGreen")

;; 行番号表示・非表示
(global-set-key [f11] 'linum-mode)

(defalias 'linum-mode 'yalinum-mode)

;; メージャーモード/マイナーモードでの指定
;; (setq my-linum-hook-name '(emacs-lisp-mode-hook slime-mode-hook sh-mode-hook text-mode-hook
;;                                                 php-mode-hook python-mode-hook ruby-mode-hook
;;                                                 css-mode-hook yaml-mode-hook org-mode-hook
;;                                                 howm-mode-hook js2-mode-hook javascript-mode-hook
;;                                                 smarty-mode-hook html-helper-mode-hook))

;; ファイル名での判定
;;(setq my-linum-file '("hosts" "my_site"))

;; 拡張子での判定
;;(setq my-linum-file-extension '("el" "bat"))

;; メージャーモード/マイナーモードでの指定
(defvar my-linum-hook-name nil)
(mapc (lambda (hook-name)
        (add-hook hook-name (lambda () (linum-mode t))))
      my-linum-hook-name)

;; ファイル名での判定
(defvar my-linum-file nil)
(defun my-linum-file-name ()
  (when (member (buffer-name) my-linum-file)
    (linum-mode t)))
(add-hook 'find-file-hook 'my-linum-file-name)

;; 拡張子での判定
(defvar my-linum-file-extension nil)
(defun my-linum-file-extension ()
  (when (member (file-name-extension (buffer-file-name)) my-linum-file-extension)
    (linum-mode t)))
(add-hook 'find-file-hook 'my-linum-file-extension)

;;(line-number-mode t)
;;(global-linum-mode t)

(provide 'init_linum)
;;; init_linum.el ends here
