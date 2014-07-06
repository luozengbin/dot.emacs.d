;;; init_video.el --- configuration for video play/record

;; Copyright (C) 2014  Zouhin.Ro

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords:

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

;; ビデオ関連ツール

;;; Code:

(defvar record-program
  (concat
   user-emacs-directory "bin/fsc.sh")
  "program for recode video")

(defvar screencast-buffer "*Screencast*" "buffer name for screencast process")

(defvar screencast-file nil "current screencast file name")

;;; popupバッファで表示する
(push `(,screencast-buffer) popwin:special-display-config)

(defun my-screencast (file)
  (interactive "FSave Screencast File: ")
  (let* ((screencast-file (expand-file-name file))
         (proc
          (start-process "my-screencast" screencast-buffer record-program
                         screencast-file)))
    (set-process-filter proc 'screencast-output-filter)
    (with-current-buffer screencast-buffer
      (setq buffer-read-only t)
      (screencast-mode)
      (set (make-local-variable 'screencast-file) screencast-file))
    (display-buffer screencast-buffer)))

(defun my-screencast-stop ()
  (interactive)
  (when (get-buffer screencast-buffer)
    (display-buffer screencast-buffer)
    (execute-kbd-macro (read-kbd-macro "q"))
    (sit-for 0.3)
    (with-current-buffer screencast-buffer
      (setq buffer-read-only nil)
      (goto-char (point-max))
      (insert "\n\n>>> " screencast-file)
      (setq buffer-read-only t))))

(defun my-screencast-play ()
  (interactive)
  (when (get-buffer screencast-buffer)
    (with-current-buffer screencast-buffer
      (when (file-exists-p screencast-file)
        (start-process "my-screencast-play"
                       "*vlc*" "vlc" screencast-file)))))

(defun screencast-output-filter (proc string)
  (with-current-buffer (process-buffer proc)
    (setq buffer-read-only nil)
    (goto-char (point-max))
    (insert (string-replace "" "\n" string))
    (setq buffer-read-only t)))

(defvar screencast-control-list
  '((?q      .    "q" ) ;; quit
    (?p      .    'my-screencast-play)
    ))

(defun screencast-control (cmd)
  (let ((proc (get-buffer-process screencast-buffer)))
    (if proc
        (process-send-string proc cmd)
      (message "no screencast process running"))))

(defun screencast-control-command ()
  (interactive)
  (let* ((form (assoc-default last-input-event screencast-control-list)))
    (if (stringp form)
        (screencast-control form)
      (setq form (if (and (listp form) (memq (car form) '(quote function)))
                     (eval form)
                   form))
      (cond
       ((commandp form)
        (setq this-command form)
        (unwind-protect
            (call-interactively form)
          (setq last-command form)))
       ((functionp form) (funcall form))
       ((and (listp form) (symbolp (car form))) (eval form))
       (t (error "Unsupported form %c %s" char rawform))))))

(define-derived-mode screencast-mode nil "SCast"
  (loop for (key . str) in screencast-control-list
        do (define-key screencast-mode-map
             (vector key) 'screencast-control-command)))

(provide 'init_video)
;;; init_video.el ends here
