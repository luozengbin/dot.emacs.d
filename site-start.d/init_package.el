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

(setq package-enable-at-startup nil)
(package-initialize)

;;; パッケージの自動インストール
(defvar installing-package-list
  '(sr-speedbar
    revive
    ac-slime
    ace-jump-mode
    ctags
    dsvn
    smooth-scroll
    undo-tree
    yascroll
    popwin
    pos-tip
    key-combo
    key-chord
    smartrep
    paredit
    wgrep
    powerline
    oauth2
    quickrun
    twittering-mode
    google-weather
    google-maps
    google-contacts
    deferred
    calfw
    calfw-gcal
    concurrent
    cacoo
    ctable
    egg
    logito
    pcache
    gh
    gist
    magit
    groovy-mode
    js2-mode
    php-mode
    markdown-mode
    memory-usage
    ;; hl-line+
    highlight-parentheses
    col-highlight
    crosshairs
    vline
    pymacs
    python-mode
    rainbow-mode
    rfringe
    fringe-helper
    smex
    svg-clock
    yaml-mode
    expand-region
    mark-multiple
    multiple-cursors
    helm
    ;; helm-R
    helm-c-moccur
    helm-c-yasnippet
    ;; helm-descbinds
    helm-gist
    helm-git
    helm-gtags
    helm-migemo
    ;; helm-projectile
    o-blog
    org2blog
    org-jekyll
    gnuplot
    ess
    google-translate
    xml-rpc
    yaoddmuse
    windresize
    ruby-block
    ruby-electric
    inf-ruby
    inlineR
    image-dired+
    htmlize
    info+
    igrep
    ;; hexrgb
    grep-a-lot
    goto-chg
    fold-dwim
    epc
    edit-list
    dired+
    diminish
    cursor-chg
    css-mode
    autopair
    bm
    browse-kill-ring
    c-eldoc
    color-moccur
    redo+
    flymake-jslint
    gtags))

;;; switch package by version
(add-to-list 'installing-package-list
             (cond
              (emacs23-p 'color-theme-buffer-local)
              (emacs24-p 'load-theme-buffer-local)))

;;; install package
(let ((not-installed (loop for x in installing-package-list
                           when (not (package-installed-p x))
                           collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (if (not (package-installed-p pkg))
	  (package-install pkg)))))

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

