;;; init_view-mode.el --- configuration for view mode

;; Copyright (C) 2011  Zouhin.Ro

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

;; 閲覧モードの強化

;;; Code:

(message "init_view-mode ...")

;;
;; view mode
;;______________________________________________________________________
;; 書き込み不可のファイルを強制的にview-modeで開く
(setq view-read-only t)

;; viewer.elでview-modeを改善する
;; (install-elisp-from-emacswiki "viewer.el")
(require 'viewer)
;; 書き込み不可のファイルをview-modeから脱げないようにする
(viewer-stay-in-setup)
;; 色名を指定する
(setq viewer-modeline-color-unwritable "tomato")
(setq viewer-modeline-color-view "orange")
(viewer-change-modeline-color-setup)
;; view-modeのキーマップを再定義する
(define-overriding-view-mode-map c-mode 
  ("RET"    .   gtags-find-tag-from-here))
(define-overriding-view-mode-map emacs-lisp-mode
  ("RET"    .   find-function-at-point))
;; .log .out .datファイルをview-modeで開く
(setq view-mode-by-default-regexp ".\\(out\\|log\\|dat\\)$")
;; 行数200以下なら、普通モードで開く
;; (setq viewer-aggressive-minimum-size 200)
;; (setq viewer-aggressive-setup 'force)

;;view-mode時のキーバインド
(define-key view-mode-map "h" 'backward-char)
(define-key view-mode-map "j" 'next-line)
(define-key view-mode-map "k" 'previous-line)
(define-key view-mode-map "l" 'forward-char)
(define-key view-mode-map "J" 'View-scroll-line-forward)
(define-key view-mode-map "K" 'View-scroll-line-backward)
(define-key view-mode-map "b" 'scroll-down)
(define-key view-mode-map " " 'scroll-up)

;; (install-elisp "http://taiyaki.org/elisp/word-count/src/word-count.el")
;; (autoload 'word-count-mode "word-count"
;;           "Minor mode to count words." t nil)
;; (global-set-key "\M-+" 'word-count-mode)
;;
;; How to use:
;; 1). M-+ (word-count-mode) toggles word-count mode.
;; 2). M-[space] (word-count-set-area) sets area for counting words.
;; 3). M-x word-count-set-region sets region or paragraph for counting words.
;; 4). M-x word-count-set-marker sets marker for counting words.

;;
;; darkroom-mode
;;______________________________________________________________________
;; darkroom-mode フルースクリーンにする
;; 参考リンク：
;;              http://www.martyn.se/code/emacs/darkroom-mode/
;;              http://redtower.plala.jp/2011/02/22/emacs-darkroom-whiteroom.html
;;              http://www.martyn.se/code/emacs/darkroom-mode/
;; hg clone https://bitbucket.org/phromo/darkroom-mode
;; (require 'darkroom-mode)
;; (global-set-key "\C-cd" 'darkroom-mode)

(provide 'init_view-mode)
;;; init_view-mode.el ends here
