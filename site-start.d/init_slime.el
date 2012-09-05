;;; init_slime.el --- auto configuration for slime

;; Copyright (C) 2012  LuoZengbin

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

;; 

;;; Code:

;; Clozure CLをデフォルトのCommon Lisp処理系に設定
;; (setq inferior-lisp-program "clisp" ;; "ccl")

;; SBCL処理系に設定
(load (expand-file-name "~/quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")

;; SLIMEのオートロード設定
(require 'slime-autoloads)

(eval-after-load "slime"
  '(progn
    (slime-setup '(slime-repl slime-fancy slime-banner))
    ;; ac-slimeによる補完する
    (require 'ac-slime)
    (add-hook 'slime-mode-hook 'set-up-slime-ac)
    (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)

    ;; popwinでslime関連windowを管理する
    ;; (require 'popwin)
    ;; ;; Apropos
    ;; (push '("*slime-apropos*") popwin:special-display-config)
    ;; ;; Macroexpand
    ;; (push '("*slime-macroexpansion*") popwin:special-display-config)
    ;; ;; Help
    ;; (push '("*slime-description*") popwin:special-display-config)
    ;; ;; Compilation
    ;; (push '("*slime-compilation*" :noselect t) popwin:special-display-config)
    ;; ;; Cross-reference
    ;; (push '("*slime-xref*") popwin:special-display-config)
    ;; ;; Debugger
    ;; (push '(sldb-mode :stick t) popwin:special-display-config)
    ;; ;; REPL
    ;; (push '(slime-repl-mode) popwin:special-display-config)
    ;; ;; Connections
    ;; (push '(slime-connection-list-mode) popwin:special-display-config)
    ))

(provide 'init_slime)
;;; init_slime.el ends here
