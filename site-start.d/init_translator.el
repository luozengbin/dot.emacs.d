;;; init_translator.el --- configuration for text-translator

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

;; 翻訳サービス

;;; Code:

;;
;; sdic-mode 用の設定
;;______________________________________________________________________
;;; http://www.namazu.org/~tsuchiya/sdic/
(autoload 'sdic-describe-word "sdic" "英単語の意味を調べる" t nil)
(autoload 'sdic-describe-word-at-point "sdic" "カーソルの位置の英単語の意味を調べる" t nil)

(defvar my-eiwa-dictionary (expand-file-name
                            (concat user-emacs-directory "share/dict/gene.sdic")))

(defvar my-waei-dictionary (expand-file-name
                            (concat user-emacs-directory "share/dict/jedict.sdic")))
;;; 英和辞書
(setq sdic-eiwa-dictionary-list `((sdicf-client ,my-eiwa-dictionary)))
;;; 和英辞書
(setq sdic-waei-dictionary-list `((sdicf-client ,my-waei-dictionary)))

;; (global-set-key "\C-cw" 'sdic-describe-word)
;; (global-set-key "\C-cW" 'sdic-describe-word-at-point)

;;
;; sdic-inline.el
;;______________________________________________________________________
;;; http://d.hatena.ne.jp/khiker/20100303/sdic_inline
;;; (install-elisp "http://www.emacswiki.org/emacs/download/sdic-inline.el")
;;; (install-elisp "http://www.emacswiki.org/emacs/download/sdic-inline-pos-tip.el")
(defvar use-sdic-inline nil "sdic-inline モード有効フラグ")
(when use-sdic-inline
  (require 'sdic-inline)
  (sdic-inline-mode t)   ; enable sdic-inline.

  ;; Setting dictionary path.
  (setq sdic-inline-eiwa-dictionary my-eiwa-dictionary)
  (setq sdic-inline-waei-dictionary my-waei-dictionary)

  (require 'sdic-inline-pos-tip)
  (defun sdic-inline-pos-tip-show-when-region-selected (entry)
    (cond
     ((and transient-mark-mode mark-active)
      (funcall 'sdic-inline-pos-tip-show entry))
     (t
      (funcall 'sdic-inline-display-minibuffer entry))))

  (setq sdic-inline-search-func 'sdic-inline-search-word-with-stem)
  (setq sdic-inline-display-func 'sdic-inline-pos-tip-show-when-region-selected)
  (define-key sdic-inline-map "\C-c\C-p" 'sdic-inline-pos-tip-show)
  )

;;
;; google-translate
;;______________________________________________________________________
(require 'google-translate)
(push '("*Google Translate*") popwin:special-display-config)

;;; keybind on [M-t]
(global-set-key (kbd "M-t") 'my-google-translate-with-popup)
(global-set-key (kbd "M-T") 'my-google-translate-at-point)

;; C-S Drog Mouse
(global-set-key [C-S-down-mouse-1] 'mouse-drag-region)
(global-set-key [C-S-drag-mouse-1] 'google-translator-all-by-mouse)

(defun google-translator-all-by-mouse (e)
  (interactive "e")
  (flet ((use-region-p () t))           ;一時的に(use-region-p)関数を置き換える
    (google-translate-at-point (posn-point (event-start e))
                               (posn-point (event-end e)))))

(defun my-google-translate-at-point (beg end &optional override-p)
  (interactive "r\nP")
  (let ((str (if (use-region-p)
                 (buffer-substring-no-properties beg end)
               (current-word))))
    (if (> (/ (* (length (replace-regexp-in-string "[^A-Za-z]+" "" str)) 100)
              (length str))
           40)
        (google-translate-select-language nil)
      (google-translate-select-language t)))
  (google-translate-at-point override-p))

(require 'popup)
(defun my-google-translate-with-popup (beg end &optional override-p)
  (interactive "r\nP")
  (save-window-excursion
    (my-google-translate-at-point beg end override-p))
  (popup-tip (with-current-buffer "*Google Translate*" (buffer-string))))

;;; 日本語→英語の自動切り替え
(defadvice google-translate-at-point (before google-translate-set-language activate)
  (let ((str (if (use-region-p)
                 (buffer-substring-no-properties beg end)
               (current-word))))
    (setq )
    (if (> (/ (* (length (replace-regexp-in-string "[^A-Za-z]+" "" str)) 100)
              (length str))
           40)
        (google-translate-select-language nil)
      (google-translate-select-language t))))

(defun google-translate-select-language (enja-p)
  (if enja-p
      (progn
        (setq google-translate-default-source-language "ja")
        (setq google-translate-default-target-language "en"))
    (setq google-translate-default-source-language "en")
    (setq google-translate-default-target-language "ja")))

;;
;; text-translator Web翻訳サービス
;;______________________________________________________________________
(defvar use-text-translator nil "text-translator 機能のOn/Offをコントロールする")
(when use-text-translator
  ;;; (auto-install-batch "text translator")
  ;; M-x text-translator
  (require 'text-translator-vars)
  ;; ocn.ne.jp利用できないため、削除する
  (setq text-translator-site-data-template-alist
        (delete (assoc "ocn.ne.jp" text-translator-site-data-template-alist)
                text-translator-site-data-template-alist))

  (require 'text-translator)
  (setq text-translator-auto-selection-func
        'text-translator-translate-by-auto-selection-enja)

  ;; show result in popwin way
  (require 'popwin)
  (push '("*translated*") popwin:special-display-config)
  (defadvice text-translator-all-by-auto-selection (after text-translator-popwin-result activate)
    (display-buffer "*translated*")))

(provide 'init_translator)
;;; init_translator.el ends here
