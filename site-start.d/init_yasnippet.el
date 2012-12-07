;;; Commentary:

;; yasnippet自動補完

;;; Code:

(message "init_yasnippet ...")

;;
;; yasnippet 補完設定
;;______________________________________________________________________
;; http://code.google.com/p/yasnippet/
;; wget http://yasnippet.googlecode.com/files/yasnippet-0.6.1c.tar.bz2
(require 'yasnippet)
(setq yas/snippet-dirs
      '(
        "~/.emacs.d/share/snippets"
        ;;"~/.emacs.d/snippets"
        ;;"~/.emacs.d/extras/imported"
        ))

;; (yas--initialize)
;; (yas-global-mode 1)
(yas-reload-all)

(defvar yas-mode-hooks '(c++-mode-hook
                         c-mode-hook
                         cc-mode-hook
                         cperl-mode-hook
                         csharp-mode-hook
                         css-mode-hook
                         emacs-lisp-mode-hook
                         erlang-mode-hook
                         ess-mode-hook
                         f90-mode-hook
                         html-mode-hook
                         java-mode-hook
                         latex-mode-hook
                         markdown-mode-hook
                         nxml-mode-hook
                         objc-mode-hook
                         org-mode-hook
                         perl-mode-hook
                         python-mode-hook
                         rst-mode-hook
                         ruby-mode-hook
                         scala-mode-hook
                         sql-mode-hook
                         ;; text-mode-hook
                         weblogger-entry-mode-hook))

(dolist (mode-hook yas-mode-hooks)
  (add-hook mode-hook 'yas-minor-mode-on))

;; ;; 補完snippetローディング関数
;; (defun my-load-directory (dir-name)
;;   (yas/load-directory
;;    (concat user-emacs-directory
;;            "lisp/yasnippet-0.6.1c/my_snippets/" dir-name)))

;; ac情報源をyasnippet
;;(yas/load-directory (concat user-emacs-directory "lisp/auto-complete/dict"))
;;(add-to-list 'ac-dictionary-directories (concat my-private-emacs-path "configuration/ac-dicts"))

;; ;; elisp補完
;; (add-hook 'emacs-lisp-mode-hook (lambda () (my-load-directory "emacs-lisp-mode")))
;; ;; org-mode補完
;; (add-hook 'org-mode-hook (lambda () (my-load-directory "org-mode")))
;; ;; java-mode補完
;; (add-hook 'java-mode-hook (lambda () (my-load-directory "java-mode")))

;; (yas/load-directory (concat my-private-emacs-path "configuration/snippets"))
;; (setq yas/prompt-functions '( yas/dropdown-prompt yas/x-prompt  yas/ido-prompt yas/completing-prompt)) ;;置提示方式，文本/X

;;------  yasnippet-config ac-sourceに影響があるため、コメントアウトしました。
;; 使い捨てのSnippetを簡単に定義できるようにする
;; (install-elisp "http://www.emacswiki.org/emacs/download/yasnippet-config.el")
;; (require 'yasnippet-config)
;; (global-set-key (kbd "C-x y") 'yas/register-oneshot-snippet)
;; (global-set-key (kbd "C-x C-y") 'yas/expand-oneshot-snippet)

(provide 'init_yasnippet)
;;; init_yasnippet.el ends here
