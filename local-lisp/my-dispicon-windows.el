;;; my-dispicon-windows.el --- display icon extention in dired mode (for windows)

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

;; for windows-nt platform
;; TODO:
;;    1. get icon file list for folder (less process call)
;;    2. cache icon file with mime type
;;    3. save dired-dispicon-icon-alist to cache file and load it when need

;;; Code:

(require 'my-lisp-utils)

;; Icon cache.
(defvar dired-dispicon-icon-alist nil)
(defvar dired-dispicon-icon-alist-length 1024)

;;; program information
(defvar dired-dispicon-program "GetFileIcon")
(defvar dired-dispicon-program-buffer " *GetFileIcon*")

;;; icon folder
(defvar dired-dispicon-icon-folder (my-unix-to-dos-filename
                                    (expand-file-name (my-cache-dir "disp-icons"))))

(defun dired-dispicon-icon-cache (filename &optional ignore-errors)
  "Wrapper function of `dispicon' which caches mini icons.
FILENAME, IGNORE-ERRORS are passed to `dispicon'."
  (let* ((name (downcase filename))
         (nondir (file-name-nondirectory name))
         ext iconkey icon)
    (cond
     ((or (file-directory-p filename)
          (string= nondir ""))
      (setq ext "DIR"))
     ((or (not (string-match "\\." nondir))
          (string-match "\\.$" nondir))
      (setq ext "TXT"))
     ((string-match "\\.\\([^.]+\\)$" nondir)
      (setq ext (match-string 1 nondir))
      (when (member ext '("exe" "dll" "ico" "bmp"))
        (setq ext name)))
     (t
      (setq ext "TXT")))
    (setq iconkey (format "%s:" ext))
    (setq icon (cdr (assoc iconkey dired-dispicon-icon-alist)))
    (if icon
        (setq dired-dispicon-icon-alist
              (delete (cons iconkey icon) dired-dispicon-icon-alist))
      (setq icon (dired-dispicon-call-process filename ignore-errors)))
    (setq dired-dispicon-icon-alist
          (cons (cons iconkey icon) dired-dispicon-icon-alist))
    (when (> (length dired-dispicon-icon-alist)
             dired-dispicon-icon-alist-length)
      (setcdr (nthcdr (1- dired-dispicon-icon-alist-length)
                      dired-dispicon-icon-alist) nil))
    icon))

(defun dired-dispicon-call-process (filename &optional ignore-errors)
  "call external to get file icon cotent"
  (let* ((temp-buffer (get-buffer-create dired-dispicon-program-buffer))
         (icon-file nil)
         (image nil))
    (cond
     ((file-exists-p filename)
      (with-current-buffer temp-buffer
        (erase-buffer)
        ;; 同期プロセスでファイルアイコンのパスをゲットする
        (setq filename (my-unix-to-dos-filename filename))
        (call-process "GetFileIcon" nil temp-buffer nil filename dired-dispicon-icon-folder)
        (setq icon-file (buffer-substring (point-min) (- (point-max) 1))))
      ;; (message "filename: %s" filename)
      ;; (message (concat "icon-file -> " icon-file))
      (setq image (create-image icon-file nil nil :ascent 90))
      (propertize " " 'display image 'invisible t))
     (ignore-errors
       (propertize " " 'display nil 'invisible t))
     (t
      (error "Error dispicon")))))

(defun dired-dispicon-fontify-region (&optional beg end)
  "render icon in dired buffer with jit-lock event"
  (when dired-dispicon-display-icon
    (let ((buffer-read-only nil)
          (inhibit-read-only t)
          (after-change-functions nil)
          (inhibit-point-motion-hooks t))
      (save-excursion
        (setq beg (or beg (point-min)))
        (setq end (or end (point-max)))
        (goto-char beg)
        (while (< (point) end)
          (condition-case nil
              (when (dired-move-to-filename)
                ;; render icon when miss 'dispicon property
                (unless (get-text-property (point) 'dispicon)
                  (let* ((beg (point))
                         (end (save-excursion (dired-move-to-end-of-filename) (point)))
                         (file (buffer-substring beg end))
                         (file (expand-file-name file dired-directory))
                         (ovl (make-overlay beg end)))
                    ;; add dispicon propertie on file name
                    (add-text-properties beg end '(dispicon t))
                    (overlay-put ovl
                                 'before-string
                                 (dired-dispicon-icon-cache file))
                    (overlay-put ovl 'evaporate t))))
            (error nil))
          (forward-line 1))
        (set-buffer-modified-p nil)))))

(provide 'my-dispicon-windows)
;;; my-dispicon-windows.el ends here
