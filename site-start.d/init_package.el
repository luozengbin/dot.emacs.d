
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
;; (when emacs23-p
;;     (load
;;      (expand-file-name "~/.emacs.d/elpa/package.el")))

(require 'package)
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("org" . "http://orgmode.org/elpa/")))

(setq package-enable-at-startup nil)
(package-initialize)

;;; パッケージの自動インストール
(defvar installing-package-list
  '(
    ;; ac-slime                 ; An auto-complete source using slime completions [source: github]
    ace-jump-mode            ; a quick cursor location minor mode for emacs [source: github]
    apel                     ; APEL (A Portable Emacs Library) provides support for portable Emacs Lisp programs
    anzu                     ; Show number of matches in mode-line while searching
    autopair                 ; Automagically pair braces and quotes like TextMate [source: github]
    bm                       ; Visible bookmarks in buffer. [source: github]
    browse-kill-ring         ; interactively insert items from kill-ring [source: github]
    c-eldoc                  ; helpful description of the arguments to C functions [source: github]
    cacoo                    ; Minor mode for Cacoo : http://cacoo.com
    calfw                    ; Calendar view framework on Emacs [source: github]
    calfw-gcal               ; edit Google calendar for calfw.el. [source: github]
    col-highlight            ; Highlight the current column.
    color-moccur             ; multi-buffer occur (grep) mode [source: github]
    concurrent               ; Concurrent utility functions for emacs lisp [source: github]
    ;; crosshairs               ; Highlight the current line and column. [source: wiki]
    clippy                   ; Show tooltip with function documentation at point
    ctable                   ; Table component for Emacs Lisp [source: github]
    ctags                    ; Exuberant Ctags utilities for Emacs [source: hg]
    cursor-chg               ; Change cursor dynamically, depending on the context. [source: wiki]
    dash                     ; A modern list library for Emacs [source: github]
    deferred                 ; Simple asynchronous functions for emacs lisp [source: github]
    dic-lookup-w3m           ; look up dictionaries on the Internet [source: svn]
    diminish                 ; Diminished modes are minor modes with no modeline display [source: github]
    dired+                   ; Extensions to Dired. [source: wiki]
    ;; dired-details            ; Make file details hide-able in dired [source: wiki]
    ;; dired-details+           ; Enhancements to library `dired-details+.el'. [source: wiki]
    dsvn                     ; Subversion interface [source: svn]
    edit-list                ; edit a single list
    ;; egg                      ; Emacs Got Git - Emacs interface to Git [source: github]
    epc                      ; A RPC stack for the Emacs Lisp [source: github]
    ess                      ; No description available. [source: github]
    expand-region            ; Increase selected region by semantic units. [source: github]
    flymake-easy             ; Helpers for easily building flymake checkers [source: github]
    flymake-jslint           ; A flymake handler for javascript using jslint [source: github]
    fold-dwim                ; No description available. [source: github]
    fringe-helper            ; helper functions for fringe bitmaps [source: github]
    gh                       ; A GitHub library for Emacs [source: github]
    gist                     ; Emacs integration for gist.github.com [source: github]
    gnuplot                  ; drive gnuplot from within emacs [source: github]
    golden-ratio             ; Automatic resizing of Emacs windows to the golden ratio [source: github]
    google-contacts          ; Support for Google Contacts in Emacs [source: git]
    google-maps              ; Access Google Maps from Emacs [source: git]
    google-translate         ; Emacs interface to Google Translate [source: github]
    ;; google-weather           ; Fetch Google Weather forecasts. [source: git]
    goto-chg                 ; goto last change [source: wiki]
    grep-a-lot               ; manages multiple search results buffers for grep.el [source: github]
    grep-o-matic             ; available  auto grep word under cursor
    ;groovy-mode             ; Groovy mode derived mode [source: bzr]
    gtags                    ; gtags facility for Emacs
    guide-key                ; Guide the following key bindings automatically and dynamically [source: github]
    helm                     ; Helm is an Emacs incremental and narrowing framework [source: github]
    helm-ag                  ; the silver searcher with helm interface
    helm-c-yasnippet         ; helm source for yasnippet.el [source: github]
    helm-descbinds           ; available  Yet Another `describe-bindings' with `helm'. [github]
    helm-gist                ; helm-sources and some utilities for gist. [source: github]
    helm-git                 ; Helm extension for Git. [source: github]
    helm-gtags               ; GNU GLOBAL helm interface [source: github]
    helm-migemo              ; Migemo plug-in for helm [source: github]
    highlight-parentheses    ; highlight surrounding parentheses [source: github]
    htmlize                  ; Convert buffer text and decorations to HTML. [source: git]
    igrep                    ; An improved interface to `grep` and `find`
    image-dired+             ; Image-dired extensions
    inf-ruby                 ; Run a ruby process in a buffer [source: github]
    info+                    ; Extensions to `info.el'. [source: wiki]
    inlineR                  ; insert Tag for inline image of R graphics [source: github]
    japanese-holidays        ; calendar functions for the Japanese calendar
    js2-mode                 ; an improved JavaScript editing mode [source: github]
    jira                     ; Connect to JIRA issue tracking software
    key-chord                ; map pairs of simultaneously pressed keys to commands [source: wiki]
    key-combo                ; map key sequence to commands
    keywiz                   ; available Emacs key sequence quiz
    litable                    ; dynamic evaluation replacement with emacs [github]
    load-theme-buffer-local  ; Install emacs24 color themes by buffer. [source: github]
    logito                   ; logging library for Emacs [source: github]
    magit                    ; Control Git from Emacs. [source: github]
    mark-multiple            ; Sorta lets you mark several regions at once. [source: github]
    markdown-mode            ; Emacs Major mode for Markdown-formatted text files [source: github]
    memory-usage             ; Analyze the memory usage of Emacs in various ways
    migemo                   ; Japanese incremental search through dynamic pattern expansion [github]
    mew                      ; Messaging in the Emacs World [github]
    moz                      ; Lets current buffer interact with inferior mozilla.
    multiple-cursors         ; Multiple cursors for Emacs. [source: github]
    nyan-mode                ; Nyan Cat shows position in current buffer in mode-line.
    org                      ; available Outline-based notes management and organizer [git]
    org-plus-contrib         ; Outline-based notes management and organizer
    o-blog                   ; Org-blog exporter [source: github]
    oauth2                   ; OAuth 2.0 Authorization Protocol
    org-jekyll               ; Export jekyll-ready posts form org-mode entries [source: github]
    org2blog                 ; Blog from Org mode to wordpress [source: github]
    org-octopress              ; available Compose octopress articles using org-mode.
    paredit                  ; minor mode for editing parentheses [source: darcs]
    pcache                   ; persistent caching for Emacs [source: github]
    php-mode                 ; major mode for editing PHP code [source: github]
    pkgbuild-mode            ; Interface to the ArchLinux package manager
    plantuml-mode            ; Major mode for plantuml
    pos-tip                  ; Show tooltip at point -*- coding: utf-8 -*-
    powerline                ; Rewrite of Powerline [source: github]
    pymacs                   ; Interface between Emacs Lisp and Python
    python-mode              ; Python major mode
    quickrun                 ; Run commands quickly [source: github]
    rainbow-mode             ; Colorize color names in buffers [source: github]
    redo+                    ; Redo/undo system for Emacs [source: wiki]
    repository-root          ; available  deduce the repository root directory for a given file
    revive                   ; Resume Emacs [source: github]
    rfringe                  ; display the relative location of the region, in the fringe. [source: wiki]
    visual-regexp            ; A regexp/replace command for Emacs with interactive visual feedback
    ruby-block               ; highlight matching block [source: wiki]
    ruby-electric            ; electric editing commands for ruby files [source: github]
    smartrep                 ; Support sequential operation which omitted prefix keys. [source: github]
    smex                     ; M-x interface with Ido-style fuzzy matching. [source: github]
    smooth-scroll            ; Minor mode for smooth scrolling and in-place scrolling. [source: github]
    sr-speedbar              ; Same frame speedbar [source: wiki]
    stem                     ; - routines for stemming [source: github]
    ;; svg-clock                ; Analog clock using Scalable Vector Graphics
    systemtap-mode           ; A mode for SystemTap
    tabbar                   ; Display a tab bar in the header line  -*-no-byte-compile: t; -*-
    twittering-mode          ; Major mode for Twitter [source: github]
    undo-tree                ; Treat undo history as a tree [source: git]
    vline                    ; show vertical line (column highlighting) mode.
    w3m                      ; an Emacs interface to w3m [source: github]
    wgrep                    ; Writable grep buffer and apply the changes to files [source: github]
    windresize               ; Resize windows interactively
    xml-rpc                  ; An elisp implementation of clientside XML-RPC [source: bzr]
    yaml-mode                ; Major mode for editing YAML files [source: github]
    yaoddmuse                ; Yet another oddmuse for Emacs [source: wiki]
    yascroll                 ; Yet Another Scroll Bar Mode
    popwin
    ztree                      ;text-tree applications
    ;; hl-line+
    ;; helm-R
    ;; helm-descbinds
    ;; helm-projectile
    ;; hexrgb
    ))

;; switch package by version
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
