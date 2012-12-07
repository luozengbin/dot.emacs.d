;;; init_logview.el --- log viewer configuration

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

;; ログ監視支援

;;; Code:

;;
;; tail mode
;;______________________________________________________________________
;; .log .out tailモードで開く
(setq my-tail-file-extension '("log" "out"))
(defun my-auto-revert-tail1-mode-on ()
  (interactive)
  (when (member (file-name-extension (buffer-file-name)) my-tail-file-extension)
    (auto-revert-tail-mode t)))
(add-hook 'find-file-hook 'my-auto-revert-tail1-mode-on)

;;
;; key word highlight
;;______________________________________________________________________
;; 特定のキーワードをハイライト表示するには、次のコードを追記し、
;; M-x my-keep-highlight-regexp すれば、対象とする語を指定できます。
;; 参考サイト：http://d.hatena.ne.jp/kitokitoki/20100706/p1
(make-face 'my-highlight-face)
(set-face-foreground 'my-highlight-face "black")
(set-face-background 'my-highlight-face "yellow")
(setq my-highlight-face 'my-highlight-face)

(defun my-keep-highlight-regexp (re)
  (interactive "sRegexp: \n")
  (setq my-highlight-keyword re)
  (my-keep-highlight-set-font-lock my-highlight-keyword))

(defun my-keep-highlight-symbole-at-point ()
  (interactive)
  (setq my-highlight-keyword (or (thing-at-point 'symbol) ""))
  (my-keep-highlight-set-font-lock my-highlight-keyword))

(defun my-keep-highlight-set-font-lock (re)
  (font-lock-add-keywords 'nil (list (list re 0 my-highlight-face t)))
  (font-lock-fontify-buffer))

(defun my-cancel-highlight-regexp ()
  (interactive)
  (font-lock-remove-keywords 'nil (list (list my-highlight-keyword 0 my-highlight-face t)))
  (font-lock-fontify-buffer))

(key-chord-define-global "hl" 'my-keep-highlight-regexp)

;;
;; tail拡張
;;______________________________________________________________________
;; ログ監視ツール
;; http://www.emacswiki.org/emacs/TailEl
;; (install-elisp "http://www.emacswiki.org/emacs/download/tail.el")
(require 'tail)

(provide 'init_logview)
;;; init_logview.el ends here
