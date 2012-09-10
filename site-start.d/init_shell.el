;;; Commentary:

;; shell 環境設定

;;; Code:

(message "init_shell ...")

;;
;; common setting
;;______________________________________________________________________
;; shell の存在を確認
(defun skt:shell ()
  (or (executable-find "bash")
      (executable-find "zsh")
      ;; (executable-find "f_zsh") ;; Emacs + Cygwin を利用する人は Zsh の代りにこれにしてください
      ;; (executable-find "f_bash") ;; Emacs + Cygwin を利用する人は Bash の代りにこれにしてください
      (executable-find "cmdproxy")
      (error "can't find 'shell' command in PATH!!")))

(when (or linux-p mac-p)
  ;; Shell 名の設定
  (setq shell-file-name (skt:shell))
  (setenv "SHELL" shell-file-name)
  (setq explicit-shell-file-name shell-file-name))

;; coding設定
;; ;; Shell Mode
;; (setq shell-mode-hook
;;       (function (lambda()
;;                   (set-buffer-process-coding-system 'utf-8-unix
;;                                                     'utf-8-unix))))

;; エスケープを綺麗に表示する
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; パスワードの入力を隠す
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;;
;; for cygwin shell
;;______________________________________________________________________

;; http://skalldan.wordpress.com/2011/11/09/ntemacs-%E3%81%A7-utf-8-%E3%81%AA%E7%92%B0%E5%A2%83%E6%A7%8B%E7%AF%89%E3%82%92%E8%A9%A6%E8%A1%8C%E9%8C%AF%E8%AA%A4/
;; Shell Mode
;; (setq shell-mode-hook
;;       (function (lambda()
;;                   (set-buffer-process-coding-system 'utf-8-unix
;;                                                     'utf-8-unix))))

;; ---------------- cygwinとの連携
;; (require 'shell)
;; (setq explicit-shell-file-name "bash.exe")
;; (setq shell-command-switch "-c")
;; (setq shell-file-name "bash.exe")

;; (M-! and M-| and compile.el)
;; (setq shell-file-name "bash.exe")
;; (modify-coding-system-alist 'process ".*sh\\.exe" 'cp932)

;; shellモードの時の^M抑制
;; (add-hook 'comint-output-filter-functions 'shell-strip-ctrl-m nil t)

;; ;; shell-modeでの補完 (for drive letter)
;; (setq shell-file-name-chars "")

;; ;; エスケープシーケンス処理の設定
;; (autoload 'ansi-color-for-comint-mode-on "ansi-color"
;;   "Set `ansi-color-for-comint-mode' to t." t)

;; (setq shell-mode-hook
;;       (function
;;        (lambda ()
;;          ;; シェルモードの入出力文字コード
;;          (set-buffer-process-coding-system 'sjis-dos 'sjis-unix)
;;          (set-buffer-file-coding-system    'sjis-unix)
;;          )))

;; ;; Prevent issues with the Windows null device (NUL)
;; ;; when using cygwin find with rgrep.
;; (defadvice grep-compute-defaults (around grep-compute-defaults-advice-null-device)
;;   "Use cygwin's /dev/null as the null-device."
;;   (let ((null-device "/dev/null"))
;;     ad-do-it))
;; (ad-activate 'grep-compute-defaults)

;; ;; shell-quote-argumentの問題回避
;; (defvar quote-argument-for-windows-p t "enables `shell-quote-argument' workaround for windows.")
;; (defadvice shell-quote-argument (around shell-quote-argument-for-win activate)
;;   "workaround for windows."
;;   (if quote-argument-for-windows-p
;;       (let ((argument (ad-get-arg 0)))
;;         (setq argument (replace-regexp-in-string "\\\\" "\\\\" argument nil t))
;;         (setq argument (replace-regexp-in-string "'" "'\\''" argument nil t))
;;         (setq ad-return-value (concat "'" argument "'")))
;;     ad-do-it))

;;
;; popup shell
;;______________________________________________________________________
;; F10でshellを素早くアクセスする
;; (install-elisp-from-emacswiki "shell-pop.el")
(require 'shell-pop)

;; multi-term に対応
(add-to-list 'shell-pop-internal-mode-list '("multi-term" "*terminal<1>*" '(lambda () (multi-term))))

(shell-pop-set-internal-mode "shell")   ;; multi-term

;; (shell-pop-set-internal-mode-shell "bash")
(global-set-key [f10] 'shell-pop)
;; 高さの調整
;; (setq shell-pop-window-height 100)

;;
;; multi shell
;;______________________________________________________________________
;; 複数のバッファーを利用できるようにする
;; (install-elisp-from-emacswiki "multi-shell.el")
(require 'multi-shell)
(defun mshell()
  (interactive)
  (call-interactively 'multi-shell-new))
;; (setq mutli-shell-command "bash")

;;
;; multi term
;;______________________________________________________________________
;; shellシミュレーション
;; (install-elisp-from-emacswiki "multi-term.el")
(require 'multi-term)
(setq multi-term-program shell-file-name)

;; term 内での文字削除、ペーストを有効にする
(add-hook 'term-mode-hook
          '(lambda ()
             (define-key term-raw-map (kbd "C-h") 'term-send-backspace)
             (define-key term-raw-map (kbd "C-y") 'term-paste)
             ))

;;
;; emux.el
;;  https://github.com/m2ym/emux-el
;;______________________________________________________________________
;; (install-elisp "https://raw.github.com/m2ym/emux-el/master/emux.el")
(autoload 'emux:term "emux" nil t nil)

;;
;; shell history
;;______________________________________________________________________
;; 実行履歴を保存
;; (install-elisp-from-emacswiki "shell-history.el")
(require 'shell-history)
(require 'anything-complete)
;; シェルコマンド履歴補完
(anything-complete-shell-history-setup-key (kbd "C-o"))

;; ;; シェール終了時自動的にバッファーをクローズする
;; (add-hook 'shell-mode-hook 'wcy-shell-mode-hook-func)
;; (defun wcy-shell-mode-hook-func  ()
;;   (set-process-sentinel (get-buffer-process (current-buffer))
;;                         #'wcy-shell-mode-kill-buffer-on-exit)
;;   )
;; (defun wcy-shell-mode-kill-buffer-on-exit (process state)
;;   (message "%s" state)
;;   (if (or
;;        (string-match "exited abnormally with code.*" state)
;;        (string-match "finished" state))
;;       (kill-buffer (current-buffer))
;;     ;;(call-interactively 'my-kill-buffer-and-window)
;;     )
;;   )
;; (defun my-kill-buffer-and-window()
;;   (interactive)
;;   (kill-buffer (current-buffer))
;;   (call-interactively 'delete-window)
;;   )

;;
;; eshell support tools
;;______________________________________________________________________
;; コマンド解釈乗っ取り
;; (require 'esh-myparser)

;; ;; zsh電卓
;; (defun eshell-parser/z (str) (eshell-parser/b str "zsh"))

;; ;; シェルバッファを即時に呼び出し
;; (require 'eshell-pop)

;; eshell履歴保存場所
;;(setq eshell-directory-name (concat my-cache-dir "eshell/"))

(provide 'init_shell)
;;; init_shell.el ends here
