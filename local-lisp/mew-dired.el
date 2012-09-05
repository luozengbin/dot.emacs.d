;;; mew-dired.el --- mew dired mode support functions

;; Copyright (C) 2012  Zouhin.Ro

;; Author: Zouhin.Ro <jalen.cn@gmail.com>
;; Keywords: mew, dired

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

;; (add-hook 'dired-mode-hook
;;           (lambda ()
;;             (define-key dired-mode-map "\C-c\C-m" 'dired-do-mew-attach-copy)))

;; (add-hook 'mew-draft-mode-hook
;;           (lambda ()
;;             (define-key mew-draft-attach-map "M" 'mew-attach-from-dired)))

(defvar dired-mew-attach-copy-files nil)
(defvar mew-attach-from-dired-mark nil)

(defun my-compose-mew-message ()
"隠しフレームを起動して新規メールバッファーを作成する"
  (interactive)
  (save-window-excursion
    (let ((temp-current-frame (selected-frame))
          (temp-frame (make-frame '((visibility . nil)
                                    (minibuffer . t)))))
      (select-frame temp-frame)
      (compose-mail)
      (select-frame temp-current-frame)
      ;; フレームを削除する
      (if (frame-live-p temp-frame)
          (delete-frame temp-frame))))
  (pop-to-buffer (mew-max-draft-buffer)))

(defun my-popup-mew-draft-buffer ()
  (interactive)
  (let ((draft (mew-max-draft-buffer))
        (curwin (selected-window)))
    (if draft
        (progn
          (pop-to-buffer draft)
          (select-window curwin)
          draft)
      (my-compose-mew-message)
      (select-window curwin)
      (setq draft (mew-max-draft-buffer)))))

(defun dired-do-mew-attach-copy (&optional arg)
  (interactive "P")
  (when (featurep 'mew)
    (or (featurep 'dired) (load "dired" 'no-err))
    (or (featurep 'dired-aux) (load "dired-aux" 'no-err))
    (setq dired-mew-attach-copy-files nil)
    (dired-map-over-marks-check
     (function dired-mew-attach-copy) arg 'mew-attach-copy t)
    (if (null dired-mew-attach-copy-files)
        (message "No selected files!")
      (let ((draft (my-popup-mew-draft-buffer)) buf)
        (print draft)
        (if mew-attach-from-dired-mark
            (progn
              (select-window
               (get-buffer-window (car mew-attach-from-dired-mark)))
              (goto-char (cdr mew-attach-from-dired-mark))
              (mew-attach-from-dired-1))
          (if (and (get-buffer draft) (get-buffer-window draft)
                   (string-match "[0-9]\\([.]mew\\)?$" draft))
              (setq buf draft)
            (setq buf (mew-input-buffer draft)))
          (if (null (get-buffer buf))
              (message "No such draft buffer!")
            (if (get-buffer-window buf)
                (select-window (get-buffer-window buf))
              (switch-to-buffer buf))
            (if (null (mew-draft-p))
                (message "draft folder!")
              (unless (mew-attach-p) (mew-draft-prepare-attachments))
              (goto-char (mew-attach-begin))
              (if (not (re-search-forward " +\\([1-9][.0-9]*\\) +\\(\\.\\)" nil t)) ;; FIXME
                  (message "Error attach area!")
                (goto-char (match-beginning 2))
                (sit-for 0)
                (if (y-or-n-p (format "Attach %s at \"%s\" now (or later) ? "
                                      (if (= (length dired-mew-attach-copy-files) 1)
                                          "file" "files")
                                      (match-string 1)))
                    (let (mew-attach-move-next-after-copy)
                      (mew-attach-from-dired-1))
                  (message
                   (substitute-command-keys
                    "Move cursor and press '\\<mew-draft-attach-map>\\[mew-attach-from-dired]'")))))))))))

(defun dired-mew-attach-copy ()
  (let ((file (mew-file-chase-links (dired-get-filename))))
    (if (and (file-readable-p file)
             (not (file-directory-p file)))
        (progn
          (setq dired-mew-attach-copy-files (cons file dired-mew-attach-copy-files))
          nil)
      ;; FIXME
      t)))

(defun mew-attach-from-dired (&optional args)
  (interactive "P")
  (let (buf)
    (if (and (interactive-p)
             (mew-attach-not-line012-1)
             (null dired-mew-attach-copy-files)
             (save-excursion
               (other-window -1)
               (setq buf (current-buffer))
               (eq major-mode 'dired-mode)))
        ;; attach から dired に移動する
        (let ((mew-attach-from-dired-mark (cons (current-buffer) (point))))
          (set-buffer buf)
          (dired-do-mew-attach-copy args))
      (mew-attach-from-dired-1))))

(defun mew-attach-from-dired-1 ()
  (if (mew-attach-not-line012-1)
      (if dired-mew-attach-copy-files
          (let (file)
            (while (setq file (car dired-mew-attach-copy-files))
              (mew-attach-copy file (file-name-nondirectory file))
              (setq dired-mew-attach-copy-files (cdr dired-mew-attach-copy-files))))
        (message "Nothing to do!"))
    (message "Can not attach from dired here!")))

(provide 'mew-dired)
;;; mew-dired.el ends here
