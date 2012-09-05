;;; init_ruby.el --- configuration ruby mode

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: languages, ruby

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

;; 

;;; Code:

;;
;; ruby-mode
;; https://github.com/ruby/ruby
;;______________________________________________________________________
;;; install
;; (install-elisp "https://raw.github.com/ruby/ruby/trunk/misc/ruby-electric.el")
;; (install-elisp "https://raw.github.com/ruby/ruby/trunk/misc/inf-ruby.el")
;; (install-elisp "http://www.emacswiki.org/emacs/download/ruby-block.el")
;;; ruby-modeのインデント設定
(setq ruby-indent-level 3               ;インデント幅を３に。初期値は２
      ruby-deep-indent-paren-style nil  ;改行時のインデントを調整する
      ;; ruby-mode実行時にindent-tabs-modeを設定値に変更
      ruby-indent-tabs-mode t           ;タブ文字を使用する。初期値nil
      )

;;; インタラクティブRubyを利用する
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")

(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")

;;; ruby-mode-hook関数
(defun init-ruby-mode ()
  ;; 括弧の自動挿入
  (require 'ruby-electric nil t)
  ;; endに対応する行のハイライト
  (when (require 'ruby-block nil t)
    (setq ruby-block-highlight-toggle t))
  (inf-ruby-keys)
  (ruby-electric-mode t)
  (ruby-block-mode t))

;;; ruby-mode-hookに追記
(add-hook 'ruby-mode-hook 'init-ruby-mode)

;;
;; flymake for ruby
;;______________________________________________________________________
;;; TODO use flymake-ruby
(require 'flymake)

;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))

(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook
 'ruby-mode-hook
 '(lambda ()
    ;; Don't want flymake mode for ruby regions in rhtml files
    (if (not (null buffer-file-name)) (flymake-mode))))

(provide 'init_ruby)
;;; init_ruby.el ends here
