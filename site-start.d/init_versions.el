;;; init_versions.el --- vc configuration

;; Copyright (C) 2011  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 履歴取得、VC支援(バージョン管理)

;;; Code:

(message "init_versions ...")

;;
;; generic setting for vc
;;______________________________________________________________________
;; 履歴バッファーのキーバンドを変更する
(add-hook 'log-view-mode-hook
          (lambda ()
            (local-set-key (kbd "RET") 'log-view-find-revision) ;該当行のリビジョンを取得
            (local-set-key (kbd "=") 'log-view-diff)            ;リビジョン間の差分を見る
            (local-set-key (kbd "g") 'log-view-annotate-version) ;該当リビジョンの注釈を表示する
            (local-set-key (kbd "e") 'log-view-ediff)))          ;ediffで差分を見る
;; 注釈バッファーのキーバンドを変更する
(add-hook 'vc-annotate-mode-hook
          (lambda ()
            (local-set-key (kbd "RET") 'vc-annotate-find-revision-at-line) ;該当行のリビジョンを取得
            (local-set-key (kbd "=") 'vc-annotate-show-diff-revision-at-line) ;該当行の差分を表示する
            (local-set-key (kbd "g") 'vc-annotate-revision-at-line))) ;該当行の注釈を表示する

;; 差分をediffで見るカスタマイズ関数
(defun log-view-ediff (beg end &optional startup-hooks)
  (interactive
   (list (if mark-active (region-beginning) (point))
         (if mark-active (region-end) (point))))
  (let ((fr (log-view-current-tag beg))
        (to (log-view-current-tag end)))
    (when (string-equal fr to)
      (save-excursion
        (goto-char end)
        (log-view-msg-next)
        (setq to (log-view-current-tag))))
    (require 'ediff-vers)
    (ediff-vc-internal fr to startup-hooks)))

(defun log-view-ediff-setup ()
  (set (make-local-variable 'ediff-keep-tmp-versions) t))

(defvar log-view-ediff-window-configuration nil)
(defun log-view-ediff-before-setup ()
  (setq log-view-ediff-window-configuration
        (if (eq this-command 'log-view-ediff)
            (current-window-configuration)
          nil)))
(defun log-view-ediff-cleanup ()
  (when log-view-ediff-window-configuration
    (ignore-errors
      (set-window-configuration log-view-ediff-window-configuration)))
  (setq log-view-ediff-window-configuration nil))

(require 'ediff-init)
(add-hook 'ediff-mode-hook 'log-view-ediff-setup)
(add-hook 'ediff-before-setup-hook 'log-view-ediff-before-setup)
;; add it after ediff-cleanup-mess
(add-hook 'ediff-quit-hook 'log-view-ediff-cleanup t)

;; ;;
;; ;; psvn
;; ;; http://emacswiki.org/emacs/SvnStatusMode
;; ;;______________________________________________________________________
;; ;;; (install-elisp "http://www.xsteve.at/prg/emacs/psvn.el")
;; (when (executable-find "svn")
;;   (autoload 'svn-status "psvn" "Run `svn status'." t)
;;   (autoload 'svn-update "psvn" "Run `svn update'." t)
;;   (eval-after-load "psvn"
;;     '(progn
;;        ;; O v で切り替える
;;        (setq svn-status-verbose nil)    ;速度がアップする
;;        (setq svn-status-hide-unmodified nil)
;;        (setq svn-status-hide-unknown nil)
;;        ;; ログにファイル名を出さない
;;        ;; (setq svn-status-default-log-arguments nil)
;;        (setq svn-status-svn-process-coding-system 'utf-8)
;;        (setq process-coding-system-alist '(("svn" . utf-8)))
;;        (setq svn-status-svn-file-coding-system 'utf-8)
;;        )))

;; ;; Subversionで管理しているファイルを開くとPSVNマイナーモードを有効にする
;; ;; プレフィクスをC-z vにする
;; (defun define-svn-minor-mode ()
;;   ;;(interactive)
;;   (require 'psvn)
;;   (define-minor-mode svn-minor-mode
;;     "Subversion Minor Mode."
;;     :global nil
;;     :lighter " PSVN"
;;     :keymap (list (cons (kbd "C-z v") svn-global-keymap)))
;;   (define-key svn-global-keymap "l" 'svn-status-show-svn-log)
;;   (define-key svn-global-keymap "g" 'svn-status-blame)
;;   (define-key svn-global-keymap "e" 'svn-file-show-svn-ediff))

;; (defun svn-find-file-hook ()
;;   (when (eq (vc-backend default-directory) 'SVN)
;;     (if (not (functionp 'svn-minor-mode))
;;         (define-svn-minor-mode))
;;     (svn-minor-mode 1)))
;; (add-hook 'find-file-hook 'svn-find-file-hook)

;;
;; dsvn
;;______________________________________________________________________
;;; (list-packages) install dsvn
;;; or install from (install-elisp "http://svn.apache.org/repos/asf/subversion/trunk/contrib/client-side/emacs/psvn.el")
(when (executable-find "svn")
  (autoload 'svn-status "dsvn" "Run `svn status'." t)
  (autoload 'svn-update "dsvn" "Run `svn update'." t)
  (eval-after-load "dsvn"
    ;; load my custom elisp code
    '(progn
       (defvar svn-process-internal-coding nil)
       (defvar svn-commit-file-coding "UTF-8")
       (require 'my-dsvn)
       (setq my-svn-commit-msg-template (my-private-file "/configuration/.svn-commit-msg")))))

;;
;; tortoise-svn.el
;;______________________________________________________________________
;;; (install-elisp "http://www.emacswiki.org/emacs/download/tortoise-svn.el")
(when (and windows-p (require 'tortoise-svn nil t))
  (defalias 'tsvn-update 'tortoise-svn-update)
  (defalias 'tsvn-update-select 'tortoise-svn-update-select)
  (defalias 'tsvn-log 'tortoise-svn-log)
  (defalias 'tsvn-log-select 'tortoise-svn-log-select)
  (defalias 'tsvn-diff 'tortoise-svn-diff)
  (defalias 'tsvn-blame 'tortoise-svn-blame)
  (defalias 'tsvn-browser 'tortoise-svn-repobrowser)
  (defalias 'tsvn-commit 'tortoise-svn-commit)
  (defalias 'tsvn-commit-select 'tortoise-svn-commit-select)
  (defalias 'tsvn-status 'tortoise-svn-repostatus)
  (defalias 'tsvn-status-select 'tortoise-svn-repostatus-select)
  (defalias 'tsvn-revert 'tortoise-svn-revert)
  (defalias 'tsvn-revert-select 'tortoise-svn-revert-select)
  (defalias 'tsvn-help 'tortoise-svn-help)

  ;; add 123 menu support
  (require '123-menu)
  (123-menu-defmenu marc-menu-tsvn
                    ("u" "[u]update"        'tsvn-update)
                    ("U" "[U]update-select" 'tsvn-update-select)
                    ("l" "[l]log"           'tsvn-log)
                    ("L" "[L]log-select"    'tsvn-log-select)
                    ("=" "[=]diff"          'tsvn-diff)
                    ("b" "[b]blame"         'tsvn-blame)
                    ("B" "[B]browser"      'tsvn-browser)
                    ("c" "[c]commit"        'tsvn-commit)
                    ("C" "[C]commit-select" 'tsvn-commit-select)
                    ("s" "[s]status"        'tsvn-status)
                    ("S" "[S]status-select" 'tsvn-status-select)
                    ("r" "[r]revert"        'tsvn-revert)
                    ("R" "[R]revert-select" 'tsvn-revert-select)
                    ("h" "[h]help"          'tsvn-help))

  (define-key global-map (kbd "C-x v t") '123-menu-display-menu-marc-menu-tsvn))

;;
;; junk file, file snapshot
;;______________________________________________________________________
;; open-junk-file.el 使い捨てのファイルを開く
;;  M-x (install-elisp-from-emacswiki "open-junk-file.el")
;;  Usage: M-x open-junk-file
;; 参考リンク：http://d.hatena.ne.jp/rubikitch/20080923/1222104034
(require 'open-junk-file)
(setq open-junk-file-format (concat my-private-emacs-path "junk/%Y-%m-%d-%H%M%S."))
(define-key global-map (kbd "C-x M-j") 'open-junk-file)

;; multiverse.elで現在のファイルのスナップショットを取る
;; (install-elisp-from-emacswiki "multiverse.el")
(require 'multiverse)


;;
;; ipa ファイルに直接メモを取る
;;______________________________________________________________________
;;; install from emacswiki
;; (install-elisp-from-emacswiki "ipa.el")
;; (install-elisp-from-emacswiki "anything-ipa.el")
;; (require 'ipa)
;; (require 'anything-ipa)
;; (setq ipa-file (my-cache-dir ".ipa"))

(provide 'init_versions)
;;; init_versions.el ends here
