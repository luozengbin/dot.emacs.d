;;; my-diminish.el --- extention lisp function for minor mode string in modeline

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: modeline, diminish

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

;; (require 'my-diminish)
;; (my-diminish 'view-mode '(:eval (propertize " View" 'face 'highlight)))

;;; Code:

(require 'diminish)

;;;###autoload
(defun my-diminish (mode &optional to-what)
  (interactive (list (read (completing-read
                            "Diminish what minor mode: "
                            (mapcar (lambda (x) (list (symbol-name (car x))))
                                    minor-mode-alist)
                            nil t nil 'diminish-history-symbols))
                     (read-from-minibuffer
                      "To what mode-line display: "
                      nil nil nil 'diminish-history-names)))
  (let ((minor (assq mode minor-mode-alist)))
    (or minor (error "%S is not currently registered as a minor mode" mode))
    (callf or to-what "")
    ;; check if to-what is string type
    (when (and (stringp to-what) (> (length to-what) 1))
      (or (= (string-to-char to-what) ?\ )
          (callf2 concat " " to-what)))
    (or (assq mode diminished-mode-alist)
        (push (copy-sequence minor) diminished-mode-alist))
    (setcdr minor (list to-what))))

(provide 'my-diminish)
;;; my-diminish.el ends here
