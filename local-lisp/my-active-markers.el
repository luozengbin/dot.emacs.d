;;; my-active-markers.el --- highting active marker in current buffer

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: extensions

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

;; M-x show-active-markers

;;; Code:

(eval-when-compile (require 'cl))

(defvar my-active-marker-max 5)
(defface my-active-marker-face
  `((((type tty) (class color))
     (:background "gray" :foreground "white"))
    (((type tty) (class mono))
     (:inverse-video t))
    (((class color) (background dark))
     (:background "gray"))
    (((class color) (background light))
     (:background "grey80"))
    (t (:background "gray")))
  "Face for the mark.")

(defun show-active-markers ()
  (interactive)
  (when (not (boundp 'my-active-marker-overlays))
    (make-local-variable 'my-active-marker-overlays)
    (setq my-active-marker-overlays nil))
  (if my-active-marker-overlays
      (progn
        (remove-hook 'activate-mark-hook 'rendering-active-markers t)
        (remove-hook 'deactivate-mark-hook 'rendering-active-markers t)
        (clear-active-markers-face))
    (rendering-active-markers)
    (add-hook 'activate-mark-hook 'rendering-active-markers nil t)
    (add-hook 'deactivate-mark-hook 'rendering-active-markers nil t)))

(defun clear-active-markers-face ()
  (while my-active-marker-overlays
    (delete-overlay (car my-active-marker-overlays))
    (setq my-active-marker-overlays (cdr my-active-marker-overlays))))

(defun rendering-active-markers ()
  (clear-active-markers-face)
  (mapcar
   '(lambda (m)
      (if (and m (marker-position m))
          (let ((ov (make-overlay (marker-position m) (1+ (marker-position m)))))
            (overlay-put ov 'face 'my-active-marker-face)
            (setq my-active-marker-overlays (cons ov my-active-marker-overlays)))))
   (let ((mr (cons (mark-marker) mark-ring)))
     (loop for i from 0 to (- my-active-marker-max 1) collect (nth i mr)))))

(provide 'my-active-markers)
;;; my-active-markers.el ends here
