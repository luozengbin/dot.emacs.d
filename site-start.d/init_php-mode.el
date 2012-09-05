;;; init_php-mode.el --- configuration for php mode

;; Copyright (C) 2011  Zouhin.Ro

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: php

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
;; php-mode
;; git submodule add https://github.com/ejmr/php-mode.git lisp/php-mode
;;______________________________________________________________________
(when (require 'php-mode nil t)
  ;; 拡張子が*.tplと*.incはphp-modeにする
  (add-to-list 'auto-mode-alist '("\\.tpl$" . php-mode))
  (add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
  (add-to-list 'auto-mode-alist '("\\.ctp$" . php-mode)))

;; php-mode初期設定
(defun init-php-mode ()
  ;;php-modeの時は文字コードをEUC-JPにする
  (set-default-coding-systems     'utf-8)
  (set-buffer-file-coding-system  'utf-8)
  (set-terminal-coding-system     'utf-8)
  ;;オンラインドキュメント
  (setq php-search-url "http://www.php.net/ja/")
  (setq php-manual-url "http://www.php.net/manual/ja/")
  ;;php-mode時のタブの調整
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 2)
  ;; (c-set-offset 'case-label '+)         ;switch文のcaseラベル
  (c-set-offset 'arglist-intro '+)      ;配列の最初の要素が改行した場合
  (c-set-offset 'arglist-close 0)       ;配列の閉じる括弧
  )
(add-hook 'php-mode-hook 'init-php-mode)

;;
;; php-completion
;; https://github.com/imakado/php-completion
;; git submodule add https://github.com/imakado/php-completion.git lisp/php-completion
;;______________________________________________________________________
;;; php入力補完
(defun php-completion-hook ()
  (when (require 'php-completion nil t)
    (php-completion-mode t)
    ;; anythingで補完
    (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
    (when (require 'auto-complete nil t)
      (make-variable-buffer-local 'ac-sources)
      ;; auto-complete補完ソースの設定
      (add-to-list 'ac-sources 'ac-source-php-completion)
      (auto-complete-mode t))))
(add-hook 'php-mode-hook 'php-completion-hook)

;; (install-elisp "http://php-mode.svn.sourceforge.net/svnroot/php-mode/tags/php-mode-1.5.0/php-mode.el")
;; (when (require 'php-mode nil t)
;;   ;; 拡張子 .ctp も php-mode で開く
;;   (add-to-list 'auto-mode-alist '("\\.ctp$" . php-mode)))

;; --------------- emacs-cake
;; http://wiki.github.com/k1LoW/emacs-cake/
;; (install-elisp "http://github.com/k1LoW/emacs-historyf/raw/master/historyf.el")
;; (install-elisp "http://github.com/k1LoW/emacs-cake/raw/master/ac-cake.el")
;; (install-elisp "http://github.com/k1LoW/emacs-cake/raw/master/cake-inflector.el")
;; (install-elisp "http://github.com/k1LoW/emacs-cake/raw/master/cake.el")
;; (install-elisp "http://github.com/k1LoW/emacs-cake/raw/master/anything-c-cake.el")
;; (when (require 'cake nil t)
;;   (global-cake t))

(provide 'init_php-mode)
;;; init_php-mode.el ends here
