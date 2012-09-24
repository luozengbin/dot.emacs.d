;;; my-info.el --- my extention elisp for info mode

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: help

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

(defun my-info-find-node (filename nodename)
"find info node by name and show it with pop-to-buffer"
  (interactive)
  (save-window-excursion
    (save-excursion
      (Info-find-node filename nodename)))
  (let ((buf (get-buffer "*info*")))
    (if buf
        (pop-to-buffer buf))))

;;; (my-info "(info-file)node")
(defun my-info (info &optional FILE-OR-NODE BUFFER)
  (interactive)
  (save-window-excursion
    (save-excursion
      (info FILE-OR-NODE BUFFER)))
  (let ((buf (get-buffer (if BUFFER BUFFER "*info*"))))
    (if buf
        (pop-to-buffer buf))))

;;; TODO refactoring with defmacro
;; (defun my-eval-info-lambda-pop-buffer (lambda-exp &optional buffer-name)
;;   (interactive)
;;   (save-window-excursion
;;     (save-excursion
;;       (funcall lambda-exp)
;;       ;; (Info-find-node filename nodename)
;;       ))
;;   (let ((buf (get-buffer "*info*")))
;;     (if buf
;;         (pop-to-buffer buf))))

(provide 'my-info)
;;; my-info.el ends here
