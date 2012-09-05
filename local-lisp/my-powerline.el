;;; my-powerline.el --- exstension for powerline

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: terminals

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

;;; install script
;; (install-elisp "http://www.emacswiki.org/emacs/download/powerline.el")

;; Powerline
(defun arrow-right-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 18 2 1\",
\". c %s\",
\"  c %s\",
\".           \",
\"..          \",
\"...         \",
\"....        \",
\".....       \",
\"......      \",
\".......     \",
\"........    \",
\".........   \",
\".........   \",
\"........    \",
\".......     \",
\"......      \",
\".....       \",
\"....        \",
\"...         \",
\"..          \",
\".           \"};"  color1 color2))

(defun arrow-left-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 18 2 1\",
\". c %s\",
\"  c %s\",
\"           .\",
\"          ..\",
\"         ...\",
\"        ....\",
\"       .....\",
\"      ......\",
\"     .......\",
\"    ........\",
\"   .........\",
\"   .........\",
\"    ........\",
\"     .......\",
\"      ......\",
\"       .....\",
\"        ....\",
\"         ...\",
\"          ..\",
\"           .\"};"  color2 color1))

(defconst color1 "#666666") ; gray40
(defconst color2 "#999999") ; gray60

(defvar arrow-right-0 (create-image (arrow-right-xpm "None" color1) 'xpm t :ascent 'center))
(defvar arrow-right-1 (create-image (arrow-right-xpm color1 color2) 'xpm t :ascent 'center))
(defvar arrow-right-2 (create-image (arrow-right-xpm color2 "None") 'xpm t :ascent 'center))
(defvar arrow-left-1  (create-image (arrow-left-xpm color2 color1) 'xpm t :ascent 'center))
(defvar arrow-left-2  (create-image (arrow-left-xpm "None" color2) 'xpm t :ascent 'center))

(display-time)

(setq-default mode-line-format
              (list
               '("-"
                 mode-line-mule-info
                 mode-line-modified
                 minor-mode-alist)
               '(:eval (concat (propertize " " 'display arrow-right-0)))
               '(:eval (concat (propertize " %m " 'face 'mode-line-color-1)
                               (propertize " " 'display arrow-right-1)))
               '(:eval (concat (propertize " %b " 'face 'mode-line-color-2)
                               (propertize " " 'display arrow-right-2)))
               ;; Justify right by filling with spaces to right fringe - 16
               ;; (16 should be computed rahter than hardcoded)
               '(:eval (propertize " " 'display '((space :align-to (- right-fringe 17)))))
               '(:eval (concat (propertize " " 'display arrow-left-2)
                               (propertize " %p " 'face 'mode-line-color-2)))
               '(:eval (concat (propertize " " 'display arrow-left-1)
                               (propertize "%4l:%2c  " 'face 'mode-line-color-1)))
               ))


(make-face 'mode-line-color-1)
(set-face-attribute 'mode-line-color-1 nil
                    :foreground "#fffacd"
                    :bold t
                    :background color1)

(make-face 'mode-line-color-2)
(set-face-attribute 'mode-line-color-2 nil
                    :foreground "#fffacd"
                    :bold t
                    :background color2)

(set-face-attribute 'mode-line nil
                    :foreground "#fffacd"
                    :background "#171717"
                    :box nil)
(set-face-attribute 'mode-line-inactive nil
                    :foreground "#fffacd"
                    :background "#171717")

(provide 'my-powerline)
;;; my-powerline.el ends here
