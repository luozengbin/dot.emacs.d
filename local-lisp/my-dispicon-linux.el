;;; my-dispicon-linux.el --- display file icon in dired mode

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: files

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

;; for GNU/Linux platform
;;  TODO:
;;    1. refactoring it change cache way

;;; Code:
(require 'deferred)

;;; icon path cache
(defvar dired-dispicon-icon-alist nil "icon alist: ((\"/home\" (\"/home/foo\" \"/icons/inode-directory.png\") ...))")
(defvar dired-dispicon-icon-alist-length 20)

;;; icon data cache
(defvar dired-dispicon-image-cache nil "icon data chache alist ((icon-path . icon-data) ... )")
(defvar dired-dispicon-image-cache-size 1024)

;;; when too many file under one folder delay it
(defvar dired-dispicon-alway nil)
(defvar dired-dispicon-delay-threshold 250)
(defvar dired-dispicon-delay-process-list nil)

;;; program information
(defvar dired-dispicon-program "GetFileIcon")
(defvar dired-dispicon-program-buffer " *GetFileIcon*")
(defvar dired-dispicon-size "16")

(defun dired-dispicon-icon-alist (dir-path)
  "get icon alist from cache or init it by call process"
  (let ((icon-alist (assoc-default dir-path dired-dispicon-icon-alist))
        file-count)
    (unless icon-alist
      (setq file-count (string-to-number
                        (replace-regexp-in-string
                         "\n" ""
                         (shell-command-to-string
                          (format "ls -a '%s' | wc -l" dir-path)))))
      (if (> file-count dired-dispicon-delay-threshold)
          ;; fetch folder icon alist by async process
          (dired-dispicon-call-async-process dir-path)
        ;; start process right now
        (setq icon-alist (dired-dispicon-call-process "complex" dir-path))
        (dired-dispicon-icon-alist-add dir-path icon-alist)))
    icon-alist))

(defun dired-dispicon-icon-alist-add (dir-path icon-alist)
  "add new icon alist set into dired-dispicon-icon-alist"
  (setq dired-dispicon-icon-alist
        (cons (cons dir-path icon-alist) dired-dispicon-icon-alist))
  ;; delete last element when cache overload
  (when (> (length dired-dispicon-icon-alist)
           dired-dispicon-icon-alist-length)
    (setcdr (nthcdr (1- dired-dispicon-icon-alist-length)
                    dired-dispicon-icon-alist) nil)))

(defun dired-dispicon-icon-file (dir-path icon-alist file)
  "get icon file from cache. or get single icon file with single process mode if necessary"
  (let ((icon-file (car (assoc-default file icon-alist))))
    (if icon-file icon-file
      (when (or dired-dispicon-alway icon-alist)
        (setq icon-file
              ;; get icon path with single mode
              (dired-dispicon-call-process
               "single"
               (expand-file-name file dired-directory)))
        (when icon-alist
          (setq dired-dispicon-icon-alist
                (delete (cons dir-path icon-alist) dired-dispicon-icon-alist))
          (setq icon-alist (cons `(,file ,icon-file) icon-alist))
          (dired-dispicon-icon-alist-add dir-path icon-alist))))
    icon-file))

(defun dired-dispicon-call-async-process (dir-path)
  "get icon alist by dir-path with deferred process"
  (unless (assoc dir-path dired-dispicon-delay-process-list)
    (message "Fetch [%s] file icons ... Starting" dir-path)
    (setq dired-dispicon-delay-process-list
          (cons (cons dir-path t)
                dired-dispicon-delay-process-list))
    (lexical-let ((dir-path dir-path))
      (deferred:$
        (deferred:process-buffer dired-dispicon-program "complex" dir-path dired-dispicon-size)
        (deferred:nextc it
          (lambda (buf)
            (dired-dispicon-icon-alist-add
             dir-path (dired-dispicon-eval-process-buffer buf))
            (setq dired-dispicon-delay-process-list
                  (delete (assoc dir-path dired-dispicon-delay-process-list)
                          dired-dispicon-delay-process-list))
            ;; refresh buffers
            (dolist (buf (dired-buffers-for-dir dir-path))
              (with-current-buffer buf
                (when (eq major-mode 'dired-mode)
                  (revert-buffer))))
            (message "Fetch [%s] file icons Done!!!" dir-path)))))))

(defun dired-dispicon-call-process (mode dir-path)
  "call dired-dispicon-program to get icon-path ot icon alist
mode: single --> get icon file path
      complex --> get icon alist by dir-path"
  (let (process-result)
    (condition-case nil
        (with-current-buffer (get-buffer-create dired-dispicon-program-buffer)
          (erase-buffer)
          (call-process dired-dispicon-program nil (current-buffer)
                        nil mode dir-path dired-dispicon-size)
          (setq process-result (dired-dispicon-eval-process-buffer (current-buffer))))
      (error nil))
    process-result))

(defun dired-dispicon-eval-process-buffer (buf)
  "eval process buffer with key word rearch"
  (let (process-result)
    (with-current-buffer buf
      (goto-char (point-min))
      (when (search-forward ";; === result alist ===" nil t)
        (save-excursion
          (insert (format "\n(setq %s " (symbol-name 'process-result)))
          (goto-char (point-max))
          (insert ")"))
        (eval-region (match-end 0) (point-max))
        process-result))))

(defun dired-dispicon-image-cache (icon-file)
  "get or create icon-data from dired-dispicon-image-cache cache for icon-file"
  (let ((image-str (assoc-default icon-file dired-dispicon-image-cache)))
    (unless image-str
      (setq image-str (propertize
                       " "
                       'display (create-image icon-file nil nil :ascent 90)
                       'invisible t))
      (setq dired-dispicon-image-cache
            (cons (cons icon-file image-str) dired-dispicon-image-cache))
      (when (> (length dired-dispicon-image-cache)
               dired-dispicon-image-cache-size)
        (setcdr (nthcdr (1- dired-dispicon-image-cache-size)
                        dired-dispicon-image-cache) nil)))
    image-str))

(defun dired-dispicon-fontify-region (&optional beg end)
  "render icon in dired buffer with jit-lock event"
  (when dired-dispicon-display-icon
    (let* ((buffer-read-only nil)
          (inhibit-read-only t)
          (after-change-functions nil)
          (inhibit-point-motion-hooks t)
          (dir-path (expand-file-name dired-directory))
          (icon-alist (dired-dispicon-icon-alist dir-path)))
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
                         (file (buffer-substring-no-properties beg end))
                         (ovl (make-overlay beg end))
                         (icon-file (dired-dispicon-icon-file dir-path icon-alist file)))
                    ;; add dispicon propertie on file name
                    (add-text-properties beg end '(dispicon t))
                    (when icon-file
                      (overlay-put ovl
                                   'before-string
                                   (dired-dispicon-image-cache icon-file))
                      (overlay-put ovl 'evaporate t)))))
            (error nil))
          (forward-line 1))
        (set-buffer-modified-p nil)))))

(defun dired-dispicon-icon-alist-clear ()
  "clear icon alist"
  (interactive)
  (setq dired-dispicon-icon-alist nil))

(provide 'my-dispicon-linux)
;;; my-dispicon-linux.el ends here
