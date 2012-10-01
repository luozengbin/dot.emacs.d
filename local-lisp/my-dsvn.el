;;; my-dsvn.el --- hacking dsvn for my personal work

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: dsvn

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

(defun svn-run-with-output (subcommand &optional args mode)
  "Run 'svn' with output to another window.
Argument SUBCOMMAND is the command to execute.
Optional argument ARGS is a list of the arguments to the command.
Optional argument MODE is the major mode to use for the output buffer.

Return non-NIL if there was any output."
  (let ((buf (get-buffer-create "*svn output*"))
        (dir default-directory)
        (inhibit-read-only t))
    (with-current-buffer buf
      (erase-buffer)
      (if mode
          (funcall mode)
        (fundamental-mode))
      (setq default-directory dir)
      (setq buffer-read-only t)
      (let ((proc (svn-start-svn-process buf (cons subcommand args))))
        ;; fix svn process coding for work well on windows
        (if svn-process-internal-coding
            (set-process-coding-system proc svn-process-internal-coding))
        (set-process-filter proc 'svn-output-filter)
        (while (eq (process-status proc) 'run)
          (accept-process-output proc 5)
          (sit-for 0)))
      (if (= (point-min) (point-max))
          nil
        (save-selected-window
          (select-window (display-buffer buf))
          (goto-char (point-min)))
        t))))

(defun svn-confirm-commit ()
  "Commit changes with the current buffer as commit message."
  (interactive)
  (let ((files (with-current-buffer log-edit-parent-buffer
                 (svn-action-files)))
        (commit-buf (current-buffer))
        (status-buf log-edit-parent-buffer)
        (window-conf saved-window-configuration)
        ;; XEmacs lacks make-temp-file but has make-temp-name + temp-directory
        (msg-file (if (fboundp 'make-temp-file)
                      (make-temp-file "svn-commit")
                    (make-temp-name (expand-file-name "svn-commit"
                                                      (temp-directory))))))
    ;; Ensure final newline
    (goto-char (point-max))
    (unless (bolp)
      (newline))
    (write-region (point-min) (point-max) msg-file)
    (when (boundp 'vc-comment-ring)
      ;; insert message into comment ring, unless identical to the previous
      (let ((comment (buffer-string)))
        (when (or (ring-empty-p vc-comment-ring)
                  (not (equal comment (ring-ref vc-comment-ring 0))))
          (ring-insert vc-comment-ring comment))))
    (kill-buffer commit-buf)
    (with-current-buffer status-buf
      (make-local-variable 'svn-commit-msg-file)
      (make-local-variable 'svn-commit-files)
      (setq svn-commit-msg-file msg-file)
      (setq svn-commit-files files)
      (svn-run 'commit (append (list "-N" "-F" msg-file "--encoding" svn-commit-file-coding) files)))
    (if window-conf
        (set-window-configuration window-conf))))

(defvar my-svn-commit-msg-template nil)
(defadvice svn-commit (around svn-commit activate)
"customize svn commit message with my-svn-commit-msg-template"
  (let ((result ad-do-it))
    (file-exists-p my-svn-commit-msg-template)
    (when (and my-svn-commit-msg-template
             (file-exists-p my-svn-commit-msg-template))
            (erase-buffer)
            (insert-file-contents my-svn-commit-msg-template))
    result))

(provide 'my-dsvn)
;;; my-dsvn.el ends here
