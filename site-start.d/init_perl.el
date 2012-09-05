;;; init_perl.el --- configuration for perl/cperl-mode

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: languages, perl

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
;; cperl-mode
;;______________________________________________________________________
;; cperl-modeをデフォルトモードにする
;; (defalias 'perl-mode 'cperl-mode)

(setq cperl-indent-level 4              ;インデント幅を４にする
      cperl-continued-statement-offset 4 ;連続する文のオフセット
      cperl-brace-offset -4             ;ブレースのオフセット
      cperl-label-offset -4             ;labelのオフセット
      cperl-indent-parens-as-block t    ;括弧もブロックとしてインデント
      cperl-close-paren-offset 4        ;閉じる括弧のオフセット
      cperl-tab-always-indent t         ;TABをインデントにする
      cperl-highlight-variables-indiscriminately t ;スカラを常にハイライト
      )

;;
;; perl-completion
;; https://github.com/imakado/perl-completion
;;______________________________________________________________________
(defun init-perl-completion ()
  (when (require 'perl-completion nil t)
    (perl-completion-mode t)
    (when (require 'auto-complete nil t)
      (make-variable-buffer-local 'ac-sources)
      ;; auto-complete補完ソースの設定
      (add-to-list 'ac-sources 'ac-source-perl-completion)
      (auto-complete-mode t))))

(add-hook 'cperl-mode-hook 'init-perl-completion)
(add-hook 'perl-mode-hook 'init-perl-completion)

;;
;; flymakeによる文法チェック
;;______________________________________________________________________
(add-hook 'cperl-mode-hook '(lambda () (flymake-mode t)))
(add-hook 'perl-mode-hook '(lambda () (flymake-mode t)))

;;
;; yaml-mode
;;______________________________________________________________________
(when (require 'yaml-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode)))

(provide 'init_perl)
;;; init_perl.el ends here
