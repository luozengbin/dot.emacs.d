;;; Commentary:

;; マクロ関連のカスタマイズ

;;; Code:

(message "init_kmacro ...")

;;
;; save kmacro setting
;;______________________________________________________________________
;; 定義したマクロの永続化をできるようにする
;; マクロの保存先
(setq my-kmacro-file (concat my-private-emacs-path "lisp/my-kmacro.el"))
(defvar kmacro-save-file my-kmacro-file "キーボードマクロを保存するファイル")
(defun kmacro-save (symbol)
  (interactive "SName for last kbd macro: ")
  (name-last-kbd-macro symbol)
  (with-current-buffer (find-file-noselect kmacro-save-file)
    (goto-char (point-max))
    (insert-kbd-macro symbol)
    (basic-save-buffer)
    )
  )

(require 'my-kmacro)


;;
;; Dynamic Macro
;;______________________________________________________________________
;; http://www.pitecan.com/DynamicMacro/
;; (install-elisp "http://www.pitecan.com/DynamicMacro/dmacro.el")

(defconst *dmacro-key*  (kbd "C-<f7>") "繰返し指定キー")
(global-set-key *dmacro-key* 'dmacro-exec)
(autoload 'dmacro-exec "dmacro" nil t)

(provide 'init_kmacro)
;;; init_kmacro.el ends here
