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
;; text-translator Web翻訳サービス
;;______________________________________________________________________
;;; (auto-install-batch "text translator")
;;; M-x text-translator
(require 'text-translator-vars)
;;; ocn.ne.jp利用できないため、削除する
(setq text-translator-site-data-template-alist
      (delete (assoc "ocn.ne.jp" text-translator-site-data-template-alist)
              text-translator-site-data-template-alist))

(require 'text-translator)
(setq text-translator-auto-selection-func
      'text-translator-translate-by-auto-selection-enja)

;;; show result in popwin way
(require 'popwin)
(push '("*translated*") popwin:special-display-config)
(defadvice text-translator-all-by-auto-selection (after text-translator-popwin-result activate)
  (display-buffer "*translated*"))

;;; TODO show result in popup tip
;; (popup-tip (with-current-buffer "*translated*"
;;              (buffer-string)))

;;; key bind for mouse and keyboard
(require 'cl)
(defun text-translator-all-by-mouse (e)
  (interactive "e")
  (flet ((text-translator-region-or-read-string
          (&rest _)
          (buffer-substring (posn-point (event-start e))
                            (posn-point (event-end e)))))
    (text-translator-all-by-auto-selection nil)))

;;; C-S Drog Mouse
(global-set-key [C-S-down-mouse-1] 'mouse-drag-region)
(global-set-key [C-S-drag-mouse-1] 'text-translator-all-by-mouse)

(global-set-key (kbd "M-t") 'text-translator-all-by-auto-selection)

(provide 'init_translator)
;;; init_translator.el ends here
