;;; init_ediff.el --- init configuration of ediff

;; Copyright (C) 2011  LuoZengbin

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

;; ediff 初期設定

;;; Code:

;;
;; diff設定
;;______________________________________________________________________
;;; http://www.clear-code.com/blog/2012/4/3.html
(setq diff-auto-refine-mode nil)
(defvar current-diff-buffer-name nil)

;; diffの表示方法を変更
(defun diff-mode-setup-faces ()
  ;; 追加された行は緑で表示
  (set-face-attribute 'diff-added nil
                      :foreground "white" :background "dark green")
  ;; 削除された行は赤で表示
  (set-face-attribute 'diff-removed nil
                      :foreground "white" :background "dark red")
  ;; 文字単位での変更箇所は色を反転して強調
  (set-face-attribute 'diff-refine-change nil
                      :foreground nil :background nil
                      :weight 'bold :inverse-video t)
  (setq current-diff-buffer-name (buffer-name))
  (run-with-idle-timer 0.1 nil 'diff-mode-refine-automatically))

;; diffを表示したらすぐに文字単位での強調表示も行う
(defun diff-mode-refine-automatically ()
  (interactive)
  (with-current-buffer current-diff-buffer-name
    (diff-auto-refine-mode t)))

(add-hook 'diff-mode-hook 'diff-mode-setup-faces)

;;
;; ediff generic setting
;;______________________________________________________________________
;; ediffのwindowsを一つのフレームに表示する
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; 差分を横に分割して表示する
(setq ediff-split-window-function 'split-window-horizontally)

;; 余計なバッファを(確認して)削除する
(setq ediff-keep-variants nil)

;;
;; customize setting
;;______________________________________________________________________
;; ediffの挙動をカスタマイズする
(require 'ediff-init)
(add-hook 'ediff-mode-hook 'log-view-ediff-setup)
(add-hook 'ediff-before-setup-hook 'log-view-ediff-before-setup)
;; add it after ediff-cleanup-mess
(add-hook 'ediff-quit-hook 'log-view-ediff-cleanup t)

(defun log-view-ediff-setup ()
  (set (make-local-variable 'ediff-keep-tmp-versions) t))

(defvar log-view-ediff-window-configuration nil)
(defun log-view-ediff-before-setup ()
  (setq log-view-ediff-window-configuration
        (if (eq this-command 'log-view-ediff)
            (current-window-configuration)
          nil)))
(defun log-view-ediff-cleanup ()
  (when log-view-ediff-window-configuration
    (ignore-errors
      (set-window-configuration log-view-ediff-window-configuration)))
  (setq log-view-ediff-window-configuration nil))

;;
;; support for gui tools
;;______________________________________________________________________
(defvar diff-gui-program (case system-type
                           ('gnu/linux (executable-find "meld"))
                           ('windows-nt "D:/ProgramData/toolkit/df141/DF.exe")
                           (t nil))
  "diff program path on windows")

(when diff-gui-program

  (defun diff-gui (fileA fileB)
    "start diff gui"
    (interactive
     (let ((arg1 (read-file-name "Diff A: "))
           (arg2 (read-file-name "Diff B: ")))
       (list arg1 arg2)))
    (unless fileA (setq fileA (read-file-name "Diff A: ")))
    (unless fileB (setq fileB (read-file-name "Diff B: ")))
    (deferred:process diff-gui-program (expand-file-name fileA) (expand-file-name fileB)))

  (defun dired-diff-gui (arg1 arg2)
    "start diff gui from dired mode"
    (interactive
     (condition-case err
         (let ((marked-files-a (dired-get-marked-files)))
           (when (>= (length marked-files-a) 1)
             (setq arg1 (car marked-files-a))
             (setq arg2 (elt marked-files-a 1))
             (unless arg2
               (setq arg2 (with-current-buffer
                              (window-buffer (get-window-with-predicate
                                              (lambda (window)
                                                (with-current-buffer (window-buffer window)
                                                  (eq major-mode 'dired-mode)))))
                            (if (and (eq major-mode 'dired-mode)
                                     (dired-current-directory))
                                (car (dired-get-marked-files)))))))
           (list arg1 (if (equal arg1 arg2) nil arg2)))
       ;; The handler.
       (error
        (list nil nil))))
    (diff-gui arg1 arg2)))

(provide 'init_ediff)
;;; init_ediff.el ends here
