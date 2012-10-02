;;; my-dispicon.el --- display icon extention in dired mode for many platform

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: dired, icon

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

;; Put following on your '.emacs' file.
;; (require 'my-dispicon)
;; (dired-dispicon-toggle t)
;; (add-hook 'dired-mode-hook
;;           (lambda ()
;;             (define-key dired-mode-map (kbd "/") 'dired-dispicon-toggle)
;;             (define-key dired-mode-map (kbd "\\") 'dired-dispicon-toggle-local)))

;;; Code:

;;; dispicon toggle var
(defvar dired-dispicon-default-display-icon nil "display icon toggle handler in global scope")
(make-variable-buffer-local 'dired-dispicon-display-icon)
(defvar dired-dispicon-display-icon nil "display icon toggle handler in buffer local scope")

;;; load diff module for each platform
(case system-type
  ('gnu/linux
   (require 'my-dispicon-linux))
  ('windows-nt
   (require 'my-dispicon-windows)
   (setq dired-dispicon-icon-folder (my-unix-to-dos-filename
                                       (expand-file-name (my-cache-dir "disp-icons")))))
  (t
   (message "NOT SUPPORT dispicon yet!!!")))

(defun dired-dispicon-toggle (&optional args)
  "Toggle display icons in global scope.
If optional ARGS are non-nil, force display icons."
  (interactive)
  (setq dired-dispicon-default-display-icon
        (or args
            (not dired-dispicon-default-display-icon)))
  (if dired-dispicon-default-display-icon
      (add-hook 'dired-mode-hook 'dired-dispicon-setup)
    (remove-hook 'dired-mode-hook 'dired-dispicon-setup))
  (message "Dired dispicon [Global]: %s" (if dired-dispicon-default-display-icon "ON" "off"))
  (dired-dispicon-refresh-dired-buffers))

(defun dired-dispicon-toggle-local (&optional args)
  "Toggle display icons in buffer local scope.
If optional ARGS are non-nil, force display icons."
  (interactive "P")
  (when (eq major-mode 'dired-mode)
    (setq dired-dispicon-display-icon (or args
                                          (not dired-dispicon-display-icon)))
    (message "Dired dispicon: %s" (if dired-dispicon-display-icon "ON" "off"))
    (revert-buffer)))

(defun dired-dispicon-refresh-dired-buffers ()
  "refresh all dired mode buffer"
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (eq major-mode 'dired-mode)
        (setq dired-dispicon-display-icon dired-dispicon-default-display-icon)
        (if dired-dispicon-display-icon
            (jit-lock-register 'dired-dispicon-fontify-region)
          (jit-lock-unregister 'dired-dispicon-fontify-region))
        (revert-buffer)))))

(defun dired-dispicon-setup ()
  "Setup function for `dired-dispicon'."
  (interactive)
  (setq dired-dispicon-display-icon dired-dispicon-default-display-icon)
  (jit-lock-register 'dired-dispicon-fontify-region))

(provide 'my-dispicon)
;;; my-dispicon.el ends here
