;;; wc-mode.el --- show length of buffer in status bar


;; Copyright (C) 2011 Toby Cubitt

;; Author: Toby Cubitt <toby-predictive@dr-qubit.org>
;; Version: 0.1
;; Keywords: length, characters, words, lines, mode line
;; URL: http://www.dr-qubit.org/emacs.php


;; This file is NOT part of Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
;; MA 02110-1301, USA.


;;; Commentary:
;;
;; A simple minor-mode to display the length of the buffer in the status bar.


;;; Change log:
;;
;; Version 0.1
;; * initial release



;;; Code:

(provide 'wc-mode)

;; emacs23にcount-words-region関数が定義されていないため、条件判定し、定義を行う
(if (not (functionp 'count-words-region))
    (progn
      (defun count-words-region (start end)
        "Return the number of words between START and END.
If called interactively, print a message reporting the number of
lines, words, and characters in the region."
        (interactive "r")
        (let ((words 0))
          (save-excursion
            (save-restriction
              (narrow-to-region start end)
              (goto-char (point-min))
              (while (forward-word 1)
                (setq words (1+ words)))))
          (when (called-interactively-p 'interactive)
            (count-words--message "Region"
                                  (count-lines start end)
                                  words
                                  (- end start)))
          words))
      (defun count-words--message (str lines words chars)
        (message "%s has %d line%s, %d word%s, and %d character%s."
                 str
                 lines (if (= lines 1) "" "s")
                 words (if (= words 1) "" "s")
                 chars (if (= chars 1) "" "s")))
      )
  )

;; add length display to mode-line construct
(setq mode-line-position (assq-delete-all 'wc-mode mode-line-position))
;; FIXME: only shows total characters at the moment
`(setq mode-line-position
      (append
       mode-line-position
       '((wc-mode
	  (6 (:eval (format " (W:%d,L:%d)"
                            (count-words-region (point-min) (point-max))
			    (line-number-at-pos (point-max)))))
	  nil))))

(define-minor-mode wc-mode
  "Toggle word-count mode.
With no argument, this command toggles the mode.
A non-null prefix argument turns the mode on.
A null prefix argument turns it off.

When enabled, the total number of characters, words, and lines is
displayed in the mode-line."
)

(define-globalized-minor-mode global-wc-mode wc-mode wc-mode-on)

(defun wc-mode-on ()
  (unless (minibufferp)
    (wc-mode 1)))

;;; wc-mode.el ends here
