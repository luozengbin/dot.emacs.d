;;; Commentary:

;; パッケージ管理、自動インストールなど

;;; Code:

(message "init_package ...")

(defun init_package ()
  "running package management elisp script"
  (interactive)
  (message "init_package completed!"))

;; elispのインストール自動化
;; wget http://www.emacswiki.org/emacs/download/auto-install.el
(require 'auto-install)
(setq auto-install-directory (concat user-emacs-directory "lisp/auto-install-lisp/"))
(auto-install-compatibility-setup)

;; 起動時にEmacsWikiのページ名を補完候補に加える
;; (auto-install-update-emacswiki-package-name t)

;; anythingインタフェースでauto-installを使用する
(when (require 'auto-install nil t)
  (require 'anything-auto-install nil t)
)

;;
;; ELPA
;; tips: http://xahlee.org/emacs/emacs_package_system.html
;;______________________________________________________________________
;;; install for emacs 23 (auto-install-from-url "http://tromey.com/elpa/package-install.el")
(when emacs23-p
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el")))

(require 'package)
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)

;;
;; el-get
;;______________________________________________________________________
;; http://shishithefool.blogspot.jp/2012/04/el-get-emacs.html
;; https://github.com/dimitri/el-get/blob/master/README.asciidoc
;;; install el-get
;; (url-retrieve
;;  "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
;;  (lambda (s)
;;    (end-of-buffer)
;;    (eval-print-last-sexp)))
;; (require 'el-get)

(provide 'init_package)
;;; init_package.el ends here

