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

(defvar record-win-program
  (concat
   user-emacs-directory "bin/fsc-window.sh")
  "program for recode window video")

(defvar record-full-program
  (concat
   user-emacs-directory "bin/fsc-full.sh")
  "program for recode full screen video")

(defvar screencast-buffer "*Screencast*" "buffer name for screencast process")

(defvar screencast-file nil "current screencast file name")

;;; popupバッファで表示する
(push `(,screencast-buffer) popwin:special-display-config)

(defun my-screencast-full (file)
  (interactive "F[FullScreen] Save Screencast File: ")
  (my-screencast record-full-program file)
  (message "Screencast Start!"))

(defun my-screencast-win (file)
  (interactive "F[SelectedWindow] Save Screencast File: ")
  (my-screencast record-win-program file)
  (message "録画対象Windowをカーソルで選択してください。"))

(defun my-screencast (record-program file &optional winid)
  (if (get-buffer-process screencast-buffer)
      (message "There is a screencast already started. Abort this request.")
    (let* ((screencast-file (expand-file-name file))
           (proc
            (if winid
                (start-process "my-screencast" screencast-buffer record-program
                               screencast-file winid)
              (start-process "my-screencast" screencast-buffer record-program
                             screencast-file))))
      (set-process-filter proc 'screencast-output-filter)
      (with-current-buffer screencast-buffer
        (setq buffer-read-only t)
        (screencast-mode)
        (set (make-local-variable 'screencast-file) screencast-file)))))

(defun my-screencast-stop ()
  (interactive)
  (if (get-buffer-process screencast-buffer)
      (progn
        (screencast-control "q")
        ;; (execute-kbd-macro (read-kbd-macro "q"))
        (sit-for 0.3)
        (with-current-buffer screencast-buffer
          (setq buffer-read-only nil)
          (goto-char (point-max))
          (insert "\n\n>>> " screencast-file)
          (setq buffer-read-only t)
          (message "Stop Screencast: %s" screencast-file))
        (display-buffer screencast-buffer))
    (message "No Screencast Started!")))

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

;;; helm interface support
(defun xwindow-list-candidates ()
  (let* ((winlist-cmd-0 (concat user-emacs-directory "bin/GetWindowInfo.py"))
         (winlist-cmd (concat "wmctrl -l | awk '{print $1}' | xargs -L 1 "
                              winlist-cmd-0 " | fgrep -v \"Xlib.protocol.request.QueryExtension\""))
         current-line candidates)
    (with-current-buffer
        (get-buffer-create " *x-window-list*")
      (erase-buffer)
      (call-process-shell-command winlist-cmd nil t nil)
      (goto-char (point-min))
      (while (re-search-forward "^\\(.+?\\),\\(.+?\\),\\(.+\\)$" nil t)
        (setq current-line
              (concat (propertize (match-string 1) 'invisible t)
                      (propertize " " 'display (create-image (match-string 2) nil nil :ascent 90))
                      (match-string 3)))
        (append-to-list candidates (list current-line))))
    (reverse candidates)))

(defvar helm-xwindow-list-source
  '((name       . "Window List")
    (candidates . xwindow-list-candidates)
    (action     . (("Take ScreenCast"  . take-screencast-action)
                   ("Print Window ID"  . message)))))

(defvar helm-xscreen-source
  '((name       . "Screen Action")
    (candidates . (("my-screencast-full : Take VideoCast for fullscreen")
                   ("my-screencast-win  : Take VideoCast for special window")))
    (action     . (("Execute Action" . xscreen-source-action)) )))

(defun xscreen-source-action (cmdline)
  (let* ((func-name (substring
                     cmdline
                     0
                     (string-match " .+" cmdline))))
    (command-execute (intern func-name))))

(defun take-screencast-action (selected-window)
  (let* ((winid (substring
                 selected-window
                 0
                 (string-match " .+" selected-window))))
    (my-screencast record-win-program
                   (read-file-name "[SelectedWindow] Save Screencast File: ")
                   winid)))

(defun helm-xwindow-list ()
  (interactive)
  (helm-other-buffer '(helm-xwindow-list-source helm-xscreen-source) "*helm xwindow list*"))

(provide 'init_video)
;;; init_video.el ends here
